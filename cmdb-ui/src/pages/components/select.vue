<template>
  <div>
    <Select
      v-if="!isGroup"
      :value="value"
      :multiple="isMultiple"
      :disabled="disabled"
      filterable
      clearable
      @on-change="changeValue"
      @on-open-change="getFilterRulesOptions"
    >
      <Option v-for="item in opts" :value="item.value || ''" :key="item.value">{{ item.label }}</Option>
    </Select>
    <Select
      v-else
      :value="value"
      :multiple="isMultiple"
      :disabled="disabled"
      filterable
      clearable
      @on-change="changeValue"
      @on-open-change="getFilterRulesOptions"
      :max-tag-count="maxTags"
    >
      <OptionGroup v-for="(group, index) in opts" :key="index" :label="group.label">
        <Option v-for="item in group.children" :value="item.value || ''" :key="item.value">{{ item.label }}</Option>
      </OptionGroup>
    </Select>
  </div>
</template>
<script>
import { queryReferenceEnumCodes, getEnumCodesByCategoryId } from '@/api/server'
const DEFAULT_TAG_NUMBER = 2
export default {
  name: 'WeCMDBSelect',

  props: {
    value: {},
    isMultiple: { default: () => false },
    isGroup: { default: () => false },
    options: { default: () => [] },
    maxTags: { default: () => DEFAULT_TAG_NUMBER },
    filterParams: {},
    disabled: { default: () => false },
    enumId: { default: () => null }
  },
  data () {
    return {
      filterOpts: [],
      enumOpts: []
    }
  },
  watch: {},
  computed: {
    opts () {
      if (this.filterParams) {
        return this.filterOpts
      } else if (this.enumId) {
        return this.enumOpts
      } else {
        return this.options
      }
    }
  },
  mounted () {
    this.fetchEnumOptions()
  },
  methods: {
    formatOptions () {},
    changeValue (val) {
      this.$emit('input', val || null)
      this.$emit('change', val || null)
    },
    fetchEnumOptions () {
      if (this.enumId) {
        this.getFilterRulesOptions(true)
      }
    },
    async getFilterRulesOptions (val) {
      if (this.options.length > 1) {
        this.filterOpts = this.options
        return
      }

      if (val && this.filterParams) {
        const rows = JSON.parse(JSON.stringify(this.filterParams.params))
        delete rows.isRowEditable
        delete rows.weTableForm
        delete rows.weTableRowId
        delete rows.isNewAddedRow
        delete rows.nextOperations
        const payload = {
          attrId: this.filterParams.attrId,
          params: {
            dialect: {
              data: rows
            }
          }
        }
        const { data, statusCode } = await queryReferenceEnumCodes(payload)
        if (statusCode === 'OK') {
          this.filterOpts = data.map(i => {
            return {
              label: i.label,
              value: i.value
            }
          })
        }
      }
      if (val && !this.filterParams && this.enumId) {
        const { data } = await getEnumCodesByCategoryId(this.enumId)
        this.enumOpts = data
          .filter(j => j.status === 'active')
          .map(i => {
            return {
              label: i.value,
              value: i.codeId
            }
          })
      }
    }
  }
}
</script>
