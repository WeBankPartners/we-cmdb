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
          <Modal v-model="fixVersionTreeModal" width="500px" :title="$t('fix_version')">
            <div style="max-height: 600px; overflow: auto;">
              <Tree :data="deployTree"></Tree>
            </div>
            <div slot="footer">
              <Button @click="cancelFixVersion">{{ $t('cancel') }}</Button>
              <Button type="info" @click="onArchFixVersion" :loading="buttonLoading.fixVersionModal">{{
                $t('confirm')
              }}</Button>
            </div>
          </Modal>
        </Row>
      </Col>
    </Row>
    <Card style="margin-top: 20px">
      <div>
        <Tabs type="card" :value="currentTab" :closable="false" @on-click="handleTabClick">
          <TabPane :label="$t('application_logic_diagram')" name="architectureDesign" class="app-tab" :index="1">
            <Alert show-icon closable v-if="isDataChanged">
              Data has beed changed, click Reload button to reload graph.
              <Button slot="desc" @click="reloadHandler">Reload</Button>
            </Alert>
            <Spin size="large" fix v-if="spinShow">
              <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
              <div>{{ $t('loading') }}</div>
            </Spin>
            <div v-else-if="!appLogicData.length" class="no-data">
              {{ $t('no_data') }}
            </div>
            <div style="padding-right: 20px">
              <div class="graph-container" id="appLogicGraph"></div>
            </div>
          </TabPane>
          <TabPane :label="$t('service_invoke_diagram')" name="serviceInvoke" class="app-tab" :index="2">
            <Alert show-icon closable v-if="isDataChanged">
              Data has beed changed, click Reload button to reload graph.
              <Button slot="desc" @click="reloadHandler">Reload</Button>
            </Alert>
            <Spin size="large" fix v-if="spinShow">
              <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
              <div>{{ $t('loading') }}</div>
            </Spin>
            <div v-else-if="!serviceInvokeData.length" class="no-data">
              {{ $t('no_data') }}
            </div>
            <Row>
              <Col span="18" style="min-height:40px;">
                <div>
                  <div class="graph-container" id="serviceInvokeGraph"></div>
                </div>
              </Col>
              <Col span="6" offset="0" class="func-wrapper" v-if="isShowInvokeSequence">
                <Collapse>
                  <Panel name="invokeDesignSequence">
                    <b>{{ $t('invoking_sequential_design') }}</b>
                    <Form
                      slot="content"
                      ref="invokeSequenceForm"
                      :model="invokeSequenceForm"
                      label-position="left"
                      :label-width="110"
                    >
                      <Form-item :label="$t('invoking_sequential_design')">
                        <Row>
                          <Select
                            :placeholder="$t('select_placeholder')"
                            v-model="invokeSequenceForm.selectedInvokeSequence"
                            style="width:calc(100% - 80px)"
                          >
                            <Option
                              v-for="item in invokeSequenceForm.invokeSequenceData"
                              :key="item.data.guid"
                              :value="item.data.guid"
                              >{{ item.data.code }}</Option
                            >
                          </Select>
                          <Button style="float:right;width:70px;" @click="onSearchInvokeSquence">{{
                            $t('confirm')
                          }}</Button>
                        </Row>
                      </Form-item>
                      <Form-item
                        :label="$t('invoking_sequential_design_sequence')"
                        v-if="invokeSequenceForm.isShowInvokeSequenceDetial"
                      >
                        <span style="margin-right: 10px">{{ invokeSequenceForm.spliceInvokeSequenceList }}</span>
                      </Form-item>
                      <Form-Item :label="$t('current_invoking')" v-if="invokeSequenceForm.isShowInvokeSequenceDetial">
                        <Row>
                          <span style="margin-right: 10px">{{ invokeSequenceForm.currentInvokeSequenceTag }}</span>
                          <span class="header-buttons-container margin-right" style="float:right">
                            <Tooltip :content="$t('prev_step')" placement="top-start">
                              <Button size="small" @click="backInvokeSequence" icon="md-arrow-round-back"></Button>
                            </Tooltip>
                            <span>{{ invokeSequenceForm.currentNum }}/{{ invokeSequenceForm.totalNum }}</span>
                            <Tooltip :content="$t('next_step')" placement="top-start">
                              <Button size="small" @click="nextInvokeSequence" icon="md-arrow-round-forward"></Button>
                            </Tooltip>
                          </span>
                        </Row>
                      </Form-Item>
                      <Form-Item v-if="invokeSequenceForm.isShowInvokeSequenceDetial">
                        <Button
                          style="margin-right: calc(50% + 35px);width=70px;float: right"
                          @click="closeInvokeSquence"
                          >{{ $t('back') }}</Button
                        >
                      </Form-Item>
                    </Form>
                  </Panel>
                </Collapse>
              </Col>
            </Row>
          </TabPane>

          <TabPane :label="$t('physical_deployment_diagram')" name="physicalGraph" class="app-tab" :index="3">
            <div>
              <PhysicalGraph
                v-if="physicalGraphData.length"
                :graphData="physicalGraphData"
                :links="physicalGraphLinks"
                :callback="graphCallback"
                :initParams="initParams"
              ></PhysicalGraph>
              <div v-else class="no-data">{{ $t('no_data') }}</div>
              <Spin size="large" fix v-if="physicalSpin">
                <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
                <div>{{ $t('loading') }}</div>
              </Spin>
            </div>
          </TabPane>
          <TabPane
            v-if="!!systemDesignVersion"
            v-for="ci in tabList"
            :key="ci.id"
            :name="ci.id"
            :label="ci.name"
            :index="ci.seqNo + 3"
          >
            <CMDBTable
              :tableData="ci.tableData"
              :tableOuterActions="isTableViewOnly ? null : ci.outerActions"
              :tableInnerActions="isTableViewOnly ? null : ci.innerActions"
              :tableColumns="ci.tableColumns"
              :pagination="ci.pagination"
              :ascOptions="ci.ascOptions"
              :showCheckbox="isTableViewOnly ? false : needCheckout"
              :isRefreshable="true"
              @actionFun="actionFun"
              @handleSubmit="handleSubmit"
              @sortHandler="sortHandler"
              @getSelectedRows="onSelectedRowsChange"
              @pageChange="pageChange"
              @pageSizeChange="pageSizeChange"
              @confirmAddHandler="confirmAddHandler"
              @confirmEditHandler="confirmEditHandler"
              tableHeight="650"
              :ref="'table' + ci.id"
            ></CMDBTable>
          </TabPane>
        </Tabs>
      </div>
    </Card>
  </Row>
