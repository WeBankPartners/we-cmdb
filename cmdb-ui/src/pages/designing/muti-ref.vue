<template>
  <div>
    <Select v-model="selected" @on-open-change="openOptions" multiple :disabled="disabled" filterable>
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
    panalData: function (panalData) {
      let selectedObject = panalData[this.formData.propertyName]
      if (!selectedObject) {
        return
      }
      if (!Array.isArray(selectedObject)) {
        selectedObject = [selectedObject]
      }
      this.selected = selectedObject.map(_ => {
        return _.guid
      })
    },
    selected: function (val) {
      if (val.length) {
        const tmp = this.options.filter(_ => {
          if (val.includes(_.guid || _.data.guid)) {
            return _
          }
        })
        this.panalData[this.formData.propertyName + '_tmp'] = tmp
      } else {
        this.panalData[this.formData.propertyName + '_tmp'] = []
      }
    }
  },
  props: ['formData', 'panalData', 'disabled'],
  mounted () {
    const selectedObject = this.panalData[this.formData.propertyName]
    if (selectedObject) {
      this.selected = selectedObject.map(_ => {
        return _.guid
      })
    }
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
