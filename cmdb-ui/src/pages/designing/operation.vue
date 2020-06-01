<template>
  <div class="">
    <h4>当前节点：</h4>
    <Collapse class="parentCollapse" accordion>
      <Panel name="1">
        {{ parentPanalData.data.code }}
        <div slot="content">
          <Form>
            <div
              v-for="(formData, formDataIndex) in parentPanalForm"
              v-if="formData.isDisplayed"
              :key="formDataIndex + 'a'"
            >
              <Tooltip :content="formData.description" placement="top-end" style="position: absolute;">
                <span class="form-item-title"> {{ formData.name }}</span>
              </Tooltip>
              <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
                <Input v-model="parentPanalData.data[formData.propertyName]"></Input>
              </FormItem>
              <FormItem v-if="formData.inputType === 'textArea'" class="form-item-content">
                <textarea v-model="parentPanalData.data[formData.propertyName]" class="textArea-style"></textarea>
              </FormItem>
              <FormItem v-if="formData.inputType === 'ref'" class="form-item-content">
                <Ref :formData="formData" :panalData="parentPanalData.data" :parentPanalForm="parentPanalForm"></Ref>
              </FormItem>
              <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
                multiRef
              </FormItem>
              <FormItem v-if="formData.inputType === 'select'" class="form-item-content">
                select
              </FormItem>
              <FormItem v-if="formData.inputType === 'multiSelect'" class="form-item-content">
                multiSelect
              </FormItem>
            </div>
            <FormItem>
              <Button type="primary" @click="saveOperation">保存</Button>
            </FormItem>
          </Form>
        </div>
      </Panel>
    </Collapse>
    <h4>子节点：</h4>
    <Collapse v-model="defaultPanal" accordion @on-change="openPanal">
      <Panel :name="panalIndex + 1 + ''" v-for="(panal, panalIndex) in panalData" :key="panalIndex">
        {{ panal.data.code }}
        <div slot="content">
          <Form v-if="defaultPanal[0] === panalIndex + 1 + ''">
            <div v-for="(formData, formDataIndex) in panalForm" v-if="formData.isDisplayed" :key="formDataIndex + 'b'">
              <Tooltip :content="formData.description" placement="top-end" style="position: absolute;">
                <span class="form-item-title"> {{ formData.name }}</span>
              </Tooltip>
              <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
                <Input v-model="panal.data[formData.propertyName]"></Input>
              </FormItem>
              <FormItem v-if="formData.inputType === 'textArea'" class="form-item-content">
                <textarea v-model="panal.data[formData.propertyName]" class="textArea-style"></textarea>
              </FormItem>
              <FormItem v-if="formData.inputType === 'ref'" class="form-item-content">
                <Ref :formData="formData" :panalData="panal.data" :panalForm="panalForm"></Ref>
              </FormItem>
              <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
                multiRef
              </FormItem>
              <FormItem v-if="formData.inputType === 'select'" class="form-item-content">
                select
              </FormItem>
              <FormItem v-if="formData.inputType === 'multiSelect'" class="form-item-content">
                multiSelect
              </FormItem>
            </div>
            <FormItem>
              <Button type="primary" @click="saveOperation">保存</Button>
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
export default {
  name: '',
  data () {
    return {
      parentPanalData: { data: { code: '' } },
      parentPanalForm: [],
      aa: '',

      defaultPanal: '1',
      operateData: null, // 选中数据集合
      panalData: [], // 格式化后panal数据
      panalForm: [] // panal表单信息
    }
  },
  mounted () {},
  methods: {
    // 保存数据
    async saveOperation () {
      const activePanalData = this.panalData[this.defaultPanal[0] - 1].data
      let tmpPanalData = JSON.parse(JSON.stringify(activePanalData))
      for (let key in activePanalData) {
        if (activePanalData[key] && typeof activePanalData[key] === 'object') {
          tmpPanalData[key] = activePanalData[key].codeId || activePanalData[key].guid
        }
      }
      let params = {
        id: this.panalForm[0].ciTypeId,
        updateData: [tmpPanalData]
      }
      const { statusCode } = await updateCiDatas(params)
      if (statusCode === 'OK') {
        this.$emit('redrawGraph')
      }
    },
    managementData (operateData) {
      this.panalData = []
      this.operateData = operateData
      let tmp = JSON.parse(JSON.stringify(this.operateData))
      this.getAttributes(tmp.ciTypeId, 'parentPanalForm')
      delete tmp.children
      // this.panalData.push(tmp)
      this.parentPanalData = tmp
      if (this.operateData.children) {
        this.panalData.push(...this.operateData.children)
      }
      this.defaultPanal = '1'
    },
    openPanal (panalId) {
      if (panalId.length) {
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
    Ref
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
.form-item-content {
  margin-left: 80px;
}
</style>
