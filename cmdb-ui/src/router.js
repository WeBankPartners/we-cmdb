import Vue from "vue";
import Router from "vue-router";

Vue.use(Router);
export const pluginRouter = [
  {
    path: "setting/change-password",
    name: "changePassword",
    component: () => import("@/pages/change-password")
  },
  {
    path: "/admin/permission-management",
    name: "permissions",
    component: () => import("@/pages/admin/permission-management")
  },
  {
    path: "/admin/cmdb-model-management",
    name: "ciDesign",
    component: () => import("@/pages/admin/cmdb-model-management")
  },
  {
    path: "/admin/base-data-management",
    name: "baseData",
    component: () => import("@/pages/admin/enums")
  },
  {
    path: "/designing/enum-management",
    name: "enumManage",
    component: () => import("@/pages/admin/enums")
  },
  {
    path: "/designing/enum-enquiry",
    name: "enumEnquiry",
    component: () => import("@/pages/admin/enums")
  },
  {
    path: "/designing/ci-data-management",
    name: "ciDataManage",
    component: () => import("@/pages/designing/ci-data")
  },
  {
    path: "/designing/ci-data-enquiry",
    name: "ciDataEnquiry",
    component: () => import("@/pages/designing/ci-data")
  },
  {
    path: "/designing/ci-integrated-query-execution",
    name: "integrateQuery",
    component: () => import("@/pages/designing/ci-integrated-query-execution")
  },
  {
    path: "/designing/ci-integrated-query-management",
    name: "integrateQueryMgmt",
    component: () => import("@/pages/designing/ci-integrated-query-management")
  },
  {
    path: "/admin/query-log",
    name: "queryLog",
    component: () => import("@/pages/admin/query-log")
  },
  {
    path: "/admin/user-password-management",
    name: "resetPassword",
    component: () => import("@/pages/admin/resetPassword")
  },
  // 视图查询
  {
    path: "/view-query/idc-planning-query",
    name: "idcPlanningQuery",
    component: () => import("@/pages/coming-soon")
  },
  {
    path: "/view-query/idc-resource-planning-query",
    name: "idcResourcePlanningQuery",
    component: () => import("@/pages/coming-soon")
  },
  {
    path: "/view-query/application-architecture-query",
    name: "applicationArchitectureQuery",
    component: () => import("@/pages/coming-soon")
  },
  {
    path: "/view-query/application-deployment-query",
    name: "applicationDeploymentQuery",
    component: () => import("@/pages/coming-soon")
  },
  // 视图管理
  {
    path: "/view-management/idc-planning-design",
    name: "idcPlanningDesign",
    component: () => import("@/pages/designing/planning")
  },
  {
    path: "/view-management/idc-resource-planning",
    name: "idcResourcePlanning",
    component: () => import("@/pages/designing/resource-planning")
  },
  {
    path: "/view-management/application-architecture-design",
    name: "applicationArchitectureDesign",
    component: () => import("@/pages/designing/application-architecture")
  },
  {
    path: "/view-management/application-deployment-design",
    name: "applicationDeploymentDesign",
    component: () => import("@/pages/designing/application-deployment")
  }
];
const appRouter = [
  {
    path: "homepage",
    name: "homepage",
    component: () => import("@/pages/home-page"),
    params: {},
    props: true
  },
  {
    path: "404",
    name: "404",
    component: () => import("@/pages/404"),
    params: {},
    props: true
  },
  {
    path: "coming-soon",
    name: "comingsoon",
    component: () => import("@/pages/coming-soon"),
    params: {},
    props: true
  }
];
export const router = new Router({
  routes: [
    {
      path: "/",
      name: "IndexPage",
      redirect: "/homepage",
      component: () => import("@/pages/index"),
      children: appRouter.concat(pluginRouter)
    }
  ]
});