</template>

<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line no-unused-vars
import * as d3Graphviz from 'd3-graphviz'
import {
  getCiTypeAttributes,
  deleteCiDatas,
  createCiDatas,
  updateCiDatas,
  getEnumCodesByCategoryId,
  getSystemDesigns,
  getAllDesignTreeFromSystemDesign,
  saveAllDesignTreeFromSystemDesign,
  getArchitectureDesignTabs,
  getArchitectureCiDatas,
  operateCiState,
  getIdcDesignTreeByGuid,
  queryCiData,
  updateSystemDesign
} from '@/api/server'
import { newOuterActions, pagination, components } from '@/const/actions.js'
import { resetButtonDisabled } from '@/const/tableActionFun.js'
import { formatData } from '../util/format.js'
import { getExtraInnerActions } from '../util/state-operations.js'
import PhysicalGraph from './physical-graph'
import moment from 'moment'
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
  INVOKE_TYPE,
  IDC_PLANNING_LINK_ID,
  IDC_PLANNING_LINK_FROM,
  IDC_PLANNING_LINK_TO
} from '@/const/init-params.js'

export default {
  components: {
    PhysicalGraph
  },
  data () {
    return {
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
      serviceInvokeData: [],
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
      // copyVisible: false,
      // copyTableVisible: false,
      // noOfCopy: 1,
      // copyRows: [],
      // copyEditData: null,
      isHandleNodeClick: false
    }
  },
  computed: {
    tableRef () {
      return 'table' + this.currentTab
    },
    needCheckout () {
      return this.$route.name !== 'ciDataEnquiry'
    },
    currentRguid () {
      const found = this.systemDesignsOrigin.find(_ => _.guid === this.systemDesignVersion)
      if (found) {
        return found.r_guid
      } else {
        return ''
      }
    }
    // copyData () {
    //   return Array(this.noOfCopy)
    //     .fill(0)
    //     .reduce(arr => {
    //       arr = arr.concat(this.copyRows)
    //       return arr
    //     }, [])
    // },
    // currentCols () {
    //   const cols = (this.tabList.find(ci => ci.id === this.currentTab) || {}).tableColumns || []
    //   return cols.filter(col => !col.isAuto && col.isEditable)
    // }
  },
  watch: {
    currentTab () {
      // this.copyVisible = false
      // this.copyTableVisible = false
      // this.noOfCopy = 1
      // this.copyRows = []
      // this.copyEditData = null
    }
  },
  methods: {
    closeInvokeSquence () {
      this.invokeSequenceForm.totalNum = 0
      this.invokeSequenceForm.currentNum = 0
      this.invokeSequenceForm.selectedInvokeSequence = ''
      this.invokeSequenceForm.currentInvokeSequenceTag = ''
      this.invokeSequenceForm.currentInvokeSequence = []
      this.invokeSequenceForm.isShowInvokeSequenceDetial = false
      this.invokeSequenceForm.spliceInvokeSequenceList = ''
      this.initGraph()
    },
    backInvokeSequence () {
      if (this.invokeSequenceForm.currentNum > 1) {
        let invokeDesignSequenceList = this.invokeSequenceForm.currentInvokeSequence
        this.invokeSequenceForm.currentNum = this.invokeSequenceForm.currentNum - 1
        this.invokeSequenceForm.currentInvokeSequenceTag =
          invokeDesignSequenceList[this.invokeSequenceForm.currentNum - 1].key_name
        this.reColorInvokeSequence()
      }
    },
    nextInvokeSequence () {
      if (this.invokeSequenceForm.currentNum < this.invokeSequenceForm.totalNum) {
        let invokeDesignSequenceList = this.invokeSequenceForm.currentInvokeSequence
        this.invokeSequenceForm.currentNum = this.invokeSequenceForm.currentNum + 1
        this.invokeSequenceForm.currentInvokeSequenceTag =
          invokeDesignSequenceList[this.invokeSequenceForm.currentNum - 1].key_name
        this.reColorInvokeSequence()
      }
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
    onSearchInvokeSquence () {
      this.invokeSequenceForm.isShowInvokeSequenceDetial = true
      const found = this.invokeSequenceForm.invokeSequenceData.find(
        i => i.data.guid === this.invokeSequenceForm.selectedInvokeSequence
      )
      if (found) {
        this.invokeSequenceForm.currentInvokeSequence = found.data[this.initParams[SERVICE_INVOKE_SEQ_DESIGN]]
        this.handleInvokeSquence(true)
      }
    },
    handleInvokeSquence () {
      let invokeDesignSequenceList = this.invokeSequenceForm.currentInvokeSequence
      let spliceInvokeSequenceList = []
      invokeDesignSequenceList.forEach(_ => {
        spliceInvokeSequenceList.push(_.key_name)
      })
      this.invokeSequenceForm.spliceInvokeSequenceList = spliceInvokeSequenceList.join(' -> ')
      if (invokeDesignSequenceList.length > 0) {
        this.invokeSequenceForm.totalNum = invokeDesignSequenceList.length
        this.invokeSequenceForm.currentNum = 1
        this.invokeSequenceForm.currentInvokeSequenceTag = invokeDesignSequenceList[0].key_name
      }
      this.reColorInvokeSequence()
    },
    reColorInvokeSequence () {
      this.initGraph()
      this.shadeAll()

      this.invokeSequenceForm.currentInvokeSequence.forEach(_ => {
        this.reColorCurrentInvokeSequenceNode(_.service_design, 'ellipse', 'black')
        this.reColorCurrentInvokeSequenceNode(_.unit_design, 'polygon', 'black')
        this.reColorCurrentInvokeSequenceLine(_, 'black')
      })

      let index = this.invokeSequenceForm.currentNum
      let current = this.invokeSequenceForm.currentInvokeSequence[index - 1]
      this.reColorCurrentInvokeSequenceLine(current, 'green')
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
    cancelFixVersion () {
      this.fixVersionTreeModal = false
    },
    async reloadHandler () {
      this.onArchChange()
      this.isDataChanged = false
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
      const treeData = await getAllDesignTreeFromSystemDesign(this.systemDesignVersion)
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
        formatAppLogicLine(treeData.data)
        formatServiceInvokeLine(treeData.data)
        this.serviceInvokeData = formatServiceInvokeTree(treeData.data)
        this.getPhysicalGraphData()
        this.initGraph()
      }
    },
    async getPhysicalGraphData () {
      this.physicalGraphData = []
      const foundIdcGuid = this.systemDesignsOrigin.find(_ => _.guid === this.systemDesignVersion).data_center_design
        .guid
      if (!foundIdcGuid) {
        return
      }
      const payload = {
        id: this.initParams[IDC_PLANNING_LINK_ID],
        queryObject: {}
      }
      const promiseArray = [getIdcDesignTreeByGuid([foundIdcGuid]), queryCiData(payload)]
      const [idcData, links] = await Promise.all(promiseArray)
      if (idcData.statusCode === 'OK') {
        let setDesigns = {}
        this.allUnitDesign.forEach(_ => {
          let color = ''
          if (this.isTableViewOnly && this.systemDesignFixedDate) {
            if (this.systemDesignFixedDate <= _.fixedDate) {
              color = stateColor[_.data.state.code]
            }
          } else if (!_.fixedDate) {
            color = stateColor[_.data.state.code]
          }
          _.color = color
          if (setDesigns[_.data.resource_set_design.guid]) {
            setDesigns[_.data.resource_set_design.guid].push(_)
          } else {
            setDesigns[_.data.resource_set_design.guid] = [_]
          }
        })
        const formatTree = data => {
          return data.map(_ => {
            let result = {
              ..._
            }
            if (setDesigns[_.guid]) {
              result.children = setDesigns[_.guid]
            }
            if (_.children instanceof Array && _.children.length) {
              result.children = formatTree(_.children)
            }
            return result
          })
        }
        this.physicalGraphData = formatTree(idcData.data)
        this.physicalSpin = false
      }
      if (links.statusCode === 'OK') {
        this.physicalGraphLinks = links.data.contents.map(_ => {
          return {
            guid: _.data.guid,
            from: _.data[this.initParams[IDC_PLANNING_LINK_FROM]].guid,
            to: _.data[this.initParams[IDC_PLANNING_LINK_TO]].guid,
            label: _.data.code,
            state: _.data.state.code
          }
        })
      }
    },
    graphCallback () {
      this.physicalSpin = false
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
      initEvent('#serviceInvokeGraph')
      this.renderGraph('#serviceInvokeGraph', this.serviceInvokeData, this.appServiceInvokeLines)
      this.spinShow = false
    },
    renderGraph (id, data, linesData) {
      let nodesString = this.genDOT(id, data, linesData)
      this.graph.graphviz.transition().renderDot(nodesString)
      let svg = d3.select(id).select('svg')
      let width = svg.attr('width')
      let height = svg.attr('height')
      svg.attr('viewBox', '0 0 ' + width + ' ' + height)
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
    shadeAll () {
      d3.selectAll('#serviceInvokeGraph g path')
        .attr('stroke', '#7f8fa6')
        .attr('stroke-opacity', '.2')
      d3.selectAll('#serviceInvokeGraph g polygon')
        .attr('stroke', '#7f8fa6')
        .attr('stroke-opacity', '.2')
        .attr('fill', '#7f8fa6')
        .attr('fill-opacity', '.2')
      d3.selectAll('#serviceInvokeGraph g ellipse')
        .attr('stroke', '#7f8fa6')
        .attr('stroke-opacity', '.2')
        .attr('fill', '#7f8fa6')
        .attr('fill-opacity', '.2')
      d3.selectAll('text').attr('fill', '#000')
    },
    reColorCurrentInvokeSequenceLine (invokeSequence, color) {
      // line
      let edge = d3
        .select('#' + `gl_${invokeSequence.guid}`)
        .attr('stroke', color)
        .attr('stroke-opacity', '1')
      edge
        .select('path')
        .attr('stroke', color)
        .attr('stroke-opacity', '1')
      edge
        .select('polygon')
        .attr('fill', color)
        .attr('stroke', color)
        .attr('stroke-opacity', '1')
    },
    reColorCurrentInvokeSequenceNode (nodeId, nodeType, color) {
      // node
      let node = d3.select('#' + `gn_${nodeId}`)
      node
        .selectAll(nodeType)
        .attr('fill', color)
        .attr('stroke', color)
        .attr('stroke-opacity', '1')
    },
    handleTabClick (name) {
      this.payload.filters = []
      this.currentTab = name
      if (name !== 'architectureDesign' && name !== 'physicalGraph' && name !== 'serviceInvoke') {
        this.getCurrentData()
      }
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
                case 'copy':
                  _.props.disabled = !rows.every(x => x.guid)
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
              _.props.disabled = resetButtonDisabled(_)
            })
          }
        })
      }
    },
    actionFun (type, data, cols) {
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
        case 'copy':
          this.copyHandler(data, cols)
          break
        default:
          this.defaultHandler(type, data)
          break
      }
    },
    copyHandler (rows = [], cols) {
      this.$refs[this.tableRef][0].showCopyModal()
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
      this.queryCiData()
    },
    handleSubmit (data) {
      this.payload.filters = data
      this.queryCiData()
    },
    async defaultHandler (type, row) {
      this.$set(row.weTableForm, `${type}Loading`, true)
      const { statusCode, message } = await operateCiState(this.currentTab, row.guid, type)
      this.$set(row.weTableForm, `${type}Loading`, false)
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

          this.$refs[this.tableRef][0].pushNewAddedRowToSelections(emptyRowData)
          this.$refs[this.tableRef][0].showAddModal()
        }
      })
    },
    deleteHandler (deleteData) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        'z-index': 1000000,
        onOk: async () => {
          let found = this.tabList.find(i => i.id === this.currentTab)
          const payload = {
            id: found && found.code,
            deleteData: deleteData.map(_ => _.guid)
          }
          const { statusCode, message } = await deleteCiDatas(payload)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: 'Delete data Success',
              desc: message
            })
            this.tabList.forEach(ci => {
              if (ci.id === this.currentTab) {
                ci.outerActions.forEach(_ => {
                  _.props.disabled = _.actionType === 'save' || _.actionType === 'edit' || _.actionType === 'delete'
                })
              }
            })
            this.isDataChanged = true
            this.queryCiData()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    editHandler () {
      this.$refs[this.tableRef][0].showEditModal()
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
    async confirmAddHandler (data) {
      const deleteAttrs = this.deleteAttr()
      let addAry = JSON.parse(JSON.stringify(data))
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
      let payload = {
        id: this.currentTab,
        createData: addAry
      }
      const { statusCode, message } = await createCiDatas(payload)
      this.$refs[this.tableRef][0].resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: 'Added successfully',
          desc: message
        })
        this.setBtnsStatus()
        this.queryCiData()
        this.$refs[this.tableRef][0].closeEditModal(false)
      }
    },
    async confirmEditHandler (data) {
      let editAry = JSON.parse(JSON.stringify(data))
      editAry.forEach(_ => {
        delete _.isRowEditable
        delete _.weTableForm
        delete _.weTableRowId
        delete _.isNewAddedRow
        delete _.nextOperations
      })
      let payload = {
        id: this.currentTab,
        updateData: editAry
      }
      const { statusCode, message } = await updateCiDatas(payload)
      this.$refs[this.tableRef][0].resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: 'Updated successfully',
          desc: message
        })
        this.setBtnsStatus()
        this.queryCiData()
        this.$refs[this.tableRef][0].closeEditModal(false)
      }
    },
    setBtnsStatus () {
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.outerActions.forEach(_ => {
            _.props.disabled = resetButtonDisabled(_)
          })
        }
      })
    },
    async saveHandler (data) {
      let setBtnsStatus = () => {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              _.props.disabled = resetButtonDisabled(_)
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
        const found = this.tabList.find(i => i.id === this.currentTab)
        if (found) {
          found.outerActions.forEach(_ => {
            if (_.actionType === 'save') {
              _.props.loading = true
            }
          })
        }
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
        let payload = {
          id: found && found.code,
          createData: addAry
        }
        const { statusCode, message } = await createCiDatas(payload)
        if (found) {
          found.outerActions.forEach(_ => {
            if (_.actionType === 'save') {
              _.props.loading = false
            }
          })
        }
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: 'Add data Success',
            desc: message
          })
          this.isDataChanged = true
          setBtnsStatus()
          this.queryCiData()
        }
      }
      if (editAry.length > 0) {
        const found = this.tabList.find(i => i.id === this.currentTab)
        if (found) {
          found.outerActions.forEach(_ => {
            if (_.actionType === 'save') {
              _.props.loading = true
            }
          })
        }
        editAry.forEach(_ => {
          delete _.isRowEditable
          delete _.weTableForm
          delete _.weTableRowId
          delete _.isNewAddedRow
          delete _.nextOperations
        })

        let payload = {
          id: found && found.code,
          updateData: editAry
        }
        const { statusCode, message } = await updateCiDatas(payload)
        if (found) {
          found.outerActions.forEach(_ => {
            if (_.actionType === 'save') {
              _.props.loading = false
            }
          })
        }
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: 'Update data Success',
            desc: message
          })
          this.isDataChanged = true
          setBtnsStatus()
          this.queryCiData()
        }
      }
    },
    async exportHandler () {
      const found = this.tabList.find(_ => _.id === this.currentTab)
      if (found) {
        found.outerActions.forEach(_ => {
          if (_.actionType === 'export') {
            _.props.loading = true
          }
        })
      }
      let exportPayload = {
        ...this.payload,
        paging: false
      }
      const { statusCode, data } = await getArchitectureCiDatas(
        this.currentTab,
        this.systemDesignVersion,
        this.currentRguid,
        exportPayload
      )
      if (found) {
        found.outerActions.forEach(_ => {
          if (_.actionType === 'export') {
            _.props.loading = false
          }
        })
      }
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
      this.queryCiData()
    },
    pageSizeChange (size) {
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.pagination.pageSize = size
        }
      })
      this.queryCiData()
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
