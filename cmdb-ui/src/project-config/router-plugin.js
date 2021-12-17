import ciDesign from '@/pages/admin/cmdb-model-management'
import enums from '@/pages/admin/enums'
import ciData from '@/pages/designing/ci-data'
import reportQuery from '@/pages/designing/report-query'
import reportConfiguration from '@/pages/designing/report-configuration'
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
    path: '/wecmdb/enum-management',
    name: 'enumManage',
    component: enums
  },
  {
    path: '/wecmdb/enum-enquiry',
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
    path: '/wecmdb/report-query',
    name: 'reportQuery',
    component: reportQuery
  },
  {
    path: '/wecmdb/report-configuration',
    name: 'reportConfiguration',
    component: reportConfiguration
  },
  {
    path: '/wecmdb/system-operation-log',
    name: 'logEnQuiry',
    component: logEnQuiry
  },
  // cmdb权限控制
  {
    path: '/wecmdb/permission-management',
    name: 'wecmdbPermissions',
    component: wecmdbPermissions
  }
]
export default router
