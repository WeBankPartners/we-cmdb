<template>
  <div class="operation">
    <div class="add-btn" v-if="editable">
      <!-- 根据CI State显示 Add/Confirm -->
      <ButtonGroup>
        <Button @click="showAddNodeModal()" v-if="isEdit && editable">
          {{ $t('new') }}
        </Button>
        <Button @click="saveNodeOrder()" v-if="isEdit && editable">
          {{ $t('save_order') }}
        </Button>
      </ButtonGroup>
    </div>
    <div slot="content" style="margin-top: 15px; height: calc(100vh - 350px); overflow: auto">
      <draggable tag="transition-group" class="list-group" :list="nodeDatas" :handle="dragClass">
        <Collapse simple v-for="nodeData in nodeDatas" :key="nodeData.guid">
          <Panel :hide-arrow="true">
            <div class="panel-icon">
              <Icon type="md-reorder" class="move" size="22" />
            </div>
            <div :title="nodeData.key_name" class="panel-text">{{ nodeData.key_name }}</div>
            <div slot="content">
              <Form>
                <div v-for="(formData, formDataIndex) in nodeCiAttrs" :key="formDataIndex + nodeData.guid">
                  <Tooltip :delay="500" placement="left-start">
                    <span class="form-item-title">
                      <span v-if="formData.uiNullable === 'no'" class="require-tag">*</span>
                      {{ formData.name }}
                    </span>
                    <div slot="content" style="white-space: normal">
                      {{ formData.description }}
                    </div>
                  </Tooltip>
                  <FormItem v-if="formData.inputType === 'int'" class="form-item-content">
                    <Input
                      v-model="nodeData[formData.propertyName]"
                      type="number"
                      :disabled="isNodeDataDisabled(nodeCiAttrs, formData, nodeData)"
                    ></Input>
                  </FormItem>
                  <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
                    <Input
                      v-model="nodeData[formData.propertyName]"
                      :disabled="isNodeDataDisabled(nodeCiAttrs, formData, nodeData)"
                    ></Input>
                  </FormItem>
                  <FormItem v-if="formData.inputType === 'longText'" class="form-item-content">
                    <textarea
                      v-model="nodeData[formData.propertyName]"
                      :disabled="isNodeDataDisabled(nodeCiAttrs, formData, nodeData)"
                      class="textArea-style"
                    ></textarea>
                  </FormItem>
                  <FormItem v-if="formData.inputType === 'datetime'" class="form-item-content">
                    <DatePicker
                      v-model="nodeData[formData.propertyName]"
                      :disabled="isNodeDataDisabled(nodeCiAttrs, formData, nodeData)"
                      type="date"
                      placeholder="Select date"
                    ></DatePicker>
                  </FormItem>
                  <FormItem v-if="formData.inputType === 'ref'" class="form-item-content">
                    <Ref
                      :formData="formData"
                      :panalData="nodeData"
                      :disabled="isNodeDataDisabled(nodeCiAttrs, formData, nodeData)"
                    ></Ref>
                  </FormItem>
                  <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
                    <MutiRef
                      :formData="formData"
                      :panalData="nodeData"
                      :disabled="isNodeDataDisabled(nodeCiAttrs, formData, nodeData)"
                    ></MutiRef>
                  </FormItem>
                  <FormItem v-if="formData.inputType === 'password'" class="form-item-content">
                    <WeCMDBCIPassword
                      :formData="formData"
                      :panalData="nodeData"
                      :disabled="isNodeDataDisabled(nodeCiAttrs, formData, nodeData)"
                    ></WeCMDBCIPassword>
                  </FormItem>
                  <FormItem v-if="formData.inputType === 'select'" class="form-item-content">
                    <Select
                      v-model="nodeData[formData.propertyName]"
                      filterable
                      clearable
                      :disabled="isNodeDataDisabled(nodeCiAttrs, formData, nodeData)"
                    >
                      <Option
                        v-for="choice in getEnumCode(formData.selectList)"
                        :value="choice.code"
                        :key="choice.code"
                        >{{ choice.value }}</Option
                      >
                    </Select>
                  </FormItem>
                  <FormItem v-if="formData.inputType === 'multiSelect'" class="form-item-content">
                    <Select
                      v-model="nodeData[formData.propertyName]"
                      filterable
                      clearable
                      multiple
                      :disabled="isNodeDataDisabled(nodeCiAttrs, formData, nodeData)"
                    >
                      <Option
                        v-for="choice in getEnumCode(formData.selectList)"
                        :value="choice.code"
                        :key="choice.code"
                        >{{ choice.value }}</Option
                      >
                    </Select>
                  </FormItem>
                  <FormItem v-if="['multiObject', 'object'].includes(formData.inputType)" class="form-item-content">
                    <CMDBJSONConfig
                      :inputKey="formData['propertyName']"
                      :jsonData="JSON.parse(JSON.stringify(nodeData[formData['propertyName']]) || '{}')"
                      :disabled="isNodeDataDisabled(nodeCiAttrs, formData, nodeData)"
                      @input="onFormJSONInput"
                    ></CMDBJSONConfig>
                  </FormItem>
                </div>
                <FormItem v-if="editable && isEdit">
                  <div class="opetation-btn-zone">
                    <ButtonGroup>
                      <Button
                        v-show="isEdit"
                        v-for="operation in nodeData._nextOperations"
                        :key="operation.value"
                        @click="nodeOperation(operation.value, operation.formType, nodeData)"
                        >{{ operation.name }}</Button
                      >
                    </ButtonGroup>
                  </div>
                </FormItem>
              </Form>
            </div>
          </Panel>
        </Collapse>
      </draggable>
    </div>
    <Modal v-model="showNodeModal" :title="this.$t('new')" height="500">
      <Form class="addNodeForm">
        <div v-for="(formData, formDataIndex) in nodeCiAttrs" :key="'newform' + formDataIndex">
          <Tooltip :delay="500" placement="left-start">
            <span class="form-item-title">
              <span v-if="formData.uiNullable == 'no'" class="require-tag">*</span>
              {{ formData.name }}
            </span>
            <div slot="content" style="white-space: normal">
              {{ formData.description }}
            </div>
          </Tooltip>
          <FormItem v-if="formData.inputType === 'int'" class="form-item-content">
            <Input
              v-model="newNodeData[formData.propertyName]"
              type="number"
              :disabled="isNewNodeDisabled(nodeCiAttrs, formData, newNodeData)"
            ></Input>
          </FormItem>
          <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
            <Input
              v-model="newNodeData[formData.propertyName]"
              :disabled="isNewNodeDisabled(nodeCiAttrs, formData, newNodeData)"
            ></Input>
          </FormItem>
          <FormItem v-if="formData.inputType === 'longText'" class="form-item-content">
            <textarea
              v-model="newNodeData[formData.propertyName]"
              :disabled="isNewNodeDisabled(nodeCiAttrs, formData, newNodeData)"
              class="textArea-style"
            ></textarea>
          </FormItem>
          <FormItem v-if="formData.inputType === 'datetime'" class="form-item-content">
            <DatePicker
              v-model="newNodeData[formData.propertyName]"
              :disabled="isNewNodeDisabled(nodeCiAttrs, formData, newNodeData)"
              type="date"
              placeholder="Select date"
            ></DatePicker>
          </FormItem>
          <FormItem v-if="formData.inputType === 'ref'" class="form-item-content">
            <Ref
              :formData="formData"
              :panalData="newNodeData"
              :disabled="isNewNodeDisabled(nodeCiAttrs, formData, newNodeData)"
            ></Ref>
          </FormItem>
          <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
            <MutiRef
              :formData="formData"
              :panalData="newNodeData"
              :disabled="isNewNodeDisabled(nodeCiAttrs, formData, newNodeData)"
            ></MutiRef>
          </FormItem>
          <FormItem v-if="formData.inputType === 'password'" class="form-item-content">
            <WeCMDBCIPassword
              :formData="formData"
              :panalData="newNodeData"
              :disabled="isNewNodeDisabled(nodeCiAttrs, formData, newNodeData)"
            ></WeCMDBCIPassword>
          </FormItem>
          <FormItem v-if="formData.inputType === 'select'" class="form-item-content">
            <Select
              v-model="newNodeData[formData.propertyName]"
              filterable
              clearable
              :disabled="isNewNodeDisabled(nodeCiAttrs, formData, newNodeData)"
            >
              <Option v-for="choice in getEnumCode(formData.selectList)" :value="choice.code" :key="choice.code">{{
                choice.value
              }}</Option>
            </Select>
          </FormItem>
          <FormItem v-if="formData.inputType === 'multiSelect'" class="form-item-content">
            <Select
              v-model="newNodeData[formData.propertyName]"
              filterable
              clearable
              multiple
              :disabled="isNewNodeDisabled(nodeCiAttrs, formData, newNodeData)"
            >
              <Option v-for="choice in getEnumCode(formData.selectList)" :value="choice.code" :key="choice.code">{{
                choice.value
              }}</Option>
            </Select>
          </FormItem>
          <FormItem v-if="formData.inputType === 'object'" class="form-item-content">
            <CMDBJSONConfig
              :inputKey="formData['propertyName']"
              :jsonData="JSON.parse(JSON.stringify(newNodeData[formData['propertyName']]) || '{}')"
              :disabled="isNewNodeDisabled(nodeCiAttrs, formData, newNodeData)"
              @input="onFormJSONInput"
            ></CMDBJSONConfig>
          </FormItem>
        </div>
      </Form>
      <div slot="footer">
        <Button type="text" @click="cancelAddNode()" :loading="newNodeBtnLoading">{{ $t('cancel') }} </Button>
        <Button type="primary" @click="saveAddNode()" :loading="newNodeBtnLoading">{{ $t('save') }} </Button>
      </div>
    </Modal>
    <SelectFormOperation ref="selectForm" @callback="callback"></SelectFormOperation>
    <Modal v-model="showHistoryModal" :title="$t('operation_data_rollback')" width="900">
      <div v-if="showHistoryModal">
        <CMDBTable
          :ciTypeId="ciType"
          :tableData="historyOptions"
          :tableColumns="historyColumns"
          :showCheckbox="true"
          :tableInnerActions="null"
          :isRefreshable="true"
          :filtersHidden="true"
          @getSelectedRows="onHistorySelectChange"
          tableHeight="650"
        ></CMDBTable>
      </div>
      <div slot="footer">
        <Button type="text" @click="onHistoryCancel()" :loading="historyBtnLoading">{{ $t('cancel') }} </Button>
        <Button type="primary" @click="onHistoryConfirm()" :loading="historyBtnLoading">{{ $t('save') }} </Button>
      </div>
    </Modal>
    <Modal
      v-model="showDoubleCheckModal"
      :title="$t('operation_data_confirm')"
      @on-ok="onDoubleCheckConfirm"
      @on-cancel="onDoubleCheckCancel"
    >
      <div v-if="showDoubleCheckModal">
        {{ $t('confirm_operation') }}
      </div>
    </Modal>
  </div>
