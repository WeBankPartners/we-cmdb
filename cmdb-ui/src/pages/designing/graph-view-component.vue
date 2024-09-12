<template>
  <Row>
    <Row>
      <Col span="24">
        <Card>
          <div class="container-height" :id="'graphMgmt' + graphIndex">
            <span class="buttons">
              <Button @click="resetZoom">{{ $t('reset_zoom') }}</Button>
            </span>
          </div>
        </Card>
        <div class="operation-area">
          <Button style="float: right" type="primary" @click="openDrawer = !openDrawer">
            {{ $t('operating_area') }}
          </Button>
          <Drawer :closable="true" :width="400" :mask="false" :transfer="false" inner v-model="openDrawer">
            <Spin fix v-if="operationLoading">
              <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
              <div>{{ $t('loading') }}</div>
            </Spin>

            <SeqOperation
              v-if="dotString.startsWith('sequenceDiagram')"
              class="operation-container"
              ref="operationPanel"
              :isEdit="isEdit"
              :editable="editable"
              :suportVersion="suportVersion"
              :ciTypeMapping="ciTypeMapping"
              :plainDatas="plainDatas"
              @operationReload="operationReload"
            ></SeqOperation>
            <Operation
              v-else
              class="operation-container"
              ref="operationPanel"
              :isEdit="isEdit"
              :editable="editable"
              :suportVersion="suportVersion"
              :ciTypeMapping="ciTypeMapping"
              @operationReload="operationReload"
            ></Operation>
          </Drawer>
        </div>
      </Col>
    </Row>
  </Row>
</template>

