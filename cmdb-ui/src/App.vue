<template>
  <div id="app">
    <div class="app-content-container">
      <BackTop :height="100" :bottom="100" />
      <router-view :key="$route.path" />
    </div>
  </div>
</template>

<style lang="scss">
#app {
  background: url('./assets/wecmdb-background.png');
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  height: 100%;
  min-width: 1280px;

  .app-content-container {
    height: 100%;
  }
}
#nav {
  padding: 30px;
  a {
    font-weight: bold;
    color: #2c3e50;
    &.router-link-exact-active {
      color: #42b983;
    }
  }
}
.ivu-layout,
.ivu-layout-sider {
  height: 100%;
}
.spin-icon-load {
  animation: ani-demo-spin 1s linear infinite;
}
body {
  height: 100%;
  overflow: auto !important;
}
html {
  height: 100%;
}
.ivu-table-fixed-body {
  height: auto !important;
}
</style>
