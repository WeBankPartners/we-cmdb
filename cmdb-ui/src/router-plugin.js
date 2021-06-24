import ciDesign from '@/pages/admin/cmdb-model-management'
import enums from '@/pages/admin/enums'
import ciData from '@/pages/designing/ci-data'
import integrateQuery from '@/pages/designing/ci-integrated-query-execution'
import integrateQueryMgmt from '@/pages/designing/ci-integrated-query-management'
import logEnQuiry from '@/pages/admin/log-enquiry'
import wecmdbPermissions from '@/pages/admin/plugin-permission-management'
import graphManagement from '@/pages/designing/graph-management'
import graphView from '@/pages/designing/graph-view'

const router = [
  {
    path: '/wecmdb/data-mgmt-view',
    name: 'graph-management',
    component: graphManagement
  },
  {
    path: '/wecmdb/data-query-view',
    name: 'graph-view',
    component: graphView
  },
  {
    path: '/wecmdb/model-configuration',
    name: 'ciDesign',
    component: ciDesign
  },
  {
    path: '/wecmdb/basekey-configuration',
    name: 'baseData',
    component: enums
  },
  {
    path: '/wecmdb/designing/enum-management',
    name: 'enumManage',
    component: enums
  },
  {
    path: '/wecmdb/designing/enum-enquiry',
    name: 'enumEnquiry',
    component: enums
  },
  {
    path: '/wecmdb/data-mgmt-ci',
    name: 'ciDataManage',
    component: ciData
  },
  {
    path: '/wecmdb/data-query-ci',
    name: 'ciDataEnquiry',
    component: ciData
  },
  {
    path: '/wecmdb/data-query-report',
    name: 'integrateQuery',
    component: integrateQuery
  },
  {
    path: '/wecmdb/report-configuration',
    name: 'integrateQueryMgmt',
    component: integrateQueryMgmt
  },
  {
    path: '/wecmdb/system-operation-log',
    name: 'logEnQuiry',
    component: logEnQuiry
  },
  // cmdb权限控制
  {
    path: '/wecmdb/admin/permission-management',
    name: 'wecmdbPermissions',
    component: wecmdbPermissions
  }
]
export default router
