<template>
  <div>
    <Row class="resource-design-tab-row">
      <Row>
        <Col span="24">
          <Card>
            <div class="graph-container-big" id="graph"></div>

            <div class="operation-area">
              <Collapse>
                <Panel name="1">
                  {{ $t('operating_area') }}
                  <div slot="content">
                    <Operation
                      ref="transferData"
                      @operationReload="operationReload"
                      @markZone="markZone"
                      @markEdge="markEdge"
                    ></Operation>
                  </div>
                </Panel>
              </Collapse>
            </div>
          </Card>
        </Col>
      </Row>
    </Row>
  </div>
</template>

<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line no-unused-vars
import * as d3Graphviz from 'd3-graphviz'
import { getEnumCodesByCategoryId, queryCiData, getTreeData } from '@/api/server'
import { colors, defaultFontSize as fontSize } from '../../const/graph-configuration'
import { addEvent } from '../util/event.js'
import {
  VIEW_CONFIG_PARAMS,
  NETWORK_SEGMENT_DESIGN,
  IDC_PLANNING_LINK_ID,
  IDC_PLANNING_LINK_FROM,
  IDC_PLANNING_LINK_TO
} from '@/const/init-params.js'
import Operation from './planning-operation'
import exprLineFinder from '@/const/format-links'

