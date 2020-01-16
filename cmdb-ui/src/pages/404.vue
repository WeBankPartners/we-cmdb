<template>
  <div class="row">
    <h1>
      404
    </h1>
    <hr />
    <h2>
      Page Not Found
    </h2>
    <p>Back to <a href="/wecmdb/">homepage</a></p>
  </div>
</template>

<script>
export default {
  methods: {}
}
</script>

<style lang="scss" scoped>
body {
  background: #fff;
}

.row {
  text-align: center;
  margin: 60px auto;
  animation-duration: 2s;
  animation-name: slideup;
  animation-delay: 1s;
  animation-fill-mode: backwards;
}

h1,
h2,
p {
  text-rendering: optimizeLegibility;
}

h2,
p {
  color: #374140;
}

h1 {
  color: #1e1e20;
  font-size: 120px;
  line-height: 122px;
}

h2 {
  font-size: 30px;
  line-height: 32px;
  margin-bottom: 10px;
}

p {
  font-size: 18px;
  line-height: 20px;
}

hr {
  width: 15%;
  margin: 40px auto;
  border-color: #dc3522;
}
</style>
