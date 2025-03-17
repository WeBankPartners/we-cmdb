<template>
  <div>
    <Form>
      <div v-for="(formData, formDataIndex) in ciAttrs" :key="formDataIndex" style="display: inline-block;width: 45%">
        <Tooltip :delay="500" placement="left-start">
          <span class="form-item-title">
            {{ formData.name }}
          </span>
          <div slot="content" style="white-space: normal;">
            {{ formData.description }}
          </div>
        </Tooltip>
        <FormItem v-if="formData.inputType === 'text'" class="form-item-content">
          <Input v-model="ciData[formData.propertyName]" disabled></Input>
        </FormItem>
        <FormItem v-if="formData.inputType === 'longText'" class="form-item-content">
          <textarea v-model="ciData[formData.propertyName]" disabled class="textArea-style"></textarea>
        </FormItem>
        <FormItem v-if="formData.inputType === 'datetime'" class="form-item-content">
          <DatePicker
            @on-change="val => setDateTime(val, 'ciData', formData.propertyName)"
            disabled
            type="datetime"
            placeholder="Select date"
          ></DatePicker>
        </FormItem>
        <FormItem v-if="formData.inputType === 'ref'" class="form-item-content">
          <Ref :formData="formData" :panalData="ciData" disabled></Ref>
        </FormItem>
        <FormItem v-if="formData.inputType === 'multiRef'" class="form-item-content">
          <MutiRef :formData="formData" :panalData="ciData" disabled></MutiRef>
        </FormItem>
        <FormItem v-if="formData.inputType === 'password'" class="form-item-content">
          <WeCMDBCIPassword :formData="formData" :panalData="ciData" disabled></WeCMDBCIPassword>
        </FormItem>
        <FormItem v-if="formData.inputType === 'select'" class="form-item-content">
          <template v-if="typeof ciData[formData.propertyName] !== 'string' || ciData[formData.propertyName] === null">
            <Select v-model="ciData[formData.propertyName].guid" filterable clearable disabled>
              <Option v-for="choice in ciData[formData.propertyName]" :value="choice.code" :key="choice.code">{{
                choice.value
              }}</Option>
            </Select>
          </template>
          <template v-else>
            <Input v-model="ciData[formData.propertyName]" disabled></Input>
          </template>
        </FormItem>
        <FormItem v-if="formData.inputType === 'multiSelect'" class="form-item-content">
          <Select v-model="ciData[formData.propertyName]" filterable clearable multiple disabled>
            <Option
              v-for="choice in getEnumCode(ciData[formData.propertyName], formData.selectList)"
              :value="choice.code"
              :key="choice.code"
              >{{ choice.value }}</Option
            >
          </Select>
        </FormItem>
        <FormItem v-if="formData.inputType === 'object'" class="form-item-content">
          <CMDBJSONConfig
            :inputKey="formData['propertyName']"
            :jsonData="JSON.parse(JSON.stringify(ciData[formData['propertyName']]) || '{}')"
            disabled
            @input="onFormJSONInput"
          ></CMDBJSONConfig>
        </FormItem>
      </div>
    </Form>
  </div>
</template>
<script>
import Ref from './ref'
import MutiRef from './muti-ref'
export default {
  components: {
    Ref,
    MutiRef
  },
  data () {
    return {
      ciAttrs: [],
      ciData: []
    }
  },
  methods: {
    setDateTime (val, obj, key) {
      this[obj][key] = val
    },
    initData (ciAttrs, ciData) {
      this.ciData = ciData[0]
      this.ciAttrs = ciAttrs.map(item => {
        if (['name', 'description'].includes('item.propertyName') || item.propertyName in this.ciData) {
          return item
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.form-item-title {
  width: 180px;
  text-align: right;
  vertical-align: middle;
  float: left;
  font-size: 14px;
  color: #0f1222;
  line-height: 1;
  padding: 10px 12px 10px 0;
  box-sizing: border-box;
  position: absolute;
  margin-top: 6px;
}
.form-item-content {
  margin-bottom: 0px;
  margin-left: 180px;
}
</style>