export default {
  data () {
    return {
      graphCiTypeId: 12,
      graph: {},
      idcDesignData: null,
      idcLink: [],
      spinShow: false,
      graphNodes: {},
      graphData: [], // 缓存所有接口返回数据
      operateNodeData: [], // 操作区数据
      firstChildrenGroup: [], // 第一层子节点id
      idPath: [], // 缓存点击图形区域从内向外容器ID值
      cacheIdPath: [], // 缓存点击图形区域从内向外容器ID值
      cacheIndex: [], // 缓存点击图形区域从内向外容器ID值
      levelData: [], // 缓存层级数据备用
      effectiveLink: [], // 图中可显示连线
      activeNodeInfo: {
        id: '',
        type: '',
        color: ''
      },
      activeLineGuid: '',

      linkExpr: {
        exprFrom:
          'network_link_design.network_segment_design_1>network_segment_design~(network_segment_design)network_zone_design',
        exprTo:
          'network_link_design.network_segment_design_2>network_segment_design~(network_segment_design)network_zone_design'
      }
    }
  },
  watch: {
    cacheIdPath: function (val) {
      // 选中节点颜色控制
      if (this.activeNodeInfo.id) {
        d3.select('#graph')
          .select(`#` + this.activeNodeInfo.id)
          .select(this.activeNodeInfo.type)
          .attr('fill', this.activeNodeInfo.color)
        this.activeNodeInfo = {}
      }
      const id = val[val.length - 1]
      this.activeNodeInfo.type = d3
        .select('#graph')
        .select(`#` + id)
        .select('polygon')._groups[0][0]
        ? 'polygon'
        : 'rect'
      const color = d3
        .select('#graph')
        .select(`#` + id)
        .select(this.activeNodeInfo.type)
        .attr('fill')
      this.activeNodeInfo.id = id
      this.activeNodeInfo.color = color
      d3.select('#graph')
        .select(`#` + id)
        .select(this.activeNodeInfo.type)
        .attr('fill', '#ff9900')
    }
  },
  methods: {
    markZone (guid) {
      this.cacheIdPath = [`g_` + guid]
    },
    markEdge (guid) {
      if (this.activeLineGuid) {
        d3.select('#graph')
          .select(`#a_gl_` + this.activeLineGuid)
          .select('a')
          .select('path')
          .attr('stroke', '#000000')
        d3.select('#graph')
          .select(`#gl_` + this.activeLineGuid)
          .select('text')
          .attr('fill', '#000000')
      }
      this.activeLineGuid = guid
      d3.select('#graph')
        .select(`#a_gl_` + guid)
        .select('a')
        .select('path')
        .attr('stroke', '#ff9900')
      d3.select('#graph')
        .select(`#gl_` + guid)
        .select('text')
        .attr('fill', '#ff9900')
    },
    operationReload (operateNodeData, operateLineData) {
      // this.onIdcDataChange(this.guid)
      if (!operateNodeData) {
        this.loadMap(this.graphData, operateLineData)
        return
      }
      let tmp = this.graphData[0]
      this.levelData = []
      let tmpData = null
      if (this.cacheIdPath.length) {
        this.cacheIdPath.forEach(id => {
          this.levelData.unshift(tmp)
          tmp = tmp.children.find(child => {
            return `g_${child.guid}` === id
          })
        })
        this.levelData.forEach(dataTmp => {
          dataTmp.children[this.cacheIndex[0]] = operateNodeData
          tmpData = dataTmp
        })
      } else {
        tmpData = operateNodeData
      }
      this.$refs.transferData.managementData(operateNodeData)
      this.loadMap([tmpData], operateLineData)
    },
    loadMap (graphData, operateLineData) {
      this.graphData = graphData
      this.graphData[0].children.forEach(_ => {
        this.firstChildrenGroup.push(`g_${_.guid}`)
      })
      const sortingTree = array => {
        let obj = {}
        array.forEach(_ => {
          _.text = [_.data.code]
          if (_.data[this.initParams[NETWORK_SEGMENT_DESIGN]] instanceof Array) {
            let text = []
            _.data[this.initParams[NETWORK_SEGMENT_DESIGN]].forEach(networkSegmentDesign => {
              text.push(networkSegmentDesign.code)
            })
            _.text.push(`[${text.join(', ')}]`)
          } else if (typeof _.data[this.initParams[NETWORK_SEGMENT_DESIGN]] === 'object') {
            _.text.push(_.data[this.initParams[NETWORK_SEGMENT_DESIGN]].code || '')
          }
          if (_.children instanceof Array) {
            _.children = sortingTree(_.children)
          }
          obj[_.data.code + _.guid] = _
        })
        return Object.keys(obj)
          .sort()
          .map(_ => obj[_])
      }
      this.idcDesignData = sortingTree(graphData)
      if (operateLineData) {
        const lineInfoData = operateLineData.lineInfo.data
        if (operateLineData.type === 'add') {
          this.idcLink.push({
            guid: lineInfoData.guid,
            from: lineInfoData[this.initParams[IDC_PLANNING_LINK_TO]].guid,
            linkInfo: {
              ...lineInfoData,
              ciTypeId: this.initParams[IDC_PLANNING_LINK_ID]
            },
            to: lineInfoData[this.initParams[IDC_PLANNING_LINK_FROM]].guid,
            label: lineInfoData.code,
            state: lineInfoData.state.code
          })
        }
        if (operateLineData.type === 'edit') {
          const index = this.idcLink.findIndex(_ => {
            return _.guid === lineInfoData.guid
          })
          this.idcLink[index] = {
            guid: lineInfoData.guid,
            from: lineInfoData[this.initParams[IDC_PLANNING_LINK_TO]].guid,
            linkInfo: {
              ...lineInfoData,
              ciTypeId: this.initParams[IDC_PLANNING_LINK_ID]
            },
            to: lineInfoData[this.initParams[IDC_PLANNING_LINK_FROM]].guid,
            label: lineInfoData.code,
            state: lineInfoData.state.code
          }
        }
        if (operateLineData.type === 'remove') {
          const index = this.idcLink.findIndex(_ => {
            return _.guid === lineInfoData.guid
          })
          this.idcLink.splice(index, 1)
        }
      }
      this.initGraph()
    },
    async onIdcDataChange (guid) {
      this.guid = guid
      this.spinShow = true
      const { data, statusCode } = await getTreeData(this.graphCiTypeId, [guid])
      this.graphData = data
      this.firstChildrenGroup = []
      this.graphData[0].children.forEach(_ => {
        this.firstChildrenGroup.push(`g_${_.guid}`)
      })
      this.operateNodeData = this.graphData[0]
      this.$refs.transferData.graphCiTypeId = this.graphCiTypeId
      this.$refs.transferData.managementData(this.operateNodeData)
      if (statusCode === 'OK') {
        const sortingTree = array => {
          let obj = {}
          array.forEach(_ => {
            _.text = [_.data.code]
            if (_.data[this.initParams[NETWORK_SEGMENT_DESIGN]] instanceof Array) {
              let text = []
              _.data[this.initParams[NETWORK_SEGMENT_DESIGN]].forEach(networkSegmentDesign => {
                text.push(networkSegmentDesign.code)
              })
              _.text.push(`[${text.join(', ')}]`)
            } else if (typeof _.data[this.initParams[NETWORK_SEGMENT_DESIGN]] === 'object') {
              _.text.push(_.data[this.initParams[NETWORK_SEGMENT_DESIGN]].code || '')
            }
            if (_.children instanceof Array) {
              _.children = sortingTree(_.children)
            }
            obj[_.data.code + _.guid] = _
          })
          return Object.keys(obj)
            .sort()
            .map(_ => obj[_])
        }
        this.idcDesignData = sortingTree(data)
        this.getZoneLink()
      }
    },
    initGraph (filters = {}) {
      let graph
      graph = d3.select('#graph')
      graph
        .on('dblclick.zoom', null)
        .on('wheel.zoom', null)
        .on('mousewheel.zoom', null)
      let graphZoom = graph
        .graphviz()
        .width(window.innerWidth - 60)
        .height(window.innerHeight - 255)
        .zoom(true)
        .fit(true)
      const idcData = this.idcDesignData[0]
      this.graph = graphZoom
      this.renderGraph(idcData)
      this.spinShow = false
    },
    genDOT (idcData) {
      this.graphNodes = {}
      let width = 16
      let height = 12
      let dots = [
        'digraph G {',
        'rankdir=TB nodesep=0.5;',
        `Node[shape=box,fontsize=${fontSize},labelloc=t,penwidth=2];`,
        'Edge[fontsize=8,arrowhead="none"];',
        `subgraph cluster_${idcData.data.guid} {`,
        `style="filled";color="${colors[0]}";`,
        `label="${idcData.data.name || idcData.data.description || idcData.data.code}";`,
        `size="${width},${height}";`,
        this.genChildren(idcData),
        this.genLink(),
        '}}'
      ]
      return dots.join('')
    },
    genChildren (idcData) {
      const width = 16
      const height = 12
      let dots = []
      const children = idcData.children || []
      // this.ResourceCollection = []
      // children.forEach(_ => {
      //   const node = this.dataSelector(_, this.graphConfig.nodePath)
      //   Array.isArray(node) ? this.ResourceCollection.push(...node) : this.ResourceCollection.push(node)
      // })
      let layers = new Map()
      children.forEach(zone => {
        if (layers.has(zone.data.network_zone_layer)) {
          layers.get(zone.data.network_zone_layer).push(zone)
        } else {
          let layer = []
          layer.push(zone)
          layers.set(zone.data.network_zone_layer, layer)
        }
      })
      if (layers.size) {
        layers.forEach(layer => {
          dots.push('{rank = "same";')
          let n = layers.size
          let lg = (height - 3) / n
          let ll = (width - 0.5 * layer.length) / layer.length
          layer.forEach(zone => {
            let label
            if (zone.data.code) {
              label = `${zone.data.code}\n${
                zone.data[this.initParams[NETWORK_SEGMENT_DESIGN]]
                  ? zone.data[this.initParams[NETWORK_SEGMENT_DESIGN]].code
                  : ''
              }`
            } else {
              label = zone.data.key_name
            }
            this.graphNodes[zone.guid] = zone
            dots.push(
              `g_${zone.guid}[id="g_${zone.guid}",style="filled",color="${colors[1]}",label="${label}",width=${ll},height=${lg}];`
            )
          })
          dots.push('}')
        })
      } else {
        dots.push(
          `g_${idcData.data.guid}[label=" ";style="filled";color="${colors[1]}";width="${width -
            0.5}";height="${height - 3}"]`
        )
      }
      return dots.join('')
    },
    genLink () {
      // let dots = []
      // let networkToNode = {}
      // this.ResourceCollection.forEach(rc => {
      //   const nodeGuid = this.dataSelector(rc, this.graphConfig.nodeKey)
      //   if (Object.keys(networkToNode).includes(nodeGuid)) {
      //     networkToNode[nodeGuid].push(rc.guid)
      //   } else {
      //     networkToNode[nodeGuid] = [rc.guid]
      //   }
      // })
      // this.effectiveLink = []
      // this.idcLink.forEach(_ => {
      //   if (networkToNode[_.from] && networkToNode[_.to]) {
      //     this.effectiveLink.push(_.linkInfo)
      //     networkToNode[_.from].forEach(from => {
      //       networkToNode[_.to].forEach(to => {
      //         dots.push(
      //           `g_${to} -> g_${from}[id=gl_${_.guid},tooltip="${_.label || ''}",taillabel="${_.label || ''}"];`
      //         )
      //       })
      //     })
      //   }
      // })
      let dots = []
      this.idcLink.forEach(_ => {
        if (_.from in this.graphNodes && _.to in this.graphNodes) {
          this.effectiveLink.push(_.linkInfo)
          dots.push(
            `g_${_.from} -> g_${_.to}[id=gl_${_.guid},tooltip="${_.label || ''}",taillabel="${_.label || ''}"];`
          )
        }
      })
      this.$refs.transferData.linkManagementData(this.effectiveLink)
      return dots.join('')
    },
    handleNodeClick (e) {
      this.idPath.unshift(e.currentTarget.id)
      this.cacheIdPath = []
      this.cacheIndex = []
      this.cacheIdPath = JSON.parse(JSON.stringify(this.idPath))
      if (this.firstChildrenGroup.includes(e.currentTarget.id)) {
        let tmp = this.graphData[0]
        this.idPath.forEach(id => {
          tmp = tmp.children.find((child, index) => {
            if (`g_${child.guid}` === id) {
              this.cacheIndex.push(index)
              return child
            }
          })
        })
        this.idPath = []
        this.operateNodeData = tmp
        this.$refs.transferData.managementData(this.operateNodeData)
      }
    },
    handleEdgeClick (e) {
      let guid = e.currentTarget.id.substring(3)
      this.markEdge(guid)
      const selectLink = this.effectiveLink.find(link => {
        return link.guid === guid
      })
      this.$refs.transferData.openLinkPanal([selectLink.guid], selectLink.tableName)
    },
    renderGraph (idcData) {
      let nodesString = this.genDOT(idcData)
      this.graph
        .transition()
        .renderDot(nodesString)
        .on('end', () => {
          addEvent('.node', 'click', this.handleNodeClick)
          addEvent('.edge', 'click', this.handleEdgeClick)
        })
      // 最外图层选中处理
      d3.select('#clust1').on('click', () => {
        this.$refs.transferData.managementData(this.graphData[0])
        if (this.activeNodeInfo.id) {
          d3.select('#graph')
            .select(`#` + this.activeNodeInfo.id)
            .select(this.activeNodeInfo.type)
            .attr('fill', this.activeNodeInfo.color)
          this.activeNodeInfo = {}
        }
      })
      let divWidth = window.innerWidth - 20
      let divHeight = window.innerHeight - 220
      let children = idcData.children || []
      let svg = d3.select('#graph').select('svg')
      svg.attr('width', divWidth).attr('height', divHeight)
      svg.attr('viewBox', '0 0 ' + divWidth + ' ' + divHeight)
      children.forEach(zone => {
        d3.select(`#g_${zone.guid}`)
          .select('polygon')
          .attr('fill', '#000000')
        if (Array.isArray(zone.children)) {
          const childrenX = d3.select('#g_' + zone.guid)._groups[0][0].__data__.children
          const polygon = childrenX.filter(child => {
            return child.tag === 'polygon'
          })
          const pointX = polygon[0].attributes.points.split(',')
          let p1 = {
            x: parseInt(pointX[1].split(' ')[1]),
            y: parseInt(pointX[1].split(' ')[0])
          }
          let pw1 = parseInt(pointX[0] - pointX[1].split(' ')[1])
          let ph1 = parseInt(pointX[3].split(' ')[0] - pointX[2].split(' ')[0])
          this.setChildren(zone, p1, pw1, ph1, fontSize, 2, 1)

          // let points = d3
          //   .select('#g_' + zone.guid)
          //   .select('polygon')
          //   .attr('points')
          //   .split(' ')
          // let p = {
          //   x: parseInt(points[1].split(',')[0]),
          //   y: parseInt(points[1].split(',')[1])
          // }
          // let pw = parseInt(points[0].split(',')[0] - points[1].split(',')[0])
          // let ph = parseInt(points[2].split(',')[1] - points[1].split(',')[1])
          // this.setChildren(zone, p, pw, ph, fontSize, 2, 1)
        }
      })
    },
    setChildren (node, p1, pw, ph, tfsize, tlength = 1, deep) {
      let graph = d3.select('#graph').select('#g_' + node.guid)
      const n = node.children.length
      let w, h, mgap, fontsize, strokewidth
      let rx, ry, tx, ty, g
      let color = colors[deep + 1]
      if (pw > ph * 1.2) {
        if (pw / n > ph - tfsize * tlength) {
          mgap = (ph - tfsize * tlength) * 0.04
          fontsize = tfsize * 0.8 > (ph - tfsize) * 0.2 ? (ph - tfsize) * 0.2 : tfsize * 0.8
          strokewidth = (ph - tfsize) * 0.005
        } else {
          mgap = (pw / n) * 0.04
          fontsize = tfsize * 0.8 > (pw / n) * 0.2 ? (pw / n) * 0.2 : tfsize * 0.8
          strokewidth = (pw / n) * 0.005
        }
        w = (pw - mgap) / n - mgap
        h = ph - tfsize * tlength - 2 * mgap
        for (let i = 0; i < n; i++) {
          const _tlength = node.children[i].text.length
          rx = p1.x + (w + mgap) * i + mgap
          ry = p1.y + tfsize * tlength + mgap
          tx = p1.x + (w + mgap) * i + w * 0.5 + mgap
          g = graph
            .append('g')
            .attr('class', 'node')
            .attr('id', `g_${node.children[i].guid}`)
          let _ry = ry
          let _h = h
          if (Array.isArray(node.children[i].children)) {
            ty = p1.y + tfsize * tlength + mgap + fontsize
          } else {
            _ry = ry
            _h = h
            ty = p1.y + tfsize * tlength + mgap + _h * 0.5
          }
          g.append('rect')
            .attr('x', rx)
            .attr('y', _ry)
            .attr('width', w)
            .attr('height', _h)
            .attr('stroke', 'black')
            .attr('fill', color)
            .attr('stroke-width', strokewidth)
          g.append('text')
            .attr('x', tx)
            .attr('y', ty)
            .attr('style', 'text-anchor:middle')
          node.children[i].text.forEach((_, index) => {
            const _fontsize = (2 * w) / _.length < fontsize ? (2 * w) / _.length : fontsize
            g.select('text')
              .append('tspan')
              .attr('font-size', _fontsize)
              .attr('x', tx)
              .attr('y', ty + fontsize * index)
              .attr('title', _)
              .text(_)
          })
          if (Array.isArray(node.children[i].children)) {
            this.setChildren(node.children[i], { x: rx, y: _ry }, w, _h, fontsize, _tlength, deep + 1)
          }
        }
      } else {
        if ((ph - tfsize) / n > pw) {
          mgap = pw * 0.04
          fontsize = tfsize * 0.8 > pw * 0.2 ? pw * 0.2 : tfsize * 0.8
          strokewidth = pw * 0.005
        } else {
          mgap = ((ph - tfsize) / n) * 0.04
          fontsize = tfsize * 0.8 > ((ph - tfsize) / n) * 0.2 ? ((ph - tfsize) / n) * 0.2 : tfsize * 0.8
          strokewidth = ((ph - tfsize) / n) * 0.005
        }
        w = pw - 2 * mgap
        h = (ph - tfsize * tlength - mgap) / n - mgap
        for (let i = 0; i < n; i++) {
          const _tlength = node.children[i].text.length
          rx = p1.x + mgap
          ry = p1.y + tfsize * tlength + (h + mgap) * i + mgap
          tx = p1.x + w * 0.5 + mgap
          if (Array.isArray(node.children[i].children)) {
            ty = p1.y + _tlength * tfsize + (h + mgap) * i + fontsize + mgap
          } else {
            ty = p1.y + tfsize * _tlength + (h + mgap) * i + mgap + h * 0.5
          }
          g = graph
            .append('g')
            .attr('class', 'node')
            .attr('id', `g_${node.children[i].guid}`)
          g.append('rect')
            .attr('x', rx)
            .attr('y', ry)
            .attr('width', w)
            .attr('height', h)
            .attr('stroke', 'black')
            .attr('fill', color)
            .attr('stroke-width', strokewidth)
          g.append('text')
            .attr('x', tx)
            .attr('y', ty)
            .attr('style', 'text-anchor:middle')
          node.children[i].text.forEach((_, index) => {
            const _fontsize = (2 * w) / _.length < fontsize ? (2 * w) / _.length : fontsize
            g.select('text')
              .append('tspan')
              .attr('font-size', _fontsize)
              .attr('x', tx)
              .attr('y', ty + fontsize * index)
              .text(_)
          })
          if (Array.isArray(node.children[i].children)) {
            this.setChildren(node.children[i], { x: rx, y: ry }, w, h, fontsize, _tlength, deep + 1)
          }
        }
      }
    },
    async getZoneLink () {
      // this.idcLink = []
      const payload = {
        id: this.initParams[IDC_PLANNING_LINK_ID],
        queryObject: {}
      }
      const { statusCode, data } = await queryCiData(payload)
      if (statusCode === 'OK') {
        this.idcLink = await exprLineFinder(this.linkExpr, data.contents, this.initParams[IDC_PLANNING_LINK_ID])
        // this.idcLink = data.contents.map(_ => {
        //   return {
        //     guid: _.data.guid,
        //     from: _.data[this.initParams[IDC_PLANNING_LINK_TO]].guid,
        //     linkInfo: {
        //       ..._.data,
        //       meta: _.meta,
        //       ciTypeId: this.initParams[IDC_PLANNING_LINK_ID]
        //     },
        //     to: _.data[this.initParams[IDC_PLANNING_LINK_FROM]].guid,
        //     label: _.data.code,
        //     state: _.data.state.code
        //   }
        // })
      }
      this.initGraph()
    },
    async getConfigParams () {
      const { statusCode, data } = await getEnumCodesByCategoryId(0, VIEW_CONFIG_PARAMS)
      if (statusCode === 'OK') {
        this.initParams = {}
        data.forEach(_ => {
          this.initParams[_.code] = _.value
        })
      }
    },
    dataSelector (data = {}, rule = '') {
      // eslint-disable-next-line no-unused-vars
      let tmp = data
      if (rule !== '') {
        const ruleArray = rule.split('.')
        if (ruleArray.length > 0) {
          ruleArray.forEach(r => {
            tmp = tmp[r]
          })
        }
      }
      return tmp
    }
  },
  mounted () {
    this.getConfigParams()

    this.graphConfig = {
      nodePath: '',
      nodeKey: 'data.network_segment_design.guid',
      fromKey: 'data.network_segment_design_2.guid',
      toKey: 'data.network_segment_design_1.guid'
    }
    // this.graphConfig = {
    //   nodePath: 'children',
    //   nodeKey: 'data.network_segment_design.f_network_segment_design',
    //   fromKey: 'data.network_segment_design_1.guid',
    //   toKey: 'data.network_segment_design_2.guid'
    // }
  },
  components: {
    Operation
  }
}
</script>

<style lang="scss" scoped>
.operation-area {
  position: absolute;
  width: 450px;
  top: 10px;
  right: 0px;
}
</style>
