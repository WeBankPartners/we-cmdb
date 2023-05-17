<template>
  <div class="operation">
    <div class="add-btn" v-if="editable">
      <!-- 可新增的子节点类型，由父组件进行管理 -->
      <Dropdown v-if="nodeGuid && nodeEditable && isEdit" @on-click="showAddChildModal">
        <Button type="primary">
          {{ $t('create_child_node') }}
          <Icon type="ios-arrow-down"></Icon>
        </Button>
        <DropdownMenu slot="list">
          <DropdownItem
            v-for="(childCiType, childCiTypeIndex) in childCiTypes"
            :key="childCiTypeIndex + 'ddm'"
            :name="childCiType.ciType"
          >
            {{ childCiType.name }}
          </DropdownItem>
        </DropdownMenu>
      </Dropdown>
    </div>
    <div slot="content">
      <Form>
        <span v-if="nodeCiAttrs.length === 0">No Data!</span>
        <div v-for="(formData, formDataIndex) in nodeCiAttrs" :key="formDataIndex + nodeGuid">
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
                v-for="choice in getEnumCode(nodeData[formData.propertyName], formData.selectList)"
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
                v-for="choice in getEnumCode(nodeData[formData.propertyName], formData.selectList)"
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
        <FormItem v-if="editable && nodeEditable">
          <div class="opetation-btn-zone">
            <!-- <Button v-if="!isEdit && nodeGuid && nodeEditable" @click="editMode(true)" type="info">{{ $t('enter_edit') }}</Button>
            <Button v-if="isEdit && nodeGuid && nodeEditable" @click="editMode(false)" type="info">{{ $t('cancel_edit') }}</Button> -->
            <ButtonGroup>
              <Button
                v-show="isEdit"
                v-for="operation in nodeNextOperations"
                :key="operation.value"
                @click="nodeOperation(operation.value, operation.formType)"
                >{{ operation.name }}</Button
              >
            </ButtonGroup>
          </div>
        </FormItem>
      </Form>
    </div>
    <Modal v-model="showChildNodeModal" :title="childNodeCiName" height="500">
      <Form class="addNodeForm">
        <div v-for="(formData, formDataIndex) in childNodeCiAttrs" :key="'childform' + nodeGuid + formDataIndex">
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
              v-model="childNodeData[formData.propertyName]"
              type="number"
              :disabled="isNewNodeDisabled(childNodeCiAttrs, formData, childNodeData)"
            ></Input>
          </FormItem>
          <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
            <Input
              v-model="childNodeData[formData.propertyName]"
              :disabled="isNewNodeDisabled(childNodeCiAttrs, formData, childNodeData)"
            ></Input>
          </FormItem>
          <FormItem v-if="formData.inputType === 'longText'" class="form-item-content">
            <textarea
              v-model="childNodeData[formData.propertyName]"
              :disabled="isNewNodeDisabled(childNodeCiAttrs, formData, childNodeData)"
              class="textArea-style"
            ></textarea>
          </FormItem>
          <FormItem v-if="formData.inputType === 'datetime'" class="form-item-content">
            <DatePicker
              v-model="childNodeData[formData.propertyName]"
              :disabled="isNewNodeDisabled(childNodeCiAttrs, formData, childNodeData)"
              type="date"
              placeholder="Select date"
            ></DatePicker>
          </FormItem>
          <FormItem v-if="formData.inputType === 'ref'" class="form-item-content">
            <Ref
              :formData="formData"
              :panalData="childNodeData"
              :disabled="isNewNodeDisabled(childNodeCiAttrs, formData, childNodeData)"
            ></Ref>
          </FormItem>
          <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
            <MutiRef
              :formData="formData"
              :panalData="childNodeData"
              :disabled="isNewNodeDisabled(childNodeCiAttrs, formData, childNodeData)"
            ></MutiRef>
          </FormItem>
          <FormItem v-if="formData.inputType === 'password'" class="form-item-content">
            <WeCMDBCIPassword
              :formData="formData"
              :panalData="childNodeData"
              :disabled="isNewNodeDisabled(childNodeCiAttrs, formData, childNodeData)"
            ></WeCMDBCIPassword>
          </FormItem>
          <FormItem v-if="formData.inputType === 'select'" class="form-item-content">
            <Select
              v-model="childNodeData[formData.propertyName]"
              filterable
              clearable
              :disabled="isNewNodeDisabled(childNodeCiAttrs, formData, childNodeData)"
            >
              <Option
                v-for="choice in getEnumCode(childNodeData[formData.propertyName], formData.selectList)"
                :value="choice.code"
                :key="choice.code"
                >{{ choice.value }}</Option
              >
            </Select>
          </FormItem>
          <FormItem v-if="formData.inputType === 'multiSelect'" class="form-item-content">
            <Select
              v-model="childNodeData[formData.propertyName]"
              filterable
              clearable
              multiple
              :disabled="isNewNodeDisabled(childNodeCiAttrs, formData, childNodeData)"
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
              :disabled="isNewNodeDisabled(childNodeCiAttrs, formData, childNodeData)"
              @input="onChildFormJSONInput"
            ></CMDBJSONConfig>
          </FormItem>
        </div>
      </Form>
      <div slot="footer">
        <Button type="text" @click="cancelChildNode()" :loading="childBtnLoading">{{ $t('cancel') }} </Button>
        <Button type="primary" @click="saveChildNode()" :loading="childBtnLoading">{{ $t('save') }} </Button>
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
export default {
  data () {
    return {
      nodeGuid: '', // 选中节点的GUID，由父组件进行管理，并监听触发initNodeData
      ciType: '', // 选中节点的ciType，由父组件进行管理
      nodeCiAttrs: [], // 选中节点的ciType属性列表，由父组件调用syncCiAttributes函数触发更新
      nodeEditable: true, // 选中节点是否可编辑, 由父组件更新
      // 当前选中节点操作需要的数据
      nodeData: {}, // 选中节点的数据，用户点击svg后，根据nodeGuid自动查询获取
      nodeNextOperations: [], // 选中节点的可用操作，用户点击svg后，根据nodeGuid自动查询获取
      ignoreNodeOperations: [], // 选中节点的排除操作，用户点击svg后，根据nodeGuid自动查询获取并过滤action=confirm的操作
      tmpNodeOperation: '', // 临时保存要对CI执行的Operation，用于Modal中获取ci对应的operation
      // isEdit: false, // 是否在编辑模式中
      // 子节点操作需要的数据
      childCiTypes: [], // 可新增的子节点类型，由父组件进行管理 [{ciType: xx, editRefAttr: xxx, name: xx}]
      showChildNodeModal: false, // 是否显示新增子节点Model
      childNodeCiType: '', // 子节点的ciType，用于渲染Model
      childNodeAddOperation: '', // 子节点的ciType状态机中对应action=insert的操作
      childNodeCiName: '', // 子节点类型的CI名称，用于渲染Model Title
      childNodeCiAttrs: [], // 子节点类型的CI属性，用于渲染表单
      childNodeData: {}, // 子节点类型的CI数据
      baseKeyCatMapping: {}, // 基础类型的枚举映射 {unit_type: [{code: xx, value: xxx}]}
      childBtnLoading: false, // 是否显示新增子节点的Modal按钮的loading动画
      // 选中节点的操作Operation需要的数据
      showHistoryModal: false, // 是否显示回退操作的Modal
      historyOptions: [], // 回退操作的数据列表
      historyColumns: [], // 回退操作的列定义
      historyBtnLoading: false,
      tmpHistorySelected: [], // 临时勾选的历史记录
      showDoubleCheckModal: false
    }
  },
  props: ['editable', 'ciTypeMapping', 'isEdit', 'suportVersion'],
  mounted () {},
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
        !this.isEdit ||
        attr.editable === 'no' ||
        (attr.autofillable === 'yes' && attr.autoFillType === 'forced') ||
        !this.nodeEditable
      return attrEditDisabled || this.isGroupEditDisabled(allAttrs, attr, item)
    },
    isNewNodeDisabled (allAttrs, attr, item) {
      let attrEditDisabled = attr.editable === 'no' || (attr.autofillable === 'yes' && attr.autoFillType === 'forced')
      return attrEditDisabled || this.isGroupEditDisabled(allAttrs, attr, item)
    },
    onFormJSONInput (jsonData, key) {
      let copyData = JSON.parse(JSON.stringify(jsonData))
      copyData.__meta = 'json'
      this.nodeData[key] = copyData
    },
    onChildFormJSONInput (jsonData, key) {
      let copyData = JSON.parse(JSON.stringify(jsonData))
      copyData.__meta = 'json'
      this.childNodeData[key] = copyData
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
    async initNodeData (value) {
      // ref 和 multiRef要求Form data初始化为{}，否则Select无法显示
      this.nodeCiAttrs = []
      this.nodeData = {}
      this.nodeNextOperations = []
      this.ignoreNodeOperations = []
      if (value) {
        // 获取CI数据
        const payload = {
          id: this.ciType,
          queryObject: {
            filters: [{ name: 'guid', operator: 'eq', value: value }],
            paging: false,
            dialect: {}
          }
        }
        const { data, statusCode } = await queryCiData(payload)
        if (statusCode === 'OK' && data.contents.length > 0) {
          this.nodeData = data.contents[0]
          let stateItems = await this.getCiTypeStateTransition(this.ciType)
          this.ignoreNodeOperations = this.suportVersion === 'yes' ? this.getCiTypeOperation(stateItems, 'confirm') : []
          this.nodeNextOperations = this.buildNextOperations(
            stateItems,
            this.filterNextOperations(data.contents[0].nextOperations)
          )
        }
        this.nodeCiAttrs = this.getCiFormAttributes(this.ciType)
      }
    },
    async nodeOperation (action, formType) {
      this.tmpNodeOperation = action
      if (formType === 'confirm_form') {
        this.showDoubleCheckModal = true
      } else if (formType === 'editable_form') {
        const resp = await graphCiDataOperation(this.ciType, action, [normalizeFormData(this.nodeData)])
        if (resp.statusCode === 'OK') {
          await this.initNodeData(this.nodeGuid)
          // TODO: trigger reload only if ref/multiRef fields changed
          this.$emit('operationReload', this.ciType, [normalizeFormData(this.nodeData)])
        }
      } else if (formType === 'select_form') {
        this.selectHandler(action, this.nodeData)
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
          await this.initNodeData(this.nodeGuid)
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
      const resp = await graphCiDataOperation(this.ciType, this.tmpNodeOperation, [normalizeFormData(this.nodeData)])
      if (resp.statusCode === 'OK') {
        await this.initNodeData(this.nodeGuid)
        this.showDoubleCheckModal = false
        this.$emit('operationReload', this.ciType, [{ guid: this.nodeGuid }], 'confirm')
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
    async initChildNodeData (attrs) {
      // ref 和 multiRef要求Form data初始化为{}，否则Select无法显示
      this.childNodeData = {}
      for (let index = 0; index < attrs.length; index++) {
        const element = attrs[index]
        if (element.inputType === 'ref') {
          this.childNodeData[element.propertyName] = {}
        }
        if (element.inputType === 'multiRef') {
          this.childNodeData[element.propertyName] = []
        }
        if (element.inputType === 'select' || element.inputType === 'multiSelect') {
          if (!(element.selectList in this.baseKeyCatMapping)) {
            await this.getEnumCodesByCategoryId(element.selectList)
          }
        }
      }
    },
    async showAddChildModal (ciType) {
      // ciType可以是rootCI，区别是rootCI不会自动填充editRefAttr值，其他类型CI会填充
      let childCiType = this.childCiTypes.find(element => {
        if (element.ciType === ciType) {
          return element
        }
      })
      this.childNodeCiName = this.$t('new') + ': ' + childCiType.name
      this.childNodeCiType = ciType
      let attributes = this.getCiFormAttributes(ciType, true)
      attributes = attributes.map(element => {
        // autofill editRefAttr
        if (element.propertyName === childCiType.editRefAttr) {
          return { ...element, editable: 'no' }
        } else {
          return element
        }
      })
      await this.initChildNodeData(attributes)
      this.childNodeData[childCiType.editRefAttr] = { guid: this.nodeData.guid, key_name: this.nodeData.key_name }
      this.childNodeCiAttrs = []
      let stateItems = await this.getCiTypeStateTransition(ciType)
      let operations = this.getCiTypeOperation(stateItems, 'insert')
      this.childNodeAddOperation = operations[0].value
      this.$nextTick(() => {
        this.childNodeCiAttrs = attributes
      })
      this.showChildNodeModal = true
    },
    async saveChildNode () {
      this.childBtnLoading = true
      let data = normalizeFormData(this.childNodeData)
      let resp = await graphCiDataOperation(this.childNodeCiType, this.childNodeAddOperation, [data])
      if (resp.statusCode === 'OK') {
        this.showChildNodeModal = false
        this.$emit('operationReload', this.childNodeCiType, resp.data, 'add')
      }
      this.childBtnLoading = false
    },
    cancelChildNode () {
      this.childBtnLoading = false
      this.showChildNodeModal = false
    }
  },
  filters: {},
  components: {
    Ref,
    MutiRef,
    SelectFormOperation
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
</style>
