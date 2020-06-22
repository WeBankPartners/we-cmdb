<template>
  <div>
    <Row class="graph-select-row">
      <Col span="8" offset="1" class="resource-planning-title">
        <TreeSelect
          v-model="selectedIdcs"
          :maxTagCount="3"
          :placeholder="$t('select_idc')"
          :data="treeIdcs"
          :clearable="true"
          style="width:100%"
        ></TreeSelect>
      </Col>
      <Col span="6">
        <Button @click="onIdcDataChange" type="primary">{{ $t('query') }}</Button>
      </Col>
    </Row>
    <Row class="graph-tabs">
      <Spin fix v-if="spinShow">
        <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
        <div>{{ $t('loading') }}</div>
      </Spin>
      <div class="graph-container-big" id="resourcePlanningGraph"></div>
    </Row>
  </div>
</template>

<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line
import * as d3Graphviz from 'd3-graphviz'
import {
  getAllIdcData,
  getIdcImplementTreeByGuid,
  getResourcePlanningCiData,
  getEnumCodesByCategoryId,
  queryCiData
} from '@/api/server'
import { colors, defaultFontSize as fontSize } from '../../const/graph-configuration'
import TreeSelect from '../components/tree-select.vue'
import {
  VIEW_CONFIG_PARAMS,
  REGIONAL_DATA_CENTER,
  NETWORK_SEGMENT,
  LAYER,
  RESOURCE_PLANNING_LINK_ID,
  RESOURCE_PLANNING_LINK_FROM,
  RESOURCE_PLANNING_LINK_TO,
  RESOURCE_PLANNING_ROUTER_CODE,
  DEFAULT_SECURITY_POLICY_CODE
} from '@/const/init-params.js'

export default {
  components: {
    TreeSelect
  },
  data () {
    return {
      initParams: {},
      treeIdcs: [],
      allIdcs: {},
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
      compareData: []
    }
  },
  computed: {
    needCheckout () {
      return this.$route.name !== 'ciDataEnquiry'
    }
  },
  mounted () {
    this.initGraph()
  },
  methods: {
    async getAllIdcData () {
      const { data, statusCode } = await getAllIdcData()
      if (statusCode === 'OK') {
        this.allIdcs = {}
        const regional = this.initParams[REGIONAL_DATA_CENTER]
        data.forEach(_ => {
          if (!_.data[regional]) {
            this.treeIdcs.push({
              guid: _.data.guid,
              title: _.data.name,
              expand: true,
              children: []
            })
          }
          this.allIdcs[_.data.guid] = {
            guid: _.data.guid,
            name: _.data.name,
            realIdcGuid: _.data[regional] ? _.data[regional].guid : _.data.guid
          }
        })
        const deep = (idcObj, idc) => {
          if (idc.data[regional] && idcObj.guid === idc.data[regional].guid) {
            const found = idcObj.children.find(_ => _.guid === idc.data.guid)
            if (!found) {
              idcObj.children.push({
                guid: idc.data.guid,
                title: idc.data.name,
                realIdcGuid: idcObj.guid,
                expand: true,
                children: []
              })
            }
          } else {
            idcObj.children.forEach(child => {
              data.forEach(i => {
                deep(child, i)
              })
            })
          }
        }
        this.treeIdcs.forEach(_ => {
          data.forEach(idc => {
            deep(_, idc)
          })
        })
      }
    },
    async reloadHandler () {
      this.onIdcDataChange()
      this.isDataChanged = false
    },
    async onIdcDataChange () {
      let willSelectIdc = {}
      this.idcData = []
      this.selectedIdcs.forEach(_ => {
        const realIdcGuid = this.allIdcs[_].realIdcGuid
        if (!this.selectedIdcs.find(guid => realIdcGuid === guid)) {
          willSelectIdc[realIdcGuid] = realIdcGuid
        }
      })
      let selectedIdcs = JSON.parse(JSON.stringify(this.selectedIdcs))
      Object.keys(willSelectIdc).forEach(guid => {
        selectedIdcs.push(guid)
      })
      if (selectedIdcs.length) {
        this.spinShow = true
        const payload = {
          id: this.initParams[RESOURCE_PLANNING_LINK_ID],
          queryObject: {}
        }
        const promiseArray = [getIdcImplementTreeByGuid(selectedIdcs), queryCiData(payload)]
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
          this.lineData = links.data.contents.map(_ => {
            return {
              guid: _.data.guid,
              from: _.data[this.initParams[RESOURCE_PLANNING_LINK_FROM]].guid,
              to: _.data[this.initParams[RESOURCE_PLANNING_LINK_TO]].guid,
              label: _.data.code,
              state: _.data.state.code
            }
          })
          this.$nextTick(() => {
            this.initGraph()
          })
        }
      } else {
        this.idcData = []
        this.lineData = []
      }
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
          .width(window.innerWidth - 20)
          .height(window.innerHeight - 230)
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
        .on('end', this.setChildrenNode)
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
      let newworkToNode = {}
      Object.keys(this.graphNodes).forEach(guid => {
        const networkSegment = this.graphNodes[guid].data[this.initParams[NETWORK_SEGMENT]]
        if (networkSegment) {
          newworkToNode[networkSegment.guid] = guid
        }
      })
      this.lineData.forEach(_ => {
        if (newworkToNode[_.from] && newworkToNode[_.to]) {
          dots.push(
            `n_${newworkToNode[_.from]} -> n_${newworkToNode[_.to]}[id=gl_${_.guid},tooltip="${_.label ||
              ''}",taillabel="${_.label || ''}"];`
          )
        }
      })
      return dots.join('')
    },
    genLink (links) {
      let result = ''
      links.forEach(link => {
        result += `${link.azone}->${link.bzone}[arrowhead="none"];`
      })
      return result
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
      this.getAllIdcData()
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
    showGraph (ci) {
      ci.showGraph = true
    },
    async getConfigParams () {
      const { statusCode, data } = await getEnumCodesByCategoryId(0, VIEW_CONFIG_PARAMS)
      if (statusCode === 'OK') {
        this.initParams = {}
        data.forEach(_ => {
          this.initParams[_.code] = _.value
        })
      }
      this.getAllIdcData()
    }
  },
  created () {
    this.getConfigParams()
  }
}
</script>

<style lang="scss" scoped>
.graph-select-row {
  margin-bottom: 10px;
}
.graph-tabs {
  min-height: 400px;
  position: relative;
}
.ivu-card-head p {
  height: 30px;
  line-height: 30px;
}
.filter-title {
  margin-right: 10px;
}
.graph-list {
  overflow-x: auto;
  display: flex;
}
.graph-list > div {
  cursor: pointer;
}
.graph-container {
  width: 160px;
  height: 120px;
  float: left;
  margin-right: 5px;
  text-align: center;
}
.graph-container-big {
  margin-top: 20px;
}
.resource-planning-title {
  display: flex;
  margin-right: 10px;
  margin-left: 0;
  & > span {
    line-height: 32px;
  }
}
.resource-planning-select {
  flex: 1;
  margin-left: 10px;
}

.copy-modal {
  .ivu-modal-body {
    max-height: 450px;
    overflow-y: auto;
  }

  .copy-form {
    display: flex;
    flex-flow: column nowrap;
  }

  .copy-input {
    display: flex;
    flex-flow: row nowrap;
    margin-top: 20px;
    align-items: center;

    .ivu-input-number {
      flex: 1;
      margin-right: 15px;
    }
  }
}
</style>
