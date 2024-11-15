<template>
  <div class="use-underline-title mb-3">
    {{ title }}
    <span class="underline"></span>
  </div>
</template>

<script>
export default {
  props: {
    title: String
  },
  methods: {}
}
</script>

<style lang="scss" scoped>
.use-underline-title {
  display: inline-block;
  font-size: 16px;
  font-weight: 700;
  margin: 0 10px;
  .underline {
    display: block;
    margin-top: -10px;
    margin-left: -6px;
    width: 100%;
    padding: 0 6px;
    height: 12px;
    border-radius: 12px;
    background-color: #c6eafe;
    -webkit-box-sizing: content-box;
    box-sizing: content-box;
  }
}
</style>
