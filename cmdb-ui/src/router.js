import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)
export default new Router({
  routes: [
    {
      path: '/',
      name: 'IndexPage',
      redirect: '/homepage',
      component: () => import('@/pages/index'),
      children: [
        {
          path: '/homepage',
          name: 'homepage',
          component: () => import('@/pages/home-page'),
          params: {},
          props: true
        },
        {
          path: '/404',
          name: '404',
          component: () => import('@/pages/404'),
          params: {},
          props: true
        },
        {
          path: '/coming-soon',
          name: 'comingsoon',
          component: () => import('@/pages/coming-soon'),
          params: {},
          props: true
        },
        {
          path: '/setting/change-password',
          name: 'changePassword',
          component: () => import('@/pages/change-password')
        },
        {
          path: '/wecmdb/admin/permission-management',
          name: 'permissions',
          component: () => import('@/pages/admin/permission-management')
        },
        {
          path: '/wecmdb/admin/cmdb-model-management',
          name: 'ciDesign',
          component: () => import('@/pages/admin/cmdb-model-management')
        },
        {
          path: '/wecmdb/admin/base-data-management',
          name: 'baseData',
          component: () => import('@/pages/admin/enums')
        },
        {
          path: '/wecmdb/designing/enum-management',
          name: 'enumManage',
          component: () => import('@/pages/admin/enums')
        },
        {
          path: '/wecmdb/designing/enum-enquiry',
          name: 'enumEnquiry',
          component: () => import('@/pages/admin/enums')
        },
        {
          path: '/wecmdb/designing/ci-data-management',
          name: 'ciDataManage',
          component: () => import('@/pages/designing/ci-data')
        },
        {
          path: '/wecmdb/designing/ci-data-enquiry',
          name: 'ciDataEnquiry',
          component: () => import('@/pages/designing/ci-data')
        },
        {
          path: '/wecmdb/designing/ci-integrated-query-execution',
          name: 'integrateQuery',
          component: () => import('@/pages/designing/ci-integrated-query-execution')
        },
        {
          path: '/wecmdb/designing/ci-integrated-query-management',
          name: 'integrateQueryMgmt',
          component: () => import('@/pages/designing/ci-integrated-query-management')
        },
        {
          path: '/wecmdb/admin/log-enquiry',
          name: 'logEnQuiry',
          component: () => import('@/pages/admin/log-enquiry')
        },
        {
          path: '/wecmdb/admin/user-password-management',
          name: 'resetPassword',
          component: () => import('@/pages/admin/resetPassword')
        },
        // 视图查询
        {
          path: '/wecmdb/view-query/idc-planning-query',
          name: 'idcPlanningQuery',
          component: () => import('@/pages/coming-soon')
        },
        {
          path: '/wecmdb/view-query/idc-resource-planning-query',
          name: 'idcResourcePlanningQuery',
          component: () => import('@/pages/coming-soon')
        },
        {
          path: '/wecmdb/view-query/application-architecture-query',
          name: 'applicationArchitectureQuery',
          component: () => import('@/pages/coming-soon')
        },
        {
          path: '/wecmdb/view-query/application-deployment-query',
          name: 'applicationDeploymentQuery',
          component: () => import('@/pages/coming-soon')
        },
        // 视图管理
        {
          path: '/wecmdb/view-management/idc-planning-design',
          name: 'idcPlanningDesign',
          component: () => import('@/pages/designing/planning')
        },
        {
          path: '/wecmdb/view-management/idc-resource-planning',
          name: 'idcResourcePlanning',
          component: () => import('@/pages/designing/resource-planning')
        },
        {
          path: '/wecmdb/view-management/application-architecture-design',
          name: 'applicationArchitectureDesign',
          component: () => import('@/pages/designing/application-architecture')
        },
        {
          path: '/wecmdb/view-management/application-architecture-query',
          name: 'applicationArchitectureQuery',
          component: () => import('@/pages/designing/application-architecture-query')
        },
        {
          path: '/wecmdb/view-management/application-deployment-design',
          name: 'applicationDeploymentDesign',
          component: () => import('@/pages/designing/application-deployment')
        }
      ]
    }
  ]
})
