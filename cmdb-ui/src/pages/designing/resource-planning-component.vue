<template>
  <div>
    <Row class="resource-design-tab-row">
      <Row>
        <Col span="24">
          <Card>
            <div class="graph-container-big" id="resourcePlanningGraph"></div>
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
// eslint-disable-next-line
import * as d3Graphviz from 'd3-graphviz'
import { getResourcePlanningCiData, getEnumCodesByCategoryId, queryCiData, getTreeData } from '@/api/server'
import { colors, defaultFontSize as fontSize } from '../../const/graph-configuration'
import TreeSelect from '../components/tree-select.vue'
import {
  VIEW_CONFIG_PARAMS,
  REGIONAL_DATA_CENTER,
  NETWORK_SEGMENT,
  LAYER,
  RESOURCE_PLANNING_LINK_ID,
  RESOURCE_PLANNING_ROUTER_CODE,
  DEFAULT_SECURITY_POLICY_CODE
} from '@/const/init-params.js'
import Operation from './planning-operation'
import { addEvent } from '../util/event.js'
import exprLineFinder from '@/const/format-links'

export default {
  components: {
    TreeSelect,
    Operation
  },
  data () {
    return {
      graphCiTypeId: 22,
      initParams: {},
      treeIdcs: [],
      selectedIdcs: [],
      payload: {
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true
      },
      graph: {},
      routerGraph: {},
      idcData: [],
      currentGraph: '',
      spinShow: false,
      isDataChanged: false,
      lineData: [],
      graphNodes: {},
      compareColumns: [],
      compareData: [],

      operateNodeData: [],
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
        exprFrom: 'network_link.network_segment_1>network_segment~(network_segment)network_zone',
        exprTo: 'network_link.network_segment_2>network_segment~(network_segment)network_zone'
      }
    }
  },
  watch: {
    cacheIdPath: function (val) {
      // 选中节点颜色控制
      if (this.activeNodeInfo.id) {
        d3.select('#resourcePlanningGraph')
          .select(`#` + this.activeNodeInfo.id)
          .select(this.activeNodeInfo.type)
          .attr('fill', this.activeNodeInfo.color)
        this.activeNodeInfo = {}
      }
      const id = val[val.length - 1]
      this.activeNodeInfo.type = d3
        .select('#resourcePlanningGraph')
        .select(`#` + id)
        .select('polygon')._groups[0][0]
        ? 'polygon'
        : 'rect'
      const color = d3
        .select('#resourcePlanningGraph')
        .select(`#` + id)
        .select(this.activeNodeInfo.type)
        .attr('fill')
      this.activeNodeInfo.id = id
      this.activeNodeInfo.color = color
      d3.select('#resourcePlanningGraph')
        .select(`#` + id)
        .select(this.activeNodeInfo.type)
        .attr('fill', '#ff9900')
    }
  },
  mounted () {
    this.initGraph()
  },
  methods: {
    operationReload (operateNodeData, operateLineData) {
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
            return `n_${child.guid}` === id
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
    async loadMap (graphData, operateLineData) {
      this.graphData = graphData
      this.graphData[0].children.forEach(_ => {
        this.firstChildrenGroup.push(`g_${_.guid}`)
      })
      const sortingTree = array => {
        let obj = {}
        array.forEach(_ => {
          _.text = [_.data.code]
          if (_.data[this.initParams[NETWORK_SEGMENT]] instanceof Array) {
            let text = []
            _.data[this.initParams[NETWORK_SEGMENT]].forEach(networkSegment => {
              text.push(networkSegment.code)
            })
            _.text.push(`[${text.join(', ')}]`)
          } else if (typeof _.data[this.initParams[NETWORK_SEGMENT]] === 'object') {
            _.text.push(_.data[this.initParams[NETWORK_SEGMENT]].code || '')
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
      this.idcData = sortingTree(graphData)
      if (operateLineData) {
        const lineInfoData = operateLineData.lineInfo.data
        if (operateLineData.type === 'add') {
          // this.lineData.push({
          //   guid: lineInfoData.guid,
          //   from: lineInfoData[this.initParams[RESOURCE_PLANNING_LINK_FROM]].guid,
          //   linkInfo: {
          //     ...lineInfoData,
          //     ciTypeId: this.initParams[RESOURCE_PLANNING_LINK_ID]
          //   },
          //   to: lineInfoData[this.initParams[RESOURCE_PLANNING_LINK_TO]].guid,
          //   label: lineInfoData.code,
          //   state: lineInfoData.state.code
          // })
          let param = {
            data: operateLineData.lineInfo.data,
            meta: operateLineData.lineInfo.data.meta
          }
          const updateLine = await exprLineFinder(this.linkExpr, [param], this.initParams[RESOURCE_PLANNING_LINK_ID])
          this.lineData.push(updateLine[0])
        }
        if (operateLineData.type === 'edit') {
          const index = this.lineData.findIndex(_ => {
            return _.guid === lineInfoData.guid
          })
          let param = {
            data: operateLineData.lineInfo.data,
            meta: operateLineData.lineInfo.data.meta
          }
          const updateLine = await exprLineFinder(this.linkExpr, [param], this.initParams[RESOURCE_PLANNING_LINK_ID])
          this.lineData[index] = updateLine[0]
        }
        if (operateLineData.type === 'remove') {
          const index = this.lineData.findIndex(_ => {
            return _.guid === lineInfoData.guid
          })
          this.lineData.splice(index, 1)
        }
      }
      this.$nextTick(() => {
        this.initGraph()
      })
    },
    markZone (guid) {
      this.cacheIdPath = [`n_` + guid]
    },
    markEdge (guid) {
      if (this.activeLineGuid) {
        d3.select('#resourcePlanningGraph')
          .select(`#a_gl_` + this.activeLineGuid)
          .select('a')
          .select('path')
          .attr('stroke', '#000000')
        d3.select('#resourcePlanningGraph')
          .select(`#gl_` + this.activeLineGuid)
          .select('text')
          .attr('fill', '#000000')
      }
      this.activeLineGuid = guid
      d3.select('#resourcePlanningGraph')
        .select(`#a_gl_` + guid)
        .select('a')
        .select('path')
        .attr('stroke', '#ff9900')
      d3.select('#resourcePlanningGraph')
        .select(`#gl_` + guid)
        .select('text')
        .attr('fill', '#ff9900')
    },
    async onIdcDataChange (selectedIdcs) {
      this.selectedIdcs = selectedIdcs
      this.idcData = []
      if (selectedIdcs.length) {
        this.spinShow = true
        const payload = {
          id: this.initParams[RESOURCE_PLANNING_LINK_ID],
          queryObject: {}
        }
        const promiseArray = [getTreeData(this.graphCiTypeId, selectedIdcs), queryCiData(payload)]
        const [idcData, links] = await Promise.all(promiseArray)
        if (idcData.statusCode === 'OK' && links.statusCode === 'OK') {
          const regional = this.initParams[REGIONAL_DATA_CENTER]
          let _idcData = []
          idcData.data.forEach(_ => {
            if (!_.data[regional]) {
              let obj = {
                ciTypeId: _.ciTypeId,
                guid: _.guid,
                data: _.data
              }
              if (_.children instanceof Array) {
                obj.children = _.children.filter(zone => zone.ciTypeId !== _.ciTypeId)
              }
              _idcData.push(obj)
            }
          })
          const sortingTree = array => {
            let obj = {}
            array.forEach(_ => {
              _.text = [_.data.code]
              if (_.data[this.initParams[NETWORK_SEGMENT]] instanceof Array) {
                let text = []
                _.data[this.initParams[NETWORK_SEGMENT]].forEach(networkSegment => {
                  text.push(networkSegment.code)
                })
                _.text.push(`[${text.join(', ')}]`)
              } else if (typeof _.data[this.initParams[NETWORK_SEGMENT]] === 'object') {
                _.text.push(_.data[this.initParams[NETWORK_SEGMENT]].code || '')
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
          this.idcData = sortingTree(_idcData)
          this.graphData = this.idcData
          this.firstChildrenGroup = []
          this.graphData[0].children.forEach(_ => {
            this.firstChildrenGroup.push(`n_${_.guid}`)
          })
          this.operateNodeData = this.graphData[0]
          this.$refs.transferData.graphCiTypeId = this.graphCiTypeId
          this.$refs.transferData.managementData(this.operateNodeData)
          this.lineData = await exprLineFinder(
            this.linkExpr,
            links.data.contents,
            this.initParams[RESOURCE_PLANNING_LINK_ID]
          )
          // this.lineData = links.data.contents.map(_ => {
          //   return {
          //     guid: _.data.guid,
          //     from: _.data[this.initParams[RESOURCE_PLANNING_LINK_FROM]].guid,
          //     linkInfo: {
          //       ..._.data,
          //       meta: _.meta,
          //       ciTypeId: this.initParams[RESOURCE_PLANNING_LINK_ID]
          //     },
          //     to: _.data[this.initParams[RESOURCE_PLANNING_LINK_TO]].guid,
          //     label: _.data.code,
          //     state: _.data.state.code
          //   }
          // })

          this.$nextTick(() => {
            this.initGraph()
          })
        }
      } else {
        this.idcData = []
        this.lineData = []
      }
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
            if (`n_${child.guid}` === id) {
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
    initGraph () {
      let graph
      const initEvent = () => {
        graph = d3.select('#resourcePlanningGraph')
        graph
          .on('dblclick.zoom', null)
          .on('wheel.zoom', null)
          .on('mousewheel.zoom', null)
        this.graph.graphviz = graph
          .graphviz()
          .fit(true)
          .zoom(true)
          .width(window.innerWidth - 60)
          .height(window.innerHeight - 275)
      }
      initEvent()
      this.renderGraph()
      this.spinShow = false
    },
    setChildrenNode () {
      this.idcData.forEach(_ => {
        const children = _.children || []
        children.forEach(zone => {
          d3.select(`#n_${zone.guid}`)
            .select('polygon')
            .attr('fill', colors[1])
          if (zone.children instanceof Array) {
            let points = d3
              .select(`#n_${zone.guid}`)
              .select('polygon')
              .attr('points')
              .split(' ')
            let p = {
              x: parseInt(points[1].split(',')[0]),
              y: parseInt(points[1].split(',')[1])
            }
            const pw = parseInt(points[0].split(',')[0] - points[1].split(',')[0])
            const ph = parseInt(points[2].split(',')[1] - points[1].split(',')[1])
            this.setChildren(zone, p, pw, ph, fontSize, 2, 1)
          }
        })
      })
    },
    renderGraph () {
      const nodesString = this.genDOT(this.idcData)
      this.graph.graphviz
        .transition()
        .renderDot(nodesString)
        .on('end', () => {
          this.setChildrenNode()
          addEvent('.node', 'click', this.handleNodeClick)
          addEvent('.edge', 'click', this.handleEdgeClick)
        })
      // 最外图层选中处理
      d3.select('#clust1').on('click', () => {
        this.$refs.transferData.managementData(this.graphData[0])
        if (this.activeNodeInfo.id) {
          d3.select('#resourcePlanningGraph')
            .select(`#` + this.activeNodeInfo.id)
            .select(this.activeNodeInfo.type)
            .attr('fill', this.activeNodeInfo.color)
          this.activeNodeInfo = {}
        }
      })

      let width = window.innerWidth - 20
      let height = window.innerHeight - 230
      let svg = d3.select('#resourcePlanningGraph').select('svg')
      svg
        .attr('width', width)
        .attr('height', height)
        .attr('viewBox', `0 0 ${width} ${height}`)
    },
    genDOT (data) {
      this.graphNodes = {}
      const width = 16
      const height = 12
      let dots = [
        'digraph G{',
        'rankdir=TB;nodesep=0.5;',
        `Node[shape=box,fontsize=${fontSize},labelloc=t,penwidth=2];`,
        'Edge[fontsize=12,arrowhead="none"];',
        `size="${width},${height}";`
      ]
      data.forEach(idc => {
        dots.push(
          `subgraph cluster_${idc.guid} {`,
          `style="filled";color="${colors[0]}";`,
          `tooltip="${idc.data.description}";`,
          `label="${idc.data.name}";`,
          this.genChildren(idc.children || [], 1),
          '}'
        )
      })
      dots.push(this.genLines(), '}')
      return dots.join('')
    },
    genChildren (data) {
      const width = 16
      const height = 12
      let dots = []
      let layers = {}
      data.forEach(_ => {
        const layerCode = _.data[this.initParams[LAYER]] || 'otherLayer'
        if (layers[layerCode]) {
          layers[layerCode].push(_)
        } else {
          layers[layerCode] = [_]
        }
      })
      if (layers) {
        Object.keys(layers).forEach(guid => {
          const layer = layers[guid]
          dots.push('{rank=same;')
          let n = Object.keys(layers).length
          let lg = (height - 3) / n
          let ll = (width - 0.5 * layer.length) / layer.length
          layer.forEach(zone => {
            let label
            if (zone.data.code) {
              label = `${zone.data.code}\n${
                zone.data[this.initParams[NETWORK_SEGMENT]] ? zone.data[this.initParams[NETWORK_SEGMENT]].code : ''
              }`
            } else {
              label = zone.data.key_name
            }
            this.graphNodes[zone.guid] = zone
            dots.push(
              `n_${zone.guid}[id="n_${zone.guid}",color="${colors[1]}",label="${label}",width=${ll},height=${lg}];`
            )
          })
          dots.push('}')
        })
      } else {
        dots.push(`n_${data.data.guid}[label=" ",color="${colors[0]}",width="${width - 0.5}",height="${height - 3}"]`)
      }
      return dots.join('')
    },
    genLines () {
      let dots = []
      this.effectiveLink = []
      this.lineData.forEach(_ => {
        if (_.from in this.graphNodes && _.to in this.graphNodes) {
          this.effectiveLink.push(_.linkInfo)
          dots.push(
            `n_${_.from} -> n_${_.to}[id=gl_${_.guid},tooltip="${_.label || ''}",taillabel="${_.label || ''}"];`
          )
        }
      })
      this.$refs.transferData.linkManagementData(this.effectiveLink)
      return dots.join('')
    },
    setChildren (node, p1, pw, ph, tfsize, tlength = 1, deep) {
      let graph = d3.select('#resourcePlanningGraph').select('#n_' + node.guid)
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
            .attr('id', `n_${node.children[i].guid}`)
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
            ty = p1.y + tfsize * _tlength + (h + mgap) * i + mgap + fontsize
          } else {
            ty = p1.y + tfsize * _tlength + (h + mgap) * i + mgap + h * 0.5
          }
          g = graph
            .append('g')
            .attr('class', 'node')
            .attr('id', `n_${node.children[i].guid}`)
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
    async queryCiData () {
      const found = this.tabList.find(_ => _.code === this.currentTab)
      if (
        this.currentTab === this.initParams[RESOURCE_PLANNING_ROUTER_CODE] ||
        this.currentTab === this.initParams[DEFAULT_SECURITY_POLICY_CODE]
      ) {
        const payload = JSON.parse(JSON.stringify(this.payload))
        payload.paging = false
        this.$refs[this.tableRef][0].isTableLoading(true)
        const [data] = await Promise.all([
          getResourcePlanningCiData({
            idcGuid: this.selectedIdcs.join(','),
            id: found.codeId,
            queryObject: this.payload
          }),
          getResourcePlanningCiData({
            idcGuid: this.selectedIdcs.join(','),
            id: found.codeId,
            queryObject: payload
          })
        ])
        this.$refs[this.tableRef][0].isTableLoading(false)
        if (data.statusCode === 'OK') {
          this.tabList.forEach(ci => {
            if (ci.id === this.currentTab) {
              ci.tableData = data.data.contents.map(_ => {
                return {
                  ..._.data,
                  ..._.meta
                }
              })
              ci.pagination.total = data.data.pageInfo.totalRows
            }
          })
        }
      } else {
        this.$refs[this.tableRef][0].isTableLoading(true)
        const { statusCode, data } = await getResourcePlanningCiData({
          idcGuid: this.selectedIdcs.join(','),
          id: found.codeId,
          queryObject: this.payload
        })
        this.$refs[this.tableRef][0].isTableLoading(false)
        if (statusCode === 'OK') {
          this.tabList.forEach(ci => {
            if (ci.id === this.currentTab) {
              ci.tableData = data.contents.map(_ => {
                return {
                  ..._.data,
                  ..._.meta
                }
              })
              ci.pagination.total = data.pageInfo.totalRows
            }
          })
        }
      }
    },
    shadeAll (id) {
      d3.selectAll(`${id} g path`)
        .attr('stroke', '#7f8fa6')
        .attr('stroke-opacity', '.2')
      d3.selectAll(`${id} g g g polygon`)
        .attr('stroke', '#7f8fa6')
        .attr('stroke-opacity', '.2')
        .attr('fill', '#7f8fa6')
        .attr('fill-opacity', '.2')
      d3.selectAll(`${id} .edge text`).attr('fill', '#7f8fa6')
    },
    colorNode (nodeName) {
      d3.selectAll('g[from="' + nodeName + '"] path')
        .attr('stroke', 'green')
        .attr('stroke-opacity', '1')
      d3.selectAll('g[from="' + nodeName + '"] text').attr('fill', 'green')
      d3.selectAll('g[from="' + nodeName + '"] polygon')
        .attr('stroke', 'green')
        .attr('fill', 'green')
        .attr('fill-opacity', '1')
        .attr('stroke-opacity', '1')
      d3.selectAll('g[to="' + nodeName + '"] path')
        .attr('stroke', 'red')
        .attr('stroke-opacity', '1')
      d3.selectAll('g[to="' + nodeName + '"] text').attr('fill', 'red')
      d3.selectAll('g[to="' + nodeName + '"] polygon')
        .attr('stroke', 'red')
        .attr('fill', 'red')
        .attr('fill-opacity', '1')
        .attr('stroke-opacity', '1')
    },
    async getConfigParams () {
      const { statusCode, data } = await getEnumCodesByCategoryId(0, VIEW_CONFIG_PARAMS)
      if (statusCode === 'OK') {
        this.initParams = {}
        data.forEach(_ => {
          this.initParams[_.code] = _.value
        })
      }
    }
  },
  created () {
    this.getConfigParams()
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
