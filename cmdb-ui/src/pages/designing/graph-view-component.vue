<template>
  <Row>
    <Row>
      <Col span="24">
        <Card>
          <div class="container-height" :id="'graphMgmt' + graphIndex"></div>
          <span class="buttons">
            <Button @click="resetZoom">{{ $t('reset_zoom') }}</Button>
            <Button @click="graphToImg">{{ $t('cmdb_export_img') }}</Button>
            <Button @click="graphToSvg">{{ $t('cmdb_export_svg') }}</Button>
          </span>
        </Card>
        <div class="operation-area">
          <Button style="float: right" type="primary" @click="openDrawer = !openDrawer">
            {{ $t('operating_area') }}
          </Button>
          <Drawer :closable="true" :width="450" :mask="false" :transfer="false" inner v-model="openDrawer">
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
import { Canvg } from 'canvg'
import * as d3 from 'd3-selection'
import * as d3Zoom from 'd3-zoom'
import { graphviz } from 'd3-graphviz'
// eslint-disable-next-line no-unused-vars
import { queryReferenceCiData, viewGraphDot } from '@/api/server'
import mermaid from 'mermaid'
import { addEvent } from '../util/event.js'
import Operation from './graph-operation-component'
import SeqOperation from './graph-sequence-component'
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
      this.handleNodeSelection(val)
    },
    openDrawer: function (val) {
      const el = document.querySelectorAll('.operation-area')
      for (let i = 0; i < el.length; i++) {
        if (val) {
          el[i].style.width = '460px'
          el[i].style.height = '100%'
        } else {
          el[i].style.width = '200px'
          el[i].style.height = '32px'
        }
      }
    }
  },
  methods: {
    handleNodeSelection (val) {
      // 切换节点时，还原上一个节点的信息
      if (this.cachedIdInfo.id) {
        let dom = d3.select('#graphMgmt' + this.graphIndex).select(`#` + this.cachedIdInfo.id)
        if (dom.attr('class') === 'edge') {
          dom.select('path').attr('stroke', this.cachedIdInfo.pathColor)
          dom.select('polygon').attr('fill', this.cachedIdInfo.color)
          dom.select('polygon').attr('stroke', this.cachedIdInfo.pathColor)
          dom.select('text').attr('fill', this.cachedIdInfo.pathColor)
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
          const polygon = dom.select('polygon')
          if (!polygon.empty()) {
            this.cachedIdInfo.color = dom.select('polygon').attr('fill')
          }
          dom.select('path').attr('stroke', '#F29360')
          dom.select('polygon').attr('fill', '#F29360')
          dom.select('polygon').attr('stroke', '#F29360')
          dom.select('text').attr('fill', '#F29360')
        } else {
          this.cachedIdInfo.graph = ''
          let typeArray = ['path', 'polygon', 'ellipse', 'rect']
          typeArray.forEach(type => {
            if (dom.select(type)._groups[0][0]) {
              this.cachedIdInfo.graph = type
            }
          })
          this.cachedIdInfo.type = 'node'
          this.cachedIdInfo.color = dom.select(this.cachedIdInfo.graph).attr('fill')
          // 设置高亮颜色
          dom.select(this.cachedIdInfo.graph).attr('fill', '#F29360')
        }
      }
    },
    async graphToImg () {
      const graphId = 'graphMgmt' + this.graphIndex
      const graphElement = document.getElementById(graphId)
      let svgElements = document.body.querySelectorAll(`#${graphId} svg`)
      const canvas = document.createElement('canvas')
      canvas.width = graphElement.getBoundingClientRect().width
      canvas.height = graphElement.getBoundingClientRect().height
      const context = canvas.getContext('2d')
      // replace &nbsp; with space or canvg will throw error
      const replaceNbsp = svgElements[0].outerHTML.replaceAll('&nbsp;', ' ')
      const canvgInstance = await Canvg.from(context, replaceNbsp)
      canvgInstance.resize(
        graphElement.getBoundingClientRect().width * 3,
        graphElement.getBoundingClientRect().height * 3
      )
      await canvgInstance.render()
      let pngDataUrl = canvas.toDataURL('image/png')
      const link = document.createElement('a')
      link.href = pngDataUrl
      link.download = this.graphSetting.graphs[this.graphIndex].graphExportName + '.png'
      link.click()
    },
    graphToSvg () {
      const svgElement = document.getElementById('graphMgmt' + this.graphIndex).querySelector('svg')
      const serializer = new XMLSerializer()
      const svgData = serializer.serializeToString(svgElement)
      const utf8EncodedSvgData = unescape(encodeURIComponent(svgData))
      const base64SvgData = btoa(utf8EncodedSvgData)
      const imgData = 'data:image/svg+xml;base64,' + base64SvgData
      const link = document.createElement('a')
      link.href = imgData
      link.download = this.graphSetting.graphs[this.graphIndex].graphExportName + '.svg'
      link.click()
    },
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
      this.openDrawer = false
      this.confirmTime = confirmTime
      this.graphNum = graphNum
      this.graphIndex = graphNum
      this.loading = true
      const initEvent = id => {
        let graph
        graph = d3.select(id)
        graph.on('dblclick.zoom', null).on('wheel.zoom', null).on('mousewheel.zoom', null)
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
        viewId: this.graphSetting.viewId,
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
        // if (data.indexOf('\n') !== -1) {
        //   dotString = data.replace(/\\n/g, '');
        // }
        dotString = data
      }
      this.dotString = dotString
      if (!d3.select.prototype.graphviz) {
        d3.select.prototype.graphviz = graphviz;
      }
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
        let svg = graph.selectAll('svg')
        let rawHTML = svg.node().innerHTML
        svg.node().innerHTML = ''
        let g = svg.append('g')
        g.html(rawHTML)
        g.attr('cursor', 'grab')
        const zoomed = function (event) {
          g.attr('transform', event.transform)
        }
        svg.call(d3Zoom.zoom().on('zoom', zoomed))
        let winWidth = window.innerWidth - 130
        let winHeight = window.innerHeight - 293
        svg.attr('width', winWidth).attr('height', winHeight).attr('style', '')
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

            // let svg = graph.select('svg')

            // let width = svg.attr('width')
            // let height = svg.attr('height')
            // if (!width.toString().endsWith('%') && !width.toString().endsWith('%')) {
            //   svg.attr('viewBox', '0 0 ' + width + ' ' + height)
            // }
          })
      }
      // 为解决系统部署视图中选中节点切换tab仍显示选中态特殊逻辑
      this.findAbnormalEle()
    },
    findAbnormalEle () {
      const polygons = document.querySelectorAll('polygon[fill="#F29360"]')
      // 遍历每个 polygon 元素
      polygons.forEach(polygon => {
        // 向上查找第一个父元素，其 class 包含 "edge node"
        const parentEle = polygon.closest('.edge, .node')
        // 如果找到带 class="edge" 的父元素，输出其 id
        if (parentEle) {
          this.fixAbnormalEle(parentEle.id)
        }
      })
    },
    fixAbnormalEle (val) {
      const groupElement = document.getElementById(val)
      if (groupElement.getAttribute('class') === 'edge') {
        const text = groupElement.querySelector('text')
        if (text) {
          text.setAttribute('fill', 'black')
        }

        const path = groupElement.querySelector('path')
        if (path) {
          path.setAttribute('stroke', 'green')
        }

        const polygon = groupElement.querySelector('polygon')
        if (polygon) {
          polygon.setAttribute('stroke', 'green')
          polygon.setAttribute('fill', 'green')
        }
      } else if (groupElement.getAttribute('class') === 'node') {
        const polygon = groupElement.querySelector('polygon')
        if (polygon) {
          polygon.setAttribute('stroke', 'green')
          polygon.setAttribute('fill', 'white')
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
      if (!Array.isArray(datas)) {
        return
      }
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
        this.handleNodeSelection(id)
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
  height: calc(100vh - 275px);
}
.operation-area {
  position: absolute;
  width: 200px;
  height: 32px;
  top: 0;
  right: 0;
}
.operation-container {
  // height: calc(100vh - 300px);
}
.buttons {
  position: absolute;
  left: 15px;
  bottom: 15px;
}
.buttons > button {
  margin-right: 5px;
}
</style>
