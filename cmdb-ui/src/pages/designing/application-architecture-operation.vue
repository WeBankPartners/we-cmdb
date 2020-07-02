<template>
  <div class="operation">
    <!-- <div class="diy-tabs">
      <div :class="['diy-tab', currentTab === 1 ? 'active-tab' : '']" @click="changeTab(1)">
        <span>{{ $t('node_information') }}</span>
      </div>
      <div :class="['diy-tab', currentTab === 2 ? 'active-tab' : '']" @click="changeTab(2)">
        <span>{{ $t('link_information') }}</span>
      </div>
    </div> -->
    <div v-if="currentTab === 1" class="operation-Collapse">
      <h5>{{ $t('current_node') }}：</h5>
      <Collapse v-model="parentPanal" class="parentCollapse" accordion @on-change="openParentPanal">
        <Panel name="1">
          {{ parentPanalData.data.key_name | filterCode }}
          <div slot="content">
            <Form>
              <div
                v-for="(formData, formDataIndex) in parentPanalForm"
                v-if="formData.isDisplayed"
                :key="formDataIndex + 'a'"
              >
                <Tooltip :content="formData.description" :delay="500" placement="left-start">
                  <span class="form-item-title"> {{ formData.name }}</span>
                </Tooltip>
                <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
                  <Input
                    v-model="parentPanalData.data[formData.propertyName]"
                    :disabled="!isEdit || !formData.isEditable"
                  ></Input>
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
                <FormItem v-if="formData.inputType === 'select'" class="form-item-content">
                  select
                </FormItem>
                <FormItem v-if="formData.inputType === 'multiSelect'" class="form-item-content">
                  multiSelect
                </FormItem>
              </div>
              <FormItem>
                <div class="opetation-btn-zone">
                  <Button @click="editOperation" type="info">{{ $t('edit') }}</Button>
                  <Button
                    type="primary"
                    @click="saveOperation('parentPanalData')"
                    :disabled="!isEdit"
                    class="opetation-btn"
                    >{{ $t('save') }}</Button
                  >
                </div>
              </FormItem>
            </Form>
          </div>
        </Panel>
      </Collapse>
      <h5>{{ $t('subsidiary_node') }}：</h5>
      <Collapse v-model="defaultPanal" accordion @on-change="openPanal">
        <Panel :name="panalIndex + 1 + ''" v-for="(panal, panalIndex) in panalData" :key="panalIndex">
          <span style="">
            {{ panal.data.key_name | filterCode }}
          </span>
          <template v-if="panal.meta.nextOperations">
            <template v-for="opera in panal.meta.nextOperations">
              <Tooltip :content="$t('delete')" v-if="opera === 'delete'" :key="opera + panalIndex" style="float:right">
                <Icon
                  type="md-trash"
                  @click="deleteNode(panalData, panalIndex, $event)"
                  class="operation-icon-delete"
                />
              </Tooltip>
              <Tooltip
                :content="$t('discard')"
                v-if="opera === 'discard'"
                :key="opera + panalIndex"
                style="float:right"
              >
                <Icon type="ios-share-alt" @click="discard(panal, $event)" class="operation-icon-discard" />
              </Tooltip>
            </template>
          </template>
          <div slot="content">
            <Form v-if="defaultPanal[0] === panalIndex + 1 + ''">
              <div
                v-for="(formData, formDataIndex) in panalForm"
                v-if="formData.isDisplayed"
                :key="formDataIndex + 'b'"
              >
                <Tooltip :content="formData.description" :delay="500" placement="left-start">
                  <span class="form-item-title"> {{ formData.name }}</span>
                </Tooltip>
                <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
                  <Input
                    v-model="panal.data[formData.propertyName]"
                    :disabled="!isEdit || !formData.isEditable"
                  ></Input>
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
              <FormItem>
                <div class="opetation-btn-zone">
                  <Button @click="editOperation" :disabled="isEditEnable(panal.meta.nextOperations)" type="info">{{
                    $t('edit')
                  }}</Button>
                  <Button
                    type="primary"
                    @click="saveOperation('panalData', panalIndex)"
                    :disabled="!isEdit"
                    class="opetation-btn"
                    >{{ $t('save') }}</Button
                  >
                </div>
              </FormItem>
            </Form>
          </div>
        </Panel>
        <div style="margin: 12px;">
          <Button @click="showAddNodeArea = true" size="small" long type="info">{{ $t('add_node') }}</Button>
        </div>
      </Collapse>
      <div v-if="showAddNodeArea" class="add-node-area">
        <Select v-model="selectedNodeType" @on-change="getNewNodeAttr" @on-open-change="getNodeTypes">
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
            <Tooltip :content="formData.description" :delay="500" placement="left-start">
              <span class="form-item-title"> {{ formData.name }}</span>
            </Tooltip>
            <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
              <Input v-model="newNodeFormData[formData.propertyName]"></Input>
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
            <FormItem v-if="formData.inputType === 'select'" class="form-item-content">
              select
            </FormItem>
            <FormItem v-if="formData.inputType === 'multiSelect'" class="form-item-content">
              multiSelect
            </FormItem>
          </div>
          <FormItem>
            <div class="opetation-btn-zone">
              <Button type="primary" @click="createNode">{{ $t('save') }}</Button>
              <Button @click="cancleAddNode" class="opetation-btn">{{ $t('cancel') }}</Button>
            </div>
          </FormItem>
        </Form>
      </div>
    </div>
    <div v-if="currentTab === 2" class="operation-Collapse">
      <Collapse v-model="linkPanal" accordion @on-change="openLinkPanal">
        <Panel :name="linkIndex + 1 + ''" v-for="(link, linkIndex) in linkData" :key="linkIndex">
          <span style="">
            {{ link.key_name | filterCode }}
          </span>
          <Tooltip :content="$t('delete')" style="float:right">
            <Icon type="md-trash" @click="deleteLink(link, $event)" class="operation-icon-delete" />
          </Tooltip>
          <!-- <Tooltip :content="$t('confirm')" style="float:right">
            <Icon type="md-checkmark" @click="confirm(link, $event)" class="operation-icon-confirm" />
          </Tooltip> -->
          <div slot="content">
            <Form v-if="linkPanal[0] === linkIndex + 1 + ''">
              <div
                v-for="(formData, formDataIndex) in linkPanalForm"
                v-if="formData.isDisplayed"
                :key="formDataIndex + 'b'"
              >
                <Tooltip :content="formData.description" :delay="500" placement="left-start">
                  <span class="form-item-title"> {{ formData.name }}</span>
                </Tooltip>
                <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
                  <Input v-model="link[formData.propertyName]" :disabled="!isEdit || !formData.isEditable"></Input>
                </FormItem>
                <FormItem v-if="formData.inputType === 'textArea'" class="form-item-content">
                  <textarea
                    v-model="link[formData.propertyName]"
                    :disabled="!isEdit || !formData.isEditable"
                    class="textArea-style"
                  ></textarea>
                </FormItem>
                <FormItem v-if="formData.inputType === 'ref'" class="form-item-content">
                  <Ref :formData="formData" :panalData="link" :disabled="!isEdit || !formData.isEditable"></Ref>
                </FormItem>
                <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
                  <MutiRef :formData="formData" :panalData="link" :disabled="!isEdit || !formData.isEditable"></MutiRef>
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
              <FormItem>
                <div class="opetation-btn-zone">
                  <Button @click="editOperation" type="info">{{ $t('edit') }}</Button>
                  <Button
                    type="primary"
                    @click="saveOperation('linkData', linkIndex)"
                    :disabled="!isEdit"
                    class="opetation-btn"
                    >{{ $t('save') }}</Button
                  >
                </div>
              </FormItem>
            </Form>
          </div>
        </Panel>
        <div style="margin: 12px;">
          <Button @click="showAddLineArea = true" size="small" long type="info">新增连线</Button>
        </div>
      </Collapse>
      <div v-if="showAddLineArea" class="add-node-area">
        <Select v-model="selectedLineType" @on-change="getNewLineAttr" @on-open-change="getLineTypes">
          <Option v-for="(item, index) in canCreateLineTypes" :value="item.value" :key="item.value + index">{{
            item.label
          }}</Option>
        </Select>
        <Form v-if="showNewLineForm" class="add-node-area">
          <div
            v-for="(formData, formDataIndex) in newLineForm"
            v-if="formData.isDisplayed && formData.isEditable"
            :key="formDataIndex + 'a'"
          >
            <Tooltip :content="formData.description" :delay="500" placement="left-start">
              <span class="form-item-title"> {{ formData.name }}</span>
            </Tooltip>
            <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
              <Input v-model="newLineFormData[formData.propertyName]"></Input>
            </FormItem>
            <FormItem v-if="formData.inputType === 'textArea'" class="form-item-content">
              <textarea v-model="newLineFormData[formData.propertyName]" class="textArea-style"></textarea>
            </FormItem>
            <FormItem v-if="formData.inputType === 'ref'" class="form-item-content">
              <Ref :formData="formData" :panalData="newLineFormData" :disabled="false"></Ref>
            </FormItem>
            <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
              <MutiRef :formData="formData" :panalData="newLineFormData"></MutiRef>
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
              <Button type="primary" @click="createLine">{{ $t('save') }}</Button>
              <Button @click="cancleAddLine" class="opetation-btn">{{ $t('cancel') }}</Button>
            </div>
          </FormItem>
        </Form>
      </div>
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
  getAllSystemEnumCodes,
  getAllCITypesByLayerWithAttr
} from '@/api/server'
import Ref from './ref'
import RefAdd from './ref-add'
import MutiRef from './muti-ref'
export default {
  name: '',
  data () {
    return {
      graphCiTypeId: '',
      graphTableName: '',
      currentTab: 1,
      initParams: {},
      parentPanal: '',
      parentPanalData: { data: { code: '' } },
      parentPanalForm: [],
      activeTab: 'nodeTab',

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

      linkPanal: '',
      linkData: [],
      linkPanalForm: [], // 连线panal表单信息

      showAddLineArea: false,
      selectedLineType: null,
      canCreateLineTypes: [], // 可创建连线类型
      newLineFormData: {}, // 待创建节点表单
      newLineForm: [], // 待创建节点表单
      showNewLineForm: false, // 新增表单
      lineFromSet: {}, // 缓存line attr

      codeData: [],
      edgeData: [], // 可连接线信息
      allCITypes: {},
      currentLineId: null
    }
  },
  mounted () {
    this.getAllCITypes()
    this.linkPanal = ''
  },
  methods: {
    isEditEnable (val) {
      if (val && val.includes('update')) {
        return false
      } else {
        return true
      }
    },
    changeTab (tabNum) {
      this.defaultPanal = []
      this.linkPanal = []
      this.currentTab = tabNum
      this.cancleAddLine()
      this.cancleAddNode()
    },
    linkManagementData (linkData) {
      this.linkData = linkData
    },
    async openLinkPanal (panalId) {
      this.currentTab = 2
      this.isEdit = false
      if (panalId.length) {
        this.linkPanal = panalId[0]
        this.$emit('markEdge', this.linkData[Number(panalId[0] - 1)].guid)
        const ciTypeId = this.linkData[Number(panalId[0] - 1)].ciTypeId
        // if (!Object.keys(this.lineFromSet).includes(ciTypeId)) {
        await this.getAttributes(ciTypeId, 'linkPanalForm')
        this.lineFromSet[ciTypeId] = this.linkPanalForm
        // } else {
        //   this.linkPanalForm = this.lineFromSet[ciTypeId]
        // }
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
    async getLineTypes (val) {
      if (!val) {
        return
      }
      const ciTypeKeys = Object.keys(this.allCITypes)
      ciTypeKeys.forEach(key => {
        if (this.allCITypes[key].ciTypeId === this.graphCiTypeId) {
          this.graphTableName = this.allCITypes[key].tableName
        }
      })
      this.canCreateLineTypes = []
      let params = {
        filters: [{ name: 'catId', operator: 'in', value: Array.from(new Array(28 + 1).keys()).slice(22) }],
        paging: false
      }
      const { statusCode, data } = await getAllSystemEnumCodes(params)
      if (statusCode === 'OK') {
        const codeData = data.contents
        const codeId = codeData.filter(dd => {
          return dd.code === this.graphTableName
        })[0].codeId
        const edgeData = codeData.filter(dd => {
          if (dd.groupCodeId) {
            return dd.groupCodeId.codeId === codeId && dd.codeDescription === 'edge'
          }
        })
        edgeData.forEach(ed => {
          this.canCreateLineTypes.push({
            label: ed.value,
            value: ed.code
          })
        })
      }
    },
    async getNewLineAttr (val) {
      this.selectedLineType = val
      if (!this.selectedLineType) {
        return
      }
      this.showNewLineForm = false
      this.newLineFormData = {}
      this.newLineForm = this.allCITypes[val].attributes
      this.currentLineId = this.allCITypes[val].ciTypeId
      // await this.getAttributes(this.selectedLineType, 'newLineForm')
      this.newLineForm.forEach(_ => {
        if (_.inputType === 'ref') {
          this.newLineFormData[_.propertyName] = { guid: '11' }
        } else if (_.inputType === 'multiRef') {
          this.newLineFormData[_.propertyName] = []
        } else {
          this.newLineFormData[_.propertyName] = ''
        }
      })
      this.showNewLineForm = true
      this.newLineForm.sort((a, b) => a.searchSeqNo - b.searchSeqNo)
    },
    async createLine () {
      // eslint-disable-next-line no-unused-vars
      let activeLineData = null
      // eslint-disable-next-line no-unused-vars
      let ciTypeId = null
      activeLineData = this.newLineFormData
      let tmpLineData = JSON.parse(JSON.stringify(activeLineData))
      for (let key in activeLineData) {
        if (activeLineData[key] && typeof activeLineData[key] === 'object') {
          // muti类型处理 '_tmp' 为组件添加数据，暂存编辑后数据，有值以此为准
          if (Array.isArray(activeLineData[key]) && !key.endsWith('_tmp')) {
            let tmp = []
            if (activeLineData[key + '_tmp']) {
              tmp = activeLineData[key + '_tmp'].map(_ => {
                return _.data.guid || _.data.codeId
              })
            } else {
              tmp = activeLineData[key].map(_ => {
                return _.data.guid || _.data.codeId
              })
            }
            tmpLineData[key] = tmp
          } else {
            // Object数据处理
            tmpLineData[key] = activeLineData[key].codeId || activeLineData[key].guid
          }
        }
      }
      let params = {
        id: this.currentLineId,
        createData: [tmpLineData]
      }
      const { statusCode, data } = await createCiDatas(params)
      if (statusCode === 'OK') {
        this.$Message.success('Success!')
        this.showAddLineArea = false
        const ciData = await queryCiData({
          id: this.currentLineId,
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
        this.$emit('operationReload', '', {
          type: 'add',
          lineInfo: ciData.data.contents[0]
        })
        this.cancleAddLine()
      }
    },
    cancleAddLine () {
      this.isEdit = false
      this.showAddLineArea = false
      this.showNewLineForm = false
      this.selectedLineType = null
      this.newLineFormData = {}
      this.newLineForm = []
    },
    async deleteLink (linkData, event) {
      event.stopPropagation()
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        loading: true,
        'z-index': 1000000,
        onOk: async () => {
          let params = {
            id: linkData.ciTypeId,
            deleteData: [linkData.guid]
          }
          const { statusCode } = await deleteCiDatas(params)
          if (statusCode === 'OK') {
            this.$Modal.remove()
            this.$Message.success('success!')
            this.$emit('operationReload', '', {
              type: 'remove',
              lineInfo: {
                data: linkData
              }
            })
          }
        },
        onCancel: () => {}
      })
    },
    async confirmNode (panalData, panalIndex, event) {
      event.stopPropagation()
      const nodeInfo = panalData[panalIndex]
      const { statusCode } = await operateCiState(nodeInfo.ciTypeId + '', nodeInfo.guid, 'confirm')
      if (statusCode === 'OK') {
        this.$Message.success('success!')
      }
    },
    async confirm (data, event) {
      event.stopPropagation()
      const { statusCode } = await operateCiState(data.ciTypeId + '', data.guid, 'confirm')
      if (statusCode === 'OK') {
        this.$Message.success('success!')
        this.$emit('operationReload', '', {})
      }
    },
    async discard (data, event) {
      event.stopPropagation()
      const { statusCode } = await operateCiState(data.ciTypeId + '', data.guid, 'discard')
      if (statusCode === 'OK') {
        this.$Message.success('success!')
        this.$emit('operationReload', '', {})
      }
    },
    async deleteNode (panalData, panalIndex, event) {
      event.stopPropagation()
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        loading: true,
        'z-index': 1000000,
        onOk: async () => {
          let params = {
            id: panalData[panalIndex].ciTypeId,
            deleteData: [panalData[panalIndex].data.guid]
          }
          const { statusCode } = await deleteCiDatas(params)
          if (statusCode === 'OK') {
            this.$Modal.remove()
            this.$Message.success('success!')
            this.panalData.splice(panalIndex, 1)
            this.operateData.children = this.panalData
            this.$emit('operationReload', this.operateData)
          }
        },
        onCancel: () => {}
      })
    },
    async createNode () {
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
            tmpPanalData[key] = activePanalData[key].codeId || activePanalData[key].guid
          }
        }
      }
      let params = {
        id: this.selectedNodeType,
        createData: [tmpPanalData]
      }
      const { statusCode, data } = await createCiDatas(params)
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
        const params = {
          ciTypeId: this.selectedNodeType,
          data: ciData.data.contents[0].data,
          text: [ciData.data.contents[0].data.code]
        }
        // text: [ciData.data.contents[0].data.code, ciData.data.contents[0].data.network_segment_design.code]
        this.panalData.push(params)
        this.operateData.children = this.panalData
        this.$emit('operationReload', this.operateData)
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
    async saveOperation (dataSource, index) {
      // eslint-disable-next-line no-unused-vars
      let activePanalData = null
      // eslint-disable-next-line no-unused-vars
      let ciTypeId = null
      if (dataSource === 'parentPanalData') {
        activePanalData = this[dataSource].data
        ciTypeId = this.parentPanalForm[0].ciTypeId
      }
      if (dataSource === 'panalData') {
        activePanalData = this.panalData[this.defaultPanal[0] - 1].data
        ciTypeId = this.panalForm[0].ciTypeId
      }
      if (dataSource === 'linkData') {
        activePanalData = this.linkData[this.linkPanal[0] - 1]
        ciTypeId = activePanalData.ciTypeId
        delete activePanalData.ciTypeId
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
            tmpPanalData[key] = activePanalData[key].codeId || activePanalData[key].guid
          }
        }
      }
      let params = {
        id: ciTypeId,
        updateData: [tmpPanalData]
      }
      const { statusCode, data } = await updateCiDatas(params)
      if (statusCode === 'OK') {
        this.$Message.success('Success!')
        this.isEdit = false
        if (dataSource === 'parentPanalData') {
          this.operateData.data = data[0]
        }
        if (dataSource === 'panalData') {
          this.operateData.children[index].data = data[0]
        }
        if (dataSource === 'linkData') {
          this.linkData[index] = data[0]
          this.linkData[index].ciTypeId = Number(ciTypeId)
          this.$emit('operationReload', '', {
            type: 'edit',
            lineInfo: {
              data: data[0]
            }
          })
          return
        }
        this.$emit('operationReload', this.operateData)
      }
    },
    async managementData (operateData) {
      this.currentTab = 1
      this.parentPanal = ''
      this.defaultPanal = ''
      this.panalData = []
      this.cancleAddNode()
      this.operateData = operateData
      let tmp = JSON.parse(JSON.stringify(this.operateData))
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
              }
            })
          })
          this.panalData = []
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
          this.newNodeFormData[_.propertyName] = { guid: '11' }
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
    openPanal (panalId) {
      this.parentPanal = ''
      this.isEdit = false
      if (panalId.length) {
        this.$emit('markZone', this.panalData[Number(panalId[0] - 1)].guid)
        const ciTypeId = this.panalData[Number(panalId[0] - 1)].ciTypeId
        this.panalForm = []
        this.getAttributes(ciTypeId, 'panalForm')
      }
    },
    async getAttributes (ciTypeId, formObject) {
      const { statusCode, data } = await getCiTypeAttributes(ciTypeId)
      if (statusCode === 'OK') {
        this[formObject] = data
      }
    }
  },
  filters: {
    filterCode: function (val) {
      return val.length > 25 ? val.substring(0, 25) + '...' : val
    }
  },
  components: {
    Ref,
    RefAdd,
    MutiRef
  }
}
</script>

<style scoped lang="scss">
// .operation {
//   overflow: auto;
//   height: calc(100vh - 205px);
// }
.operation-Collapse {
  overflow: auto;
  height: calc(100vh - 320px);
}
.diy-tabs {
  display: flex;
  justify-content: space-around;
  border-bottom: 1px solid #dcdee2;
  flex-grow: 1;
  margin-bottom: 8px;
}
.diy-tab {
  width: 50%;
  text-align: center;
  // padding: 8px 16px;
  cursor: pointer;
}
.active-tab {
  /* width: 50%; */
  color: #2d8cf0;
  border-bottom: 2px solid #2d8cf0;
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

// .operation-icon:hover {
//   color: #57a3f3;
//   border-color: #57a3f3;
// }
</style>
