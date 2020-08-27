<template>
  <div class="operation-Collapse">
    <div class="parent-title">{{ $t('current_node') }}：</div>
    <Collapse v-model="parentPanal" class="parentCollapse" accordion @on-change="openParentPanal">
      <Panel name="1">
        <Tooltip :delay="500" placement="top">
          <span> {{ parentPanalData.data.key_name | filterCode }}</span>
          <div slot="content" style="white-space: normal;">
            {{ parentPanalData.data.key_name }}
          </div>
        </Tooltip>
        <div slot="content">
          <Form>
            <div
              v-for="(formData, formDataIndex) in parentPanalForm"
              v-if="formData.isDisplayed"
              :key="formDataIndex + 'a'"
            >
              <Tooltip :delay="500" placement="left-start">
                <span class="form-item-title">
                  <span v-if="!formData.isNullable" class="require-tag">*</span>
                  {{ formData.name }}
                </span>
                <div slot="content" style="white-space: normal;">
                  {{ formData.description }}
                </div>
              </Tooltip>
              <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
                <Input
                  v-model="parentPanalData.data[formData.propertyName]"
                  :disabled="!isEdit || !formData.isEditable"
                ></Input>
              </FormItem>
              <FormItem v-if="formData.inputType === 'date'" class="form-item-content">
                <DatePicker
                  v-model="parentPanalData.data[formData.propertyName]"
                  :disabled="!isEdit || !formData.isEditable"
                  type="date"
                  placeholder="Select date"
                ></DatePicker>
              </FormItem>
              <FormItem v-if="formData.inputType === 'textArea'" class="form-item-content">
                <textarea
                  v-model="parentPanalData.data[formData.propertyName]"
                  :disabled="!isEdit || !formData.isEditable"
                  class="textArea-style"
                ></textarea>
              </FormItem>
              <FormItem v-if="formData.inputType === 'ref'" class="form-item-content">
                <Ref
                  :formData="formData"
                  :panalData="parentPanalData.data"
                  :disabled="!isEdit || !formData.isEditable"
                ></Ref>
              </FormItem>
              <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
                <MutiRef
                  :formData="formData"
                  :panalData="parentPanalData.data"
                  :disabled="!isEdit || !formData.isEditable"
                ></MutiRef>
              </FormItem>
              <FormItem v-if="formData.inputType === 'password'" class="form-item-content">
                <Password
                  :isNewAddedRow="false"
                  :formData="formData"
                  :panalData="parentPanalData.data"
                  :disabled="!isEdit || !formData.isEditable"
                ></Password>
              </FormItem>
              <FormItem v-if="formData.inputType === 'select'" class="form-item-content">
                select
              </FormItem>
              <FormItem v-if="formData.inputType === 'multiSelect'" class="form-item-content">
                multiSelect
              </FormItem>
            </div>
            <FormItem v-if="hideNextOperations">
              <div class="opetation-btn-zone">
                <Button @click="editOperation" type="info">{{ $t('edit') }}</Button>
                <Button
                  type="primary"
                  @click="saveOperation('parentPanalData')"
                  :disabled="!isEdit"
                  class="opetation-btn"
                  :loading="btnLoading"
                  >{{ $t('save') }}</Button
                >
              </div>
            </FormItem>
          </Form>
        </div>
      </Panel>
    </Collapse>
    <template v-for="(newPanalKey, newPanalKeyIndex) in newPanalDataKeys">
      <div class="subsidiary-title" :key="newPanalKeyIndex + 'a'">{{ $t('subsidiary_node') }}{{ newPanalKey }}：</div>
      <Collapse
        v-model="defaultPanal"
        accordion
        @on-change="openPanal(defaultPanal, newPanalKey)"
        :key="newPanalKeyIndex + 'b'"
      >
        <Panel :name="panal.guid" v-for="(panal, panalIndex) in newPanalData[newPanalKey]" :key="panalIndex">
          <Tooltip :delay="500" placement="top">
            <span>{{ panal.data.key_name | filterCode }}</span>
            <div slot="content" style="white-space: normal;">
              {{ panal.data.key_name }}
            </div>
          </Tooltip>
          <template v-if="panal.meta">
            <template v-for="opera in filterNextoperations(panal.meta.nextOperations)" v-if="hideNextOperations">
              <Tooltip :content="$t('confirm')" v-if="opera === 'confirm'" :key="opera" style="float:right">
                <Icon
                  type="md-checkmark"
                  @click="confirm(newPanalData, newPanalKey, panalIndex, $event)"
                  class="operation-icon-confirm"
                />
              </Tooltip>
              <Tooltip :content="$t('delete')" v-if="opera === 'delete'" :key="opera + panalIndex" style="float:right">
                <Icon
                  type="md-trash"
                  @click="deleteNode(newPanalData, newPanalKey, panalIndex, $event)"
                  class="operation-icon-delete"
                />
              </Tooltip>
              <Tooltip
                :content="$t('discard')"
                v-if="opera === 'discard'"
                :key="opera + panalIndex"
                style="float:right"
              >
                <Icon
                  type="ios-share-alt"
                  @click="discard(newPanalData, newPanalKey, panalIndex, $event)"
                  class="operation-icon-discard"
                />
              </Tooltip>
            </template>
          </template>
          <div slot="content">
            <Form v-if="defaultPanal[0] === panal.guid">
              <div
                v-for="(formData, formDataIndex) in panalForm"
                v-if="formData.isDisplayed"
                :key="formDataIndex + 'b'"
              >
                <Tooltip :delay="500" placement="left-start">
                  <span class="form-item-title">
                    <span v-if="!formData.isNullable" class="require-tag">*</span>
                    {{ formData.name }}
                  </span>
                  <div slot="content" style="white-space: normal;">
                    {{ formData.description }}
                  </div>
                </Tooltip>
                <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
                  <Input
                    v-model="panal.data[formData.propertyName]"
                    :disabled="!isEdit || !formData.isEditable"
                  ></Input>
                </FormItem>
                <FormItem v-if="formData.inputType === 'date'" class="form-item-content">
                  <DatePicker
                    v-model="panal.data[formData.propertyName]"
                    :disabled="!isEdit || !formData.isEditable"
                    type="date"
                    placeholder="Select date"
                  ></DatePicker>
                </FormItem>
                <FormItem v-if="formData.inputType === 'textArea'" class="form-item-content">
                  <textarea
                    v-model="panal.data[formData.propertyName]"
                    :disabled="!isEdit || !formData.isEditable"
                    class="textArea-style"
                  ></textarea>
                </FormItem>
                <FormItem v-if="formData.inputType === 'ref'" class="form-item-content">
                  <Ref :formData="formData" :panalData="panal.data" :disabled="!isEdit || !formData.isEditable"></Ref>
                </FormItem>
                <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
                  <MutiRef
                    :formData="formData"
                    :panalData="panal.data"
                    :disabled="!isEdit || !formData.isEditable"
                  ></MutiRef>
                </FormItem>
                <FormItem v-if="formData.inputType === 'password'" class="form-item-content">
                  <Password
                    :isNewAddedRow="false"
                    :formData="formData"
                    :panalData="panal.data"
                    :disabled="!isEdit || !formData.isEditable"
                  ></Password>
                </FormItem>
                <FormItem
                  v-if="formData.inputType === 'select'"
                  :disabled="!isEdit || !formData.isEditable"
                  class="form-item-content"
                >
                  select
                </FormItem>
                <FormItem
                  v-if="formData.inputType === 'multiSelect'"
                  :disabled="!isEdit || !formData.isEditable"
                  class="form-item-content"
                >
                  multiSelect
                </FormItem>
              </div>
              <FormItem v-if="hideNextOperations">
                <div class="opetation-btn-zone">
                  <Button @click="editOperation" :disabled="isEditEnable(panal.meta.nextOperations)" type="info">{{
                    $t('edit')
                  }}</Button>
                  <Button
                    type="primary"
                    @click="saveOperation('panalData', newPanalKey)"
                    :disabled="!isEdit"
                    class="opetation-btn"
                    :loading="btnLoading"
                    >{{ $t('save') }}</Button
                  >
                </div>
              </FormItem>
            </Form>
          </div>
        </Panel>
      </Collapse>
    </template>
    <div class="add-btn" v-if="hideNextOperations">
      <Button @click="showAddNodeArea = true" size="small" long type="info">{{ $t('add_node') }}</Button>
    </div>
    <div v-if="showAddNodeArea" class="add-node-area">
      <Select
        v-model="selectedNodeType"
        @on-change="getNewNodeAttr"
        @on-open-change="getNodeTypes"
        filterable
        clearable
      >
        <Option v-for="(item, index) in canCreateNodeTypes" :value="item.value" :key="item.value + index">{{
          item.label
        }}</Option>
      </Select>
      <Form v-if="showNewNodeForm" class="add-node-area">
        <div
          v-for="(formData, formDataIndex) in newNodeForm"
          v-if="formData.isDisplayed && formData.isEditable"
          :key="formDataIndex + 'a'"
        >
          <Tooltip :delay="500" placement="left-start">
            <span class="form-item-title">
              <span v-if="!formData.isNullable" class="require-tag">*</span>
              {{ formData.name }}
            </span>
            <div slot="content" style="white-space: normal;">
              {{ formData.description }}
            </div>
          </Tooltip>
          <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
            <Input v-model="newNodeFormData[formData.propertyName]"></Input>
          </FormItem>
          <FormItem v-if="formData.inputType === 'date'" class="form-item-content">
            <DatePicker
              v-model="newNodeFormData[formData.propertyName]"
              type="date"
              placeholder="Select date"
            ></DatePicker>
          </FormItem>
          <FormItem v-if="formData.inputType === 'textArea'" class="form-item-content">
            <textarea v-model="newNodeFormData[formData.propertyName]" class="textArea-style"></textarea>
          </FormItem>
          <FormItem v-if="formData.inputType === 'ref'" class="form-item-content">
            <Ref
              :formData="formData"
              :panalData="newNodeFormData"
              :disabled="formData.referenceType === 29 && formData.referenceId === parentPanalData.ciTypeId"
            ></Ref>
          </FormItem>
          <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
            <MutiRef :formData="formData" :panalData="newNodeFormData"></MutiRef>
          </FormItem>
          <FormItem v-if="formData.inputType === 'password'" class="form-item-content">
            <Password
              :isNewAddedRow="true"
              :formData="formData"
              :panalData="newNodeFormData"
              :disabled="false"
            ></Password>
          </FormItem>
          <FormItem v-if="formData.inputType === 'select'" class="form-item-content">
            select
          </FormItem>
          <FormItem v-if="formData.inputType === 'multiSelect'" class="form-item-content">
            multiSelect
          </FormItem>
        </div>
        <FormItem>
          <div class="opetation-btn-zone">
            <Button type="primary" @click="createNode" :loading="btnLoading">{{ $t('save') }}</Button>
            <Button @click="cancleAddNode" class="opetation-btn">{{ $t('cancel') }}</Button>
          </div>
        </FormItem>
      </Form>
    </div>
  </div>
