<template>
  <Row>
    <Row>
      <Col span="16">
        <Row>
          <span style="margin-right: 10px">{{ $t('system_design') }}</span>
          <Select v-model="systemDesignVersion" @on-change="onSystemDesignSelect" label-in-name style="width: 35%;">
            <OptionGroup v-for="(data, idx) in systemDesigns" :key="idx" :label="data[0].name">
              <Option
                v-for="item in data"
                :value="item.guid"
                :key="item.guid"
                :label="`${item.name}${item.fixed_date ? ' ' + item.fixed_date : ''}`"
                style="display:flex; flex-flow:row nowrap; justify-content:space-between; align-items:center"
              >
                <div>{{ item.name }}</div>
                <div v-if="item.fixed_date" style="color:#ccc; flex-shrink:1; margin-left:10px">
                  {{ item.fixed_date }}
                </div>
              </Option>
            </OptionGroup>
          </Select>
          <Button
            style="margin: 0 10px;"
            @click="onArchChange(false)"
            :loading="buttonLoading.fixVersionModal"
            :disabled="!allowArch"
            >{{ $t('architecture_change') }}</Button
          >
          <Button
            style="margin-right: 10px;"
            @click="querySysTree"
            :loading="buttonLoading.fixVersion"
            :disabled="!allowFixVersion"
            >{{ $t('fix_version') }}</Button
          >
          <Button @click="onArchChange(true)" :disabled="!systemDesignVersion || allowFixVersion">{{
            $t('query')
          }}</Button>
        </Row>
      </Col>
    </Row>
    <Row class="resource-design-tab-row">
      <Spin fix v-if="spinShow">
        <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
        <div>{{ $t('loading') }}</div>
      </Spin>
      <Row>
        <Col span="16">
          <Card>
            <div class="graph-container" id="appLogicGraph"></div>
          </Card>
        </Col>
        <Col span="8" class="operation-zone">
          <Card>
            <Operation ref="transferData" @markZone="markZone"></Operation>
          </Card>
        </Col>
      </Row>
    </Row>
  </Row>
</template>

