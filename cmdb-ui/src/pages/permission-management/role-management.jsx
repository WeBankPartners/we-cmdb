import React, { useState, useEffect } from "react";
import { withStyles } from "@material-ui/core/styles";
import { Tooltip, IconButton, TextField } from "@material-ui/core";
import { Add as AddIcon } from "@material-ui/icons";
import CMDBTable from "../../components/cmdb-table";
import CMDBDialog from "../../components/cmdb-dialog";
import {
  retrieveRoles,
  createRoles,
  updateRoles,
  deleteRoles
} from "../../apis/endpoints";

const styles = theme => ({
  root: {
    padding: "10 0"
  },
  title: {
    padding: "10px 0"
  },
  form: {
    padding: "0 20px 20px 20px",
    width: 220
  },
  textField: {
    marginBottom: 10
  }
});

function RoleManagement(props) {
  const { classes, columns } = props;

  const [tableData, setTableData] = useState([]);
  const [visible, setVisible] = useState(false);
  const [editFormData, setEditFormData] = useState({
    description: "",
    roleName: "",
    roleId: "",
    roleType: ""
  });
  const [isCreate, setIsCreate] = useState(true);
  const tableActions = [
    {
      name: "编辑",
      handler: row => editRole(row)
    },
    {
      name: "删除",
      handler: row => deleteRole(row)
    }
  ];

  useEffect(() => {
    const fetchData = async () => {
      const data = await retrieveRoles({});
      setTableData(data.contents);
    };
    fetchData();
  }, []);

  const queryRoles = async () => {
    const data = await retrieveRoles({});
    setTableData(data.contents);
  };

  const addRole = () => {
    setIsCreate(true);
    setVisible(true);
    setEditFormData({
      description: "",
      roleName: "",
      roleType: ""
    });
  };

  const editRole = row => {
    setIsCreate(false);
    setVisible(true);
    setEditFormData(row);
  };

  const deleteRole = async row => {
    const data = await deleteRoles([row.roleId]);
    if (!(data instanceof Error)) {
      queryRoles();
    }
  };

  const createRole = async () => {
    setVisible(false);
    const data = await createRoles([editFormData]);
    if (!(data instanceof Error)) {
      queryRoles();
    }
  };

  const updateRole = async () => {
    setVisible(false);
    const data = await updateRoles([editFormData]);
    if (!(data instanceof Error)) {
      queryRoles();
    }
  };

  const closeDialog = () => {
    setVisible(false);
  };

  const handleFormDataChange = (event, dataIndex) => {
    const data = { ...editFormData };
    data[dataIndex] = event.target.value;
    setEditFormData(data);
  };

  return (
    <div className={classes.root}>
      <div className={classes.title}>
        <span>角色列表</span>
        <Tooltip title="添加角色">
          <IconButton aria-label="add role" onClick={addRole}>
            <AddIcon />
          </IconButton>
        </Tooltip>
      </div>
      <CMDBTable
        select={false}
        columns={columns}
        source={tableData}
        actions={tableActions}
        hasPagination={false}
      />
      <CMDBDialog
        visible={visible}
        title={isCreate ? "创建角色" : "编辑角色"}
        onOk={isCreate ? createRole : updateRole}
        onCancel={closeDialog}
      >
        <form className={classes.form}>
          {columns
            .filter(_ => _.canEdit)
            .map(_ => (
              <TextField
                className={classes.textField}
                label={_.title}
                key={_.dataIndex}
                value={editFormData[_.dataIndex]}
                onChange={event => handleFormDataChange(event, _.dataIndex)}
              />
            ))}
        </form>
      </CMDBDialog>
    </div>
  );
}

export default withStyles(styles)(RoleManagement);
