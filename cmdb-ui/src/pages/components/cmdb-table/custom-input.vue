<template>
  <div style="display: inline-block">
    <Input
      v-bind="allInputInfo"
      @input="onInputChange"
      :style="isSensitive ? 'width: 63%' : 'width: 100%'"
      :disabled="inputDisabled"
    >
    </Input>
    <div v-if="isSensitive" style="float: right; margin-right: 3px; margin-top: 2px">
      <Button
        size="small"
        type="primary"
        :disabled="sensitiveInfo.queryPermission === false"
        ghost
        @click="onPreviewButtonClick"
      >
        <Icon :type="isShowSensitiveValue ? 'md-eye-off' : 'md-eye'" size="16" />
      </Button>
      <Button
        size="small"
        type="primary"
        :disabled="sensitiveInfo.updatePermission === false"
        ghost
        @click="onEditButtonClick"
      >
        <Icon type="ios-build-outline" size="16" />
      </Button>
    </div>
  </div>
</template>
<script>
import { find, isEmpty } from 'lodash'
export default {
  name: '',
  data () {
    return {
      allInputInfo: null,
      isShowSensitiveValue: false,
      itemGuid: '',
      sensitiveInfo: {},
      canEditSensitiveValue: false,
      initInputValue: '', // 开始的 ***
      hasSavedInputValue: '', // 从后端请求的字段
      finalEditInputValue: '' // 基于后端请求的数据，更改后的val, 不是 ***
    }
  },
  computed: {
    isSensitive () {
      return this.allInputInfo.sensitive === 'yes'
    },
    inputDisabled () {
      if (!this.isSensitive) {
        return false
      }
      if (this.canEditSensitiveValue && this.isShowSensitiveValue) {
        return false
      }
      return true
    }
  },
  watch: {
    inputDetail: {
      handler (val) {
        if (val) {
          this.allInputInfo = val.props
          if (this.allInputInfo.value !== this.initInputValue) {
            this.finalEditInputValue = this.allInputInfo.value
          }
          if (this.itemGuid !== val.guid) {
            this.initInputValue = this.allInputInfo.value
            this.itemGuid = val.guid
          }
        }
      },
      immediate: true,
      deep: true
    },
    allSensitiveData: {
      handler (val) {
        if (!isEmpty(val)) {
          this.sensitiveInfo =
            find(val, {
              guid: this.itemGuid,
              ciType: this.allInputInfo.ciTypeId,
              attrName: this.allInputInfo.inputKey
            }) || {}
          this.hasSavedInputValue = this.sensitiveInfo.value
          this.finalEditInputValue = this.hasSavedInputValue
        }
      },
      immediate: true,
      deep: true
    }
  },
  props: ['inputDetail', 'allSensitiveData'],
  methods: {
    onInputChange (e) {
      if (e !== this.initInputValue && this.isSensitive) {
        if (e !== this.hasSavedInputValue) {
          this.sensitiveInfo.hasBeenModified = true
          this.sensitiveInfo.finalEditInputValue = e
        } else {
          this.sensitiveInfo.hasBeenModified = false
        }
      }
      this.$emit('inputChange', e)
    },
    onPreviewButtonClick () {
      this.isShowSensitiveValue = !this.isShowSensitiveValue
      let currentVal = this.initInputValue
      if (this.isShowSensitiveValue) {
        currentVal = this.finalEditInputValue
      } else {
        this.canEditSensitiveValue = false
      }
      this.onInputChange(currentVal)
    },
    onEditButtonClick () {
      this.canEditSensitiveValue = true
      this.isShowSensitiveValue = true
      this.onInputChange(this.finalEditInputValue)
    }
  }
}
</script>

<style scoped lang="scss"></style>