</template>
<script>
import {
  getCiTypeAttributes,
  updateCiDatas,
  getRefCiTypeFrom,
  createCiDatas,
  deleteCiDatas,
  queryCiData,
  operateCiState,
  getAllCITypesByLayerWithAttr
} from '@/api/server'
import Ref from './ref'
import Password from './password'
import MutiRef from './muti-ref'
export default {
  name: '',
  data () {
    return {
      btnLoading: false,
      graphCiTypeId: '',
      graphTableName: '',
      initParams: {},
      parentPanal: '',
      parentOriginData: null,
      parentPanalData: { data: { code: '' } },
      parentPanalForm: [],

      defaultPanal: '',
      operateData: null, // 选中数据集合
      panalData: [], // 格式化后panal数据
      panalForm: [], // panal表单信息

      isEdit: false,
      nodeFromSet: {}, // 缓存node attr

      showAddNodeArea: false, // 新增节点区域
      selectedNodeType: null,
      canCreateNodeTypes: [], // 可创建节点类型列表
      newNodeFormData: {}, // 待创建节点表单
      newNodeForm: [], // 待创建节点表单
      showNewNodeForm: false, // 新增表单

      allCITypes: {},

      newPanalDataKeys: [],
      newPanalData: null
    }
  },
  props: ['hideNextOperations', 'ignoreOpera'],
  mounted () {
    this.getAllCITypes()
  },
  methods: {
    filterNextoperations (val) {
      const ignoreOpera = new Set(this.ignoreOpera)
      return val.filter(x => !ignoreOpera.has(x))
    },
    isEditEnable (val) {
      if (val && val.includes('update')) {
        return false
      } else {
        return true
      }
    },
    async getAllCITypes () {
      this.allCITypes = {}
      const status = ['notCreated', 'created', 'dirty', 'decommissioned']
      const allCITypesInfo = await getAllCITypesByLayerWithAttr(status)
      if (allCITypesInfo.statusCode === 'OK') {
        allCITypesInfo.data.map(_ => {
          _.ciTypes.forEach(ciType => {
            this.allCITypes[ciType.tableName] = ciType
          })
        })
      }
    },
    async confirm (panalData, tableName, panalIndex, $event) {
      event.stopPropagation()
      const activePanal = panalData[tableName][panalIndex]
      const { statusCode } = await operateCiState(activePanal.ciTypeId + '', activePanal.guid, 'confirm')
      if (statusCode === 'OK') {
        this.$Message.success('success!')
        this.$emit('operationReload', this.operateData.guid, '', '', 'confirm')
      }
    },
    async discard (panalData, tableName, panalIndex, $event) {
      event.stopPropagation()
      const activePanal = panalData[tableName][panalIndex]
      const { statusCode } = await operateCiState(activePanal.ciTypeId + '', activePanal.guid, 'discard')
      if (statusCode === 'OK') {
        this.$Message.success('success!')
      }
      const ciData = await queryCiData({
        id: activePanal.ciTypeId,
        queryObject: {
          filters: [
            {
              name: 'guid',
              value: activePanal.guid,
              operator: 'eq'
            }
          ]
        }
      })
      if (ciData.statusCode === 'OK') {
        const index = this.getIndex(this.operateData.children, activePanal.guid)
        let editNode = {
          children: this.operateData.children[index].children,
          ciTypeId: activePanal.ciTypeId,
          data: ciData.data.contents[0].data,
          guid: ciData.data.contents[0].data.guid,
          imageFileId: this.operateData.children[index].imageFileId,
          parentGuid: this.operateData.children[index].parentGuid
        }
        this.$emit('operationReload', this.operateData.guid, editNode, index, 'edit')
      }
    },
    async deleteNode (panalData, tableName, panalIndex, event) {
      event.stopPropagation()
      const activePanal = panalData[tableName][panalIndex]
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        loading: true,
        'z-index': 1000000,
        onOk: async () => {
          let params = {
            id: activePanal.ciTypeId,
            deleteData: [activePanal.guid]
          }
          const { statusCode } = await deleteCiDatas(params)
          if (statusCode === 'OK') {
            this.$Message.success('success!')
          }
          this.$Modal.remove()
          const ciData = await queryCiData({
            id: activePanal.ciTypeId,
            queryObject: {
              filters: [
                {
                  name: 'guid',
                  value: activePanal.guid,
                  operator: 'eq'
                }
              ]
            }
          })
          if (ciData.statusCode === 'OK') {
            const index = this.getIndex(this.operateData.children, activePanal.guid)
            let editNode = {}
            if (ciData.data.contents.length === 0) {
              this.$emit('operationReload', this.operateData.guid, {}, index, 'deleteNode')
            } else {
              editNode = {
                children: this.operateData.children[index].children,
                ciTypeId: activePanal.ciTypeId,
                data: ciData.data.contents[0].data,
                guid: ciData.data.contents[0].data.guid,
                imageFileId: this.operateData.children[index].imageFileId,
                parentGuid: this.operateData.children[index].parentGuid
              }
              this.$emit('operationReload', this.operateData.guid, editNode, index, 'edit')
            }
          }
        },
        onCancel: () => {}
      })
    },
    async createNode () {
      this.btnLoading = true
      // eslint-disable-next-line no-unused-vars
      let activePanalData = null
      // eslint-disable-next-line no-unused-vars
      let ciTypeId = null
      activePanalData = this.newNodeFormData
      let tmpPanalData = JSON.parse(JSON.stringify(activePanalData))
      for (let key in activePanalData) {
        if (activePanalData[key] && typeof activePanalData[key] === 'object') {
          // muti类型处理 '_tmp' 为组件添加数据，暂存编辑后数据，有值以此为准
          if (Array.isArray(activePanalData[key]) && !key.endsWith('_tmp')) {
            let tmp = []
            if (activePanalData[key + '_tmp']) {
              tmp = activePanalData[key + '_tmp'].map(_ => {
                return _.guid || _.codeId
              })
            } else {
              tmp = activePanalData[key].map(_ => {
                return _.data.guid || _.data.codeId
              })
            }
            tmpPanalData[key] = tmp
          } else {
            // Object数据处理
            tmpPanalData[key] = activePanalData[key].codeId || activePanalData[key].guid || ''
          }
        }
      }
      tmpPanalData = this.clearInvalidParameter(tmpPanalData)
      let params = {
        id: this.selectedNodeType,
        createData: [tmpPanalData]
      }
      const { statusCode, data } = await createCiDatas(params)
      this.btnLoading = false
      if (statusCode === 'OK') {
        this.$Message.success('Success!')
        this.showAddNodeArea = false

        const ciData = await queryCiData({
          id: this.selectedNodeType,
          queryObject: {
            filters: [
              {
                name: 'guid',
                value: data[0].guid,
                operator: 'eq'
              }
            ]
          }
        })
        const addNode = {
          ciTypeId: this.selectedNodeType,
          data: ciData.data.contents[0].data,
          guid: ciData.data.contents[0].data.guid,
          imageFileId: ''
        }
        this.$emit('operationReload', this.operateData.guid, addNode, '', 'addNode')
        this.cancleAddNode()
      }
    },
    cancleAddNode () {
      this.isEdit = false
      this.showAddNodeArea = false
      this.showNewNodeForm = false
      this.selectedNodeType = null
      this.newNodeFormData = {} // 待创建节点表单
      this.newNodeForm = [] // 待创建节点表单
    },
    editOperation () {
      this.isEdit = true
    },
    // 保存数据
    async saveOperation (dataSource, tableName) {
      this.btnLoading = true
      // eslint-disable-next-line no-unused-vars
      let activePanalData = null
      // eslint-disable-next-line no-unused-vars
      let ciTypeId = null
      if (dataSource === 'parentPanalData') {
        activePanalData = this[dataSource].data
        ciTypeId = this.parentPanalForm[0].ciTypeId
      }
      if (dataSource === 'panalData') {
        const activePanal = this.newPanalData[tableName].find(item => item.guid === this.defaultPanal[0])
        activePanalData = activePanal.data

        ciTypeId = activePanal.ciTypeId
      }

      let tmpPanalData = JSON.parse(JSON.stringify(activePanalData))
      for (let key in activePanalData) {
        if (activePanalData[key] && typeof activePanalData[key] === 'object') {
          // muti类型处理 '_tmp' 为组件添加数据，暂存编辑后数据，有值以此为准
          if (Array.isArray(activePanalData[key]) && !key.endsWith('_tmp')) {
            let tmp = []
            if (activePanalData[key + '_tmp']) {
              tmp = activePanalData[key + '_tmp'].map(_ => {
                return _.data.guid || _.data.codeId
              })
            } else {
              tmp = activePanalData[key].map(_ => {
                return _.data.guid || _.data.codeId
              })
            }
            tmpPanalData[key] = tmp
          } else {
            // Object数据处理
            tmpPanalData[key] = activePanalData[key].codeId || activePanalData[key].guid || ''
          }
        }
      }
      tmpPanalData = this.clearInvalidParameter(tmpPanalData)
      let params = {
        id: ciTypeId,
        updateData: [tmpPanalData]
      }
      const { statusCode, data } = await updateCiDatas(params)
      this.btnLoading = false
      if (statusCode === 'OK') {
        this.$Message.success('Success!')
        this.isEdit = false
        const ciData = await queryCiData({
          id: ciTypeId,
          queryObject: {
            filters: [
              {
                name: 'guid',
                value: data[0].guid,
                operator: 'eq'
              }
            ]
          }
        })
        if (dataSource === 'parentPanalData') {
          // let editNode = {
          //   children: this.parentOriginData.children,
          //   ciTypeId: ciTypeId,
          //   data: data[0],
          //   guid: this.parentOriginData.guid,
          //   imageFileId: this.parentOriginData.imageFileId,
          //   parentGuid: this.parentOriginData.parentGuid
          // }
          this.operateData.data = data[0]
          this.$emit('operationReload', this.operateData.guid, this.operateData, '', 'parentNode')
        }
        if (dataSource === 'panalData') {
          const index = this.getIndex(this.operateData.children, ciData.data.contents[0].data.guid)
          let editNode = {
            children: this.operateData.children[index].children,
            ciTypeId: ciTypeId,
            data: ciData.data.contents[0].data,
            guid: ciData.data.contents[0].data.guid,
            imageFileId: this.operateData.children[index].imageFileId,
            parentGuid: this.operateData.children[index].parentGuid
          }
          this.$emit('operationReload', this.operateData.guid, editNode, index, 'edit')
        }
      }
    },
    async managementData (operateData) {
      this.parentPanal = ''
      this.defaultPanal = ''
      this.panalData = []
      this.newPanalDataKeys = []
      this.cancleAddNode()
      this.operateData = operateData
      let tmp = JSON.parse(JSON.stringify(this.operateData))
      this.parentOriginData = JSON.parse(JSON.stringify(this.operateData))
      delete tmp.children
      this.parentPanalData = tmp
      if (this.operateData.children) {
        let cacthCiTypeId = []
        this.operateData.children.forEach(child => {
          cacthCiTypeId.push(child.ciTypeId)
        })
        cacthCiTypeId = Array.from(new Set(cacthCiTypeId))
        await cacthCiTypeId.forEach(async ciTypeId => {
          let xx = await this.test(ciTypeId)
          xx.data.contents.forEach(md => {
            this.operateData.children.forEach(child => {
              if (md.data.code === child.data.code) {
                md.meta.nextOperations = Array.from(new Set(md.meta.nextOperations))
                child.meta = md.meta
                child.tableName = this.findCiType(child)
              }
            })
          })
          this.panalData = []
          this.newPanalData = {}
          this.newPanalDataKeys = []
          this.operateData.children.forEach(child => {
            if (child.tableName in this.newPanalData) {
              this.newPanalData[child.tableName].push(child)
            } else {
              this.newPanalData[child.tableName] = [child]
              this.newPanalDataKeys.push(child.tableName)
            }
          })
          this.panalData.push(...this.operateData.children)
        })
      }
    },
    async test (ciTypeId) {
      const { statusCode, data } = await getCiTypeAttributes(ciTypeId)
      if (statusCode === 'OK') {
        const ss = data.filter(_ => {
          return _.referenceId === this.operateData.ciTypeId
        })
        const query = {
          id: ciTypeId,
          queryObject: {
            dialect: {
              showCiHistory: false
            },
            filters: [
              {
                name: ss[0].propertyName,
                operator: 'eq',
                value: this.operateData.guid
              }
            ]
          }
        }
        const meta = await queryCiData(query)
        if (meta.statusCode === 'OK') {
          return meta
        }
      }
    },
    async getNodeTypes (isOpen) {
      if (!isOpen) return
      this.canCreateNodeTypes = []
      let { statusCode, data } = await getRefCiTypeFrom(this.operateData.ciTypeId)
      if (statusCode === 'OK') {
        data.forEach(p => {
          if (p.referenceType === 29) {
            this.canCreateNodeTypes.push({
              value: p.ciType.ciTypeId,
              label: p.ciType.name
            })
          }
        })
      }
    },
    async getNewNodeAttr (val) {
      if (!this.selectedNodeType) {
        return
      }
      this.showNewNodeForm = false
      this.newNodeFormData = {}
      await this.getAttributes(this.selectedNodeType, 'newNodeForm')
      this.newNodeForm.forEach(_ => {
        if (_.inputType === 'ref') {
          this.newNodeFormData[_.propertyName] = { guid: '' }
        } else if (_.inputType === 'multiRef') {
          this.newNodeFormData[_.propertyName] = []
        } else {
          this.newNodeFormData[_.propertyName] = ''
        }
      })
      const defaultAttr = this.newNodeForm.filter(_ => {
        return _.inputType === 'ref' && _.referenceId === this.parentPanalData.ciTypeId
      })
      this.newNodeFormData[defaultAttr[0].propertyName].guid = this.parentPanalData.data.guid
      this.showNewNodeForm = true
    },
    openParentPanal (val) {
      if (val.length) {
        this.defaultPanal = ''
        this.isEdit = false
        const ciTypeId = this.operateData.ciTypeId
        this.parentPanalForm = []
        this.getAttributes(ciTypeId, 'parentPanalForm')
      }
    },
    openPanal (panalId, tableName) {
      this.parentPanal = ''
      this.isEdit = false
      if (panalId.length) {
        const ciData = this.newPanalData[tableName].find(item => item.guid === panalId[0])
        const ciTypeId = ciData.ciTypeId
        this.panalForm = []
        this.getAttributes(ciTypeId, 'panalForm')
        this.$emit('markZone', ciData.guid)
      }
    },
    async getAttributes (ciTypeId, formObject) {
      const { statusCode, data } = await getCiTypeAttributes(ciTypeId)
      if (statusCode === 'OK') {
        this[formObject] = data
      }
    },
    findCiType (formData) {
      for (let key in this.allCITypes) {
        if (this.allCITypes[key].ciTypeId === formData.ciTypeId) {
          return this.allCITypes[key].tableName
        }
      }
    },
    getIndex (dataGroup, guid) {
      const index = dataGroup.findIndex(child => {
        return child.guid === guid
      })
      return index
    },
    clearInvalidParameter (params) {
      let keys = []
      for (let key in params) {
        if (key.endsWith('_tmp') || ['meta', 'ciTypeId', 'tableName'].includes(key)) {
          keys.push(key)
          delete params[key]
        }
      }
      return params
    }
  },
  filters: {
    filterCode: function (val) {
      if (val) {
        return val.length > 25 ? val.substring(0, 25) + '...' : val
      }
    }
  },
  components: {
    Ref,
    Password,
    MutiRef
  }
}
</script>