<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line no-unused-vars
import * as d3Graphviz from 'd3-graphviz'
import {
  getCiTypeAttributes,
  getEnumCodesByCategoryId,
  getSystemDesigns,
  getAllDesignTreeFromSystemDesign,
  saveAllDesignTreeFromSystemDesign,
  getArchitectureDesignTabs,
  getArchitectureCiDatas,
  updateSystemDesign,
  getTreeData
} from '@/api/server'
import { newOuterActions, pagination, components } from '@/const/actions.js'
import { getExtraInnerActions } from '../util/state-operations.js'
import PhysicalGraph from './physical-graph'
import moment from 'moment'
import { addEvent } from '../util/event.js'
import { colors, stateColor } from '../../const/graph-configuration'
import {
  VIEW_CONFIG_PARAMS,
  UNIT_DESIGN_ID,
  INVOKE_DESIGN_ID,
  SERVICE_INVOKE_DESIGN_ID,
  SERVICE_DESIGN,
  SERVICE_TYPE,
  SERVICE_INVOKE_SEQ_DESIGN,
  INVOKE_SEQUENCE_ID,
  INVOKE_DIAGRAM_LINK_FROM,
  INVOKE_DIAGRAM_LINK_TO,
  INVOKE_TYPE
} from '@/const/init-params.js'
import Operation from './operation'
export default {
  components: {
    PhysicalGraph,
    Operation
  },
  data () {
    return {
      graphCiTypeId: 37,
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
      physicalGraphData: [],
      physicalGraphLinks: [],
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
        .attr('fill', '#2b85e4')
    }
  },
  computed: {
    currentRguid () {
      const found = this.systemDesignsOrigin.find(_ => _.guid === this.systemDesignVersion)
      if (found) {
        return found.r_guid
      } else {
        return ''
      }
    }
  },
  methods: {
    markZone (guid) {
      const firstLevelGuid = this.firstChildrenGroup.find(_ => {
        return `g_` + guid === _ || `n_` + guid === _
      })
      this.cacheIdPath = firstLevelGuid ? [firstLevelGuid] : [`n_` + guid]
    },
    async getAllInvokeSequenceData () {
      this.invokeSequenceForm.invokeSequenceData = []
      let found = this.tabList.find(i => i.code === this.initParams[INVOKE_SEQUENCE_ID] + '')
      if (!found) return
      const { statusCode, data } = await getArchitectureCiDatas(
        found.codeId,
        this.systemDesignVersion,
        this.currentRguid,
        {}
      )
      if (statusCode === 'OK') {
        this.invokeSequenceForm.invokeSequenceData = data.contents
      }
    },
    async onArchFixVersion () {
      if (this.systemDesignVersion === '') return
      this.buttonLoading.fixVersionModal = true
      const { statusCode, message } = await saveAllDesignTreeFromSystemDesign(this.systemDesignVersion)
      if (statusCode === 'OK') {
        this.queryCiData()
        this.$Notice.success({
          title: 'Success',
          desc: message
        })
        this.getSystemDesigns()
        this.fixVersionTreeModal = false
        this.buttonLoading.fixVersionModal = false
      } else {
        this.buttonLoading.fixVersionModal = false
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
      if (
        this.currentTab === 'architectureDesign' ||
        this.currentTab === 'physicalGraph' ||
        this.currentTab === 'serviceInvoke'
      ) {
        this.getAllDesignTreeFromSystemDesign()
      } else {
        this.getCurrentData()
      }
    },
    async getAllDesignTreeFromSystemDesign () {
      this.allUnitDesign = []
      // const treeData = await getAllDesignTreeFromSystemDesign(this.systemDesignVersion)
      const treeData = await getTreeData(this.graphCiTypeId, [this.systemDesignVersion])
      if (treeData.statusCode === 'OK') {
        this.getAllInvokeSequenceData()
        this.appInvokeLines = {}
        this.appServiceInvokeLines = {}
        this.systemDesignFixedDate = +new Date(treeData.data[0].data.fixed_date)
        const formatAppLogicTree = array =>
          array.map(_ => {
            let result = {
              ciTypeId: _.ciTypeId,
              guid: _.guid,
              data: _.data,
              fixedDate: +new Date(_.data.fixed_date)
            }
            if (_.children instanceof Array && _.children.length && _.ciTypeId !== this.initParams[UNIT_DESIGN_ID]) {
              result.children = formatAppLogicTree(_.children)
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
        let serviceDesignNodes = {}
        const formatServiceInvokeLine = array =>
          array.forEach(_ => {
            if (_.ciTypeId === this.initParams[SERVICE_INVOKE_DESIGN_ID]) {
              const linkTypeName = _.data[this.initParams[SERVICE_DESIGN]][this.initParams[SERVICE_TYPE]]
              serviceDesignNodes[_.data[this.initParams[INVOKE_DIAGRAM_LINK_FROM]].guid] = true
              serviceDesignNodes[_.data[this.initParams[INVOKE_DIAGRAM_LINK_TO]].guid] = true
              this.appServiceInvokeLines[_.guid] = {
                from: _.data[this.initParams[INVOKE_DIAGRAM_LINK_FROM]],
                to: _.data[this.initParams[INVOKE_DIAGRAM_LINK_TO]],
                id: _.guid,
                label: `${_.data[this.initParams[SERVICE_DESIGN]].name}:${linkTypeName}`,
                tooltip: _.data.description || '-',
                state: _.data.state.code,
                fixedDate: +new Date(_.data.fixed_date)
              }
            }
            if (_.children instanceof Array && _.children.length) {
              formatServiceInvokeLine(_.children)
            }
          })
        const formatServiceInvokeTree = array =>
          array
            .filter(_ => _.ciTypeId !== this.initParams[UNIT_DESIGN_ID] || serviceDesignNodes[_.guid])
            .map(_ => {
              let result = {
                ciTypeId: _.ciTypeId,
                guid: _.guid,
                data: _.data,
                fixedDate: +new Date(_.data.fixed_date)
              }
              if (_.ciTypeId !== this.initParams[UNIT_DESIGN_ID] && _.children instanceof Array && _.children.length) {
                result.children = formatServiceInvokeTree(_.children)
              }
              return result
            })
        this.appLogicData = formatAppLogicTree(treeData.data)
        this.graphData = this.appLogicData
        this.firstChildrenGroup = []
        this.graphData[0].children.forEach(_ => {
          if (_.children instanceof Array && _.children.length) {
            this.firstChildrenGroup.push(`g_${_.guid}`)
          } else {
            this.firstChildrenGroup.push(`n_${_.guid}`)
          }
        })
        this.operateNodeData = this.appLogicData[0]
        this.$refs.transferData.graphCiTypeId = this.graphCiTypeId
        this.$refs.transferData.managementData(this.operateNodeData)
        formatAppLogicLine(treeData.data)
        this.$refs.transferData.linkManagementData(this.effectiveLink)
        formatServiceInvokeLine(treeData.data)
        this.initGraph()
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
        this.graph.graphviz = graph
          .graphviz()
          .width(window.innerWidth - 20)
          .height(window.innerHeight - 240)
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
          addEvent('.cluster', 'click', this.handleClusterClick)
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
      this.idPath.unshift(e.currentTarget.id)
      this.cacheIdPath = []
      this.cacheIndex = []
      this.cacheIdPath = JSON.parse(JSON.stringify(this.idPath))
      if (this.firstChildrenGroup.includes(e.currentTarget.id)) {
        let tmp = this.graphData[0]
        this.idPath.forEach(id => {
          if (tmp.children) {
            tmp = tmp.children.find((child, index) => {
              if (`n_${child.guid}` === id) {
                this.cacheIndex.push(index)
                return child
              }
            })
          } else {
            console.log(tmp)
          }
        })
        this.idPath = []
        this.operateNodeData = tmp
        this.$refs.transferData.managementData(this.operateNodeData)
      }
    },
    handleClusterClick (e) {
      if (e.currentTarget.id === 'clust1') {
        return
      }
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
    async queryCiData () {
      this.payload.pageable.pageSize = 10
      this.payload.pageable.startIndex = 0
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          this.payload.pageable.pageSize = ci.pagination.pageSize
          this.payload.pageable.startIndex = (ci.pagination.currentPage - 1) * ci.pagination.pageSize
        }
      })

      let found = this.tabList.find(i => i.code === this.currentTab)
      if (!found) return
      const { statusCode, data } = await getArchitectureCiDatas(
        found.codeId,
        this.systemDesignVersion,
        this.currentRguid,
        this.payload
      )
      if (statusCode === 'OK') {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.tableData = data
              ? data.contents.map(_ => {
                return {
                  ..._.data,
                  // 需要过滤掉‘确认’按钮
                  nextOperations: _.meta.nextOperations.filter(item => item !== 'confirm') || []
                }
              })
              : []
            ci.pagination.total = data ? data.pageInfo.totalRows : 0
          }
        })
      }
    },
    async queryCiAttrs (id) {
      const { statusCode, data } = await getCiTypeAttributes(id)
      if (statusCode === 'OK') {
        let columns = []
        data.forEach(_ => {
          let renderKey = _.propertyName
          if (_.status !== 'decommissioned' && _.status !== 'notCreated') {
            const com =
              _.propertyName === this.initParams[SERVICE_INVOKE_SEQ_DESIGN]
                ? { component: 'WeCMDBSequenceDiagram' }
                : { ...components[_.inputType] }
            columns.push({
              ..._,
              tooltip: true,
              title: _.name,
              renderHeader: (h, params) => (
                <Tooltip content={_.description} placement="top">
                  <span style="white-space:normal">{_.name}</span>
                </Tooltip>
              ),
              key: renderKey,
              inputKey: _.propertyName,
              inputType: _.inputType,
              referenceId: _.referenceId,
              disEditor: !_.isEditable,
              disAdded: !_.isEditable,
              placeholder: _.name,
              component: 'Input',
              filterRule: !!_.filterRule,
              ciType: { id: _.referenceId, name: _.name },
              type: 'text',
              isMultiple: _.inputType === 'multiSelect',
              serviceInvokeDesignId: this.initParams[SERVICE_INVOKE_DESIGN_ID],
              invokeUnitDesign: this.initParams[INVOKE_DIAGRAM_LINK_FROM],
              invokedUnitDesign: this.initParams[INVOKE_DIAGRAM_LINK_TO],
              serviceDesign: this.initParams[SERVICE_DESIGN],
              ...com
            })
          }
        })
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.tableColumns = this.getSelectOptions(columns)
          }
        })
      }
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
    getCurrentData () {
      this.queryCiAttrs(this.currentTab)
      this.queryCiData()
    },
    async getArchitectureDesignTabs () {
      const { data, statusCode } = await getArchitectureDesignTabs()
      let allInnerActions = await getExtraInnerActions()
      if (statusCode === 'OK') {
        // 需要过滤掉‘确认’按钮
        this.tabList = data
          .filter(_ => _.actionType !== 'confirm')
          .map(_ => {
            return {
              ..._,
              name: _.value,
              id: _.code,
              tableData: [],
              tableColumns: [],
              outerActions: JSON.parse(JSON.stringify(newOuterActions)),
              innerActions: JSON.parse(JSON.stringify(allInnerActions)),
              pagination: JSON.parse(JSON.stringify(pagination)),
              ascOptions: {}
            }
          })
      }
    },
    onSystemDesignSelect (key) {
      this.allowArch = this.systemDesignsOrigin.some(x => x.r_guid === key) // 是否允许架构变更，当guid等于r_guid时允许
      this.allowFixVersion = false
      this.isTableViewOnly = true
      if (
        this.currentTab !== 'architecture-design' &&
        this.currentTab !== 'physicalGraph' &&
        this.currentTab === 'serviceInvoke'
      ) {
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
        this.getArchitectureDesignTabs()
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
#physicalGraph {
  position: relative;
  min-height: 300px;
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
