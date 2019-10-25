import Vue from "vue";
import Router from "vue-router";
import changePassword from "@/pages/change-password";
import permissions from "@/pages/admin/permission-management";
import ciDesign from "@/pages/admin/cmdb-model-management";
import enums from "@/pages/admin/enums";
import ciData from "@/pages/designing/ci-data";
import integrateQuery from "@/pages/designing/ci-integrated-query-execution";
import integrateQueryMgmt from "@/pages/designing/ci-integrated-query-management";
import queryLog from "@/pages/admin/query-log";
import resetPassword from "@/pages/admin/resetPassword";
import idcPlanningQuery from "@/pages/coming-soon";
import idcResourcePlanningQuery from "@/pages/coming-soon";
import applicationArchitectureQuery from "@/pages/coming-soon";
import applicationDeploymentQuery from "@/pages/coming-soon";
import idcPlanningDesign from "@/pages/designing/planning";
import idcResourcePlanning from "@/pages/designing/resource-planning";
import applicationArchitectureDesign from "@/pages/designing/application-architecture";
import applicationDeploymentDesign from "@/pages/designing/application-deployment";

const isPlugin = process.env.PLUGIN === "plugin";

Vue.use(Router);
export const pluginRouter = [
  {
    path: "setting/change-password",
    name: "changePassword",
    component: () =>
      isPlugin ? changePassword : import("@/pages/change-password")
  },
  {
    path: "/admin/permission-management",
    name: "permissions",
    component: () =>
      isPlugin ? permissions : import("@/pages/admin/permission-management")
  },
  {
    path: "/admin/cmdb-model-management",
    name: "ciDesign",
    component: () =>
      isPlugin ? ciDesign : import("@/pages/admin/cmdb-model-management")
  },
  {
    path: "/admin/base-data-management",
    name: "baseData",
    component: () => (isPlugin ? enums : import("@/pages/admin/enums"))
  },
  {
    path: "/designing/enum-management",
    name: "enumManage",
    component: () => (isPlugin ? enums : import("@/pages/admin/enums"))
  },
  {
    path: "/designing/enum-enquiry",
    name: "enumEnquiry",
    component: () => (isPlugin ? enums : import("@/pages/admin/enums"))
  },
  {
    path: "/designing/ci-data-management",
    name: "ciDataManage",
    component: () => (isPlugin ? ciData : import("@/pages/designing/ci-data"))
  },
  {
    path: "/designing/ci-data-enquiry",
    name: "ciDataEnquiry",
    component: () => (isPlugin ? ciData : import("@/pages/designing/ci-data"))
  },
  {
    path: "/designing/ci-integrated-query-execution",
    name: "integrateQuery",
    component: () =>
      isPlugin
        ? integrateQuery
        : import("@/pages/designing/ci-integrated-query-execution")
  },
  {
    path: "/designing/ci-integrated-query-management",
    name: "integrateQueryMgmt",
    component: () =>
      isPlugin
        ? integrateQueryMgmt
        : import("@/pages/designing/ci-integrated-query-management")
  },
  {
    path: "/admin/query-log",
    name: "queryLog",
    component: () => (isPlugin ? queryLog : import("@/pages/admin/query-log"))
  },
  {
    path: "/admin/user-password-management",
    name: "resetPassword",
    component: () =>
      isPlugin ? resetPassword : import("@/pages/admin/resetPassword")
  },
  // 视图查询
  {
    path: "/view-query/idc-planning-query",
    name: "idcPlanningQuery",
    component: () =>
      isPlugin ? idcPlanningQuery : import("@/pages/coming-soon")
  },
  {
    path: "/view-query/idc-resource-planning-query",
    name: "idcResourcePlanningQuery",
    component: () =>
      isPlugin ? idcResourcePlanningQuery : import("@/pages/coming-soon")
  },
  {
    path: "/view-query/application-architecture-query",
    name: "applicationArchitectureQuery",
    component: () =>
      isPlugin ? applicationArchitectureQuery : import("@/pages/coming-soon")
  },
  {
    path: "/view-query/application-deployment-query",
    name: "applicationDeploymentQuery",
    component: () =>
      isPlugin ? applicationDeploymentQuery : import("@/pages/coming-soon")
  },
  // 视图管理
  {
    path: "/view-management/idc-planning-design",
    name: "idcPlanningDesign",
    component: () =>
      isPlugin ? idcPlanningDesign : import("@/pages/designing/planning")
  },
  {
    path: "/view-management/idc-resource-planning",
    name: "idcResourcePlanning",
    component: () =>
      isPlugin
        ? idcResourcePlanning
        : import("@/pages/designing/resource-planning")
  },
  {
    path: "/view-management/application-architecture-design",
    name: "applicationArchitectureDesign",
    component: () =>
      isPlugin
        ? applicationArchitectureDesign
        : import("@/pages/designing/application-architecture")
  },
  {
    path: "/view-management/application-deployment-design",
    name: "applicationDeploymentDesign",
    component: () =>
      isPlugin
        ? applicationDeploymentDesign
        : import("@/pages/designing/application-deployment")
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
