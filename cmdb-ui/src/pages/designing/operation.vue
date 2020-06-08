<template>
  <div class="">
    <!-- <div
      @click="test($event)"
      style="float: right;margin:6px;"
      >abc</div
    > -->
    <h4>当前节点：</h4>
    <Collapse v-model="parentPanal" class="parentCollapse" accordion @on-change="openParentPanal">
      <Panel name="1">
        {{ parentPanalData.data.code }}
        <div slot="content">
          <Form>
            <div
              v-for="(formData, formDataIndex) in parentPanalForm"
              v-if="formData.isDisplayed"
              :key="formDataIndex + 'a'"
            >
              <Tooltip :content="formData.description" :delay="500" placement="top-end" style="position: absolute;">
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
                <Button @click="editOperation">编辑</Button>
                <Button
                  type="primary"
                  @click="saveOperation('parentPanalData')"
                  :disabled="!isEdit"
                  class="opetation-btn"
                  >保存</Button
                >
              </div>
            </FormItem>
          </Form>
        </div>
      </Panel>
    </Collapse>
    <h4>子节点：</h4>
    <Collapse v-model="defaultPanal" accordion @on-change="openPanal">
      <Panel :name="panalIndex + 1 + ''" v-for="(panal, panalIndex) in panalData" :key="panalIndex">
        {{ panal.data.code }}
        <Button
          @click="deleteNode(panalData, panalIndex, $event)"
          size="small"
          type="error"
          style="float: right;margin:6px;"
          >删除</Button
        >
        <Button @click="editOperation" size="small" type="primary" style="float: right;margin:6px;">确认</Button>
        <div slot="content">
          <Form v-if="defaultPanal[0] === panalIndex + 1 + ''">
            <div v-for="(formData, formDataIndex) in panalForm" v-if="formData.isDisplayed" :key="formDataIndex + 'b'">
              <Tooltip :content="formData.description" :delay="500" placement="top-end" style="position: absolute;">
                <span class="form-item-title"> {{ formData.name }}</span>
              </Tooltip>
              <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
                <Input v-model="panal.data[formData.propertyName]" :disabled="!isEdit || !formData.isEditable"></Input>
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
                <Button @click="editOperation">编辑</Button>
                <Button
                  type="primary"
                  @click="saveOperation('panalData', panalIndex)"
                  :disabled="!isEdit"
                  class="opetation-btn"
                  >保存</Button
                >
              </div>
            </FormItem>
          </Form>
        </div>
      </Panel>
      <div style="margin: 12px;">
        <Button @click="showAddNodeArea = true" size="small" long type="info">新增节点</Button>
      </div>
    </Collapse>
    <div v-if="showAddNodeArea" class="add-node-area">
      <Select v-model="selectedType" @on-change="getNewNodeAttr" @on-open-change="getNodeTypes">
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
          <Tooltip :content="formData.description" :delay="500" placement="top-end" style="position: absolute;">
            <span class="form-item-title"> {{ formData.name }}</span>
          </Tooltip>
          <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
            <Input v-model="newNodeFormData[formData.propertyName]"></Input>
          </FormItem>
          <FormItem v-if="formData.inputType === 'textArea'" class="form-item-content">
            <textarea v-model="newNodeFormData[formData.propertyName]" class="textArea-style"></textarea>
          </FormItem>
          <FormItem v-if="formData.inputType === 'ref'" class="form-item-content">
            <Ref :formData="formData" :panalData="newNodeFormData" :disabled="false"></Ref>
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
            <Button type="primary" @click="createNode">创建节点</Button>
            <Button @click="cancleAddNode" class="opetation-btn">取消</Button>
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
  queryCiData
} from '@/api/server'
import Ref from './ref'
import RefAdd from './ref-add'
import MutiRef from './muti-ref'
export default {
  name: '',
  data () {
    return {
      parentPanal: '',
      parentPanalData: { data: { code: '' } },
      parentPanalForm: [],

      defaultPanal: '',
      operateData: null, // 选中数据集合
      panalData: [], // 格式化后panal数据
      panalForm: [], // panal表单信息

      isEdit: false,

      showAddNodeArea: false, // 新增节点区域
      selectedType: null,
      canCreateNodeTypes: [], // 可创建节点类型列表
      newNodeFormData: {}, // 待创建节点表单
      newNodeForm: [], // 待创建节点表单
      showNewNodeForm: false // 新增表单
    }
  },
  watch: {
    // parentPanal: function (val) {
    //   console.log(val)
    //   this.isEdit = false
    //   if (val.length) {
    //     const ciTypeId = this.parentPanalForm[0].ciTypeId
    //     this.getAttributes(ciTypeId, 'parentPanalForm')
    //   }
    // }
  },
  mounted () {},
  methods: {
    test (event) {
      event.stopPropagation()
      console.log(this.operateData.text)
      this.$emit('operationReload', 111)
    },
    async deleteNode (panalData, panalIndex, event) {
      event.stopPropagation()
      let params = {
        id: panalData[panalIndex].ciTypeId,
        deleteData: [panalData[panalIndex].data.guid]
      }
      const { statusCode } = await deleteCiDatas(params)
      if (statusCode === 'OK') {
        this.$Message.success('success!')
        this.panalData.splice(panalIndex, 1)
        this.operateData.children = this.panalData
        console.log(this.operateData)
        this.$emit('operationReload', this.operateData)
      }
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
        id: this.selectedType,
        createData: [tmpPanalData]
      }
      const { statusCode, data } = await createCiDatas(params)
      if (statusCode === 'OK') {
        this.$Message.success('Success!')
        this.showAddNodeArea = false

        const ciData = await queryCiData({
          id: this.selectedType,
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
          ciTypeId: this.selectedType,
          data: ciData.data.contents[0].data,
          text: [ciData.data.contents[0].data.code]
        }
        // text: [ciData.data.contents[0].data.code, ciData.data.contents[0].data.network_segment_design.code]
        this.panalData.push(params)
        this.operateData.children = this.panalData
        this.$emit('operationReload', this.operateData)
        this.selectedType = null
        this.newNodeFormData = {} // 待创建节点表单
        this.newNodeForm = [] // 待创建节点表单
      }
    },
    cancleAddNode () {
      this.isEdit = false
      this.showAddNodeArea = false
      this.selectedType = null
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
        if (dataSource === 'parentPanalData') {
          this.operateData.data = data[0]
        }
        console.log(data)
        if (dataSource === 'panalData') {
          console.log(index)
          this.operateData.children[index].data = data[0]
        }
        console.log(this.operateData)
        this.isEdit = false
        this.$emit('operationReload', this.operateData)
        // this.$emit('redrawGraph')
      }
    },
    managementData (operateData) {
      this.parentPanal = ''
      this.defaultPanal = ''
      this.panalData = []
      this.operateData = operateData
      let tmp = JSON.parse(JSON.stringify(this.operateData))
      this.getAttributes(tmp.ciTypeId, 'parentPanalForm')
      delete tmp.children
      this.parentPanalData = tmp
      if (this.operateData.children) {
        this.panalData.push(...this.operateData.children)
      }
    },
    async getNodeTypes (isOpen) {
      this.canCreateNodeTypes = []
      if (!isOpen) return
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
    async getNewNodeAttr () {
      if (!this.selectedType) {
        return
      }
      this.showNewNodeForm = false
      this.newNodeFormData = {}
      await this.getAttributes(this.selectedType, 'newNodeForm')
      this.newNodeForm.forEach(_ => {
        if (_.inputType === 'ref') {
          this.newNodeFormData[_.propertyName] = { guid: '11' }
        } else if (_.inputType === 'multiRef') {
          this.newNodeFormData[_.propertyName] = []
        } else {
          this.newNodeFormData[_.propertyName] = ''
        }
      })
      this.showNewNodeForm = true
    },
    openParentPanal () {
      this.defaultPanal = ''
      this.$emit('markZone', this.parentPanalData.guid)
    },
    openPanal (panalId) {
      this.parentPanal = ''
      this.isEdit = false
      if (panalId.length) {
        this.$emit('markZone', this.panalData[Number(panalId[0] - 1)].guid)
        const ciTypeId = this.panalData[Number(panalId[0] - 1)].ciTypeId
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
  components: {
    Ref,
    RefAdd,
    MutiRef
  }
}
</script>

<style scoped lang="scss">
.ivu-form-item {
  margin-bottom: 8px;
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
  margin-bottom: 20px;
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
</style>
