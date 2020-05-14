import 'core-js/stable'
import 'regenerator-runtime/runtime'
import Vue from 'vue'
import VueHighlightJS from 'vue-highlight.js'
import 'vue-highlight.js/lib/allLanguages'
import 'highlight.js/styles/default.css'
import App from './App.vue'
import router from './router'
import ViewUI from 'view-design'
import 'view-design/dist/styles/iview.css'
import VueI18n from 'vue-i18n'
import locale from 'view-design/dist/locale/en-US'
import './locale/i18n'

import WeCMDBSelect from '../src/pages/components/select.vue'
import WeCMDBRefSelect from './pages/components/ref-select.js'
import WeCMDBRadioRroup from '../src/pages/components/radio-group.vue'
import WeCMDBTable from '../src/pages/components/table.js'
import CMDBTable from '../src/pages/components/cmdb-table/index.js'
import WeCMDBSimpleTable from '../src/pages/components/simple-table.vue'
import WeCMDBAttrInput from '../src/pages/components/attr-input'
import WeCMDBSequenceDiagram from '../src/pages/components/sequence-diagram.vue'
import WeCMDBOrchestration from '../src/pages/components/orchestration.vue'
import WeCMDBCIPassword from '../src/pages/components/ci-password.vue'
import CMDBPermissionFilters from '../src/pages/components/filters'

Vue.component('WeCMDBSelect', WeCMDBSelect)
Vue.component('WeCMDBRefSelect', WeCMDBRefSelect)
Vue.component('WeCMDBRadioRroup', WeCMDBRadioRroup)
Vue.component('WeCMDBTable', WeCMDBTable)
Vue.component('CMDBTable', CMDBTable)
Vue.component('WeCMDBSimpleTable', WeCMDBSimpleTable)
Vue.component('WeCMDBAttrInput', WeCMDBAttrInput)
Vue.component('WeCMDBSequenceDiagram', WeCMDBSequenceDiagram)
Vue.component('WeCMDBOrchestration', WeCMDBOrchestration)
Vue.component('WeCMDBCIPassword', WeCMDBCIPassword)
Vue.component('CMDBPermissionFilters', CMDBPermissionFilters)
Vue.config.productionTip = false

Vue.use(ViewUI, {
  transfer: true,
  size: 'default',
  VueI18n,
  locale
})

Vue.use(VueHighlightJS)

router.beforeEach((to, from, next) => {
  if (window.myMenus) {
    let hasPermission = [].concat(...window.myMenus.map(_ => _.submenus)).find(_ => _.link === to.path)
    if (hasPermission || to.path === '/homepage' || to.path.startsWith('/setting') || to.path === '/404') {
      /* has permission */
      next()
    } else {
      /* has no permission */
      next('/404')
    }
  } else {
    next()
  }
})
new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
