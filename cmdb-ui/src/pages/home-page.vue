<template>
  <div class="home-page">
    <h1>welcome cmdb</h1>
  </div>
</template>

<script>
const imgPath = require("./images/home.png");
export default {
  data() {
    return {
      imgPath
    };
  }
};
</script>

<style lang="scss" scoped>
.home-page {
  align-items: center;
  display: flex;
  font-size: 75px;
  height: calc(100vh - 60px);
  justify-content: center;
}
</style>
