<template>
  <div>
    {{ selectedOption }}
    <Select v-model="selectedOption" @on-open-change="openOptions">
      <Option v-for="item in options" :value="item.value" :key="item.value">{{ item.label }}</Option>
    </Select>
  </div>
</template>
<script>
import { queryReferenceCiData, queryCiData } from '@/api/server'
export default {
  data () {
    return {
      options: [],
      selectedOption: ''
    }
  },
  props: ['formData', 'panalData'],
  mounted () {
    // this.openOptions(true)
  },
  methods: {
    async openOptions (val) {
      if (val) {
        console.log(this.formData)
        console.log(this.panalData[this.formData.propertyName].guid)
        // // 取panalData
        console.log(this.panalData)
        // console.log(this.formData.name)
        console.log(this.formData.filterRule)
        if (this.formData.filterRule) {
          console.log(222)
          console.log(this.panalData)
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
        this.selectedOption = this.panalData[this.formData.propertyName].guid
      }
    }
  }
}
</script>
<style scoped lang="scss"></style>
