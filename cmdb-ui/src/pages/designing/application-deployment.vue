<template>
  <div>
    <Row class="artifact-management">
      <Col span="6">
        <span style="margin-right: 10px">{{ $t('system') }}</span>
        <Select filterable @on-change="onSystemDesignSelect" v-model="systemVersion" label-in-name style="width: 70%;">
          <Option v-for="item in systems" :value="item.guid" :key="item.guid">{{ item.key_name }}</Option>
        </Select>
      </Col>
      <Col span="3">
        <Button type="info" @click="querySysTree">{{ $t('query') }}</Button>
      </Col>
    </Row>
    <hr style="margin: 10px 0" />
    <Tabs type="card" :value="currentTab" :closable="false" @on-click="handleTabClick">
      <TabPane :label="$t('application_logic_diagram')" name="logic-graph" :index="1">
        <Alert show-icon closable v-if="isDataChanged">
          Data has beed changed, click Reload button to reload graph.
          <Button slot="desc" @click="reloadHandler">Reload</Button>
        </Alert>

        <div class="graph-container" id="graph">
          <Spin size="large" fix v-if="spinShow">
            <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
            <div>{{ $t('loading') }}</div>
          </Spin>
          <div v-else-if="!systemData.length" class="no-data">
            {{ $t('no_data') }}
          </div>
        </div>
      </TabPane>
      <TabPane :label="$t('application_logic_tree_diagram')" name="logic-tree-graph" :index="2">
        <Alert show-icon closable v-if="isDataChanged">
          Data has beed changed, click Reload button to reload graph.
          <Button slot="desc" @click="reloadHandler">Reload</Button>
        </Alert>

        <div class="graph-container" id="graphTree">
          <Spin size="large" fix v-if="treeSpinShow">
            <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
            <div>{{ $t('loading') }}</div>
          </Spin>
        </div>
      </TabPane>
      <TabPane :label="$t('physical_deployment_diagram')" name="physicalGraph" :index="3">
        <div id="physicalGraph">
          <PhysicalGraph
            v-if="physicalGraphData.length"
            :graphData="physicalGraphData"
            :links="physicalGraphLinks"
            :callback="graphCallback"
          ></PhysicalGraph>
          <div v-else class="no-data">{{ $t('no_data') }}</div>
          <Spin size="large" fix v-if="physicalSpin">
            <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
            <div>{{ $t('loading') }}</div>
          </Spin>
        </div>
      </TabPane>
      <TabPane
        v-for="(ci, index) in tabList"
        :key="ci.id"
        :name="ci.id"
        :label="ci.name"
        v-if="isShowTabs"
        :index="index + 5"
      >
        <WeCMDBTable
          :tableData="ci.tableData"
          :tableOuterActions="ci.outerActions"
          :tableInnerActions="ci.innerActions"
          :tableColumns="ci.tableColumns"
          :pagination="ci.pagination"
          :ascOptions="ci.ascOptions"
          :showCheckbox="needCheckout"
          :isRefreshable="true"
          @actionFun="actionFun"
          @sortHandler="sortHandler"
          @handleSubmit="handleSubmit"
          @getSelectedRows="onSelectedRowsChange"
          @pageChange="pageChange"
          @pageSizeChange="pageSizeChange"
          tableHeight="650"
          :ref="'table' + ci.id"
        ></WeCMDBTable>
      </TabPane>
    </Tabs>
  </div>
</template>

<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line no-unused-vars
import * as d3Graphviz from 'd3-graphviz'

import {
  getDeployCiData,
  getDeployDesignTabs,
  getCiTypeAttributes,
  deleteCiDatas,
  createCiDatas,
  updateCiDatas,
  getSystems,
  getEnumCodesByCategoryId,
  getAllDeployTreesFromSystemCi,
  startProcessInstancesWithCiDataInbatch,
  getAllCITypes,
  operateCiState,
  getApplicationDeploymentDataTree,
  getAllZoneLinkGroupByIdc
} from '@/api/server.js'
import { outerActions, innerActions, pagination, components } from '@/const/actions.js'
import { formatData } from '../util/format.js'
import { getExtraInnerActions } from '../util/state-operations.js'
import PhysicalGraph from './physical-graph'

