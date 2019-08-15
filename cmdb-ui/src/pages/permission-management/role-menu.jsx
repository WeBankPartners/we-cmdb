import React, { useState, useEffect } from "react";
import { withStyles } from "@material-ui/core/styles";
import CMDBTable from "../../components/cmdb-table";
import CMDBDialog from "../../components/cmdb-dialog";
import CMDBTree from "../../components/cmdb-tree";
import CMDBMessage from "../../components/cmdb-message";
import { menus } from "../../constants/menus";
import {
  retrieveMenus,
  retrieveRoles,
  retrieveRoleMenus,
  createRoleMenus,
  deleteRoleMenus
} from "../../apis/endpoints";

const styles = theme => ({
  root: {
    padding: "10 0"
  }
});

function RoleMenu(props) {
  const { classes, columns } = props;

  const [menusTree, setMenusTree] = useState([]);
  const [tableData, setTableData] = useState([]);
  const [currentRole, setCurrentRole] = useState({});
  const [roleMenusObj, setRoleMenusObj] = useState({});
  const [visible, setVisible] = useState(false);
  const tableActions = [
    {
      name: "菜单管理",
      handler: row => showDialog(row),
      size: 100
    }
  ];

  useEffect(() => {
    const fetchData = async () => {
      const [menusList, rolesData] = await Promise.all([
        retrieveMenus(),
        retrieveRoles({})
      ]);

      let tree = [];
      let menusObj = {};

      const formatTree = nodes => {
        nodes.forEach(_ => {
          _.title = menus[_.name].name;
          _.checked = false;
          _.treeId = _.menuId;
          if (menusObj[_.menuId]) {
            _.expand = true;
            _.children = menusObj[_.menuId];
            formatTree(_.children);
          }
        });
      };

      menusList.contents.forEach(_ => {
        if (_.parentIdAdmMenu) {
          if (!menusObj[_.parentIdAdmMenu]) {
            menusObj[_.parentIdAdmMenu] = [];
          }
          menusObj[_.parentIdAdmMenu].push(_);
        } else {
          tree.push(_);
        }
      });

      formatTree(tree);
      setMenusTree(tree);
      setTableData(rolesData.contents);
    };
    fetchData();
  }, []);

  const showDialog = async row => {
    const { contents: data } = await retrieveRoleMenus({
      filters: [
        {
          name: "roleId",
          operator: "eq",
          value: row.roleId
        }
      ]
    });
    if (data instanceof Array) {
      setCurrentRole(row);
      const initTree = nodes => {
        const result = nodes.map(_ => {
          if (obj[_.menuId]) {
            _.checked = true;
            _.roleMenuId = obj[_.menuId].roleMenuId;
          } else {
            _.checked = false;
          }
          if (_.children) {
            _.children = initTree(_.children);
          }
          return _;
        });
        return result;
      };

      let obj = {};
      data.forEach(_ => {
        obj[_.menuId] = _;
      });
      setRoleMenusObj(obj);
      const currentTree = initTree(menusTree);
      setMenusTree(currentTree);
      setVisible(true);
    }
  };

  const updateTreeData = val => {
    setMenusTree(val);
  };

  const handleRoleMenusChange = async () => {
    let addArray = [];
    let delArray = [];
    const formatData = nodes => {
      nodes.forEach(_ => {
        if (roleMenusObj[_.menuId] && !_.checked) {
          delArray.push(_.roleMenuId);
        } else if (!roleMenusObj[_.menuId] && _.checked) {
          addArray.push(_.menuId);
        }
        if (_.children) {
          formatData(_.children);
        }
      });
    };
    formatData(menusTree);
    const addVal = addArray.map(menuId => {
      return {
        callbackId: menuId,
        roleId: currentRole.roleId,
        menuId: menuId
      };
    });
    let promiseArray = [];
    if (addArray.length) {
      promiseArray.push(createRoleMenus(addVal));
    } else {
      promiseArray.push([]);
    }
    if (delArray.length) {
      promiseArray.push(deleteRoleMenus(delArray));
    }
    const [addResult, deleteResult] = await Promise.all(promiseArray);
    if (
      addResult instanceof Array &&
      (!deleteResult || deleteResult === "Success")
    ) {
      CMDBMessage({
        message: "角色菜单权限更新成功"
      });
    }
    closeDialog();
  };

  const closeDialog = () => {
    setVisible(false);
    setRoleMenusObj({});
    setCurrentRole({});
  };

  return (
    <div className={classes.root}>
      <CMDBTable
        select={false}
        columns={columns}
        source={tableData}
        actions={tableActions}
        hasPagination={false}
      />
      <CMDBDialog
        className={classes.dialog}
        visible={visible}
        title="用户菜单管理"
        onOk={handleRoleMenusChange}
        onCancel={closeDialog}
      >
        <CMDBTree sourceData={menusTree} handleDataChange={updateTreeData} />
      </CMDBDialog>
    </div>
  );
}

export default withStyles(styles)(RoleMenu);
