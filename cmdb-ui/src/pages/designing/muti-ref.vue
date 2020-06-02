<template>
  <div>
    <Select v-model="selected" @on-open-change="openOptions" multiple :disabled="disabled">
      <Option v-for="item in options" :value="item.value" :key="item.value">{{ item.label }}</Option>
    </Select>
  </div>
</template>
<script>
import { queryReferenceCiData, queryCiData } from '@/api/server'
export default {
  data () {
    return {
      selected: [],
      options: []
    }
  },
  watch: {
    selected: function (val) {
      console.log(val)
      if (val.length) {
        const xx = this.options.filter(_ => {
          if (val.includes(_.data.guid)) {
            return _
          }
        })
        console.log(xx)
        this.panalData[this.formData.propertyName + '_tmp'] = xx
      }
    }
  },
  props: ['formData', 'panalData', 'panalForm', 'disabled'],
  mounted () {
    const selectedObject = this.panalData[this.formData.propertyName]
    this.selected = selectedObject.map(_ => {
      return _.guid
    })
    this.openOptions(true)
  },
  methods: {
    async openOptions (val) {
      console.log(val)
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
            queryObject: { filters: [], paging: false, dialect: { data: params } }
          })
          if (statusCode === 'OK') {
            this.options = data.contents.map(_ => {
              return {
                ..._,
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
                ..._,
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
