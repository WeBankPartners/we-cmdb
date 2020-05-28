<template>
  <div class=" ">
    <Collapse v-model="defaultPanal" accordion @on-change="openPanal">
      <Panel :name="panalIndex + 1 + ''" v-for="(panal, panalIndex) in panalData" :key="panalIndex">
        {{ panal.data.code }}{{ panalIndex === 0 ? '(父)' : '(子)' }}
        <div slot="content">
          <Form :label-width="80" v-if="defaultPanal[0] === panalIndex + 1 + ''">
            <template v-for="(formData, formDataIndex) in panalForm">
              <FormItem v-if="formData.inputType === 'text'" :key="formDataIndex" :label="formData.name">
                <Input v-model="panal.data[formData.propertyName]"></Input>
              </FormItem>
              <FormItem v-if="formData.inputType === 'textArea'" :key="formDataIndex" :label="formData.name">
                <textArea v-model="panal.data[formData.propertyName]" class="textArea-style"></textArea>
              </FormItem>
              <FormItem v-if="formData.inputType === 'ref'" :key="formDataIndex" :label="formData.name">
                <Ref :formData="formData" :panalData="panal.data"></Ref>
              </FormItem>
              <FormItem v-if="formData.inputType === 'multiRef'" :key="formDataIndex" :label="formData.name">
                multiRef
              </FormItem>
              <FormItem v-if="formData.inputType === 'select'" :key="formDataIndex" :label="formData.name">
                select
              </FormItem>
              <FormItem v-if="formData.inputType === 'multiSelect'" :key="formDataIndex" :label="formData.name">
                multiSelect
              </FormItem>
            </template>
          </Form>
        </div>
      </Panel>
    </Collapse>
  </div>
</template>

<script>
import { getCiTypeAttributes } from '@/api/server'
import Ref from './ref'
export default {
  name: '',
  data () {
    return {
      defaultPanal: '1',
      operateData: null, // 选中数据集合
      panalData: [], // 格式化后panal数据
      panalForm: [] // panal表单信息
    }
  },
  mounted () {},
  methods: {
    managementData (operateData) {
      this.panalData = []
      this.operateData = operateData
      let tmp = JSON.parse(JSON.stringify(this.operateData))
      this.getAttributes(tmp.ciTypeId)
      delete tmp.children
      this.panalData.push(tmp)
      if (this.operateData.children) {
        this.panalData.push(...this.operateData.children)
      }
      this.defaultPanal = '1'
    },
    openPanal (panalId) {
      console.log(panalId)
      if (panalId.length) {
        const ciTypeId = this.panalData[Number(panalId[0] - 1)].ciTypeId
        this.getAttributes(ciTypeId)
      }
    },
    async getAttributes (ciTypeId) {
      const { statusCode, data } = await getCiTypeAttributes(ciTypeId)
      if (statusCode === 'OK') {
        this.panalForm = data.filter(_ => {
          if (_.isDisplayed) {
            return _
          }
        })
        console.log(this.panalForm)
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
</style>
