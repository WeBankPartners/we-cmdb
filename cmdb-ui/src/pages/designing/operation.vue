<template>
  <div class="">
    <h4>当前节点：</h4>
    <Collapse v-model="parentPanal" class="parentCollapse" accordion>
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
                  :panalForm="parentPanalForm"
                  :disabled="!isEdit || !formData.isEditable"
                ></Ref>
              </FormItem>
              <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
                <MutiRef
                  :formData="formData"
                  :panalData="parentPanalData.data"
                  :panalForm="parentPanalForm"
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
        <Button @click="editOperation" size="small" type="error" style="float: right;margin:6px;">删除</Button>
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
                <Ref
                  :formData="formData"
                  :panalData="panal.data"
                  :panalForm="panalForm"
                  :disabled="!isEdit || !formData.isEditable"
                ></Ref>
              </FormItem>
              <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
                <MutiRef
                  :formData="formData"
                  :panalData="panal.data"
                  :panalForm="panalForm"
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
                <Button type="primary" @click="saveOperation('panalData')" :disabled="!isEdit" class="opetation-btn"
                  >保存</Button
                >
              </div>
            </FormItem>
          </Form>
        </div>
      </Panel>
    </Collapse>
  </div>
</template>

<script>
import { getCiTypeAttributes, updateCiDatas } from '@/api/server'
import Ref from './ref'
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

      isEdit: false
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
    editOperation () {
      this.isEdit = true
    },
    // 保存数据
    async saveOperation (dataSource) {
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
      const { statusCode } = await updateCiDatas(params)
      if (statusCode === 'OK') {
        this.$Message.success('Success!')
        // this.$emit('redrawGraph')
      }
    },
    managementData (operateData) {
      // this.parentPanal = ''
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
    openPanal (panalId) {
      this.isEdit = false
      if (panalId.length) {
        const ciTypeId = this.panalData[Number(panalId[0] - 1)].ciTypeId
        this.getAttributes(ciTypeId, 'panalForm')
      }
    },
    async getAttributes (ciTypeId, formObject) {
      const { statusCode, data } = await getCiTypeAttributes(ciTypeId)
      if (statusCode === 'OK') {
        this[formObject] = data
        console.log(this[formObject])
        console.log(data)
      }
    }
  },
  components: {
    Ref,
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
</style>
