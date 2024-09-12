<template>
  <Row>
    <Col span="24">
      <Row>
        <Col span="12">
          <template>
            <!-- select view -->
            <Select
              v-model="currentView"
              @on-change="onViewSelect"
              @on-clear="onClearViewSelect"
              @on-open-change="onViewOptions"
              clearable
              filterable
              label-in-name
              style="width: 35%;z-index:auto"
            >
              <Option
                v-for="(item, itemIndex) in viewOptions"
                :value="item.viewId"
                :key="item.viewId + itemIndex"
                :label="item.name"
                style="display:flex; flex-flow:row nowrap; justify-content:space-between; align-items:center"
              >
                {{ item.name }}
              </Option>
            </Select>
            <!-- select rootData -->
            <Select
              v-if="viewSetting.suportVersion !== 'yes'"
              v-model="currentRoot"
              :disabled="!currentView || !viewSetting.ciType"
              @on-change="onRootSelect"
              @on-clear="onClearRootSelect"
              @on-open-change="onRootOptions"
              clearable
              filterable
              :multiple="viewSetting.multiple == 'yes'"
              label-in-name
              style="width: 35%;z-index:auto"
              ref="rootSelect"
            >
              <Option
                v-if="currentView && viewSetting.editable === 'yes'"
                :value="-1"
                :key="-1"
                style="padding: 0 0 0 0px;"
              >
                <span style="width: 95%;">
                  <Button @click.stop.prevent="onAddRoot()" icon="md-add" type="success" long></Button>
                </span>
              </Option>
              <Option
                v-for="(item, itemIndex) in rootOptions"
                :value="item._id"
                :key="item._id + itemIndex"
                :label="item.name || item.key_name"
                style="display:flex; flex-flow:row nowrap; justify-content:space-between; align-items:center"
              >
                {{ item.name || item.key_name }}
              </Option>
            </Select>
            <!-- group select -->
            <Select
              v-else
              v-model="currentRoot"
              :disabled="!currentView || !viewSetting.ciType"
              @on-change="onRootSelect"
              @on-clear="onClearRootSelect"
              @on-open-change="onRootOptions"
              clearable
              filterable
              :multiple="viewSetting.multiple == 'yes'"
              label-in-name
              style="width: 35%;z-index:auto"
              ref="rootSelect"
            >
              <Option
                v-if="currentView && viewSetting.editable === 'yes'"
                :value="-1"
                :key="-1"
                style="padding: 0 0 0 0px;"
              >
                <span style="width: 95%;">
                  <Button @click.stop.prevent="onAddRoot()" icon="md-add" type="success" long></Button>
                </span>
              </Option>
              <OptionGroup
                v-for="(data, dataIndex) in rootGroupOptions"
                :key="data.key_name + dataIndex"
                :label="data.name || data.key_name"
              >
                <Option
                  v-for="(item, itemIndex) in data.options"
                  :value="item._id"
                  :key="item._id + itemIndex"
                  :label="`${item.name || item.key_name}${item.confirm_time ? ' ' + item.confirm_time : ''}`"
                  style="display:flex; flex-flow:row nowrap; justify-content:space-between; align-items:center"
                >
                  <div>{{ item.name || item.key_name }}</div>
                  <div v-if="item.confirm_time" style="color:#ccc; flex-shrink:1; margin-left:10px">
                    {{ item.confirm_time }}
                  </div>
                </Option>
              </OptionGroup>
            </Select>
          </template>
          <Button @click="onQuery()" :disabled="!(currentView && validateCurrentRoot())">
            {{ $t('query') }}
          </Button>
          <!-- <Button
            :disabled="viewSetting.editable !== 'yes' || viewData.length == 0 || isEditMode || !isGroupFirstNode()"
            @click="onEditMode()"
            >{{ $t('version_change') }}</Button
          >
          <Button
            v-if="viewSetting.suportVersion === 'yes'"
            :disabled="viewSetting.suportVersion !== 'yes' || viewSetting.editable !== 'yes' || !isEditMode"
            @click="onConfirmVersion()"
            >{{ $t('fix_version') }}</Button
          > -->

          <!-- <Button :disabled="!(currentView && viewSetting.editable === 'yes')" @click="onAddRoot()">{{
            $t('new_root')
          }}</Button> -->
        </Col>
      </Row>
      <Row>
        <Card class="view-card" style="margin-top: 20px;">
          <div>
            <Tabs type="card" :closable="false" @on-click="handleTabClick" ref="tab">
              <Spin size="large" fix v-if="tabLoading">
                <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
                <div>{{ $t('loading') }}</div>
              </Spin>
              <TabPane
                v-for="(graph, graphIndex) in viewSetting.graphs"
                :label="graph.name"
                :key="graph.name + graphIndex"
                :name="'tabgraph' + graphIndex"
              >
                <div v-if="viewData.length">
                  <Graph
                    :ref="'graphView' + graphIndex"
                    :key="'graphView' + graphIndex"
                    :isEdit="isEditMode"
                    :graphSetting="viewSetting"
                    :graphData="viewData"
                    :graphIndex="graphIndex"
                    :ciTypeMapping="ciTypeMapping"
                    :editable="viewSetting.editable === 'yes'"
                    :initTransform="graph._initTransform"
                    @graphReload="graphReload"
                  ></Graph>
                </div>
              </TabPane>
              <TabPane
                v-for="(citype, itemIndex) in ciTypeTables"
                :label="citype.name"
                :key="citype.id + itemIndex"
                :name="'tabci' + citype.id"
              >
                <CITable
                  v-if="citype.isInit"
                  :ci="citype.id"
                  :ciTypeName="citype.name"
                  :tableFilters="ciTypeTableFilters"
                  :isEdit="isEditMode"
                  tableHeight="650"
                  :ref="'citable' + citype.id"
                ></CITable>
              </TabPane>
            </Tabs>
          </div>
        </Card>
      </Row>
    </Col>
    <Modal v-model="showChildNodeModel" :title="childNodeCiName" footer-hide>
      <Form class="addNodeForm">
        <div v-for="(formData, formDataIndex) in childNodeCiAttrs" :key="formDataIndex + 'childform'">
          <Tooltip :delay="500" placement="left-start">
            <span class="form-item-title">
              <span v-if="formData.nullable == 'no'" class="require-tag">*</span>
              {{ formData.name }}
            </span>
            <div slot="content" style="white-space: normal;">
              {{ formData.description }}
            </div>
          </Tooltip>
          <FormItem v-if="formData.inputType === 'text' && formData.editable == 'yes'" class="form-item-content">
            <Input v-model="childNodeData[formData.propertyName]" :disabled="formData.editable == 'no'"></Input>
          </FormItem>
          <FormItem v-if="formData.inputType === 'longText' && formData.editable == 'yes'" class="form-item-content">
            <textarea
              v-model="childNodeData[formData.propertyName]"
              :disabled="formData.editable == 'no'"
              class="textArea-style"
            ></textarea>
          </FormItem>
          <FormItem v-if="formData.inputType === 'datetime' && formData.editable == 'yes'" class="form-item-content">
            <DatePicker
              v-model="childNodeData[formData.propertyName]"
              :disabled="formData.editable == 'no'"
              type="date"
              placeholder="Select date"
            ></DatePicker>
          </FormItem>
          <FormItem v-if="formData.inputType === 'ref' && formData.editable == 'yes'" class="form-item-content">
            <Ref :formData="formData" :panalData="childNodeData" :disabled="formData.editable == 'no'"></Ref>
          </FormItem>
          <FormItem v-if="formData.inputType === 'multiRef' && formData.editable == 'yes'" class="form-item-content">
            <MutiRef :formData="formData" :panalData="childNodeData" :disabled="formData.editable == 'no'"></MutiRef>
          </FormItem>
          <FormItem v-if="formData.inputType === 'password' && formData.editable == 'yes'" class="form-item-content">
            <WeCMDBCIPassword
              :formData="formData"
              :panalData="childNodeData"
              :disabled="formData.editable == 'no'"
            ></WeCMDBCIPassword>
          </FormItem>
          <FormItem v-if="formData.inputType === 'select' && formData.editable == 'yes'" class="form-item-content">
            <Select
              v-model="childNodeData[formData.propertyName]"
              filterable
              clearable
              :disabled="formData.editable == 'no'"
            >
              <Option
                v-for="choice in getEnumCode(childNodeData[formData.propertyName], formData.selectList)"
                :value="choice.code"
                :key="choice.code"
                >{{ choice.value }}</Option
              >
            </Select>
          </FormItem>
          <FormItem v-if="formData.inputType === 'multiSelect' && formData.editable == 'yes'" class="form-item-content">
            <Select
              v-model="childNodeData[formData.propertyName]"
              filterable
              clearable
              multiple
              :disabled="formData.editable == 'no'"
            >
              <Option
                v-for="choice in getEnumCode(childNodeData[formData.propertyName], formData.selectList)"
                :value="choice.code"
                :key="choice.code"
                >{{ choice.value }}</Option
              >
            </Select>
          </FormItem>
          <FormItem v-if="formData.inputType === 'object'" class="form-item-content">
            <CMDBJSONConfig
              :inputKey="formData['propertyName']"
              :jsonData="JSON.parse(JSON.stringify(childNodeData[formData['propertyName']]) || '{}')"
              :disabled="formData.editable == 'no'"
              @input="onChildFormJSONInput"
            ></CMDBJSONConfig>
          </FormItem>
        </div>
        <FormItem>
          <div class="opetation-btn-zone">
            <Button type="primary" @click="saveChildNode()" class="opetation-btn" :loading="childBtnLoading"
              >{{ $t('save') }}
            </Button>
            <Button type="primary" @click="cancelChildNode()" class="opetation-btn" :loading="childBtnLoading"
              >{{ $t('cancel') }}
            </Button>
          </div>
        </FormItem>
      </Form>
    </Modal>
  </Row>
