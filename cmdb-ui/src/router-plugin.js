import ciDesign from '@/pages/admin/cmdb-model-management'
import enums from '@/pages/admin/enums'
import ciData from '@/pages/designing/ci-data'
import integrateQuery from '@/pages/designing/ci-integrated-query-execution'
import integrateQueryMgmt from '@/pages/designing/ci-integrated-query-management'
import logEnQuiry from '@/pages/admin/log-enquiry'
import idcPlanningDesign from '@/pages/designing/planning'
import idcResourcePlanning from '@/pages/designing/resource-planning'
import applicationArchitectureDesign from '@/pages/designing/application-architecture'
import applicationDeploymentDesign from '@/pages/designing/application-deployment'
import wecmdbPermissions from '@/pages/admin/plugin-permission-management'

const router = [
  {
    path: '/wecmdb/admin/cmdb-model-management',
    name: 'ciDesign',
    component: ciDesign
  },
  {
    path: '/wecmdb/admin/base-data-management',
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
    path: '/wecmdb/designing/ci-data-management',
    name: 'ciDataManage',
    component: ciData
  },
  {
    path: '/wecmdb/designing/ci-data-enquiry',
    name: 'ciDataEnquiry',
    component: ciData
  },
  {
    path: '/wecmdb/designing/ci-integrated-query-execution',
    name: 'integrateQuery',
    component: integrateQuery
  },
  {
    path: '/wecmdb/designing/ci-integrated-query-management',
    name: 'integrateQueryMgmt',
    component: integrateQueryMgmt
  },
  {
    path: '/wecmdb/admin/query-log',
    name: 'logEnQuiry',
    component: logEnQuiry
  },
  // 视图管理
  {
    path: '/wecmdb/view-management/idc-planning-design',
    name: 'idcPlanningDesign',
    component: idcPlanningDesign
  },
  {
    path: '/wecmdb/view-management/idc-resource-planning',
    name: 'idcResourcePlanning',
    component: idcResourcePlanning
  },
  {
    path: '/wecmdb/view-management/application-architecture-design',
    name: 'applicationArchitectureDesign',
    component: applicationArchitectureDesign
  },
  {
    path: '/wecmdb/view-management/application-deployment-design',
    name: 'applicationDeploymentDesign',
    component: applicationDeploymentDesign
  },
  // cmdb权限控制
  {
    path: '/wecmdb/admin/permission-management',
    name: 'wecmdbPermissions',
    component: wecmdbPermissions
  }
]
export default router
