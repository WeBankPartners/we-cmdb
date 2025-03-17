import 'core-js/stable'
import 'regenerator-runtime/runtime'
import Vue from 'vue'
import App from './App.vue'
import router from './project-config/router'
import ViewUI from 'view-design'

import './styles/index.less'

import VueI18n from 'vue-i18n'
import i18n from './locale/i18n'

import WeCMDBSelect from '../src/pages/components/select.vue'
import WeCMDBRefSelect from './pages/components/ref-select.js'
import WeCMDBRadioRroup from '../src/pages/components/radio-group.vue'
import CMDBTable from '../src/pages/components/cmdb-table/index.js'
import WeCMDBSimpleTable from '../src/pages/components/simple-table.vue'
import WeCMDBAttrInput from '../src/pages/components/attr-input'
import WeCMDBSequenceDiagram from '../src/pages/components/sequence-diagram.vue'
import WeCMDBOrchestration from '../src/pages/components/orchestration.vue'
import WeCMDBCIPassword from '../src/pages/components/ci-password.vue'
import CMDBPermissionFilters from '../src/pages/components/permission-filters'
import CMDBJSONConfig from '../src/pages/components/cmdb-table/json-config.vue'
import JsonViewer from 'vue-json-viewer'

Vue.component('WeCMDBSelect', WeCMDBSelect)
Vue.component('WeCMDBRefSelect', WeCMDBRefSelect)
Vue.component('WeCMDBRadioRroup', WeCMDBRadioRroup)
Vue.component('CMDBTable', CMDBTable)
Vue.component('WeCMDBSimpleTable', WeCMDBSimpleTable)
Vue.component('WeCMDBAttrInput', WeCMDBAttrInput)
Vue.component('WeCMDBSequenceDiagram', WeCMDBSequenceDiagram)
Vue.component('WeCMDBOrchestration', WeCMDBOrchestration)
Vue.component('WeCMDBCIPassword', WeCMDBCIPassword)
Vue.component('CMDBPermissionFilters', CMDBPermissionFilters)
Vue.component('CMDBJSONConfig', CMDBJSONConfig)
Vue.component('JsonViewer', JsonViewer)
Vue.config.productionTip = false

Vue.use(ViewUI, {
  transfer: true,
  size: 'default',
  VueI18n
})

router.beforeEach((to, from, next) => {
  if (window.myMenus) {
    let hasPermission = [].concat(...window.myMenus.map(_ => _.submenus)).find(_ => _.link === to.path)
    if (hasPermission || to.path === '/wecmdb/home' || to.path.startsWith('/setting') || to.path === '/login') {
      /* has permission */
      next()
    } else {
      next()
      /* has no permission */
      // next('/wecmdb/home')
    }
  } else {
    next()
  }
})
const cmdbVm = new Vue({
  router,
  render: h => h(App),
  i18n
})

window.cmdbVm = cmdbVm

cmdbVm.$mount('#app')
