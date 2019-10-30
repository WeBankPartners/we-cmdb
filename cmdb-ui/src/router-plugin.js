import Vue from "vue";
import Router from "vue-router";

import ciDesign from "@/pages/admin/cmdb-model-management";
import enums from "@/pages/admin/enums";
import ciData from "@/pages/designing/ci-data";
import integrateQuery from "@/pages/designing/ci-integrated-query-execution";
import integrateQueryMgmt from "@/pages/designing/ci-integrated-query-management";
import queryLog from "@/pages/admin/query-log";
import idcPlanningQuery from "@/pages/coming-soon";
import idcResourcePlanningQuery from "@/pages/coming-soon";
import applicationArchitectureQuery from "@/pages/coming-soon";
import applicationDeploymentQuery from "@/pages/coming-soon";
import idcPlanningDesign from "@/pages/designing/planning";
import idcResourcePlanning from "@/pages/designing/resource-planning";
import applicationArchitectureDesign from "@/pages/designing/application-architecture";
import applicationDeploymentDesign from "@/pages/designing/application-deployment";

Vue.use(Router);
const router = [
  {
    path: "/admin/cmdb-model-management",
    name: "ciDesign",
    component: ciDesign
  },
  {
    path: "/admin/base-data-management",
    name: "baseData",
    component: enums
  },
  {
    path: "/designing/enum-management",
    name: "enumManage",
    component: enums
  },
  {
    path: "/designing/enum-enquiry",
    name: "enumEnquiry",
    component: enums
  },
  {
    path: "/designing/ci-data-management",
    name: "ciDataManage",
    component: ciData
  },
  {
    path: "/designing/ci-data-enquiry",
    name: "ciDataEnquiry",
    component: ciData
  },
  {
    path: "/designing/ci-integrated-query-execution",
    name: "integrateQuery",
    component: integrateQuery
  },
  {
    path: "/designing/ci-integrated-query-management",
    name: "integrateQueryMgmt",
    component: integrateQueryMgmt
  },
  {
    path: "/admin/query-log",
    name: "queryLog",
    component: queryLog
  },
  // 视图查询
  {
    path: "/view-query/idc-planning-query",
    name: "idcPlanningQuery",
    component: idcPlanningQuery
  },
  {
    path: "/view-query/idc-resource-planning-query",
    name: "idcResourcePlanningQuery",
    component: idcResourcePlanningQuery
  },
  {
    path: "/view-query/application-architecture-query",
    name: "applicationArchitectureQuery",
    component: applicationArchitectureQuery
  },
  {
    path: "/view-query/application-deployment-query",
    name: "applicationDeploymentQuery",
    component: applicationDeploymentQuery
  },
  // 视图管理
  {
    path: "/view-management/idc-planning-design",
    name: "idcPlanningDesign",
    component: idcPlanningDesign
  },
  {
    path: "/view-management/idc-resource-planning",
    name: "idcResourcePlanning",
    component: idcResourcePlanning
  },
  {
    path: "/view-management/application-architecture-design",
    name: "applicationArchitectureDesign",
    component: applicationArchitectureDesign
  },
  {
    path: "/view-management/application-deployment-design",
    name: "applicationDeploymentDesign",
    component: applicationDeploymentDesign
  }
];
export default router;