const LAST_LEVEL_CI_TYPE_ID = 9
const BUSINESS_APP_INSTANCE = 14
const URL_ATTR_NAME = 'resource_instance'
const LINE_CI_TYPE_ID = 11
const LINE_FROM_ATTR = 'invoke_unit'
const LINE_TO_ATTR = 'invoked_unit'
const stateColor = {
  new: '#19be6b',
  created: '#19be6b',
  update: '#2d8cf0',
  change: '#2d8cf0',
  destroyed: '#ed4014',
  delete: '#ed4014'
}
const colors = ['#bbdefb', '#90caf9', '#64b5f6', '#42a5f5', '#2196f3', '#1e88e5', '#1976d2']

export default {
  components: {
    PhysicalGraph
  },
  data () {
    return {
      isShowTabs: false,
      systems: [],
      systemVersion: '',
      env: '',
      currentTab: 'logic-graph',
      selectedDeployItems: [],
      graphSource: [],
      graphs: {},
      tabList: [],
      payload: {
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true
      },
      spinShow: false,
      graph: {},
      systemData: [],
      systemLines: {},
      graphNodes: {},
      physicalGraphData: [],
      physicalGraphLinks: [],
      serviceCiTypeId: '',
      invokeCiTypeId: '',
      instanceCiTypeId: '',
      isDataChanged: false,
      physicalSpin: false,
      graphTree: {},
      allCiTypes: {},
      systemTreeData: [],
      rankNodes: {},
      treeSpinShow: true
    }
  },
  computed: {
    tableRef () {
      return 'table' + this.currentTab
    },
    needCheckout () {
      return this.$route.name !== 'ciDataEnquiry'
    }
  },
  methods: {
    initADGraph () {
      this.spinShow = true
      const initEvent = () => {
        let graph = d3.select('#graph')

        graph
          .on('dblclick.zoom', null)
          .on('wheel.zoom', null)
          .on('mousewheel.zoom', null)
        this.graph.graphviz = graph
          .graphviz()
          .scale(1.2)
          .width(window.innerWidth * 0.96)
          .height(window.innerHeight * 0.8)
          .zoom(true)
      }

      initEvent()
      this.renderADGraph(this.systemData)
      this.spinShow = false
    },
    renderADGraph (data) {
      let nodesString = this.genADDOT(data)
      this.graph.graphviz.renderDot(nodesString)
      let svg = d3.select('#graph').select('svg')
      let width = svg.attr('width')
      let height = svg.attr('height')
      svg.attr('viewBox', '0 0 ' + width + ' ' + height)
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
        'rankdir=TB;nodesep=0.5;',
        'Node[fontname=Arial,fontsize=12,shape=box,style=filled];',
        'Edge[fontname=Arial,minlen="2",fontsize=6,labeldistance=1.5];',
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
      console.log(
        dots
          .join('')
          .replace(/\}/g, '}\n')
          .replace(/;/g, ';\n')
          .replace(/,/g, ',\n')
      )
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
        if (this.graphNodes[node.from] && this.graphNodes[node.to]) {
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
        }
      })
      return result.join('')
    },
    async reloadHandler () {
      this.querySysTree()
      this.isDataChanged = false
    },

    onSystemDesignSelect (key) {
      this.isShowTabs = false
      this.systemData = []
      this.systemTreeData = []
      this.systemLines = {}
      this.graphNodes = {}
      this.initADGraph()
      this.initTreeGraph()
    },
    async getSystems () {
      let { statusCode, data } = await getSystems()
      if (statusCode === 'OK') {
        this.systems = data.contents.map(_ => _.data)
      }
    },
    onTreeCheck (all, current) {
      this.selectedDeployItems = all
    },
    async querySysTree () {
      if (!this.systemVersion) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('please_select_system')
        })
        return
      }
      this.spinShow = true
      this.treeSpinShow = true
      if (this.currentTab) {
        this.queryCiData()
      }
      this.physicalSpin = true
      this.getAllDeployTreesFromSystemCi()
      this.getPhysicalGraphData()
    },
    async getAllDeployTreesFromSystemCi () {
      const { statusCode, data } = await getAllDeployTreesFromSystemCi(this.systemVersion)
      if (statusCode === 'OK') {
        this.isShowTabs = true
        this.systemTreeData = data
        this.systemLines = {}

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
            if (_.children instanceof Array && _.children.length && _.ciTypeId !== LAST_LEVEL_CI_TYPE_ID) {
              result.children = formatADData(_.children)
            }
            if (_.ciTypeId === LAST_LEVEL_CI_TYPE_ID) {
              const label = [
                '<<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">',
                `<TR><TD COLSPAN="3">${_.data.code}</TD></TR>`
              ]
              if (_.children instanceof Array && _.children.length) {
                _.children.forEach(item => {
                  if (item.ciTypeId === BUSINESS_APP_INSTANCE) {
                    const code = item.data.code
                    const url =
                      item.data[URL_ATTR_NAME] && item.data[URL_ATTR_NAME].code ? item.data[URL_ATTR_NAME].code : '-'
                    const ip = item.data.port || '-'
                    label.push(`<TR><TD>${code}</TD><TD>${url}</TD><TD>${ip}</TD></TR>`)
                  }
                })
              }
              label.push('</TABLE>>')
              result.label = label.join('')
            }
            return result
          })
        }
        const formatADLine = array =>
          array.forEach(_ => {
            if (_.ciTypeId === LINE_CI_TYPE_ID) {
              this.systemLines[_.guid] = {
                from: _.data[LINE_FROM_ATTR].guid,
                to: _.data[LINE_TO_ATTR].guid,
                id: _.guid,
                label: _.data.invoke_type.value,
                state: _.data.state.code,
                fixedDate: +new Date(_.data.fixed_date)
              }
            }
            if (_.children instanceof Array && _.children.length) {
              formatADLine(_.children)
            }
          })

        this.systemData = formatADData(data)
        formatADLine(data)

        this.initADGraph()
        this.initTreeGraph()
      }
    },
    async getPhysicalGraphData () {
      this.physicalGraphData = []
      const promiseArray = [getApplicationDeploymentDataTree(this.systemVersion), getAllZoneLinkGroupByIdc()]
      const [graphData, links] = await Promise.all(promiseArray)
      if (graphData.statusCode === 'OK') {
        if (graphData.data.length) {
          this.physicalGraphData = graphData.data
        } else {
          this.physicalGraphData = []
          this.physicalSpin = false
        }
      }
      if (links.statusCode === 'OK') {
        this.physicalGraphLinks = links.data.map(_ => {
          return {
            ..._,
            from: _.data.network_zone_1,
            to: _.data.network_zone_2
          }
        }) || []
      }
    },
    graphCallback () {
      this.physicalSpin = false
    },
    async executeDeploy () {
      let payload = {
        attach: {
          attachItems: [
            {
              filterName: 'systemVersion',
              filterValue: this.systemVersion
            }
          ]
        },
        requests: this.selectedDeployItems.map(_ => {
          return {
            ciDataId: _.guid,
            ciTypeId: _.ciTypeId,
            processDefinitionKey: _.data.WeCMDBOrchestration.codeId
          }
        })
      }
      const { statusCode, message } = await startProcessInstancesWithCiDataInbatch(payload)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('start_execution'),
          desc: message
        })
      }
    },
    initTreeGraph (filters = {}) {
      this.treeSpinShow = true
      let graph
      const initEvent = () => {
        graph = d3.select('#graphTree')
        graph
          .on('dblclick.zoom', null)
          .on('wheel.zoom', null)
          .on('mousewheel.zoom', null)
        this.graphTree.graphviz = graph
          .graphviz()
          .scale(1.2)
          .width(window.innerWidth * 0.96)
          .height(window.innerHeight * 0.8)
          .zoom(true)
          .fit(true)
      }

      initEvent()
      this.renderTreeGraph(this.systemTreeData)
      this.treeSpinShow = false
    },
    renderTreeGraph (data) {
      let nodesString = this.genTreeDOT(data)
      this.graphTree.graphviz.renderDot(nodesString)
      let svg = d3.select('#graphTree').select('svg')
      let width = svg.attr('width')
      let height = svg.attr('height')
      svg.attr('viewBox', '0 0 ' + width + ' ' + height)
    },
    genTreeDOT (data) {
      if (data.length === 0) {
        return 'digraph G {}'
      }
      const width = 16
      const height = 12
      let dots = [
        'digraph G{',
        'rankdir=TB nodesep=0.5;',
        `size="${width},${height}";`,
        this.genlayerDot(data),
        'Node [fontname=Arial, fontsize=12];',
        'Edge [fontname=Arial, minlen="2", fontsize=10, arrowhead="t"];',
        ...this.genChildrenDot(data || [], 1),
        ...this.genRankNodeDot(),
        '}'
      ]
      return dots.join(' ')
    },
    genlayerDot (data) {
      let layerData = []
      let childrenLayer = {}
      const findLayerCi = array =>
        array.forEach(_ => {
          const found = layerData.find(layer => layer.code === _.ciTypeId)
          if (!found) {
            layerData.push({
              code: _.ciTypeId,
              value: this.allCiTypes[_.ciTypeId].name
            })
          }
          if (_.children instanceof Array && _.children.length) {
            if (_.ciTypeId !== LAST_LEVEL_CI_TYPE_ID) {
              findLayerCi(_.children)
            } else {
              _.children.forEach(item => {
                childrenLayer[item.ciTypeId] = {
                  code: item.ciTypeId,
                  value: this.allCiTypes[item.ciTypeId].name
                }
              })
            }
          }
        })
      findLayerCi(data)
      Object.keys(childrenLayer).forEach(key => {
        layerData.push(childrenLayer[key])
      })
      let result = ['{', 'node[shape=plaintext,fontsize=16];']
      layerData.forEach((_, i) => {
        if (i === layerData.length - 1) {
          result.push(`"title_${_.code}"`)
        } else {
          result.push(`"title_${_.code}"->`)
        }
        this.rankNodes[_.code] = []
        this.rankNodes[_.code].push(_.value)
      })
      result.push('[style=invis]', '}')
      return result.join('')
    },
    genChildrenDot (data, level) {
      let dots = []
      data.forEach(_ => {
        dots = dots.concat([
          `"${_.guid}"`,
          `[id="n_${_.guid}";`,
          `label="${_.data.code || _.data.key_name}";`,
          'shape=ellipse;',
          `style="filled";color="${colors[level]}";`,
          `tooltip="${_.data.description || '-'}"];`
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
    genRankNodeDot () {
      let dot = []
      Object.keys(this.rankNodes).forEach((key, index) => {
        dot.push('{rank=same;')
        this.rankNodes[key].forEach((_, i) => {
          if (i === 0) {
            dot.push(`"title_${key}"[label="${_}";tooltip="${_}"];`)
          } else {
            dot.push(`${_};`)
          }
        })
        dot.push('}')
      })
      return dot
    },
    handleTabClick (name) {
      this.payload.filters = []
      this.currentTab = name
      if (
        this.currentTab !== 'logic-graph' &&
        this.currentTab !== 'deploy-detail' &&
        this.currentTab !== 'physicalGraph' &&
        this.currentTab !== 'logic-tree-graph'
      ) {
        this.getCurrentData()
      }
    },
    getCurrentData () {
      this.queryCiAttrs(this.currentTab)
      this.queryCiData()
    },
    onSelectedRowsChange (rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        let isUpdateableAry = []
        let isDeleteableAry = []

        rows.forEach((r, index) => {
          isUpdateableAry.push(!!r.nextOperations.find(op => op === 'update'))
          isDeleteableAry.push(!!r.nextOperations.find(op => op === 'delete'))
        })
        let isValueTrue = val => {
          return val === true
        }

        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              switch (_.actionType) {
                case 'add':
                  _.props.disabled = _.actionType === 'add'
                  break
                case 'edit':
                  _.props.disabled = !isUpdateableAry.every(isValueTrue)
                  break
                case 'delete':
                  _.props.disabled = !isDeleteableAry.every(isValueTrue)
                  break
                default:
                  break
              }
            })
          }
        })
      } else {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              _.props.disabled = !(_.actionType === 'add' || _.actionType === 'export' || _.actionType === 'cancel')
            })
          }
        })
      }
    },
    actionFun (type, data) {
      switch (type) {
        case 'export':
          this.exportHandler()
          break
        case 'add':
          this.addHandler()
          break
        case 'edit':
          this.editHandler()
          break
        case 'save':
          this.saveHandler(data)
          break
        case 'delete':
          this.deleteHandler(data)
          break
        case 'cancel':
          this.cancelHandler()
          break
        case 'innerCancel':
          this.$refs[this.tableRef][0].rowCancelHandler(data.weTableRowId)
          break
        default:
          this.defaultHandler(type, data)
          break
      }
    },
    sortHandler (data) {
      if (data.order === 'normal') {
        delete this.payload.sorting
      } else {
        this.payload.sorting = {
          asc: data.order === 'asc',
          field: data.key
        }
      }
      this.getCurrentData()
    },
    handleSubmit (data) {
      this.payload.filters = data
      this.getCurrentData()
    },
    async defaultHandler (type, row) {
      const { statusCode, message } = await operateCiState(this.currentTab, row.guid, type)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: type,
          desc: message
        })
        this.queryCiData()
      }
    },

    addHandler () {
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          let emptyRowData = {}
          ci.tableColumns.forEach(_ => {
            if (_.inputType === 'multiSelect' || _.inputType === 'multiRef') {
              emptyRowData[_.inputKey] = []
            } else {
              emptyRowData[_.inputKey] = ''
            }
          })
          emptyRowData['isRowEditable'] = true
          emptyRowData['isNewAddedRow'] = true
          emptyRowData['weTableRowId'] = 1
          emptyRowData['nextOperations'] = []

          ci.tableData.unshift(emptyRowData)
          this.$nextTick(() => {
            this.$refs[this.tableRef][0].pushNewAddedRowToSelections()
            this.$refs[this.tableRef][0].setCheckoutStatus(true)
          })
          ci.outerActions.forEach(_ => {
            _.props.disabled = _.actionType === 'add'
          })
        }
      })
    },
    cancelHandler () {
      this.$refs[this.tableRef][0].setAllRowsUneditable()
      this.$refs[this.tableRef][0].setCheckoutStatus()
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.outerActions.forEach(_ => {
            _.props.disabled = !(_.actionType === 'add' || _.actionType === 'export' || _.actionType === 'cancel')
          })
        }
      })
    },
    deleteHandler (deleteData) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        'z-index': 1000000,
        onOk: async () => {
          const payload = {
            id: this.currentTab,
            deleteData: deleteData.map(_ => _.guid)
          }
          const { statusCode, message } = await deleteCiDatas(payload)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: 'Delete data Success',
              desc: message
            })
            this.isDataChanged = true
            this.tabList.forEach(ci => {
              if (ci.id === this.currentTab) {
                ci.outerActions.forEach(_ => {
                  _.props.disabled = _.actionType === 'save' || _.actionType === 'edit' || _.actionType === 'delete'
                })
              }
            })
            this.getCurrentData()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    editHandler () {
      this.$refs[this.tableRef][0].swapRowEditable(true)
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.outerActions.forEach(_ => {
            if (_.actionType === 'save') {
              _.props.disabled = false
            }
          })
        }
      })
      this.$nextTick(() => {
        this.$refs[this.tableRef][0].setCheckoutStatus(true)
      })
    },
    deleteAttr () {
      let attrs = []
      const found = this.tabList.find(_ => _.id === this.currentTab)
      found.tableColumns.forEach(i => {
        if (i.isAuto) {
          attrs.push(i.propertyName)
        }
      })
      return attrs
    },
    async saveHandler (data) {
      let setBtnsStatus = () => {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              _.props.disabled = !(_.actionType === 'add' || _.actionType === 'export')
            })
          }
        })
        this.$refs[this.tableRef][0].setAllRowsUneditable()
        this.$nextTick(() => {
          /* to get iview original data to set _ischecked flag */
          let objData = this.$refs[this.tableRef][0].$refs.table.$refs.tbody.objData
          for (let obj in objData) {
            objData[obj]._isChecked = false
            objData[obj]._isDisabled = false
          }
        })
      }

      let d = JSON.parse(JSON.stringify(data))
      let addAry = d.filter(_ => _.isNewAddedRow)
      let editAry = d.filter(_ => !_.isNewAddedRow)
      if (addAry.length > 0) {
        const deleteAttrs = this.deleteAttr()
        addAry.forEach(_ => {
          deleteAttrs.forEach(attr => {
            delete _[attr]
          })
          delete _.isRowEditable
          delete _.weTableForm
          delete _.weTableRowId
          delete _.isNewAddedRow
          delete _.nextOperations
        })
        let found = this.tabList.find(i => i.id === this.currentTab)
        let payload = {
          id: found && found.code,
          createData: addAry
        }
        const { statusCode, message } = await createCiDatas(payload)
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: 'Add data Success',
            desc: message
          })
          this.isDataChanged = true
          setBtnsStatus()
          this.getCurrentData()
        }
      }
      if (editAry.length > 0) {
        editAry.forEach(_ => {
          delete _.isRowEditable
          delete _.weTableForm
          delete _.weTableRowId
          delete _.isNewAddedRow
          delete _.nextOperations
        })

        let found = this.tabList.find(i => i.id === this.currentTab)

        let payload = {
          id: found && found.code,
          updateData: editAry
        }
        const { statusCode, message } = await updateCiDatas(payload)
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: 'Update data Success',
            desc: message
          })
          this.isDataChanged = true
          setBtnsStatus()
          this.getCurrentData()
        }
      }
    },
    async exportHandler () {
      let found = this.tabList.find(i => i.code === this.currentTab)
      let requst = {
        codeId: found.codeId,
        systemGuid: this.systemVersion
      }

      let exportPayload = {
        ...this.payload,
        paging: false
      }
      const { statusCode, data } = await getDeployCiData(requst, exportPayload)
      if (statusCode === 'OK') {
        this.$refs[this.tableRef][0].export({
          filename: 'Ci Data',
          data: formatData(data.contents.map(_ => _.data))
        })
      }
    },
    pageChange (current) {
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.pagination.currentPage = current
        }
      })
      this.getCurrentData()
    },
    pageSizeChange (size) {
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.pagination.pageSize = size
        }
      })
      this.getCurrentData()
    },
    async queryCiAttrs (id) {
      const { statusCode, data } = await getCiTypeAttributes(id)
      if (statusCode === 'OK') {
        let columns = []
        data.forEach(_ => {
          let renderKey = _.propertyName
          if (_.status !== 'decommissioned' && _.status !== 'notCreated') {
            columns.push({
              ..._,
              title: _.name,
              key: renderKey,
              inputKey: _.propertyName,
              inputType: _.inputType,
              referenceId: _.referenceId,
              disEditor: !_.isEditable,
              disAdded: !_.isEditable,
              placeholder: _.name,
              component: 'Input',
              ciType: { id: _.referenceId, name: _.name },
              type: 'text',
              ...components[_.inputType]
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

    async queryCiData () {
      if (this.systemVersion === '') {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('please_select_system')
        })
        return
      }
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
      let requst = {
        codeId: found.codeId,
        systemGuid: this.systemVersion
      }

      const { statusCode, data } = await getDeployCiData(requst, this.payload)
      if (statusCode === 'OK') {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.tableData = data
              ? data.contents.map(_ => {
                return {
                  ..._.data,
                  nextOperations: _.meta.nextOperations || []
                }
              })
              : []
            ci.pagination.total = data ? data.pageInfo.totalRows : 0
          }
        })
      }
    },
    async getDeployDesignTabs () {
      const { statusCode, data } = await getDeployDesignTabs()
      if (statusCode === 'OK') {
        let allInnerActions = await getExtraInnerActions()
        if (statusCode === 'OK') {
          this.tabList = data.map(_ => {
            return {
              ..._,
              name: _.value,
              id: _.code,
              tableData: [],
              tableColumns: [],
              outerActions: JSON.parse(JSON.stringify(outerActions)),
              innerActions: JSON.parse(JSON.stringify(innerActions.concat(allInnerActions))),
              pagination: JSON.parse(JSON.stringify(pagination)),
              ascOptions: {}
            }
          })
        }
      }
    },
    async queryTreeLayerData () {
      const req = await getAllCITypes()
      if (req.statusCode) {
        req.data.forEach(_ => {
          this.allCiTypes[_.ciTypeId] = _
        })
      }
    }
  },
  created () {
    this.getSystems()
    this.getDeployDesignTabs()
    this.queryTreeLayerData()
  }
}
</script>

<style lang="scss" scoped>
#physicalGraph {
  position: relative;
  min-height: 300px;
}
#graphTree {
  position: relative;
  min-height: calc(50% + 300px);
}
.no-data {
  text-align: center;
}
</style>