<style scoped lang="scss">
.operation-Collapse {
  overflow: auto;
}

.ivu-form-item {
  margin-bottom: 0;
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
.parent-title {
  font-size: 14px;
  font-weight: 500;
}
.subsidiary-title {
  font-size: 13px;
  font-weight: 500;
}
.panal-title {
  font-size: 12px;
  font-weight: 500;
  margin: 6px 0;
}
.parentCollapse {
  background-color: #5cadff;
  margin-bottom: 8px;
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
.form-item-content,
.opetation-btn-zone {
  margin-left: 80px;
}
.opetation-btn {
  margin: 0 16px;
}
.add-node-area {
  margin-top: 8px;
}

.opertaion /deep/ .ivu-tabs-tab {
  width: 100%;
  text-align: center;
}
.opertaion /deep/ .ivu-tabs-ink-bar {
  width: 100% !important;
}

.operation-icon-delete {
  font-size: 16px;
  border: 1px solid #ed4014;
  color: #ed4014;
  border-radius: 4px;
  width: 24px;
  line-height: 24px;
  margin: 6px;
}
.operation-icon-discard {
  font-size: 16px;
  border: 1px solid #ff9900;
  color: #ff9900;
  border-radius: 4px;
  width: 24px;
  line-height: 24px;
  margin: 6px;
}
.operation-icon-confirm {
  font-size: 16px;
  border: 1px solid #57a3f3;
  color: #57a3f3;
  border-radius: 4px;
  width: 24px;
  line-height: 24px;
  margin: 6px;
}
.require-tag {
  color: red;
}
.add-btn {
  margin: 0 auto;
  margin-top: 16px;
  width: 97%;
}
</style>
