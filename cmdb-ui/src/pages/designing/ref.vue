<template>
  <div>
    <div v-if="panalData[formData.propertyName]">
      <Select
        v-model="panalData[formData.propertyName].guid"
        @on-open-change="openOptions"
        @on-clear="clearSelect"
        :disabled="disabled"
        filterable
        clearable
      >
        <Option v-for="item in options" :value="item.value" :key="item.value">{{ item.label }}</Option>
      </Select>
    </div>
  </div>
</template>
<script>
import { queryReferenceCiData, queryCiData } from '@/api/server'
export default {
  data () {
    return {
      options: []
    }
  },
  props: ['formData', 'panalData', 'disabled'],
  created () {
    if (!this.panalData[this.formData.propertyName]) {
      this.panalData[this.formData.propertyName] = {
        guid: ''
      }
    }
  },
  mounted () {
    this.openOptions(true)
  },
  methods: {
    async openOptions (val) {
      if (val) {
        if (this.formData.filterRule) {
          let params = JSON.parse(JSON.stringify(this.panalData))
          for (let key in this.panalData) {
            if (this.panalData[key] && typeof this.panalData[key] === 'object') {
              params[key] = this.panalData[key].codeId || this.panalData[key].guid
            }
          }
          const { statusCode, data } = await queryReferenceCiData({
            attrId: this.formData.ciTypeAttrId,
            queryObject: { filters: [], paging: false, dialect: { associatedData: params } }
          })
          if (statusCode === 'OK') {
            this.options = data.contents.map(_ => {
              return {
                label: _.key_name,
                value: _.guid
              }
            })
          }
          // queryReferenceCiData
        } else {
          // queryCiData
          const { statusCode, data } = await queryCiData({
            id: this.formData.referenceId,
            queryObject: { filters: [], paging: false }
          })
          if (statusCode === 'OK') {
            this.options = data.contents.map(_ => {
              return {
                label: _.data.key_name,
                value: _.data.guid
              }
            })
          }
        }
      }
    },
    clearSelect () {
      this.panalData[this.formData.propertyName].guid = ''
      console.log(this.panalData[this.formData.propertyName])
    }
  }
}
</script>
<style scoped lang="scss"></style>
