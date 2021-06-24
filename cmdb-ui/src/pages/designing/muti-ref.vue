<template>
  <div>
    <Select v-model="selected" @on-open-change="openOptions" multiple :disabled="disabled" filterable>
      <Option v-for="item in options" :value="item.value" :key="item.value">{{ item.label }}</Option>
    </Select>
  </div>
</template>
<script>
import { normalizeFormData } from '@/pages/util/format'
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
        const selectedOpts = this.options.filter(_ => {
          if (val.includes(_.value)) {
            return _
          }
        })
        this.panalData[this.formData.propertyName] = selectedOpts.map(el => {
          return { guid: el.value, key_name: el.label }
        })
      } else {
        this.panalData[this.formData.propertyName] = []
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
    this.defaultOptions()
  },
  methods: {
    defaultOptions () {
      if (this.panalData[this.formData.propertyName]) {
        let opts = this.panalData[this.formData.propertyName]
        opts.forEach(opt => {
          this.options = [
            {
              label: opt.key_name,
              value: opt.guid
            }
          ]
        })
      }
    },
    async openOptions (val) {
      if (val) {
        if (this.formData.referenceFilter) {
          let params = normalizeFormData(this.panalData)
          const { statusCode, data } = await queryReferenceCiData({
            attrId: this.formData.ciTypeAttrId,
            queryObject: { filters: [], paging: false, dialect: { associatedData: params } }
          })
          if (statusCode === 'OK') {
            this.options = data.map(_ => {
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
            queryObject: { filters: [], paging: false, dialect: {} }
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
        }
      }
    }
  }
}
</script>
<style scoped lang="scss"></style>
