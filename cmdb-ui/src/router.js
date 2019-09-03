import Vue from "vue";
import Router from "vue-router";

Vue.use(Router);
export default new Router({
  routes: [
    {
      path: "/",
      name: "IndexPage",
      redirect: "/homepage",
      component: () => import("@/pages/index"),
      children: [
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
          name: "enumEnquiry",
          component: () => import("@/pages/admin/enums")
        },
        {
          path: "/designing/enum-enquiry",
          name: "enumManage",
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
          component: () =>
            import("@/pages/designing/ci-integrated-query-execution")
        },
        {
          path: "/designing/ci-integrated-query-management",
          name: "integrateQueryMgmt",
          component: () =>
            import("@/pages/designing/ci-integrated-query-management")
        },
        {
          path: "/admin/query-log",
          name: "queryLog",
          component: () => import("@/pages/admin/query-log")
        }
      ]
    }
  ]
});