</template>
<script>
import { queryCiData, graphCiDataOperation, graphQueryStateTransition, getEnumCodesByCategoryId } from '@/api/server'
import { normalizeFormData } from '@/pages/util/format'
import Ref from './ref'
import MutiRef from './muti-ref'
import SelectFormOperation from '@/pages/components/select-form-operation'
import draggable from 'vuedraggable'
export default {
  data () {
    return {
      ciType: '', // 序列对应的CIType
      nodeDatas: [], // 时序数据
      nodeCiAttrs: [], // 节点的ciType属性列表，自动根据ciType获取
      ignoreNodeOperations: ['confirm'], // 支持版本的情况下，需要忽略confirm操作
      nodeUpdateOperation: 'Update', // 用于更新顺序

      tmpNodeOperation: '', // 临时保存要对CI执行的Operation，用于Modal中获取ci对应的operation
      tmpNodeGuid: '', // 临时保存要对CI执行的Operation，用于Modal函数发起请求
      // isEdit: false, // 是否在编辑模式中
      graphMetadata: {}, // 图元素的元数据，包括节点的editRefAttr， 排序data字段
      parentNodeData: {}, // 父节点信息，用于填充editRefAttr
      // 新增节点控制数据
      showNodeModal: false, // 是否显示新增节点Model
      nodeAddOperation: 'Add', // 子节点的ciType状态机中对应action=insert的操作
      newNodeData: {}, // 新增节点数据
      newNodeBtnLoading: false, // 是否显示新增子节点的Modal按钮的loading动画

      baseKeyCatMapping: {}, // 基础类型的枚举映射 {unit_type: [{code: xx, value: xxx}]}
      // 节点操作Operation需要的数据
      showHistoryModal: false, // 是否显示回退操作的Modal
      historyOptions: [], // 回退操作的数据列表
      historyColumns: [], // 回退操作的列定义
      historyBtnLoading: false,
      tmpHistorySelected: [], // 临时勾选的历史记录
      showDoubleCheckModal: false,
      dragClass: '.move-disabled'
    }
  },
  props: ['editable', 'ciTypeMapping', 'isEdit', 'suportVersion', 'plainDatas'],
  async mounted () {
    let guids = []
    let ciType = ''
    let graphMetadata = null
    let parentNodeDataGuid = null
    this.plainDatas.forEach(item => {
      if (['assist_item', 'service_invoke_item'].includes(item.metadata.setting.graphType)) {
        graphMetadata = item.metadata
        parentNodeDataGuid = item.parent
        ciType = item.ciType
        guids.push(item.guid)
      }
    })
    //
    if (ciType.length === 0) {
      this.plainDatas.forEach(item => {
        if (item.metadata.setting.graphType === 'sequence_diagram') {
          let setting = item.metadata.setting.children.find(el => el.graphType === 'service_invoke_item')
          graphMetadata = {
            setting: setting,
            editRefAttr: setting.editRefAttr,
            editable: setting.editable
          }
          parentNodeDataGuid = item.guid
          ciType = setting.ciType
        }
      })
    }

    // 准备基础数据
    this.ciType = ciType
    this.graphMetadata = graphMetadata
    this.nodeUpdateOperation = graphMetadata.setting.updateOperation || 'Update'
    this.parentNodeData = this.plainDatas.find(el => parentNodeDataGuid === el.guid).data
    if (this.isEdit && this.editable) {
      this.dragClass = '.move'
    }
    let ciAttrs = this.getCiFormAttributes(this.ciType)
    for (let idx = 0; idx < ciAttrs.length; idx++) {
      let el = ciAttrs[idx]
      if (['multiSelect', 'select'].includes(el.inputType)) {
        await this.getEnumCodesByCategoryId(el.selectList)
      }
    }
    await this.initNodeData(guids)
  },
  watch: {},
  methods: {
    isGroupEditDisabled (allAttrs, attr, item) {
      let attrGroupEditDisabled = false
      if (attr.editGroupControl === 'yes') {
        if (attr.editGroupValues.length > 0) {
          let groups = JSON.parse(attr.editGroupValues)
          for (let idx = 0; idx < groups.length; idx++) {
            let group = groups[idx]
            if (attrGroupEditDisabled) {
              break
            }
            const findAttr = allAttrs.find(el => {
              if (el.propertyName === group.key) {
                return true
              }
              return false
            })
            if (findAttr && group.value.length > 0) {
              if (!item[findAttr.propertyName]) {
                // 控制字段未赋值，禁用当前字段
                attrGroupEditDisabled = true
              } else if (Array.isArray(item[findAttr.propertyName])) {
                let attrValues = item[findAttr.propertyName]
                let intersect = attrValues.filter(v => {
                  return group.value.indexOf(v) > -1
                })
                // 控制字段是数组且与设置的数据没有交集，禁用当前字段
                if (intersect.length === 0) {
                  attrGroupEditDisabled = true
                }
              } else {
                // 控制字段是单值且不在分组范围，应当禁用当前字段
                if (group.value.indexOf(item[findAttr.propertyName]) < 0) {
                  attrGroupEditDisabled = true
                }
              }
            }
          }
        }
      }
      return attrGroupEditDisabled
    },
    isNodeDataDisabled (allAttrs, attr, item) {
      let attrEditDisabled =
        !this.isEdit || attr.editable === 'no' || (attr.autofillable === 'yes' && attr.autoFillType === 'forced')
      return attrEditDisabled || this.isGroupEditDisabled(allAttrs, attr, item)
    },
    isNewNodeDisabled (allAttrs, attr, item) {
      let attrEditDisabled = attr.editable === 'no' || (attr.autofillable === 'yes' && attr.autoFillType === 'forced')
      return attrEditDisabled || this.isGroupEditDisabled(allAttrs, attr, item)
    },
    onFormJSONInput (jsonData, key) {
      let copyData = JSON.parse(JSON.stringify(jsonData))
      copyData.__meta = 'json'
      this.newNodeData[key] = copyData
    },
    filterNextOperations (operations) {
      // 过滤val中ignoreNodeOperations的操作
      const ignoreOperas = new Set(
        this.ignoreNodeOperations.map(element => {
          return element.value
        })
      )
      return operations.filter(x => !ignoreOperas.has(x))
    },
    buildNextOperations (stateItems, operations) {
      // 根据CI的状态机定义和当前CI行的operations(nextOperations)计算出name和formType
      let setOperations = Array.from(new Set(operations))
      return setOperations.map(operation => {
        let state = stateItems.find(element => {
          if (element.operation_en === operation) {
            return true
          }
        })
        return { value: state.operation_en, name: state.operation, formType: state.operationFormType }
      })
    },
    getEnumCode (enumCat) {
      return this.baseKeyCatMapping[enumCat] || []
    },
    async getEnumCodesByCategoryId (val) {
      let resp = await getEnumCodesByCategoryId(val)
      this.baseKeyCatMapping[val] = resp.data.map(element => {
        return { code: element.code, value: element.value }
      })
    },
    async initNodeData (value) {
      // ref 和 multiRef要求Form data初始化为{}，否则Select无法显示
      this.nodeCiAttrs = []
      this.ignoreNodeOperations = []
      if (value) {
        // 获取CI数据
        const payload = {
          id: this.ciType,
          queryObject: {
            filters: [{ name: 'guid', operator: 'in', value: value }],
            paging: false,
            dialect: {}
          }
        }
        if (value.length > 0) {
          const { data, statusCode } = await queryCiData(payload)
          if (statusCode === 'OK' && data.contents.length > 0) {
            data.contents.sort((a, b) => {
              let orderField = this.graphMetadata.setting.orderData || 'order_number'
              return parseInt(a[orderField]) - parseInt(b[orderField])
            })
            this.nodeDatas = data.contents
            let stateItems = await this.getCiTypeStateTransition(this.ciType)
            this.ignoreNodeOperations =
              this.suportVersion === 'yes' ? this.getCiTypeOperation(stateItems, 'confirm') : []
            this.nodeDatas.forEach(item => {
              item._nextOperations = this.buildNextOperations(
                stateItems,
                this.filterNextOperations(data.contents[0].nextOperations)
              )
            })
          }
        }
        this.nodeCiAttrs = this.getCiFormAttributes(this.ciType)
      }
    },
    async nodeOperation (action, formType, nodeData) {
      this.tmpNodeOperation = action
      if (formType === 'confirm_form') {
        this.showDoubleCheckModal = true
        this.tmpNodeGuid = nodeData.guid
      } else if (formType === 'editable_form') {
        const resp = await graphCiDataOperation(this.ciType, action, [normalizeFormData(nodeData)])
        if (resp.statusCode === 'OK') {
          this.$emit('operationReload', this.ciType, [normalizeFormData(nodeData)])
        }
      } else if (formType === 'select_form') {
        this.selectHandler(action, nodeData)
      }
    },
    callback (ci, items) {
      this.$emit('operationReload', ci, items)
    },
    async selectHandler (operationType, data) {
      const params = {
        operation: operationType,
        ciType: this.ciType,
        guid: data.guid
      }
      this.$refs.selectForm.initFormData(params)
    },
    async onHistoryConfirm () {
      if (this.tmpHistorySelected.length === 1) {
        this.historyBtnLoading = true
        let rollBackData = normalizeFormData(this.tmpHistorySelected[0])
        // delete rollBackData.update_time
        const resp = await graphCiDataOperation(this.ciType, this.tmpNodeOperation, [rollBackData])
        if (resp.statusCode === 'OK') {
          this.showHistoryModal = false
          // TODO: trigger reload only if ref/multiRef fields changed
          this.$emit('operationReload', this.ciType, [rollBackData])
        }
        this.historyBtnLoading = false
      } else {
        this.$Notice.error({
          title: 'Error',
          desc: this.$t('must_select_one_item')
        })
        return false
      }
    },
    onHistoryCancel () {
      this.historyBtnLoading = false
      this.showHistoryModal = false
    },
    onHistorySelectChange (selected) {
      this.tmpHistorySelected = selected
    },
    async onDoubleCheckConfirm () {
      let nodeData = this.nodeDatas.find(el => this.tmpNodeGuid === el.guid)
      const resp = await graphCiDataOperation(this.ciType, this.tmpNodeOperation, [normalizeFormData(nodeData)])
      if (resp.statusCode === 'OK') {
        this.showDoubleCheckModal = false
        this.$emit('operationReload', this.ciType, [{ guid: this.tmpNodeGuid }], 'confirm')
      }
    },
    onDoubleCheckCancel () {
      this.showDoubleCheckModal = false
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
    async initNewNodeData (attrs) {
      // ref 和 multiRef要求Form data初始化为{}，否则Select无法显示
      this.newNodeData = {}
      for (let index = 0; index < attrs.length; index++) {
        const element = attrs[index]
        if (element.inputType === 'ref') {
          this.newNodeData[element.propertyName] = {}
        }
        if (element.inputType === 'multiRef') {
          this.newNodeData[element.propertyName] = []
        }
        if (element.inputType === 'select' || element.inputType === 'multiSelect') {
          if (!(element.selectList in this.baseKeyCatMapping)) {
            await this.getEnumCodesByCategoryId(element.selectList)
          }
        }
      }
    },
    async showAddNodeModal () {
      // ciType可以是rootCI，区别是rootCI不会自动填充editRefAttr值，其他类型CI会填充
      let attributes = this.getCiFormAttributes(this.ciType, true)
      attributes = attributes.map(element => {
        // autofill editRefAttr
        if (element.propertyName === this.graphMetadata.editRefAttr) {
          return { ...element, editable: 'no' }
        } else {
          return element
        }
      })
      await this.initNewNodeData(attributes)
      this.newNodeData[this.graphMetadata.editRefAttr] = {
        guid: this.parentNodeData.guid,
        key_name: this.parentNodeData.key_name
      }
      this.nodeCiAttrs = []
      let stateItems = await this.getCiTypeStateTransition(this.ciType)
      let operations = this.getCiTypeOperation(stateItems, 'insert')
      this.nodeAddOperation = operations[0].value
      this.$nextTick(() => {
        this.nodeCiAttrs = attributes
      })
      this.showNodeModal = true
    },
    async saveAddNode () {
      this.newNodeBtnLoading = true
      let data = normalizeFormData(this.newNodeData)
      let resp = await graphCiDataOperation(this.ciType, this.nodeAddOperation, [data])
      if (resp.statusCode === 'OK') {
        this.showNodeModal = false
        this.$emit('operationReload', this.ciType, resp.data, 'add')
      }
      this.newNodeBtnLoading = false
    },
    cancelAddNode () {
      this.newNodeBtnLoading = false
      this.showNodeModal = false
    },
    async saveNodeOrder () {
      let orderField = this.graphMetadata.setting.orderData || 'order_number'
      let nodes = this.nodeDatas.map(el => {
        let node = { guid: el.guid }
        node[orderField] = (10001 + parseInt(el[orderField])).toString()
        return node
      })
      const resp = await graphCiDataOperation(this.ciType, this.nodeUpdateOperation, nodes)
      if (resp.statusCode === 'OK') {
        nodes.forEach((el, idx) => {
          el[orderField] = (idx + 1).toString()
        })
        const resp2 = await graphCiDataOperation(this.ciType, this.nodeUpdateOperation, nodes)
        if (resp2.statusCode === 'OK') {
          this.$emit('operationReload', this.ciType, nodes)
        }
      }
    }
  },
  filters: {},
  components: {
    Ref,
    MutiRef,
    SelectFormOperation,
    draggable
  }
}
</script>

<style scoped lang="scss">
.operation {
  overflow: auto;
}

.addNodeForm {
  min-height: 300px;
  max-height: 600px;
  overflow: auto;
}
.textArea-style {
  width: 100%;
  border-color: #dcdee2;
}
.textArea-style:focus {
  border-color: #57a3f3;
  outline: 0;
  box-shadow: 0 0 0 2px rgba(45, 140, 240, 0.2);
}
.form-item-title {
  width: 80px;
  text-align: right;
  vertical-align: middle;
  float: left;
  font-size: 14px;
  color: #515a6e;
  line-height: 1;
  padding: 10px 12px 10px 0;
  box-sizing: border-box;
  position: absolute;
  margin-top: 6px;
}
.form-item-content {
  margin-bottom: 0px;
  margin-left: 80px;
}
.opetation-btn-zone {
  margin-top: 20px;
  margin-left: 80px;
}
.opetation-btn {
  margin: 0 16px;
}

.opertaion ::v-deep .ivu-tabs-tab {
  width: 100%;
  text-align: center;
}
.opertaion ::v-deep .ivu-tabs-ink-bar {
  width: 100% !important;
}

.require-tag {
  color: red;
}
.add-btn {
  margin: 0 auto;
  width: 97%;
}

.panel-icon {
  display: inline-block;
  cursor: move;
  vertical-align: text-bottom;
}

.panel-text {
  display: inline-block;
  width: 85%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  vertical-align: text-bottom;
}
</style>