<script>
import * as d3 from 'd3-selection'
import * as d3Zoom from 'd3-zoom'
// eslint-disable-next-line no-unused-vars
import * as d3Graphviz from 'd3-graphviz'
import { queryReferenceCiData, viewGraphDot } from '@/api/server'
import { addEvent } from '../util/event.js'
// import { renderGraph } from '../util/render-graph.js'
import Operation from './graph-operation-component'
import SeqOperation from './graph-sequence-component'
import mermaid from 'mermaid'
export default {
  components: {
    Operation,
    SeqOperation
  },
  data () {
    return {
      openDrawer: false,
      selectedId: '', // 点击选中的图形容器ID值, 赋值会使元素高亮
      cachedIdInfo: { id: '', type: '', graph: '', color: '', pathColor: '' }, // 缓存点击后的图形容器原始信息，比如color
      plainDatas: [], // 存储平面数据[{guid:xxx, metadata: {}, ci: unit, parent: guid_x, data: data, operation: nextOperation}]
      graph: {}, // graph元素，用于存储d3.graphviz
      ignoreOperations: [], // 忽略操作，默认忽略action=Confirm的操作
      loading: false, // 是否显示loading动画
      operationLoading: false,
      dotString: '',
      confirmTime: '', // 确认时间，获取视图dot有值需传
      graphNum: null // 视图顺序，通过此获取视图参数
    }
  },
  props: [
    'graphSetting',
    'graphData',
    'graphIndex',
    'ciTypeMapping',
    'editable',
    'isEdit',
    'initTransform',
    'suportVersion'
  ],
  watch: {
    selectedId: function (val) {
      // 切换节点时，还原上一个节点的信息
      if (this.cachedIdInfo.id) {
        let dom = d3.select('#graphMgmt' + this.graphIndex).select(`#` + this.cachedIdInfo.id)
        if (dom.attr('class') === 'edge') {
          dom.select('path').attr('stroke', this.cachedIdInfo.pathColor)
          dom.select('polygon').attr('fill', this.cachedIdInfo.color)
          dom.select('polygon').attr('stroke', this.cachedIdInfo.color)
        } else {
          dom.select(this.cachedIdInfo.graph).attr('fill', this.cachedIdInfo.color)
        }
        this.cachedIdInfo = {}
      }
      this.cachedIdInfo.id = val
      if (val) {
        // 记录节点type
        let dom = d3.select('#graphMgmt' + this.graphIndex).select(`#` + val)
        if (dom.attr('class') === 'edge') {
          this.cachedIdInfo.pathColor = 'edge'
          this.cachedIdInfo.pathColor = dom.select('path').attr('stroke')
          this.cachedIdInfo.color = dom.select('polygon').attr('fill')
          dom.select('path').attr('stroke', '#ff9900')
          dom.select('polygon').attr('fill', '#ff9900')
          dom.select('polygon').attr('stroke', '#ff9900')
        } else {
          this.cachedIdInfo.type = 'node'
          this.cachedIdInfo.graph = dom.select('polygon')._groups[0][0]
            ? 'polygon'
            : dom.select('ellipse')._groups[0][0]
              ? 'ellipse'
              : 'rect'
          this.cachedIdInfo.color = dom.select(this.cachedIdInfo.graph).attr('fill')
          // 设置高亮颜色
          dom.select(this.cachedIdInfo.graph).attr('fill', '#ff9900')
        }
      }
    }
  },
  methods: {
    resetZoom () {
      this.graph.graphviz.resetZoom()
    },
    getGraphTransform () {
      if (this.dotString.startsWith('sequenceDiagram')) {
        return null
      }
      let domId = '#graphMgmt' + this.graphIndex + ' > svg'
      let svg = d3.select(domId)
      return d3Zoom.zoomTransform(svg.node())
    },
    setGraphTransform (transform) {
      this.graph.graphviz.zoomSelection().call(this.graph.graphviz.zoomBehavior().transform, transform)
    },
    async initGraph (confirmTime, graphNum) {
      this.confirmTime = confirmTime
      this.graphNum = graphNum
      this.loading = true
      const initEvent = id => {
        let graph
        graph = d3.select(id)
        graph
          .on('dblclick.zoom', null)
          .on('wheel.zoom', null)
          .on('mousewheel.zoom', null)
      }
      // 初始化画布和鼠标事件
      let domId = '#graphMgmt' + this.graphIndex
      initEvent(domId)
      await this.renderGraph(domId)
      // 服务调用图
      this.loading = false
    },
    async graphQueryReferenceCiData (ciTypeAttrId, editRefAttr, refAttrValue) {
      let params = {}
      params[editRefAttr] = refAttrValue
      const { data } = await queryReferenceCiData({
        attrId: ciTypeAttrId,
        queryObject: {
          filters: [{ name: 'guid', operator: 'eq', value: refAttrValue }],
          paging: false,
          dialect: { associatedData: params }
        }
      })
      // TODO: remove filter when api support filters
      return data.filter(element => {
        if (element.guid === refAttrValue) {
          return true
        } else {
          return false
        }
      })
    },
    loadImage (nodesString) {
      const imageTags = (nodesString.match(/image=[^;]*(files\/\d*|png)/g) || []).filter((value, index, self) => {
        return self.indexOf(value) === index
      })
      const imagePaths = imageTags.map(keyvaluepaire => {
        return keyvaluepaire.substr(7)
      })

      imagePaths.forEach(image => {
        this.graph.graphviz.addImage(image, '48px', '48px')
      })
    },
    nodeConfigStyle (setting, item) {
      let useMapping = setting.graphConfigData.length !== 0
      let styleData = {}
      if (useMapping) {
        styleData = JSON.parse(setting.graphConfigs)
      } else {
        styleData = setting.graphConfigs || ''
      }
      if (useMapping) {
        return styleData[item[setting.graphConfigData] || ''] || ''
      } else {
        return styleData
      }
    },
    async renderGraph (id) {
      let graphIndex = this.graphIndex
      let graphSetting = this.graphSetting
      let graphData = this.graphData
      this.plainDatas = []
      this.buildPlainDatas(graphSetting, graphData, graphIndex)
      let params = {
        viewId: this.graphSetting.report,
        rootCi: this.graphData[0].guid,
        graphId: this.graphSetting.graphs[this.graphNum].rootData.graph
      }
      if (this.confirmTime) {
        params.confirmTime = this.confirmTime
      }
      // let params = {
      //   viewId: 'app_arc',
      //   rootCi: 'app_system_design_60b9e3479afe1d2c',
      //   graphId: 'app_arc__service',
      // }
      const { data, statusCode } = await viewGraphDot(params)
      let dotString = ''
      if (statusCode === 'OK') {
        dotString = data
      }
      // let dotString = renderGraph(
      //   graphSetting,
      //   graphData,
      //   ci => {
      //     return '/wecmdb/fonts/' + this.ciTypeMapping[ci].imageFile
      //   },
      //   [graphIndex]
      // )[0]
      this.dotString = dotString
      let graph = d3.select(id)
      if (dotString.startsWith('sequenceDiagram')) {
        const element = document.querySelector(id)
        element.removeAttribute('data-processed')
        // mermaid.parse(dotString)
        element.innerHTML = dotString
        mermaid.initialize({
          startOnLoad: false,
          securityLevel: 'antiscript',
          sequence: {
            showSequenceNumbers: true
          },
          theme: 'default'
        })
        mermaid.init(undefined, element)
        let svg = graph.select('svg')
        let rawHTML = svg.node().innerHTML
        svg.node().innerHTML = ''
        let g = svg.append('g')
        g.html(rawHTML)
        g.attr('cursor', 'grab')
        const zoomed = function (event) {
          g.attr('transform', d3.event.transform)
        }
        svg.call(d3Zoom.zoom().on('zoom', zoomed))
        let winWidth = window.innerWidth - 130
        let winHeight = window.innerHeight - 293
        svg
          .attr('width', winWidth)
          .attr('height', winHeight)
          .attr('style', '')
        // g.selectAll('.sequenceNumber').on('click', () => {console.log('click ', d3.event.target.innerHTML)})
        // let svgWidth = parseInt(svg.attr("viewBox").split(' ')[2])
        // svg.attr('viewBox', '0 0 ' + winWidth + ' ' + winHeight)
        // svg.select("g").attr("transform", `translate(${winWidth/2 - svgWidth/2}, 200) scale(1)`)

        let idFinder = /\$\{([a-z0-9]+(?:_[a-z0-9]+)+)\}/g
        // note
        svg
          .selectAll(' .noteText')
          .nodes()
          .forEach(node => {
            let rets = idFinder.exec(node.innerHTML)
            if (rets) {
              node.innerHTML = node.innerHTML.replace(idFinder, '')
              // mark node.previousElementSibling[rect] color
              let item = this.plainDatas.find(item => item.guid === rets[1])
              node.previousElementSibling.style.cssText += this.nodeConfigStyle(item.metadata.setting, item.data)
            }
          })
        // alt, opt, par
        svg
          .selectAll(' .loopText')
          .nodes()
          .forEach(node => {
            // console.log(node)
            let rets = idFinder.exec(node.innerHTML)
            if (rets) {
              node.innerHTML = node.innerHTML.replace(idFinder, '')
              // mark node.previousElementSibling[rect] color
              let item = this.plainDatas.find(item => item.guid === rets[1])
              node.parentElement.children.forEach(loopNode => {
                if (loopNode.tagName === 'line') {
                  loopNode.style.cssText += this.nodeConfigStyle(item.metadata.setting, item.data)
                }
              })
            }
          })
        // message
        svg
          .selectAll(' .messageLine1')
          .nodes()
          .forEach(node => {
            let rets = idFinder.exec(node.previousElementSibling.innerHTML)
            if (rets) {
              node.previousElementSibling.innerHTML = node.previousElementSibling.innerHTML.replace(idFinder, '')
              // mark node[line] & sibling[text] color
              let item = this.plainDatas.find(item => item.guid === rets[1])
              node.style.cssText += this.nodeConfigStyle(item.metadata.setting, item.data)
              // node.previousElementSibling.style.cssText += this.nodeConfigStyle(item.metadata.setting, item.data)
            }
          })
        svg
          .selectAll(' .messageLine0')
          .nodes()
          .forEach(node => {
            let rets = idFinder.exec(node.previousElementSibling.innerHTML)
            if (rets) {
              node.previousElementSibling.innerHTML = node.previousElementSibling.innerHTML.replace(idFinder, '')
              // mark node[line] & sibling[text] color
              let item = this.plainDatas.find(item => item.guid === rets[1])
              node.style.cssText += this.nodeConfigStyle(item.metadata.setting, item.data)
              // node.previousElementSibling.style.cssText += this.nodeConfigStyle(item.metadata.setting, item.data)
            }
          })
        // actor
        svg
          .selectAll(' text.actor')
          .nodes()
          .forEach(node => {
            let rets = idFinder.exec(node.innerHTML)
            if (rets) {
              node.innerHTML = node.innerHTML.replace(idFinder, '')
              // mark node.previousElementSibling[rect] color
              let item = this.plainDatas.find(item => item.guid === rets[1])
              node.previousElementSibling.style.cssText += this.nodeConfigStyle(item.metadata.setting, item.data)
            }
          })
      } else {
        this.graph.graphviz = graph
          .graphviz()
          .width(window.innerWidth - 130)
          .height(window.innerHeight - 293)
          .fit(true)
          .zoom(true)
        this.loadImage(dotString)
        this.graph.graphviz
          .transition()
          .renderDot(dotString)
          .on('end', () => {
            if (this.initTransform) {
              this.setGraphTransform(this.initTransform)
            }
            addEvent(id + ' > svg', 'click', this.handleNodeClick)
            // addEvent(id + ' .node', 'mouseover', this.handleNodeMouseover)
            // addEvent(id + ' .cluster', 'mouseover', this.handleNodeMouseover)
            addEvent(id + ' .node', 'click', this.handleNodeClick)
            addEvent(id + ' .cluster', 'click', this.handleNodeClick)
            addEvent(id + ' .edge', 'click', this.handleNodeClick)
          })
        let svg = graph.select('svg')
        let width = svg.attr('width')
        let height = svg.attr('height')
        if (!width.toString().endsWith('%') && !width.toString().endsWith('%')) {
          svg.attr('viewBox', '0 0 ' + width + ' ' + height)
        }
      }
    },
    buildPlainDatas (graphSetting, graphData, graphIndex = 0) {
      graphData.forEach(data => {
        let node = {
          guid: data.guid,
          ciType: graphSetting.ciType,
          parent: '',
          data: data,
          operation: data.nextOperation,
          metadata: {
            setting: graphSetting.graphs[graphIndex].rootData,
            editRefAttr: '',
            editable: graphSetting.editable
          }
        }
        this.plainDatas.push(node)
        if (graphSetting.graphs[graphIndex].rootData.children) {
          graphSetting.graphs[graphIndex].rootData.children.forEach(setting => {
            this.buildChildPlainDatas(setting, data, data[setting.dataName] || [], node.metadata)
          })
        }
      })
    },
    buildChildPlainDatas (setting, parent, datas, metadata) {
      datas.forEach(data => {
        let node = {
          guid: data.guid,
          ciType: setting.ciType,
          parent: parent.guid,
          data: data,
          operation: data.nextOperation,
          metadata: {
            setting: setting,
            editRefAttr: setting.editRefAttr,
            editable:
              'editable' in setting === false || setting.editable === null ? metadata.editable : setting.editable
          }
        }
        this.plainDatas.push(node)
        if (setting.children) {
          setting.children.forEach(childSetting => {
            this.buildChildPlainDatas(childSetting, data, data[childSetting.dataName] || [], metadata)
          })
        }
      })
    },
    async handleNodeClick (e) {
      e.preventDefault()
      e.stopPropagation()
      if (e.currentTarget.tagName === 'svg') {
        this.selectedId = ''
        this.openDrawer = false
        this.$refs.operationPanel.ciType = ''
        this.$refs.operationPanel.nodeGuid = ''
        this.$refs.operationPanel.nodeEditable = []
        this.$refs.operationPanel.childCiTypes = []
        await this.$refs.operationPanel.initNodeData('')
        return
      }
      if (e.currentTarget.id === 'graph0') {
        return
      }
      let id = e.currentTarget.id
      let allNodes = this.plainDatas.filter(el => {
        if (el.guid === id) {
          return true
        }
        return false
      })
      if (allNodes.length) {
        this.openDrawer = true
        let node = allNodes[0]
        // 高亮节点
        this.selectedId = id
        // 赋值ciType并初始化NodeData
        this.operationLoading = true
        this.$refs.operationPanel.ciType = node.ciType
        this.$refs.operationPanel.nodeGuid = id
        this.$refs.operationPanel.nodeEditable = allNodes
          .map(el => {
            return el.metadata.setting.editable
          })
          .includes('yes')
        await this.$refs.operationPanel.initNodeData(id)
        // 计算节点的子类型
        let setChildrenCiType = new Set()
        let ciTypeChildren = []
        allNodes.forEach(el => {
          ;(el.metadata.setting.children || []).forEach(gEl => {
            if (!setChildrenCiType.has(gEl.ciType) && gEl.editRefAttr) {
              ciTypeChildren.push({ ciType: gEl.ciType, editRefAttr: gEl.editRefAttr })
              setChildrenCiType.add(gEl.ciType)
            }
          })
        })
        this.$refs.operationPanel.childCiTypes = []
        let refPormises = []
        for (let index = 0; index < ciTypeChildren.length; index++) {
          const setting = ciTypeChildren[index]
          let ciTypeAttr = this.ciTypeMapping[setting.ciType].attributes.find(element => {
            if (element.propertyName === setting.editRefAttr) {
              return true
            }
          })
          // if (!ciTypeAttr){
          //   console.error('can not find editRefAttr:', setting.editRefAttr, ' from ciType:', setting.ciType)
          // }
          refPormises.push(this.graphQueryReferenceCiData(ciTypeAttr.ciTypeAttrId, setting.editRefAttr, id))
        }
        let refPormiseResponses = await Promise.all(refPormises)
        refPormiseResponses.forEach((el, idx) => {
          if (el.length > 0) {
            const setting = ciTypeChildren[idx]
            this.$refs.operationPanel.childCiTypes.push({
              ciType: setting.ciType,
              editRefAttr: setting.editRefAttr,
              name: this.ciTypeMapping[setting.ciType].name
            })
          }
        })
        this.operationLoading = false
      }
    },
    operationReload (ci, items, type = 'edit') {
      // enum of type
      // add
      // edit [default]
      // confirm
      this.$emit('graphReload', ci, items, type)
    }
  },
  mounted () {
    // this.initGraph()
  }
}
</script>

<style lang="scss" scoped>
.container-height {
  height: calc(100vh - 290px);
}
.operation-area {
  position: absolute;
  width: 450px;
  height: 100%;
  top: 0;
  right: 0;
}
.operation-container {
  height: calc(100vh - 300px);
}
.buttons {
  position: absolute;
  left: 15px;
  bottom: 15px;
}
</style>
