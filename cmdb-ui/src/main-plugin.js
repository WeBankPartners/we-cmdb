import 'core-js/stable'
import 'regenerator-runtime/runtime'
import router from './project-config/router-plugin'
import zhCN from './locale/i18n/zh-CN.json'
import enUS from './locale/i18n/en-US.json'
// import 'view-design/dist/styles/iview.css'

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

const implicitRoute = {
  'wecmdb/designing/data-import-detail': {
    childBreadcrumb: {
      'en-US': 'Data Management (Import)',
      'zh-CN': '数据管理(导入)'
    },
    parentBreadcrumb: {
      'en-US': 'Design',
      'zh-CN': '设计'
    }
  }
}

window.addRoutes && window.addRoutes(router, 'cmdb')
window.addImplicitRoute && window.addImplicitRoute(implicitRoute)
window.addRoutersWithoutPermission && window.addRoutersWithoutPermission(router, 'cmdb')

window.component('WeCMDBSelect', WeCMDBSelect)
window.component('WeCMDBRefSelect', WeCMDBRefSelect)
window.component('WeCMDBRadioRroup', WeCMDBRadioRroup)
window.component('CMDBTable', CMDBTable)
window.component('WeCMDBSimpleTable', WeCMDBSimpleTable)
window.component('WeCMDBAttrInput', WeCMDBAttrInput)
window.component('WeCMDBSequenceDiagram', WeCMDBSequenceDiagram)
window.component('WeCMDBOrchestration', WeCMDBOrchestration)
window.component('WeCMDBCIPassword', WeCMDBCIPassword)
window.component('CMDBPermissionFilters', CMDBPermissionFilters)
window.component('CMDBJSONConfig', CMDBJSONConfig)
window.component('JsonViewer', JsonViewer)

window.locale('zh-CN', zhCN)
window.locale('en-US', enUS)


