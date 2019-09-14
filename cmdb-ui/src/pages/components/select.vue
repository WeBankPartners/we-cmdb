<template>
  <div>
    <Select
      v-if="!isGroup"
      :value="value"
      :multiple="isMultiple"
      filterable
      clearable
      @on-change="changeValue"
      @on-open-change="getFilterRulesOptions"
    >
      <Option v-for="item in opts" :value="item.value" :key="item.value">{{
        item.label
      }}</Option>
    </Select>
    <Select
      v-else
      :value="value"
      :multiple="isMultiple"
      filterable
      clearable
      @on-change="changeValue"
      @on-open-change="getFilterRulesOptions"
      :max-tag-count="maxTags"
    >
      <OptionGroup
        v-for="(group, index) in opts"
        :key="index"
        :label="group.label"
      >
        <Option
          v-for="item in group.children"
          :value="item.value"
          :key="item.value"
          >{{ item.label }}</Option
        >
      </OptionGroup>
    </Select>
  </div>
</template>
<script>
const DEFAULT_TAG_NUMBER = 2;
import { queryReferenceEnumCodes } from "@/api/server";
export default {
  name: "WeSelect",

  props: {
    value: {},
    isMultiple: { default: () => false },
    isGroup: { default: () => false },
    options: { default: () => [] },
    maxTags: { default: () => DEFAULT_TAG_NUMBER },
    filterParams: {}
  },
  data() {
    return {
      filterOpts: []
    };
  },
  watch: {},
  computed: {
    opts() {
      if (this.filterParams) {
        return this.filterOpts;
      } else {
        return this.options;
      }
    }
  },
  mounted() {},
  methods: {
    formatOptions() {},
    changeValue(val) {
      this.$emit("input", val);
      this.$emit("change", val);
    },
    async getFilterRulesOptions(val) {
      if (val && this.filterParams) {
        const rows = JSON.parse(JSON.stringify(this.filterParams.params));
        delete rows.isRowEditable;
        delete rows.weTableForm;
        delete rows.weTableRowId;
        delete rows.isNewAddedRow;
        delete rows.nextOperations;
        const payload = {
          attrId: this.filterParams.attrId,
          params: {
            dialect: {
              data: rows
            }
          }
        };
        const { data, status, message } = await queryReferenceEnumCodes(
          payload
        );
        if (status === "OK") {
          this.filterOpts = data.contents
            .filter(j => j.status === "active")
            .map(i => {
              return {
                label: i.value,
                value: i.codeId
              };
            });
        }
      }
    }
  }
};
</script>
