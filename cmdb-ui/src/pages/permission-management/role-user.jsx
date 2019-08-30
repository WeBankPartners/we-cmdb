import React, { useState, useEffect } from "react";
import { withStyles } from "@material-ui/core/styles";
import CMDBTable from "../../components/cmdb-table";
import CMDBDialog from "../../components/cmdb-dialog";
import CMDBMessage from "../../components/cmdb-message";
import {
  TextField,
  IconButton,
  FormControlLabel,
  Checkbox
} from "@material-ui/core";
import { Search as SearchIcon } from "@material-ui/icons";
import {
  retrieveUsers,
  retrieveRoles,
  retrieveRoleUsers,
  createRoleUsers,
  deleteRoleUsers
} from "../../apis/endpoints";

const styles = theme => ({
  root: {
    padding: "10 0"
  },
  dialogContent: {
    maxWidth: 600
  }
});

function RoleUser(props) {
  const { classes, columns } = props;

  const [users, setUsers] = useState([]);
  const [tableData, setTableData] = useState([]);
  const [visible, setVisible] = useState(false);
  const [currentRole, setCurrentRole] = useState(null);
  const [currentRoleUsers, setCurrentRoleUsers] = useState([]);
  const [searchValue, setSearchValue] = useState("");
  const [deleteRoleUsersList, setDeleteRoleUsersList] = useState([]);
  const [addRoleUsersList, setAddRoleUsersList] = useState([]);
  const tableActions = [
    {
      name: "用户管理",
      handler: row => showDialog(row),
      size: 100
    }
  ];

  useEffect(() => {
    const fetchData = async () => {
      const [usersList, rolesData] = await Promise.all([
        retrieveUsers({}),
        retrieveRoles({})
      ]);
      setUsers(usersList.contents);
      setTableData(rolesData.contents);
    };
    fetchData();
  }, []);

  const showDialog = async row => {
    const { contents: data } = await retrieveRoleUsers({
      filters: [
        {
          name: "roleId",
          operator: "eq",
          value: row.roleId
        }
      ]
    });
    if (data instanceof Array) {
      const roleUsers = users.map(user => {
        const found = data.find(_ => _.userId === user.userId);
        return {
          ...user,
          isShow: true,
          checked: found ? true : false,
          roleUserId: found ? found.roleUserId : null
        };
      });
      setCurrentRole(row);
      setCurrentRoleUsers(roleUsers);
      setVisible(true);
    }
  };

  const searchInputChange = event => {
    setSearchValue(event.target.value);
  };

  const filterUsers = () => {
    const val = currentRoleUsers.map(_ => {
      return {
        ..._,
        isShow: _.username.indexOf(searchValue.trim()) >= 0
      };
    });
    setCurrentRoleUsers(val);
  };

  const handleChange = (user, i) => event => {
    const val = currentRoleUsers.map((_, index) => {
      if (i === index) {
        _.checked = !_.checked;
      }
      return _;
    });
    setCurrentRoleUsers(val);
    if (event.target.checked) {
      if (deleteRoleUsersList.indexOf(user.roleUserId) >= 0) {
        deleteRoleUsersList.splice(
          deleteRoleUsersList.indexOf(user.roleUserId),
          1
        );
        setDeleteRoleUsersList(deleteRoleUsersList);
      } else {
        setAddRoleUsersList(addRoleUsersList.concat([user.userId]));
      }
    } else {
      if (addRoleUsersList.indexOf(user.userId) >= 0) {
        addRoleUsersList.splice(addRoleUsersList.indexOf(user.userId), 1);
        setAddRoleUsersList(addRoleUsersList);
      } else {
        setDeleteRoleUsersList(deleteRoleUsersList.concat([user.roleUserId]));
      }
    }
  };

  const handleRoleUsersChange = async () => {
    const addVal = addRoleUsersList.map(userId => {
      return {
        callbackId: userId,
        roleId: currentRole.roleId,
        userId: userId
      };
    });
    let promiseArray = [];
    if (addVal.length) {
      promiseArray.push(createRoleUsers(addVal));
    } else {
      promiseArray.push([]);
    }
    if (deleteRoleUsersList.length) {
      promiseArray.push(deleteRoleUsers(deleteRoleUsersList));
    }
    setVisible(false);
    setAddRoleUsersList([]);
    setDeleteRoleUsersList([]);
    const [addResult, deleteResult] = await Promise.all(promiseArray);
    if (
      addResult instanceof Array &&
      (!deleteResult || deleteResult === "Success")
    ) {
      CMDBMessage({
        message: "更新用户成功"
      });
    }
  };

  const closeDialog = () => {
    setVisible(false);
    setAddRoleUsersList([]);
    setDeleteRoleUsersList([]);
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
        visible={visible}
        title="角色用户管理"
        onOk={handleRoleUsersChange}
        onCancel={closeDialog}
      >
        <div className={classes.dialogContent}>
          <div>
            <TextField
              label="查询用户"
              value={searchValue}
              onChange={searchInputChange}
            ></TextField>
            <IconButton onClick={filterUsers}>
              <SearchIcon />
            </IconButton>
          </div>
          {currentRoleUsers
            .filter(_ => _.isShow)
            .map((_, i) => (
              <FormControlLabel
                control={
                  <Checkbox
                    checked={_.checked}
                    value={_.userId}
                    color="primary"
                  />
                }
                label={_.username}
                onChange={handleChange(_, i)}
                key={i}
              />
            ))}
        </div>
      </CMDBDialog>
    </div>
  );
}

export default withStyles(styles)(RoleUser);
