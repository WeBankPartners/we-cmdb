<template>
  <RadioGroup :value="value" @on-change="changeValue">
    <Radio v-for="item in options" :key="item.label" :label="item.label">{{ item.text }}</Radio>
  </RadioGroup>
</template>

<script>
export default {
  name: 'WeCMDBRadioRroup',
  props: {
    value: {},
    options: { default: () => [] }
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
