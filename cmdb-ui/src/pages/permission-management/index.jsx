import React, { useState } from "react";
import { withStyles } from "@material-ui/core/styles";
import { Tabs, Tab, Paper } from "@material-ui/core";
import RoleManagement from "./role-management";
import RoleUser from "./role-user";
import RoleCi from "./role-ci";
import RoleMenu from "./role-menu";

const styles = theme => ({
  root: {
    margin: "0 20px",
    padding: "20px"
  },
  tabsRoot: {
    borderBottom: "1px solid #e8e8e8"
  },
  tabsIndicator: {
    backgroundColor: "#1890ff"
  },
  tabRoot: {
    textTransform: "initial",
    minWidth: 72,
    fontWeight: theme.typography.fontWeightRegular,
    marginRight: theme.spacing.unit * 4,
    "&:hover": {
      color: "#40a9ff",
      opacity: 1
    },
    "&tabSelected": {
      color: "#1890ff",
      fontWeight: theme.typography.fontWeightMedium
    },
    "&:focus": {
      color: "#40a9ff"
    }
  }
});

function PermissionManagement(props) {
  const [currentTab, changeCurrentTab] = useState(0);

  const { classes } = props;

  const columns = [
    {
      canEdit: false,
      dataIndex: "roleId",
      inputType: "text",
      order: "asc",
      title: "ID"
    },
    {
      canEdit: true,
      dataIndex: "description",
      inputType: "text",
      order: "asc",
      title: "描述"
    },
    {
      canEdit: true,
      dataIndex: "roleName",
      inputType: "text",
      order: "asc",
      title: "角色名"
    },
    {
      canEdit: true,
      dataIndex: "roleType",
      inputType: "text",
      order: "asc",
      title: "类型"
    }
  ];

  return (
    <Paper className={classes.root}>
      <Tabs
        value={currentTab}
        onChange={(event, newValue) => {
          changeCurrentTab(newValue);
        }}
        classes={{
          root: classes.tabsRoot,
          indicator: classes.tabsIndicator
        }}
      >
        <Tab
          label="角色管理"
          classes={{
            root: classes.tabRoot,
            selected: classes.tabSelected
          }}
        ></Tab>
        <Tab
          label="角色用户管理"
          classes={{
            root: classes.tabRoot,
            selected: classes.tabSelected
          }}
        ></Tab>
        <Tab
          label="数据权限"
          classes={{
            root: classes.tabRoot,
            selected: classes.tabSelected
          }}
        ></Tab>
        <Tab
          label="菜单管理"
          classes={{
            root: classes.tabRoot,
            selected: classes.tabSelected
          }}
        ></Tab>
      </Tabs>
      {currentTab === 0 && <RoleManagement columns={columns} />}
      {currentTab === 1 && <RoleUser columns={columns} />}
      {currentTab === 2 && <RoleCi columns={columns} />}
      {currentTab === 3 && <RoleMenu columns={columns} />}
    </Paper>
  );
}

export default withStyles(styles)(PermissionManagement);
