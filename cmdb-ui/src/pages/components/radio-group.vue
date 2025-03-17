<template>
  <div class="radio-group-content">
    <div v-if="radioText" class="radio-group-text">{{ this.$t(radioText) }}</div>
    <RadioGroup :value="value" @on-change="changeValue" :type="groupType">
      <Radio v-for="item in options" :key="item.label" :label="item.label">{{ item.text }}</Radio>
    </RadioGroup>
  </div>
</template>

<script>
export default {
  name: 'WeCMDBRadioRroup',
  props: {
    value: {},
    options: { default: () => [] },
    groupType: { default: undefined },
    radioText: { default: '' }
  },
  methods: {
    changeValue (val) {
      this.$emit('input', val || null)
      this.$emit('change', val || null)
    }
  },
  mounted () {
    this.$emit('input', this.value)
  }
}
</script>

<style scoped lang="scss">
.radio-group-content {
  display: flex;
  .radio-group-text {
    margin-right: 10px;
  }
}
</style>
