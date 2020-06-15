<template>
  <div>
    <Row style="margin-bottom: 16px;">
      <span>{{ $t('select_idc') }}：</span>
      <Select :placeholder="$t('select_idc')" class="graph-select" @on-change="onIdcDataChange">
        <Option v-for="item in allIdcs" :value="item.guid" :key="item.guid">
          {{ item.name }}
        </Option>
      </Select>
    </Row>
    <Row class="resource-design-tab-row">
      <Spin fix v-if="spinShow">
        <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
        <div>{{ $t('loading') }}</div>
      </Spin>
      <Row>
        <Col span="16">
          <Card>
            <div class="graph-container-big" id="graph"></div>
          </Card>
        </Col>
        <Col span="8" class="operation-zone">
          <Card>
            <Operation ref="transferData" @operationReload="operationReload" @markZone="markZone"></Operation>
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
import { getEnumCodesByCategoryId, getIdcDesignTreeByGuid, getAllIdcDesignData, queryCiData } from '@/api/server'
import { colors, defaultFontSize as fontSize } from '../../const/graph-configuration'
import { addEvent } from '../util/event.js'
import {
  VIEW_CONFIG_PARAMS,
  NETWORK_SEGMENT_DESIGN,
  IDC_PLANNING_LINK_ID,
  IDC_PLANNING_LINK_FROM,
  IDC_PLANNING_LINK_TO
} from '@/const/init-params.js'
import Operation from './operation'

export default {
  data () {
    return {
      allIdcs: [],
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
        .attr('fill', '#2b85e4')
    }
  },
  methods: {
    markZone (guid) {
      this.cacheIdPath = [`g_` + guid]
    },
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
      this.loadMap([tmpData], operateLineData)
    },
    loadMap (graphData, operateLineData) {
      this.graphData = graphData
      this.graphData[0].children.forEach(_ => {
        this.firstChildrenGroup.push(`g_${_.guid}`)
      })
      // this.operateNodeData = this.graphData[0]
      // this.$refs.transferData.managementData(this.operateNodeData)
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
            from: lineInfoData[this.initParams[IDC_PLANNING_LINK_FROM]].guid,
            linkInfo: {
              ...lineInfoData,
              ciTypeId: this.initParams[IDC_PLANNING_LINK_ID]
            },
            to: lineInfoData[this.initParams[IDC_PLANNING_LINK_TO]].guid,
            label: lineInfoData.code,
            state: lineInfoData.state.code
          })
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
    async onIdcDataChange (guid = '0012_0000000003') {
      this.spinShow = true
      const { data, statusCode } = await getIdcDesignTreeByGuid([guid])
      this.graphData = data
      this.graphData[0].children.forEach(_ => {
        this.firstChildrenGroup.push(`g_${_.guid}`)
      })
      this.operateNodeData = this.graphData[0]
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
      // graph.selectAll('svg').remove()
      graph
        .on('dblclick.zoom', null)
        .on('wheel.zoom', null)
        .on('mousewheel.zoom', null)
      const width = (window.innerWidth / 24) * 18
      let graphZoom = graph
        .graphviz()
        .width(width - 80)
        .height(window.innerHeight - 190)
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
      let dots = []
      let newworkToNode = {}
      Object.keys(this.graphNodes).forEach(guid => {
        const networkSegmentDesign = this.graphNodes[guid].data[this.initParams[NETWORK_SEGMENT_DESIGN]]
        if (networkSegmentDesign) {
          newworkToNode[networkSegmentDesign.guid] = guid
        }
      })
      this.effectiveLink = []
      this.idcLink.forEach(_ => {
        if (newworkToNode[_.from] && newworkToNode[_.to]) {
          this.effectiveLink.push(_.linkInfo)
          dots.push(
            `g_${newworkToNode[_.from]} -> g_${newworkToNode[_.to]}[id=gl_${_.guid},tooltip="${_.label ||
              ''}",taillabel="${_.label || ''}"];`
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
    renderGraph (idcData) {
      let nodesString = this.genDOT(idcData)
      this.graph
        .transition()
        .renderDot(nodesString)
        .on('end', () => {
          addEvent('.node', 'click', this.handleNodeClick)
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
            ty = p1.y + mgap + fontsize * (tlength + 1) + (h + mgap) * i + h * 0.5
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
        this.idcLink = data.contents.map(_ => {
          return {
            guid: _.data.guid,
            from: _.data[this.initParams[IDC_PLANNING_LINK_FROM]].guid,
            linkInfo: {
              ..._.data,
              ciTypeId: this.initParams[IDC_PLANNING_LINK_ID]
            },
            to: _.data[this.initParams[IDC_PLANNING_LINK_TO]].guid,
            label: _.data.code,
            state: _.data.state.code
          }
        })
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
    async getAllIdcDesignData () {
      const { statusCode, data } = await getAllIdcDesignData()
      if (statusCode === 'OK') {
        this.allIdcs = data.map(_ => _.data)
      }
    }
  },
  mounted () {
    this.getAllIdcDesignData()
    this.onIdcDataChange()
    this.getConfigParams()
  },
  components: {
    Operation
  }
}
</script>

<style lang="scss" scoped>
.graph-container-big {
  // margin-top: 20px;
  // border: 1px solid red;
}
.operation-zone {
  // margin-top: 20px;
  // overflow: auto;
  // min-height: calc(100vh - 205px) !important;
}
.graph-select {
  width: 400px;
}
</style>
