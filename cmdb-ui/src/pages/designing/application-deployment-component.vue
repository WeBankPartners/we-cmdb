<template>
  <div>
    <Row class="resource-design-tab-row">
      <Spin fix v-if="spinShow">
        <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
        <div>{{ $t('loading') }}</div>
      </Spin>
      <Row>
        <Col span="16">
          <Card>
            <div class="graph-container" id="graph"></div>
          </Card>
        </Col>
        <Col span="8" class="operation-zone">
          <Card>
            <Operation
              ref="transferData"
              @operationReload="operationReload"
              @markZone="markZone"
              @markEdge="markEdge"
            ></Operation>
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
import { getSystems, getEnumCodesByCategoryId, getAllDeployTreesFromSystemCi } from '@/api/server.js'
import { colors, stateColor } from '../../const/graph-configuration'
import { addEvent } from '../util/event.js'
import { baseURL } from '@/api/base.js'
import {
  VIEW_CONFIG_PARAMS,
  UNIT_ID,
  BUSINESS_APP_INSTANCE_ID,
  INVOKE_ID,
  INVOKE_UNIT,
  INVOKED_UNIT
} from '@/const/init-params.js'
import Operation from './application-deployment-operation'
export default {
  components: {
    Operation
  },
  data () {
    return {
      initParams: {},
      systems: [],
      systemVersion: '',
      env: '',
      selectedDeployItems: [],
      graphs: {},
      spinShow: false,
      graph: {},
      systemData: [],
      systemLines: {},
      graphNodes: {},
      rankNodes: {},

      originData: null,
      graphCiTypeId: 46,
      graphDataWithGuid: {},
      graphData: null,
      operateNodeData: {},
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
      activeLineGuid: ''
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
      const nodeKeys = Object.keys(this.graphDataWithGuid)
      this.cacheIdPath = nodeKeys.includes(`n_${guid}`) ? [`n_${guid}`] : [`g_${guid}`]
    },
    markEdge (guid) {
      if (this.activeLineGuid) {
        d3.select('#graph')
          .select(`#gl_` + this.activeLineGuid)
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
        .select(`#gl_` + guid)
        .select(`#a_gl_` + guid)
        .select('a')
        .select('path')
        .attr('stroke', 'red')
      d3.select('#graph')
        .select(`#gl_` + guid)
        .select('text')
        .attr('fill', 'red')
    },
    async operationReload (originData, operateLineData) {
      this.getAllDeployTreesFromSystemCi(this.systemVersion)
    },
    reloadEdge (operateLineData) {
      const lineInfoData = operateLineData.lineInfo.data
      if (operateLineData.type === 'add') {
        this.systemLines[lineInfoData.guid] = {
          ...lineInfoData,
          from: lineInfoData[this.initParams[INVOKE_UNIT]].guid,
          to: lineInfoData[this.initParams[INVOKED_UNIT]].guid,
          label: lineInfoData.invoke_type,
          state: lineInfoData.state.code,
          fixedDate: +new Date(lineInfoData.fixed_date)
        }
        this.effectiveLink.push(lineInfoData)
      }
      if (operateLineData.type === 'edit') {
        const index = this.effectiveLink.findIndex(_ => {
          return _.guid === lineInfoData.guid
        })
        this.effectiveLink[index] = lineInfoData
        this.systemLines[lineInfoData.guid] = {
          ...lineInfoData,
          from: lineInfoData[this.initParams[INVOKE_UNIT]].guid,
          to: lineInfoData[this.initParams[INVOKED_UNIT]].guid,
          label: lineInfoData.invoke_type,
          state: lineInfoData.state.code,
          fixedDate: +new Date(lineInfoData.fixed_date)
        }
      }
      if (operateLineData.type === 'remove') {
        const index = this.effectiveLink.findIndex(_ => {
          return _.guid === lineInfoData.guid
        })
        this.effectiveLink.splice(index, 1)
        delete this.systemLines[lineInfoData.guid]
      }
      const { initParams } = this
      const formatADData = array => {
        return array.map(_ => {
          let result = {
            ciTypeId: _.ciTypeId,
            guid: _.guid,
            data: _.data,
            label: `"${_.data.code}"`,
            tooltip: _.data.description || '',
            fixedDate: +new Date(_.data.fixed_date)
          }
          if (_.children instanceof Array && _.children.length && _.ciTypeId !== initParams[UNIT_ID]) {
            result.children = formatADData(_.children)
          }
          if (_.ciTypeId === initParams[UNIT_ID]) {
            let label = ['<<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">', `<TR><TD>${_.data.code}</TD></TR>`]
            if (_.children instanceof Array && _.children.length) {
              _.children.forEach(item => {
                if (initParams[BUSINESS_APP_INSTANCE_ID].split(',').indexOf(item.ciTypeId + '') >= 0) {
                  label.push(`<TR><TD>${item.data.code}</TD></TR>`)
                }
              })
            }
            label.push('</TABLE>>')
            result.label = label.join('')
          }
          return result
        })
      }
      const fetchOtherSystemInstances = async () => {
        this.instancesInUnit = {}
        this.graphNodes = {}
        this.genADChildrenDot(this.systemData[0].children || [], 1)
        this.initADGraph()
      }
      // this.operateNodeData = this.systemData[0]
      // this.$refs.transferData.graphCiTypeId = this.graphCiTypeId
      // this.$refs.transferData.managementData(this.operateNodeData, this.originData)
      // console.log(this.systemLines)
      this.$refs.transferData.linkManagementData(this.effectiveLink)
      fetchOtherSystemInstances()
    },
    async getAllDeployTreesFromSystemCi (systemVersion) {
      this.systemVersion = systemVersion
      const { initParams } = this
      const { statusCode, data } = await getAllDeployTreesFromSystemCi(this.systemVersion)
      this.originData = data
      if (statusCode === 'OK') {
        this.systemTreeData = data
        this.systemLines = {}
        this.graphDataWithGuid = {}
        const formatADData = array => {
          return array.map(_ => {
            let result = {
              ciTypeId: _.ciTypeId,
              guid: _.guid,
              data: _.data,
              label: `"${_.data.code}"`,
              tooltip: _.data.description || '',
              fixedDate: +new Date(_.data.fixed_date)
            }
            if (_.children instanceof Array && _.children.length && _.ciTypeId !== initParams[UNIT_ID]) {
              result.children = formatADData(_.children)
              this.graphDataWithGuid['g_' + _.guid] = _
            } else {
              this.graphDataWithGuid['n_' + _.guid] = _
            }
            if (_.ciTypeId === initParams[UNIT_ID]) {
              let label = ['<<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">', `<TR><TD>${_.data.code}</TD></TR>`]
              if (_.children instanceof Array && _.children.length) {
                _.children.forEach(item => {
                  if (initParams[BUSINESS_APP_INSTANCE_ID].split(',').indexOf(item.ciTypeId + '') >= 0) {
                    label.push(`<TR><TD>${item.data.code}</TD></TR>`)
                  }
                })
              }
              label.push('</TABLE>>')
              result.label = label.join('')
            }
            return result
          })
        }
        this.effectiveLink = []
        const formatADLine = array => {
          array.forEach(_ => {
            if (_.ciTypeId === this.initParams[INVOKE_ID]) {
              this.systemLines[_.guid] = {
                ..._,
                from: _.data[this.initParams[INVOKE_UNIT]].guid,
                to: _.data[this.initParams[INVOKED_UNIT]].guid,
                id: _.guid,
                label: _.data.invoke_type,
                state: _.data.state.code,
                fixedDate: +new Date(_.data.fixed_date)
              }
              _.data.ciTypeId = this.initParams[INVOKE_ID]
              this.effectiveLink.push(_.data)
            }
            if (_.children instanceof Array && _.children.length) {
              formatADLine(_.children)
            }
          })
        }

        const fetchOtherSystemInstances = async () => {
          this.instancesInUnit = {}
          this.graphNodes = {}
          this.genADChildrenDot(this.systemData[0].children || [], 1)
          this.initADGraph()
        }
        this.systemData = formatADData(data)
        this.graphData = this.systemData
        this.operateNodeData = this.systemData[0]
        this.$refs.transferData.graphCiTypeId = this.graphCiTypeId
        this.$refs.transferData.managementData(this.operateNodeData, this.originData)
        formatADLine(data)
        this.$refs.transferData.linkManagementData(this.effectiveLink)
        fetchOtherSystemInstances()
      }
    },
    initADGraph () {
      this.spinShow = true
      const initEvent = () => {
        let graph = d3.select('#graph')

        graph
          .on('dblclick.zoom', null)
          .on('wheel.zoom', null)
          .on('mousewheel.zoom', null)
        const width = ((window.innerWidth - 60) / 24) * 16 - 40
        this.graph.graphviz = graph
          .graphviz()
          .width(width)
          .height(window.innerHeight - 260)
          .zoom(true)
          .fit(true)
      }

      initEvent()
      this.renderADGraph(this.systemData)
      this.spinShow = false
    },
    renderADGraph (data) {
      let nodesString = this.genADDOT(data)
      this.graph.graphviz
        .transition()
        .renderDot(nodesString)
        .on('end', () => {
          addEvent('.node', 'click', this.handleNodeClick)
          addEvent('.cluster', 'click', this.handleNodeClick)
          addEvent('.edge', 'click', this.handleEdgeClick)
        })
      // 最外图层选中处理
      d3.select('#clust1').on('click', () => {
        this.$refs.transferData.managementData(this.originData[0])
        if (this.activeNodeInfo.id) {
          d3.select('#graph')
            .select(`#` + this.activeNodeInfo.id)
            .select(this.activeNodeInfo.type)
            .attr('fill', this.activeNodeInfo.color)
          this.activeNodeInfo = {}
        }
      })
      let svg = d3.select('#graph').select('svg')
      let width = svg.attr('width')
      let height = svg.attr('height')
      svg.attr('viewBox', '0 0 ' + width + ' ' + height)
    },
    handleNodeClick (e) {
      if (e.currentTarget.id === 'clust1') {
        return
      }
      const guid = e.currentTarget.id
      this.operateNodeData = this.graphDataWithGuid[guid]
      this.cacheIdPath = [guid]
      this.$refs.transferData.managementData(this.operateNodeData)
    },
    handleEdgeClick (e) {
      let guid = e.currentTarget.id.substring(3)
      this.markEdge(guid)
      const selectLinkIndex = this.effectiveLink.findIndex(link => {
        return link.guid === guid
      })
      this.$refs.transferData.openLinkPanal([selectLinkIndex + 1 + ''])
    },
    genADDOT (data) {
      this.graphNodes = {}
      if (!data.length) {
        return 'digraph G{}'
      }
      let width = 16
      let height = 12
      let dots = [
        'digraph G{',
        'rankdir=LR;nodesep=0.5;',
        'Node[fontname=Arial,fontsize=12,shape=box,style=filled];',
        'Edge[fontname=Arial,minlen="1",fontsize=12,labeldistance=1.5];',
        `size="${width},${height}";`,
        `subgraph cluster_${data[0].guid}{`,
        `style="filled";color="${colors[0]}";`,
        `tooltip="${data[0].data.code}";`,
        `label="${data[0].data.code}";`,
        this.genADChildrenDot(data[0].children || [], 1),
        '}',
        this.genADLines(),
        '}'
      ]
      return dots.join('')
    },
    genADChildrenDot (data, level) {
      const width = 12
      const height = 9
      let dots = []
      if (data.length) {
        data.forEach(_ => {
          let color = ''
          if (!_.fixedDate) {
            color = stateColor[_.data.state.code]
          }
          if (_.children instanceof Array && _.children.length) {
            dots.push(
              `subgraph cluster_${_.guid}{`,
              `id="g_${_.guid}";`,
              `color="${color || colors[level]}";`,
              `style="filled";fillcolor="${colors[level]}";`,
              `label=${_.label};`,
              `tooltip="${_.tooltip}";`,
              this.genADChildrenDot(_.children, level + 1),
              '}'
            )
          } else {
            this.graphNodes[_.guid] = _
            dots.push(
              `"n_${_.guid}"`,
              `[id="n_${_.guid}",shape="none",`,
              `fillcolor="${color || colors[level]}";`,
              `label=${_.label}`,
              '];'
            )
          }
        })
      } else {
        dots.push(`g[label=" ",color="${colors[level - 1]}";width="${width}";height="${height - 3}"];`)
      }
      return dots.join('')
    },
    genADLines () {
      const result = []
      Object.keys(this.systemLines).forEach(guid => {
        const node = this.systemLines[guid]

        let color = '#000'
        if (!node.fixedDate) {
          color = stateColor[node.state]
        }
        result.push(
          `n_${node.from}->n_${node.to}`,
          `[id="gl_${node.id}",`,
          `color="${color}"`,
          `tooltip="${node.label || ''}",`,
          `taillabel="${node.label || ''}"];`
        )

        const formatLabel = (keyName, guid) => {
          if (this.instancesInUnit[guid]) {
            let label = [
              '<<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" COLOR="#000">',
              `<TR><TD>${keyName}</TD></TR>`
            ]
            this.instancesInUnit[guid].forEach(_ => {
              label.push(`<TR><TD>${_.key_name}</TD></TR>`)
            })
            label.push('</TABLE>>')
            return label.join('')
          } else {
            return `"${keyName}"`
          }
        }

        if (!this.graphNodes[node.from]) {
          const _fromNode = node.data[this.initParams[INVOKE_UNIT]]
          result.push(
            `n_${_fromNode.guid}`,
            `[label=${formatLabel(_fromNode.key_name, _fromNode.guid)},`,
            this.instancesInUnit[_fromNode.guid] ? 'color="#d3d3d3"' : '',
            `tooltip="${_fromNode.key_name || ''}"];`
          )
        } else if (!this.graphNodes[node.to]) {
          const _fromTo = node.data[this.initParams[INVOKED_UNIT]]
          result.push(
            `n_${_fromTo.guid}`,
            `[label=${formatLabel(_fromTo.key_name, _fromTo.guid)},`,
            this.instancesInUnit[_fromTo.guid] ? 'color="#d3d3d3"' : '',
            `tooltip="${_fromTo.key_name || ''}"];`
          )
        }
      })
      return result.join('')
    },
    genChildrenDot (data, level) {
      let dots = []
      data.forEach(_ => {
        let _label = _.data.code
        _label = _label.length > 21 ? `${_label.slice(0, 1)}...${_label.slice(-15)}` : _label
        dots = dots.concat([
          `"${_.guid}"`,
          `[id="n_${_.guid}";`,
          `label="${_label}";`,
          `image="${baseURL}/files/${_.imageFileId}.png";`,
          'labelloc="b"',
          `tooltip="${_.data.code}"];`
        ])
        this.rankNodes[_.ciTypeId].push(`"${_.guid}"`)
        if (_.children instanceof Array && _.children.length) {
          dots = dots.concat(this.genChildrenDot(_.children, level + 1))
          _.children.forEach(c => {
            dots = dots.concat([`"${_.guid}" -> "${c.guid}";`])
          })
        }
      })
      return dots
    },
    onSystemDesignSelect (key) {
      this.systemData = []
      this.systemTreeData = []
      this.systemLines = {}
      this.graphNodes = {}
      this.initADGraph()
    },
    async getSystems () {
      let { statusCode, data } = await getSystems()
      if (statusCode === 'OK') {
        this.systems = data.contents.map(_ => _.data)
      }
    },
    async querySysTree () {
      this.spinShow = true
      this.getAllDeployTreesFromSystemCi()
    },
    async getConfigParams () {
      const { statusCode, data } = await getEnumCodesByCategoryId(0, VIEW_CONFIG_PARAMS)
      if (statusCode === 'OK') {
        this.initParams = {}
        data.forEach(_ => {
          this.initParams[_.code] = Number(_.value) ? Number(_.value) : _.value
        })
        this.getSystems()
      }
    }
  },
  created () {
    this.getConfigParams()
  }
}
</script>

<style lang="scss" scoped>
.no-data {
  text-align: center;
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