</template>

<script>
import {
  getEnumCodesByCategoryId,
  graphViews,
  graphViewDetail,
  graphQueryRootCI,
  queryCiData,
  graphCiDataOperation,
  graphQueryStateTransition,
  getAllCITypesWithAttr
} from '@/api/server'
import { normalizeFormData } from '@/pages/util/format'
import Graph from './graph-view-component'
import CITable from './ci-data-component'
import Ref from './ref'
import MutiRef from './muti-ref'
export default {
  components: {
    Graph,
    Ref,
    MutiRef,
    CITable
  },
  data () {
    return {
      ciTypeMapping: {},
      currentView: '',
      viewOptions: [],
      currentRoot: '',
      rootOptions: [],
      rootGroupOptions: [],
      viewSetting: {},
      viewData: [],
      ciTypeTables: [],
      ciTypeTableFilters: {},
      isEditMode: false,
      tabLoading: false,

      // 新增root节点数据
      showChildNodeModel: false,
      childNodeCiName: '',
      childNodeCiAttrs: '',
      childNodeAddOperation: '',
      childNodeData: {},
      childBtnLoading: false,
      baseKeyCatMapping: {}
    }
  },
  computed: {},
  watch: {},
  methods: {
    handleTabClick (name) {
      if (name.startsWith('tabci')) {
        let ciTypeId = name.substring('tabci'.length)
        let ciType = this.ciTypeTables.find(el => el.id === ciTypeId)
        if (ciType) {
          ciType.isInit = true
        }
      } else if (name.startsWith('tabgraph')) {
        this.$nextTick(() => {
          let currentRoots = [this.currentRoot]
          if (Array.isArray(this.currentRoot)) {
            currentRoots = this.currentRoot
          }
          let rootDetails = currentRoots.map(currentRoot => {
            let rootDetail = this.rootOptions.find(el => {
              return el._id === currentRoot
            })
            return rootDetail
          })
          const num = name.slice(-1)
          this.$refs['graphView' + num][0].initGraph(rootDetails[0]['confirm_time'], Number(num))
        })
      }
    },
    onChildFormJSONInput (jsonData, key) {
      let copyData = JSON.parse(JSON.stringify(jsonData))
      copyData.__meta = 'json'
      this.childNodeData[key] = copyData
    },
    validateCurrentRoot () {
      if (this.currentRoot) {
        return this.currentRoot.length > 0
      }
      return false
    },
    isGroupFirstNode () {
      if (this.currentView && this.validateCurrentRoot()) {
        if (this.viewSetting.suportVersion === 'yes') {
          let rootDetail = this.rootOptions.find(el => {
            return el._id === this.currentRoot
          })
          if (rootDetail) {
            let rootGroup = this.rootGroupOptions.find(el => {
              return el.guid === rootDetail.guid
            })
            if (rootGroup && rootGroup.options.length > 0 && rootGroup.options[0]._id === this.currentRoot) {
              return true
            }
          }
        } else {
          return true
        }
      }
      return false
    },
    async onViewSelect (key) {
      if (key) {
        this.onClearViewSelect()
        const { data } = await graphViewDetail(key)
        this.viewSetting = data
      }
    },
    onClearViewSelect () {
      this.currentRoot = ''
      this.viewSetting = {}
      this.rootOptions = []
      this.rootGroupOptions = []
      this.onClearRootSelect()
    },
    async onViewOptions (val) {
      if (val) {
        const params = {
          permission: 'USE'
        }
        const { data, statusCode } = await graphViews(params)
        if (statusCode === 'OK' && data.length > 0) {
          this.viewOptions = data
        }
      }
    },
    onRootSelect (key) {
      if (key) {
        this.onClearRootSelect()
      }
    },
    onClearRootSelect () {
      this.$refs.rootSelect.query = ''
      this.viewData = []
      this.ciTypeTables = []
      this.isEditMode = false
    },
    async onRootOptions (val) {
      if (val) {
        let payload = null
        // 先查询一次最新数据
        payload = {
          id: this.viewSetting.ciType,
          queryObject: {
            filters: [],
            paging: false,
            sorting: { asc: false, field: 'create_time' },
            dialect: { queryMode: 'new' }
          }
        }
        if (this.viewSetting.filterAttr && this.viewSetting.filterValue) {
          payload.queryObject.filters.push({
            name: this.viewSetting.filterAttr,
            operator: 'eq',
            value: this.viewSetting.filterValue
          })
        }
        const { data, statusCode } = await queryCiData(payload)
        if (statusCode === 'OK') {
          // 直接使用数据
          let rootOptions = data.contents.map((opt, optIndex) => {
            return { _id: opt.guid + (opt.update_time || '') + (opt.confirm_time || ''), ...opt }
          })
          if (this.viewSetting.suportVersion === 'yes') {
            // 查询历史confirm数据
            let allGUIDs = data.contents.map(item => {
              return item.guid
            })
            let resp = null
            if (allGUIDs.length > 0) {
              payload = {
                id: this.viewSetting.ciType,
                queryObject: {
                  filters: [
                    { name: 'history_state_confirmed', operator: 'eq', value: '1' },
                    // 过滤GUID避免已经删除的数据被返回
                    { name: 'guid', operator: 'in', value: allGUIDs }
                  ],
                  paging: false,
                  sorting: { asc: false, field: 'confirm_time' },
                  dialect: { queryMode: 'all' }
                }
              }
              resp = await queryCiData(payload)
            }
            const hisData = resp ? resp.data : []
            let groupOptions = []
            let extendRootOptions = []
            rootOptions.forEach((item, itemIndex) => {
              groupOptions.push({ guid: item.guid, key_name: item.key_name, name: item.name, options: [item] })
              let hisOptions = hisData.contents.filter(hisItem => {
                if (hisItem.guid === item.guid && hisItem.confirm_time !== item.confirm_time) {
                  return true
                }
                return false
              })
              // 追加history option 到 rootOptions
              hisOptions = hisOptions.map((opt, optIndex) => {
                return { _id: opt.guid + (opt.update_time || '') + (opt.confirm_time || ''), ...opt }
              })
              extendRootOptions = extendRootOptions.concat(hisOptions)
              groupOptions[itemIndex].options = groupOptions[itemIndex].options.concat(hisOptions)
            })
            rootOptions = rootOptions.concat(extendRootOptions)
            this.rootGroupOptions = groupOptions
          }
          this.rootOptions = rootOptions
        }
      }
    },
    async onEditMode () {
      if (this.viewSetting.suportVersion === 'yes') {
        let ciType = this.viewSetting.ciType
        let rootDetail = this.rootOptions.find(el => {
          return el._id === this.currentRoot
        })
        let stateItems = await this.getCiTypeStateTransition(ciType)
        let operations = this.getCiTypeOperation(stateItems, 'update')
        let nextOperations = rootDetail.nextOperations
        let intersect = operations.filter(el => {
          return nextOperations.includes(el.value)
        })
        if (intersect.length === 0) {
          this.$Notice.error({
            title: 'Error',
            desc: this.$t('no_update_action_available')
          })
        } else {
          const resp = await graphCiDataOperation(ciType, intersect[0].value, [normalizeFormData(rootDetail)])
          if (resp.statusCode === 'OK') {
            this.isEditMode = true
          }
        }
      } else {
        this.isEditMode = true
      }
    },
    async onConfirmVersion () {
      let ciType = this.viewSetting.ciType
      let confirmGuids = new Set()
      this.viewSetting.graphs.forEach((graph, graphIndex) => {
        // refs -> graphView + index -> index=0 -> plainDatas
        let plainDatas = this.$refs['graphView' + graphIndex][0].plainDatas
        plainDatas.forEach(node => {
          if (node.metadata.setting.editable === 'yes') {
            confirmGuids.add(node.guid)
          }
        })
      })

      this.$Modal.confirm({
        title: this.$t('confirm_operation'),
        loading: true,
        'z-index': 1000000,
        onOk: async () => {
          const resp = await graphCiDataOperation(
            ciType,
            'Confirm',
            Array.from(confirmGuids).map(g => {
              return { guid: g }
            })
          )
          if (resp.statusCode === 'OK') {
            this.isEditMode = false
            this.$Modal.remove()
            this.graphReload()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    async onQuery () {
      this.isEditMode = false
      let currentRoots = [this.currentRoot]
      if (Array.isArray(this.currentRoot)) {
        currentRoots = this.currentRoot
      }
      let rootDetails = currentRoots.map(currentRoot => {
        let rootDetail = this.rootOptions.find(el => {
          return el._id === currentRoot
        })
        return rootDetail
      })
      let payload = {
        viewId: this.currentView,
        rootCi: rootDetails
          .map(el => {
            return el.guid
          })
          .join(',')
      }
      if (rootDetails[0]['confirm_time'] && this.viewSetting.suportVersion === 'yes') {
        payload['confirmTime'] = rootDetails[0]['confirm_time']
      }
      const { data } = await graphQueryRootCI(payload)
      this.viewData = []
      this.$nextTick(function () {
        this.viewData = data
        this.generateCiTypeTab()
        if (this.viewSetting.graphs.length > 0) {
          this.$refs.tab.activeKey = 'tabgraph0'
          this.handleTabClick('tabgraph0')
        }
      })
    },
    getCiFormAttributes (ciType, editOnly = false) {
      let attributes = this.ciTypeMapping[ciType].attributes.filter(el => {
        if (el.status === 'deleted' || el.status === 'notCreated') {
          return false
        }
        if (el.displayByDefault === 'yes') {
          if (editOnly && el.editable === 'yes') {
            if (el.autoFillType === 'forced' && el.autofillable === 'yes') {
              return false
            }
            return true
          } else if (!editOnly) {
            return true
          }
          return false
        }
        return false
      })
      attributes.sort((a, b) => {
        return a.uiFormOrder > b.uiFormOrder
      })
      return attributes
    },
    async onAddRoot () {
      this.$refs.rootSelect.visible = false
      let childCiType = this.ciTypeMapping[this.viewSetting.ciType]
      this.childNodeCiName = this.$t('new') + ': ' + childCiType.name
      this.childNodeCiAttrs = this.getCiFormAttributes(childCiType.ciTypeId, true)
      this.initChildNodeData()
      let stateItems = await this.getCiTypeStateTransition(childCiType.ciTypeId)
      let operations = this.getCiTypeOperation(stateItems, 'insert')
      this.childNodeAddOperation = operations[0].value
      this.showChildNodeModel = true
    },
    async getCiTypeStateTransition (ciType) {
      let resp = await graphQueryStateTransition(ciType, { params: { mode: 'all' } })
      return resp.data
    },
    getCiTypeOperation (stateItems, action) {
      let operations = stateItems.filter(element => {
        if (element.action === action) {
          return true
        }
      })
      return operations.map(element => {
        return { value: element.operation_en, name: element.operation }
      })
    },
    initChildNodeData () {
      // ref 和 multiRef要求Form data初始化为{}，否则Select无法显示
      this.childNodeData = {}
      this.childNodeCiAttrs.forEach(element => {
        if (element.inputType === 'ref') {
          this.childNodeData[element.propertyName] = {}
        }
        if (element.inputType === 'multiRef') {
          this.childNodeData[element.propertyName] = []
        }
      })
    },
    getEnumCode (value, enumCat) {
      // 根据CI.selectList定义获取枚举值
      if (!(enumCat in this.baseKeyCatMapping)) {
        let defaultOptions = []
        if (value) {
          if (Array.isArray(value)) {
            value.forEach(el => {
              defaultOptions.push({ code: el, value: el })
            })
          } else {
            defaultOptions.push({ code: value, value: value })
          }
        }
        this.baseKeyCatMapping[enumCat] = defaultOptions
        this.getEnumCodesByCategoryId(enumCat)
      }
      return this.baseKeyCatMapping[enumCat]
    },
    async getEnumCodesByCategoryId (val) {
      let resp = await getEnumCodesByCategoryId(val)
      this.baseKeyCatMapping[val] = resp.data.map(element => {
        return { code: element.code, value: element.value }
      })
    },
    async saveChildNode () {
      this.childBtnLoading = true
      let data = normalizeFormData(this.childNodeData)
      let resp = await graphCiDataOperation(this.viewSetting.ciType, this.childNodeAddOperation, [data])
      if (resp.statusCode === 'OK') {
        await this.onRootOptions(true)
        if (this.viewSetting.multiple === 'yes') {
          this.currentRoot = [resp.data[0].guid + (resp.data[0].update_time || '') + (resp.data[0].confirm_time || '')]
        } else {
          this.currentRoot = resp.data[0].guid + (resp.data[0].update_time || '') + (resp.data[0].confirm_time || '')
        }
        await this.onQuery()
        this.showChildNodeModel = false
      }
      this.childBtnLoading = false
    },
    cancelChildNode () {
      this.childBtnLoading = false
      this.showChildNodeModel = false
    },
    async getAllCITypes () {
      this.ciTypeMapping = {}
      const status = ['dirty', 'created']
      const allCITypesInfo = await getAllCITypesWithAttr(status)
      if (allCITypesInfo.statusCode === 'OK') {
        allCITypesInfo.data.map(_ => {
          this.ciTypeMapping[_.ciTypeId] = _
        })
      }
    },
    async generateCiTypeTab () {
      this.ciTypeTables = []
      let tabs = new Set()
      this.viewSetting.graphs.forEach(graph => {
        if (graph.rootData.showTable === 'yes') {
          tabs.add(this.viewSetting.ciType)
        }
        graph.rootData.children.forEach(graphChild => {
          if (graphChild.showTable === 'yes') {
            tabs.add(graphChild.ciType)
          }
          this.gatherGraphCiType(graphChild).forEach(ciType => {
            tabs.add(ciType)
          })
        })
      })
      Array.from(tabs).forEach(ciType => {
        this.ciTypeTables.push({ name: this.ciTypeMapping[ciType].name, id: ciType, isInit: false })
      })
      this.$nextTick(function () {
        this.ciTypeTableFilters = {}
        let ciFilters = {}
        if (this.viewSetting.graphs.length > 0) {
          this.$nextTick(() => {
            //   // refs -> graphView + index -> index=0 -> plainDatas
            let plainDatas = this.$refs['graphView' + 0][0].plainDatas
            plainDatas.forEach(node => {
              if (node.metadata.setting.editable !== 'no') {
                if (!(node.metadata.setting.ciType in ciFilters)) {
                  ciFilters[node.metadata.setting.ciType] = new Set()
                  ciFilters[node.metadata.setting.ciType].add(node.guid)
                } else {
                  ciFilters[node.metadata.setting.ciType].add(node.guid)
                }
              }
            })
            Object.keys(ciFilters).forEach(ci => {
              this.ciTypeTableFilters[ci] = Array.from(ciFilters[ci])
            })
          })
        }
      })
    },
    gatherGraphCiType (setting) {
      let tabs = []
      if (setting.showTable === 'yes') {
        tabs.push(setting.ciType)
      }
      ;(setting.children || []).forEach(subSetting => {
        tabs = tabs.concat(this.gatherGraphCiType(subSetting))
      })
      return tabs
    },
    async graphReload () {
      let currentRoots = [this.currentRoot]
      if (Array.isArray(this.currentRoot)) {
        currentRoots = this.currentRoot
      }
      let rootDetails = currentRoots.map(currentRoot => {
        let rootDetail = this.rootOptions.find(el => {
          return el._id === currentRoot
        })
        return rootDetail
      })
      let payload = {
        viewId: this.currentView,
        rootCi: rootDetails
          .map(el => {
            return el.guid
          })
          .join(',')
      }
      if (rootDetails[0]['confirm_time'] && this.viewSetting.suportVersion === 'yes') {
        payload['confirmTime'] = rootDetails[0]['confirm_time']
      }
      const { data } = await graphQueryRootCI(payload)
      this.viewSetting.graphs.forEach((graph, graphIndex) => {
        // refs -> graphView + index -> index=0 -> plainDatas
        let transform = this.$refs['graphView' + graphIndex][0].getGraphTransform()
        graph._initTransform = transform
      })
      this.viewData = []
      this.$nextTick(function () {
        this.viewData = data
        this.generateCiTypeTab()
      })
    }
  },
  async mounted () {
    await this.getAllCITypes()
  },
  created () {}
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
.graph {
  position: relative;
  min-height: 300px;
}

.view-card {
  height: calc(100vh - 180px);
  width: 100%;
}
.require-tag {
  color: red;
}
</style>
