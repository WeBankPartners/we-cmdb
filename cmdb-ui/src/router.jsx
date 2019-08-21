import React, { useState, useEffect } from "react";
import { HashRouter as Router, Route } from "react-router-dom";
import Home from "./pages/home";
import NoPermission from "./pages/no-permission";
import ConfigManagement from "./pages/config-management/";
import CommonInterfaceConfig from "./pages/config-management/common-interface-config";
import CommonInterfaceRunner from "./pages/config-management/common-interface-runner";
import BasicConfigQuery from "./pages/basic-config-query";
import QueryConfig from "./pages/query/query-config";
import QueryLog from "./pages/query/query-log";
import SystemManageMent from "./pages/permission-management";
import CommingSoon from "./pages/coming-soon";
import { retrieveMenus, myMenus } from "./apis/endpoints";

function AppRouter() {
  const [roleMenus, setRoleMenus] = useState({});
  useEffect(() => {
    const fetchRoleMenus = async () => {
      const menusList = await retrieveMenus();
      if (!menusList || !(menusList.contents instanceof Array)) return;
      const rolesData = await myMenus();
      if (rolesData && rolesData.contents instanceof Array) {
        let allMenusObj = {};
        let roleMenusObj = {};
        menusList.contents.forEach(_ => {
          allMenusObj[_.menuId] = _;
        });
        rolesData.contents.forEach(_ => {
          if (allMenusObj[_.menuId] && allMenusObj[_.menuId].parentIdAdmMenu) {
            roleMenusObj[allMenusObj[_.menuId].name] = allMenusObj[_.menuId];
          }
        });
        setRoleMenus(roleMenusObj);
      }
    };
    fetchRoleMenus();
  }, []);
  return (
    <Router>
      <>
        <Route
          path="/config-management"
          component={roleMenus["OVERVIEW"] ? ConfigManagement : NoPermission}
        />
        <Route
          path="/basic-config-query"
          exact
          component={
            roleMenus["BASIC_CONFIG_QUERY"] ? BasicConfigQuery : NoPermission
          }
        />
        <Route
          path="/query-config"
          exact
          component={roleMenus["QUERY_CONFIG"] ? QueryConfig : NoPermission}
        />
        <Route
          path="/query-log"
          exact
          component={roleMenus["QUERY_LOG"] ? QueryLog : NoPermission}
        />
        <Route
          path="/common-interface-runner"
          exact
          component={
            roleMenus["COMMON_INTERFACE_RUNNER"]
              ? CommonInterfaceRunner
              : NoPermission
          }
        />
        <Route
          path="/common-interface-config"
          exact
          component={
            roleMenus["COMMON_INTERFACE_CONFIG"]
              ? CommonInterfaceConfig
              : NoPermission
          }
        />
        <Route
          path="/permission-management"
          exact
          component={roleMenus["PERMISSION"] ? SystemManageMent : NoPermission}
        />
        <Route
          path="/rule-management"
          exact
          component={roleMenus["RULE"] ? CommingSoon : NoPermission}
        />
        <Route path="/" exact component={Home} />
      </>
    </Router>
  );
}

export default AppRouter;
