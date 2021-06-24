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
import { normalizeFormData } from '@/pages/util/format'
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
    this.defaultOptions()
  },
  methods: {
    defaultOptions () {
      if (this.panalData[this.formData.propertyName]) {
        let opt = this.panalData[this.formData.propertyName]
        if (opt && opt.guid) {
          this.options = [
            {
              label: opt.key_name,
              value: opt.guid
            }
          ]
        }
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
                label: _.key_name,
                value: _.guid
              }
            })
          }
        }
      }
    },
    clearSelect () {
      this.panalData[this.formData.propertyName].guid = ''
    }
  }
}
</script>

<style scoped lang="scss"></style>
