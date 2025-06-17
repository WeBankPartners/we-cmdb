<template>
  <div class="title-content">
    <div class="use-underline-title">
      {{ title }}
      <span class="underline"></span>
    </div>
    <Icon
      v-if="isShowContent"
      size="26"
      @click="changeHideStatus"
      type="md-arrow-dropdown"
      style="cursor: pointer"
    />
    <Icon
      v-else
      size="26"
      @click="changeHideStatus"
      type="md-arrow-dropup"
      style="cursor: pointer"
    />
  </div>
</template>

<script>
export default {
  props: {
    title: String
  },
   data () {
    return {
      isShowContent: true
    }
  },
  methods: {
    changeHideStatus() {
      this.isShowContent = !this.isShowContent
      this.$emit('showContentChange', this.isShowContent)
    }
  }
}
</script>

<style lang="scss" scoped>
.title-content {
  display: flex;
  align-items: center;
  .use-underline-title {
    display: inline-block;
    font-size: 16px;
    font-weight: 700;
    margin: 0 10px;
    .underline {
      display: block;
      margin-top: -15px;
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
}
</style>
