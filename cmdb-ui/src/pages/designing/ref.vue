<template>
  <div>
    {{ panalData[formData.propertyName].guid }}
    <Select v-model="panalData[formData.propertyName].guid" @on-open-change="openOptions">
      <Option v-for="item in options" :value="item.value" :key="item.value">{{ item.label }}</Option>
    </Select>
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
  props: ['formData', 'panalData', 'panalForm'],
  mounted () {
    this.openOptions(true)
  },
  methods: {
    async openOptions (val) {
      if (val) {
        console.log(this.panalForm)
        // // 取panalData
        if (this.formData.filterRule) {
          // console.log(this.formData.filterRule)
          console.log(this.panalData)
          // const keys = Object.keys(this.panalData)
          let params = JSON.parse(JSON.stringify(this.panalData))
          for (let key in this.panalData) {
            // console.log(key, this.panalData[key])
            if (this.panalData[key] && typeof this.panalData[key] === 'object') {
              const xx = this.panalForm.find(_ => {
                console.log(_.propertyName, key)
                return _.propertyName === key
              })
              if (xx) {
                if (xx.inputType === 'ref') {
                  params[key] = this.panalData[key].guid
                }
                if (xx.inputType === 'select') {
                  params[key] = this.panalData[key].codeId
                }
              }
            }
          }
          console.log(params)
          // console.log(this.formData)
          // let dialect = {
          //   data:
          // }
          const { statusCode, data } = await queryReferenceCiData({
            attrId: this.formData.ciTypeAttrId,
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
    }
  }
}
</script>
<style scoped lang="scss"></style>
