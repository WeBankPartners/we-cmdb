<!--
 * @Author: wanghao7717 792974788@qq.com
 * @Date: 2024-11-08 16:53:30
 * @LastEditors: wanghao7717 792974788@qq.com
 * @LastEditTime: 2024-11-15 17:22:48
-->
<template>
  <div class="attr-table-header-tooltip">
    <Poptip transfer popper-class="attr-table-header-popper" trigger="hover" word-wrap placement="right" width="600">
      <Icon type="ios-help-circle-outline" />
      <div slot="content">
        <!--描述说明-->
        <div class="item" v-if="attr.description">
          <span class="title">{{ $t('description') }}：</span>
          <span class="content">{{ attr.description }}</span>
        </div>
        <!--正则规则-->
        <div class="item" v-if="attr.regularExpressionRule">
          <span class="title">{{ $t('regular_rule') }}：</span>
          <span class="content">{{ attr.regularExpressionRule }}</span>
        </div>
        <!--填充规则-->
        <div class="item" v-if="attr.autoFillRule">
          <span class="title">{{ $t('auto_fill_rule') }}：</span>
          <AutoFill
            :allCiTypes="allCiTypesWithAttr"
            :rootCiTypeId="attr.ciTypeId"
            :specialDelimiters="specialDelimiters"
            :isReadOnly="true"
            v-model="attr.autoFillRule"
            style="max-width:460px;"
          ></AutoFill>
        </div>
        <!--过滤规则-->
        <div class="item" v-if="attr.referenceFilter && attr.referenceId !== ''">
          <span class="title">{{ $t('filter_rule') }}：</span>
          <FilterRule
            v-model="attr.referenceFilter"
            :allCiTypes="allCiTypesWithAttr"
            :rootCiTypeId="attr.ciTypeId"
            :leftRootCi="
              (allCiTypesFormatByCiTypeId[attr.referenceId] && allCiTypesFormatByCiTypeId[attr.referenceId].ciTypeId) ||
                ''
            "
            :rightRootCi="attr.ciTypeId"
            :banRootCiDelete="true"
            :disabled="true"
            style="max-width:460px;"
          ></FilterRule>
        </div>
      </div>
    </Poptip>
  </div>
</template>

<script>
import AutoFill from './auto-fill.js'
import FilterRule from './filter-rule/index.js'
export default {
  components: {
    AutoFill,
    FilterRule
  },
  props: {
    attr: {
      type: Object,
      default: () => {}
    },
    allCiTypesWithAttr: {
      type: Array,
      default: () => []
    },
    allCiTypesFormatByCiTypeId: {
      type: Object,
      default: () => {}
    }
  },
  data () {
    return {
      specialDelimiters: [
        { code: '&', value: '&' },
        { code: '=', value: '=' }
      ]
    }
  }
}
</script>

<style lang="scss" scoped>
.item {
  display: flex;
  .title {
    display: block;
    width: fit-content;
  }
  .content {
    display: inline-block;
    max-width: 460px;
    word-wrap: break-word;
    white-space: normal;
  }
}
</style>
<style lang="scss">
.attr-table-header-popper .ivu-poptip-body {
  padding: 8px 16px !important;
}
</style>
