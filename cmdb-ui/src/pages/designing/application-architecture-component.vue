<template>
  <Row>
    <Spin fix v-if="spinShow">
      <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
      <div>{{ $t('loading') }}</div>
    </Spin>
    <Row>
      <Col span="16">
        <Card>
          <div id="appLogicGraph"></div>
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
</template>

<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line no-unused-vars
import * as d3Graphviz from 'd3-graphviz'
import {
  getEnumCodesByCategoryId,
  getSystemDesigns,
  getAllDesignTreeFromSystemDesign,
  updateSystemDesign
} from '@/api/server'
import moment from 'moment'
import { addEvent } from '../util/event.js'
import { colors, stateColor } from '../../const/graph-configuration'
import {
  VIEW_CONFIG_PARAMS,
  UNIT_DESIGN_ID,
  INVOKE_DESIGN_ID,
  INVOKE_DIAGRAM_LINK_FROM,
  INVOKE_DIAGRAM_LINK_TO,
  INVOKE_TYPE
} from '@/const/init-params.js'
import Operation from './application-architecture-operation'
export default {
  components: {
    Operation
  },
  data () {
    return {
      graphCiTypeId: 37,
      graphData: null,
      graphDataWithGuid: {},
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
      activeLineGuid: '',

      tabList: [],
      systemDesigns: [],
      systemDesignsOrigin: [],
      systemDesignVersion: '',
      deployTree: [],
      fixVersionTreeModal: false,
      payload: {
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true
      },
      systemDesignCiTypeId: '',
      invokeDesignCiTypeId: '',
      graph: {},
      systemDesignData: [],
      appLogicData: [],
      graphNodes: {},
      currentTab: 'architectureDesign',
      spinShow: false,
      isDataChanged: false,
      physicalSpin: false,
      invokeLines: [],
      isShowInvokeSequence: false,
      invokeSequenceForm: {
        isShowInvokeSequenceDetial: false,
        invokeSequenceData: [],
        spliceInvokeSequenceList: '',
        totalNum: 0,
        currentNum: 0,
        currentInvokeSequenceTag: '',
        currentInvokeSequence: [],
        selectedInvokeSequence: ''
      },
      appInvokeLines: {},
      appServiceInvokeLines: {},
      allowArch: false,
      allowFixVersion: false,
      isTableViewOnly: true,
      systemDesignFixedDate: 0,
      allUnitDesign: [],
      buttonLoading: {
        fixVersion: false,
        fixVersionModal: false
      },
      initParams: {},
      isHandleNodeClick: false
    }
  },
  watch: {
    cacheIdPath: function (val) {
      // 选中节点颜色控制
      if (this.activeNodeInfo.id) {
        d3.select('#appLogicGraph')
          .select(`#` + this.activeNodeInfo.id)
          .select(this.activeNodeInfo.type)
          .attr('fill', this.activeNodeInfo.color)
        this.activeNodeInfo = {}
      }
      const id = val[val.length - 1]
      this.activeNodeInfo.type = d3
        .select('#appLogicGraph')
        .select(`#` + id)
        .select('polygon')._groups[0][0]
        ? 'polygon'
        : 'rect'
      const color = d3
        .select('#appLogicGraph')
        .select(`#` + id)
        .select(this.activeNodeInfo.type)
        .attr('fill')
      this.activeNodeInfo.id = id
      this.activeNodeInfo.color = color
      d3.select('#appLogicGraph')
        .select(`#` + id)
        .select(this.activeNodeInfo.type)
        .attr('fill', '#ff9900')
    }
  },
  methods: {
    markZone (guid) {
      const nodeKeys = Object.keys(this.graphDataWithGuid)
      this.cacheIdPath = nodeKeys.includes(`n_${guid}`) ? [`n_${guid}`] : [`g_${guid}`]
    },
    markEdge (guid) {
      if (this.activeLineGuid) {
        d3.select('#appLogicGraph')
          .select(`#gl_` + this.activeLineGuid)
          .select('path')
          .attr('stroke', '#000000')
        d3.select('#appLogicGraph')
          .select(`#a_gl_` + this.activeLineGuid + '-taillabel')
          .select('a')
          .select('text')
          .attr('fill', '#000000')
      }
      this.activeLineGuid = guid
      d3.select('#appLogicGraph')
        .select(`#gl_` + guid)
        .select('path')
        .attr('stroke', '#ff9900')
      d3.select('#appLogicGraph')
        .select(`#a_gl_` + guid + '-taillabel')
        .select('a')
        .select('text')
        .attr('fill', '#ff9900')
    },
    operationReload () {
      this.getAllDesignTreeFromSystemDesign(this.systemDesignVersion)
    },
    async getAllDesignTreeFromSystemDesign (systemDesignVersion) {
      this.systemDesignVersion = systemDesignVersion
      this.allUnitDesign = []
      const treeData = await getAllDesignTreeFromSystemDesign(this.systemDesignVersion)
      if (treeData.statusCode === 'OK') {
        this.appInvokeLines = {}
        this.appServiceInvokeLines = {}
        this.systemDesignFixedDate = +new Date(treeData.data[0].data.fixed_date)
        this.graphDataWithGuid = {}
        const formatAppLogicTree = array =>
          array.map(_ => {
            let result = {
              ciTypeId: _.ciTypeId,
              guid: _.guid,
              data: _.data,
              children_x: _.children,
              fixedDate: +new Date(_.data.fixed_date)
            }
            if (_.children instanceof Array && _.children.length && _.ciTypeId !== this.initParams[UNIT_DESIGN_ID]) {
              result.children = formatAppLogicTree(_.children)
              this.graphDataWithGuid['g_' + _.guid] = _
            } else {
              this.graphDataWithGuid['n_' + _.guid] = _
            }
            if (_.ciTypeId === this.initParams[UNIT_DESIGN_ID]) {
              this.allUnitDesign.push(result)
            }
            return result
          })
        this.effectiveLink = []
        const formatAppLogicLine = array =>
          array.forEach(_ => {
            if (_.ciTypeId === this.initParams[INVOKE_DESIGN_ID]) {
              this.appInvokeLines[_.guid] = {
                from: _.data[this.initParams[INVOKE_DIAGRAM_LINK_FROM]],
                to: _.data[this.initParams[INVOKE_DIAGRAM_LINK_TO]],
                id: _.guid,
                label: _.data[this.initParams[INVOKE_TYPE]],
                tooltip: _.data.description || '-',
                state: _.data.state.code,
                fixedDate: +new Date(_.data.fixed_date)
              }
              _.data.ciTypeId = this.initParams[INVOKE_DESIGN_ID]
              this.effectiveLink.push(_.data)
            }
            if (_.children instanceof Array && _.children.length) {
              formatAppLogicLine(_.children)
            }
          })
        this.appLogicData = formatAppLogicTree(treeData.data)
        this.graphData = treeData.data
        this.operateNodeData = this.appLogicData[0]
        this.$refs.transferData.graphCiTypeId = this.graphCiTypeId
        this.$refs.transferData.managementData(this.operateNodeData)
        formatAppLogicLine(treeData.data)
        this.$refs.transferData.linkManagementData(this.effectiveLink)
        this.initGraph()
      }
    },
    async onArchChange (isTableViewOnly = false) {
      if (isTableViewOnly) {
        this.queryGraphData(isTableViewOnly)
      } else {
        const { statusCode, data } = await updateSystemDesign(this.systemDesignVersion)
        if (statusCode === 'OK') {
          if (data.length) {
            this.getSystemDesigns(() => {
              this.queryGraphData(isTableViewOnly)
            })
          } else {
            this.queryGraphData(isTableViewOnly)
          }
        }
      }
    },
    async queryGraphData (isTableViewOnly) {
      this.invokeSequenceForm.selectedInvokeSequence = ''
      this.invokeSequenceForm.isShowInvokeSequenceDetial = false

      if (this.systemDesignVersion === '') {
        return
      }
      this.spinShow = true
      this.physicalSpin = true
      this.allowFixVersion = !isTableViewOnly
      this.isTableViewOnly = isTableViewOnly
      if (this.currentTab === 'architectureDesign' || this.currentTab === 'serviceInvoke') {
        this.getAllDesignTreeFromSystemDesign()
      }
    },
    async querySysTree () {
      this.buttonLoading.fixVersion = true
      if (this.systemDesignVersion === '') return
      this.spinShow = true
      const { statusCode, data } = await getAllDesignTreeFromSystemDesign(this.systemDesignVersion)
      if (statusCode === 'OK') {
        this.spinShow = false
        this.deployTree = this.formatTree(data).array
        this.fixVersionTreeModal = true
        this.buttonLoading.fixVersion = false
      } else {
        this.buttonLoading.fixVersion = false
      }
    },
    formatTree (data) {
      let array = []
      let isShow = false
      data.forEach(_ => {
        let _isShow = false
        if (!_.data.fixed_date) {
          isShow = true
          _isShow = true
        }
        const color = _.data.fixed_date ? '#000' : stateColor[_.data.state.code]
        let result = {
          fixed_date: _.data.fixed_date,
          state: _.data.state.code,
          expand: true,
          render: (h, params) => <span style={'color:' + color + ';'}>{_.data.key_name}</span>
        }
        if (_.children instanceof Array && _.children.length && this.formatTree(_.children).isShow) {
          isShow = true
          _isShow = true
          result.children = this.formatTree(_.children).array
        }
        if (_isShow) {
          array.push(result)
        }
      })
      if (array.length && isShow) {
        return {
          isShow: isShow,
          array: array
        }
      } else {
        return {
          isShow: isShow,
          array: []
        }
      }
    },
    initGraph () {
      this.isShowInvokeSequence = true
      this.spinShow = true
      let graph
      const initEvent = id => {
        graph = d3.select(id)
        graph
          .on('dblclick.zoom', null)
          .on('wheel.zoom', null)
          .on('mousewheel.zoom', null)
        const width = ((window.innerWidth - 60) / 24) * 16 - 60
        this.graph.graphviz = graph
          .graphviz()
          .width(width)
          .height(window.innerHeight - 293)
          .fit(true)
          .zoom(true)
      }
      // 应用逻辑图
      initEvent('#appLogicGraph')
      this.renderGraph('#appLogicGraph', this.appLogicData, this.appInvokeLines)
      // 服务调用图
      this.spinShow = false
    },
    renderGraph (id, data, linesData) {
      let nodesString = this.genDOT(id, data, linesData)
      this.graph.graphviz
        .transition()
        .renderDot(nodesString)
        .on('end', () => {
          addEvent('.node', 'click', this.handleNodeClick)
          addEvent('.cluster', 'click', this.handleNodeClick)
          // addEvent('.edge', 'click', this.handleEdgeClick)
        })
      // 最外图层选中处理
      d3.select('#clust1').on('click', () => {
        this.$refs.transferData.managementData(this.graphData[0])
        if (this.activeNodeInfo.id) {
          d3.select('#appLogicGraph')
            .select(`#` + this.activeNodeInfo.id)
            .select(this.activeNodeInfo.type)
            .attr('fill', this.activeNodeInfo.color)
          this.activeNodeInfo = {}
        }
      })

      let svg = d3.select(id).select('svg')
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
    genDOT (id, sysData, linesData) {
      this.graphNodes[id] = {}
      this.invokeLines = []
      const width = 16
      const height = 12
      let dots = [
        'digraph G{',
        'rankdir=LR;nodesep=0.5;',
        'Node[fontname=Arial,fontsize=12,shape=box,style=filled];',
        'Edge[fontname=Arial,minlen="2",fontsize=6,labeldistance=1.5];',
        `size="${width},${height}";`,
        `subgraph cluster_${sysData[0].guid} {`,
        `style="filled";color="${colors[0]}";`,
        `tooltip="${sysData[0].data.description}";`,
        `label="${sysData[0].data.name}";`,
        this.genChildrenDot(id, sysData[0].children || [], 1),
        '}',
        this.genLines(id, linesData),
        '}'
      ]
      return dots.join('')
    },
    genChildrenDot (id, data, level) {
      const width = 12
      const height = 9
      let dots = []
      if (data.length) {
        data.forEach(_ => {
          let color = ''
          if (this.isTableViewOnly && this.systemDesignFixedDate) {
            if (this.systemDesignFixedDate <= _.fixedDate) {
              color = stateColor[_.data.state.code]
            }
          } else if (!_.fixedDate) {
            color = stateColor[_.data.state.code]
          }
          if (_.children instanceof Array && _.children.length) {
            dots = dots.concat([
              `subgraph cluster_${_.guid}{`,
              `id="g_${_.guid}";`,
              `color="${color || colors[level]}";`,
              `style="filled";fillcolor="${colors[level]}";`,
              `label="${_.data.code || _.data.key_name}";`,
              `tooltip="${_.data.description || _.data.name}"`,
              this.genChildrenDot(id, _.children, level + 1),
              '}'
            ])
          } else {
            this.graphNodes[id][_.guid] = _
            dots = dots.concat([
              `"n_${_.guid}"`,
              `[id="n_${_.guid}";`,
              `label="${_.data.code || _.data.key_name}";`,
              `color="${color || colors[level]}";`,
              `fillcolor="${colors[level]}";`,
              `tooltip="${_.data.description || _.data.name}"];`
            ])
          }
        })
      } else {
        dots.push(`g[label=" ",color="${colors[0]}";width="${width}";height="${height - 3}"]`)
      }
      return dots.join('')
    },
    genLines (id, linesData) {
      let otherNodes = []
      const result = Object.keys(linesData).map(guid => {
        const node = linesData[guid]
        let color = '#000'
        if (this.isTableViewOnly && this.systemDesignFixedDate) {
          if (this.systemDesignFixedDate <= node.fixedDate) {
            color = stateColor[node.state]
          }
        } else if (!node.fixedDate) {
          color = stateColor[node.state]
        }
        if (!this.graphNodes[id][node.from.guid]) {
          otherNodes.push(node.from)
        }
        if (!this.graphNodes[id][node.to.guid]) {
          otherNodes.push(node.to)
        }
        return `n_${node.from.guid} -> n_${node.to.guid}[id="gl_${node.id}",color="${color}",tailtooltip="${
          node.tooltip
        }",taillabel="${node.label || ''}"];`
      })
      let nodes = []
      otherNodes.forEach(_ => {
        nodes = nodes.concat([
          `"n_${_.guid}"`,
          `[id="n_${_.guid}";`,
          `label="${_.key_name}";`,
          'shape=box;',
          `style="filled";`,
          `title="${_.tooltip}"`,
          `tooltip="${_.tooltip}"];`
        ])
      })
      return result.join('') + nodes.join('')
    },
    getSelectOptions (columns) {
      columns.forEach(async _ => {
        if (_.inputType === 'select') {
          const { data } = await getEnumCodesByCategoryId(0, _.referenceId)
          _['options'] = data
            .filter(j => j.status === 'active')
            .map(i => {
              return {
                label: i.value,
                value: i.codeId
              }
            })
        }
      })
      return columns
    },
    onSystemDesignSelect (key) {
      this.allowArch = this.systemDesignsOrigin.some(x => x.r_guid === key) // 是否允许架构变更，当guid等于r_guid时允许
      this.allowFixVersion = false
      this.isTableViewOnly = true
      if (this.currentTab !== 'architecture-design' && this.currentTab === 'serviceInvoke') {
        this.tabList.forEach(ci => {
          ci.tableData = []
        })
      }
    },
    async getSystemDesigns (callback) {
      this.systemDesigns = []
      const { statusCode, data } = await getSystemDesigns()
      if (statusCode === 'OK') {
        this.systemDesignsOrigin = data.contents.map(_ => _.data)
        // 进行分组排序
        const resultObj = this.systemDesignsOrigin
          .sort((a, b) => {
            if (!b.fixed_date) return 1
            if (!a.fixed_date) return -1
            if (moment(a.fixed_date).isSameOrAfter(moment(b.fixed_date))) return -1
            return 1
          })
          .reduce((obj, x) => {
            if (!obj[x.r_guid]) obj[x.r_guid] = []
            x.guid === x.r_guid ? obj[x.r_guid].unshift(x) : obj[x.r_guid].push(x)
            return obj
          }, {})
        this.systemDesigns = Object.values(resultObj)
        if (callback && callback instanceof Function) {
          callback()
        }
      }
    },
    async getConfigParams () {
      const { statusCode, data } = await getEnumCodesByCategoryId(0, VIEW_CONFIG_PARAMS)
      if (statusCode === 'OK') {
        this.initParams = {}
        data.forEach(_ => {
          this.initParams[_.code] = Number(_.value) ? Number(_.value) : _.value
        })
        this.getSystemDesigns()
      }
    }
  },
  created () {
    this.getConfigParams()
  }
}
</script>

<style lang="scss" scoped>
.ivu-card-head p {
  height: 30px;
  line-height: 30px;
}
.filter-title {
  margin-right: 10px;
}
.no-data {
  text-align: center;
}
.app-tab {
  height: calc(100vh - 240px);
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
