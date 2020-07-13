<template>
  <div class="operation">
    <div class="diy-tabs">
      <div :class="['diy-tab', currentTab === 1 ? 'active-tab' : '']" @click="changeTab(1)">
        <span>{{ $t('node_information') }}</span>
      </div>
      <div :class="['diy-tab', currentTab === 2 ? 'active-tab' : '']" @click="changeTab(2)">
        <span>{{ $t('link_information') }}</span>
      </div>
    </div>
    <div v-if="currentTab === 1" class="operation-Collapse">
      <h4>{{ $t('current_node') }}：</h4>
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
                <Tooltip :content="formData.description" :delay="500" placement="left-start">
                  <span class="form-item-title"> {{ formData.name }}</span>
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
      <template v-for="(groupingKey, groupingKeyIndex) in groupingNodeKeys">
        <div :key="groupingKeyIndex + 'a'" class="panal-title">{{ $t('subsidiary_node') }}{{ groupingKey }}：</div>
        <Collapse
          v-model="defaultPanal"
          accordion
          @on-change="openPanal(defaultPanal, groupingKey)"
          :key="groupingKeyIndex + 'b'"
        >
          <Panel :name="panal.guid" v-for="(panal, panalIndex) in groupingNode[groupingKey]" :key="panalIndex">
            <Tooltip :delay="500" placement="top">
              <span>{{ panal.data.key_name | filterCode }}</span>
              <div slot="content" style="white-space: normal;">
                {{ panal.data.key_name }}
              </div>
            </Tooltip>
            <template v-if="panal.data.meta">
              <template v-for="opera in panal.data.meta.nextOperations">
                <Tooltip :content="$t('confirm')" v-if="opera === 'confirm'" :key="opera" style="float:right">
                  <Icon type="md-checkmark" @click="confirm(panal, $event, 'node')" class="operation-icon-confirm" />
                </Tooltip>
                <Tooltip
                  :content="$t('delete')"
                  v-if="opera === 'delete'"
                  :key="opera + panalIndex"
                  style="float:right"
                >
                  <Icon type="md-trash" @click="deleteNode(panal, $event)" class="operation-icon-delete" />
                </Tooltip>
                <Tooltip
                  :content="$t('discard')"
                  v-if="opera === 'discard'"
                  :key="opera + panalIndex"
                  style="float:right"
                >
                  <Icon type="ios-share-alt" @click="discard(panal, $event, 'node')" class="operation-icon-discard" />
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
                  <Tooltip :content="formData.description" :delay="500" placement="left-start">
                    <span class="form-item-title">{{ formData.name }}</span>
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
                  <FormItem v-if="formData.inputType === 'date'" class="form-item-content">
                    <DatePicker
                      v-model="panal.data[formData.propertyName]"
                      :disabled="!isEdit || !formData.isEditable"
                      type="date"
                      placeholder="Select date"
                    ></DatePicker>
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
                    <Button
                      @click="editOperation"
                      :disabled="isEditEnable(panal.data.meta.nextOperations)"
                      type="info"
                      >{{ $t('edit') }}</Button
                    >
                    <Button
                      type="primary"
                      @click="saveOperation('panalData', groupingKey)"
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
      </template>
      <div style="margin: 6px 0;">
        <Button @click="showAddNodeArea = true" size="small" long type="info">{{ $t('add_node') }}</Button>
      </div>
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
                :disabled="formData.referenceId === parentPanalData.ciTypeId"
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
              <Button type="primary" @click="createNode">{{ $t('save') }}</Button>
              <Button @click="cancleAddNode" class="opetation-btn">{{ $t('cancel') }}</Button>
            </div>
          </FormItem>
        </Form>
      </div>
    </div>
    <div v-if="currentTab === 2" class="operation-Collapse">
      <template v-for="(groupingKey, groupingKeyIndex) in groupingLinkKeys">
        <div :key="groupingKeyIndex + 'e'" class="panal-title">{{ groupingKey }}：</div>
        <Collapse
          v-model="linkPanal"
          accordion
          @on-change="openLinkPanal(linkPanal, groupingKey)"
          :key="groupingKeyIndex + 'f'"
        >
          <Panel :name="link.guid" v-for="(link, linkIndex) in groupingLink[groupingKey]" :key="linkIndex">
            <Tooltip :delay="500" placement="top">
              <span>{{ link.key_name | filterCode }}</span>
              <div slot="content" style="white-space: normal;">
                {{ link.key_name }}
              </div>
            </Tooltip>
            <template v-if="link.meta.nextOperations">
              <template v-for="opera in setNextOperations(link.meta.nextOperations)">
                <Tooltip :content="$t('delete')" v-if="opera === 'delete'" :key="opera" style="float:right">
                  <Icon type="md-trash" @click="deleteLink(link, $event)" class="operation-icon-delete" />
                </Tooltip>
                <Tooltip :content="$t('confirm')" v-if="opera === 'confirm'" :key="opera" style="float:right">
                  <Icon type="md-checkmark" @click="confirm(link, $event, 'link')" class="operation-icon-confirm" />
                </Tooltip>
                <Tooltip :content="$t('discard')" v-if="opera === 'discard'" :key="opera" style="float:right">
                  <Icon type="ios-share-alt" @click="discard(link, $event, 'link')" class="operation-icon-discard" />
                </Tooltip>
              </template>
            </template>

            <div slot="content">
              <Form v-if="linkPanal[0] === link.guid">
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
                  <FormItem v-if="formData.inputType === 'date'" class="form-item-content">
                    <DatePicker
                      v-model="link[formData.propertyName]"
                      :disabled="!isEdit || !formData.isEditable"
                      type="date"
                      placeholder="Select date"
                    ></DatePicker>
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
                    <MutiRef
                      :formData="formData"
                      :panalData="link"
                      :disabled="!isEdit || !formData.isEditable"
                    ></MutiRef>
                  </FormItem>
                  <FormItem v-if="formData.inputType === 'password'" class="form-item-content">
                    <Password
                      :isNewAddedRow="false"
                      :formData="formData"
                      :panalData="link"
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
                <FormItem>
                  <div class="opetation-btn-zone">
                    <Button @click="editOperation" type="info">{{ $t('edit') }}</Button>
                    <Button
                      type="primary"
                      @click="saveOperation('linkData', groupingKey)"
                      :disabled="!isEdit || isEditEnable(link.meta.nextOperations)"
                      class="opetation-btn"
                      >{{ $t('save') }}</Button
                    >
                  </div>
                </FormItem>
              </Form>
            </div>
          </Panel>
        </Collapse>
      </template>
      <div style="margin: 6px 0;">
        <Button @click="showAddLineArea = true" size="small" long type="info">{{ $t('add_link') }}</Button>
      </div>
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
            <FormItem v-if="formData.inputType === 'date'" class="form-item-content">
              <DatePicker
                v-model="newLineFormData[formData.propertyName]"
                type="date"
                placeholder="Select date"
              ></DatePicker>
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
            <FormItem v-if="formData.inputType === 'password'" class="form-item-content">
              <Password
                :isNewAddedRow="false"
                :formData="formData"
                :panalData="newLineFormData"
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
import Password from './password'
import MutiRef from './muti-ref'
export default {
  name: '',
  data () {
    return {
      isShow: true,
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
      currentLineId: null,

      groupingNode: {}, // 节点分组数据
      groupingNodeKeys: [], // 节点分组类型

      groupingLink: {}, // 调用分组数据
      groupingLinkKeys: [] // 调用分组类型
    }
  },
  mounted () {
    this.getAllCITypes()
  },
  methods: {
    setNextOperations (nextOperations) {
      return Array.from(new Set(nextOperations))
    },
    isEditEnable (val) {
      if (val && val.includes('update')) {
        return false
      } else {
        return true
      }
    },
    changeTab (tabNum) {
      this.currentTab = tabNum
      this.cancleAddLine()
      this.cancleAddNode()
    },
    async linkManagementData (linkData) {
      this.linkData = linkData
      this.linkData.forEach(link => {
        link.meta.nextOperations = Array.from(new Set(link.meta.nextOperations))
        link.tableName = this.findCiType(Number(link.ciTypeId))
      })
      this.groupingLink = {}
      this.groupingLinkKeys = []
      this.linkData.forEach(link => {
        if (link.tableName in this.groupingLink) {
          this.groupingLink[link.tableName].push(link)
        } else {
          this.groupingLink[link.tableName] = [link]
          this.groupingLinkKeys.push(link.tableName)
        }
      })
    },
    async openLinkPanal (panalId, tableName) {
      this.currentTab = 2
      this.isEdit = false
      if (panalId.length) {
        const ciData = this.groupingLink[tableName].find(item => item.guid === panalId[0])
        const ciTypeId = ciData.ciTypeId
        this.$emit('markEdge', ciData.guid)
        if (!Object.keys(this.lineFromSet).includes(ciTypeId)) {
          await this.getAttributes(ciTypeId, 'linkPanalForm')
          this.lineFromSet[ciTypeId] = this.linkPanalForm
        } else {
          this.linkPanalForm = this.lineFromSet[ciTypeId]
        }
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
        let tmp = null
        if (ciData.statusCode === 'OK') {
          tmp = ciData.data.contents[0].data
          tmp.meta = ciData.data.contents[0].meta
          tmp.ciTypeId = Number(ciTypeId)
        }
        this.$emit('operationReload', '', {
          type: 'add',
          lineInfo: {
            data: tmp
          }
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
          this.$Modal.remove()
        },
        onCancel: () => {}
      })
    },
    async confirm (data, event, type) {
      event.stopPropagation()
      const { statusCode } = await operateCiState(data.ciTypeId + '', data.guid, 'confirm')
      if (statusCode === 'OK') {
        this.$Message.success('success!')
      }
      const ciData = await queryCiData({
        id: data.ciTypeId,
        queryObject: {
          filters: [
            {
              name: 'guid',
              value: data.guid,
              operator: 'eq'
            }
          ]
        }
      })
      let tmp = null
      if (ciData.statusCode === 'OK') {
        tmp = ciData.data.contents[0].data
        tmp.meta = ciData.data.contents[0].meta
        tmp.ciTypeId = Number(data.ciTypeId)
      }
      if (type === 'node') {
        const index = this.getIndex(this.operateData.children, data.guid)
        this.operateData.children[index].data = tmp
        this.$emit('operationReload', this.operateData)
      }
      if (type === 'link') {
        const index = this.getIndex(this.linkData, data.guid)
        this.linkData[index] = tmp
        this.$emit('operationReload', '', {
          type: 'edit',
          lineInfo: {
            data: this.linkData[index]
          }
        })
      }
    },
    async discard (data, event, type) {
      event.stopPropagation()
      const { statusCode } = await operateCiState(data.ciTypeId + '', data.guid, 'discard')
      if (statusCode === 'OK') {
        this.$Message.success('success!')
      }
      const ciData = await queryCiData({
        id: data.ciTypeId,
        queryObject: {
          filters: [
            {
              name: 'guid',
              value: data.guid,
              operator: 'eq'
            }
          ]
        }
      })
      let tmp = null
      if (ciData.statusCode === 'OK') {
        tmp = ciData.data.contents[0].data
        tmp.meta = ciData.data.contents[0].meta
        tmp.ciTypeId = Number(data.ciTypeId)
      }
      if (type === 'node') {
        const index = this.getIndex(this.operateData.children, data.guid)
        this.operateData.children[index].data = tmp
        this.$emit('operationReload', this.operateData)
      }
      if (type === 'link') {
        const index = this.getIndex(this.linkData, data.guid)
        this.linkData[index] = tmp
        this.$emit('operationReload', '', {
          type: 'edit',
          lineInfo: {
            data: this.linkData[index]
          }
        })
      }
    },
    async deleteNode (data, event) {
      event.stopPropagation()
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        loading: true,
        'z-index': 1000000,
        onOk: async () => {
          let params = {
            id: data.ciTypeId,
            deleteData: [data.guid]
          }
          const { statusCode } = await deleteCiDatas(params)
          if (statusCode === 'OK') {
            this.$Message.success('success!')
            const index = this.getIndex(this.operateData.children, data.guid)
            let children = JSON.parse(JSON.stringify(this.operateData.children))
            children.splice(index, 1)
            this.operateData.children = children
            this.$emit('operationReload', this.operateData)
          }
          this.$Modal.remove()
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
        ciData.data.contents[0].data.meta = ciData.data.contents[0].meta
        const params = {
          ciTypeId: this.selectedNodeType,
          guid: ciData.data.contents[0].data.guid,
          data: ciData.data.contents[0].data,
          text: [ciData.data.contents[0].data.code]
        }
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
    async saveOperation (dataSource, tableName) {
      // eslint-disable-next-line no-unused-vars
      let activePanalData = null
      // eslint-disable-next-line no-unused-vars
      let ciTypeId = null
      if (dataSource === 'parentPanalData') {
        activePanalData = this[dataSource].data
        ciTypeId = this.parentPanalForm[0].ciTypeId
      }
      if (dataSource === 'panalData') {
        const activePanal = this.groupingNode[tableName].find(item => item.guid === this.defaultPanal[0])
        activePanalData = activePanal.data
        ciTypeId = activePanal.ciTypeId
      }
      if (dataSource === 'linkData') {
        activePanalData = this.groupingLink[tableName].find(item => item.guid === this.linkPanal[0])
        ciTypeId = activePanalData.ciTypeId
        delete activePanalData.ciTypeId
      }

      let tmpPanalData = JSON.parse(JSON.stringify(activePanalData))
      delete tmpPanalData.ciTypeId
      delete tmpPanalData.tableName
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
        let tmp = null
        if (dataSource === 'parentPanalData') {
          this.operateData.data = data[0]
        }
        if (dataSource === 'panalData') {
          ciData.data.contents[0].meta.nextOperations = Array.from(new Set(ciData.data.contents[0].meta.nextOperations))
          ciData.data.contents[0].data.meta = ciData.data.contents[0].meta
          const index = this.getIndex(this.operateData.children, ciData.data.contents[0].data.guid)
          this.operateData.children[index].data = ciData.data.contents[0].data
          this.$emit('operationReload', this.operateData)
          return
        }
        if (dataSource === 'linkData') {
          tmp = ciData.data.contents[0].data
          tmp.meta = ciData.data.contents[0].meta
          tmp.ciTypeId = Number(ciTypeId)

          const index = this.getIndex(this.linkData, ciData.data.contents[0].data.guid)
          this.linkData[index] = tmp
          this.$emit('operationReload', '', {
            type: 'edit',
            lineInfo: {
              data: this.linkData[index]
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
      this.groupingNode = {}
      this.groupingNodeKeys = []
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
          let attr = await this.getAttr(ciTypeId)
          attr.data.contents.forEach(md => {
            this.operateData.children.forEach(child => {
              if (md.data.code === child.data.code) {
                md.meta.nextOperations = Array.from(new Set(md.meta.nextOperations))
                child.data.meta = md.meta
                child.tableName = this.findCiType(child.ciTypeId)
              }
            })
          })
          this.panalData = []
          this.groupingNode = {}
          this.groupingNodeKeys = []
          this.operateData.children.forEach(child => {
            if (child.tableName in this.groupingNode) {
              this.groupingNode[child.tableName].push(child)
            } else {
              this.groupingNode[child.tableName] = [child]
              this.groupingNodeKeys.push(child.tableName)
            }
          })
          this.panalData.push(...this.operateData.children)
        })
      }
    },
    async getAttr (ciTypeId) {
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
    openPanal (panalId, tableName) {
      this.parentPanal = ''
      this.isEdit = false
      if (panalId.length) {
        const ciData = this.groupingNode[tableName].find(item => item.guid === panalId[0])
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
    findCiType (ciTypeId) {
      for (let key in this.allCITypes) {
        if (this.allCITypes[key].ciTypeId === ciTypeId) {
          return this.allCITypes[key].tableName
        }
      }
    },
    getIndex (dataGroup, guid) {
      const index = dataGroup.findIndex(child => {
        return child.guid === guid
      })
      return index
    }
  },
  filters: {
    filterCode: function (val) {
      if (val) {
        return val.length > 20 ? val.substring(0, 20) + '...' : val
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
  height: calc(100vh - 280px);
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
.operation-icon-discard {
  font-size: 16px;
  border: 1px solid #ff9900;
  color: #ff9900;
  border-radius: 4px;
  width: 24px;
  line-height: 24px;
  margin: 6px;
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
