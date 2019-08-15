import React from "react";
import PropTypes from "prop-types";
import CMDBTable from "../../components/cmdb-table";
import { withStyles } from "@material-ui/core/styles";
import { TextField, Tooltip, IconButton } from "@material-ui/core";
import {
  Add as AddIcon,
  CloudDownload,
  AddToQueue,
  RemoveRedEye
} from "@material-ui/icons";
import { connect } from "react-redux";
import CMDBDialog from "../../components/cmdb-dialog";
import {
  addCiTypeAttr,
  updateCiTypeAttr,
  addUnionGroup,
  deleteUnionGroup,
  fetchUnionGroup,
  fetchCITypeAttrById,
  deleteCiTypeAttr,
  implementAttr
} from "../../apis/endpoints";
import AttributeEditor, {
  attributeEditorConfig,
  propertyTypeMap
} from "./attribute-editor";
import CMDBMessage from "../../components/cmdb-message";

const styles = theme => ({
  root: {
    display: "flex"
  },
  menu: {
    width: "200px",
    "&  li.selected": {
      background: "transparent",
      position: "relative",
      color: "#2196f3"
    }
  },
  content: {
    flexGrow: 1,
    padding: "0 20px"
  },
  btns: {
    display: "flex",
    alignItems: "center",
    margin: "10px 0"
  },
  form: {
    width: 500
  },
  input: {
    width: "100%"
  },
  group: {
    marginTop: 20
  },
  unionGroup: {
    width: 600,
    marginBottom: 20
  },
  unionGroupName: {
    margin: "0 0 10px 0"
  },
  unionGroupList: {},
  list: {
    paddingLeft: 81,
    "& ul": {
      margin: 0,
      padding: 0
    },
    "& li": {
      display: "inline-block",
      marginRight: 20
    }
  }
});

const boolValueMap = {
  1: "是",
  0: "否"
};

const columns = [
  {
    title: "中文名",
    dataIndex: "name"
  },
  {
    title: "描述",
    dataIndex: "description"
  },
  {
    title: "输入类型",
    dataIndex: "inputType"
  },
  {
    title: "属性真实列名",
    dataIndex: "propertyName"
  },
  {
    title: "属性真实类型",
    dataIndex: "propertyType"
  },
  {
    title: "搜索条件序号",
    dataIndex: "searchSeqNo"
  },
  {
    title: "是否展示",
    dataIndex: "isDisplayable",
    valueMap: boolValueMap
  },
  {
    title: "是否为空",
    dataIndex: "isNullable",
    valueMap: boolValueMap
  },
  {
    title: "是否唯一",
    dataIndex: "isUnique",
    valueMap: boolValueMap
  },
  {
    title: "是否丢弃",
    dataIndex: "isDefunct",
    valueMap: boolValueMap
  },
  {
    title: "是否系统",
    dataIndex: "isSystem",
    valueMap: boolValueMap
  },
  {
    title: "长度",
    dataIndex: "length"
  }
];

class InfomationManagement extends React.Component {
  state = {
    editorVisible: false,
    editorValues: {},
    selectedAttrs: [],
    groupName: "",
    groupNameEditorVisible: false,
    groupListVisible: false
  };

  mode = "new"; // new or edit

  toEditCiTypeAttr = attrs => {
    this.mode = "edit";
    this.toShowEditor(attrs);
  };

  toDeleteCiTypeAttr = async row => {
    if (row.status === "notCreated") {
      const req = await deleteCiTypeAttr(row.ciTypeId, row.ciTypeAttrId);
      if (req === "Success") {
        CMDBMessage({
          message: "CI Type Attibute 删除成功"
        });
        this.fetchCiTypeAttr();
      }
    } else {
      CMDBMessage({
        message: "该 CI Type Attibute 无法被删除",
        variant: "warning"
      });
    }
  };

  toApplyCiTypeAttr = async row => {
    if (row.status === "notCreated") {
      const res = await implementAttr(row.ciTypeAttrId, { operation: "apply" });
      if (res === "Success") {
        CMDBMessage({
          message: "CI Type Attibute 应用成功"
        });

        this.fetchCiTypeAttr();
      }
    } else {
      CMDBMessage({
        message: "该 CI Type Attibute 无法应用",
        variant: "warning"
      });
    }
  };

  toRevertCiTypeAttr = async row => {
    if (row.status === "decommissioned") {
      const res = await implementAttr(row.ciTypeAttrId, {
        operation: "revert"
      });
      if (res === "Success") {
        CMDBMessage({
          message: "CI Type Attibute 回滚成功"
        });

        this.fetchCiTypeAttr();
      }
    } else {
      CMDBMessage({
        message: "该 CI Type Attibute 无法回滚",
        variant: "warning"
      });
    }
  };

  toDecoCiTypeAttr = async row => {
    if (row.status === "created") {
      const res = await implementAttr(row.ciTypeAttrId, { operation: "deco" });
      if (res === "Success") {
        CMDBMessage({
          message: "CI Type Attibute 作废成功"
        });

        this.fetchCiTypeAttr();
      }
    } else {
      CMDBMessage({
        message: "该 CI Type Attibute 无法作废",
        variant: "warning"
      });
    }
  };

  tableActions = [
    {
      name: "编辑",
      handler: this.toEditCiTypeAttr
    },
    {
      name: "删除",
      handler: this.toDeleteCiTypeAttr
    },
    {
      name: "应用",
      handler: this.toApplyCiTypeAttr
    },
    {
      name: "回滚",
      handler: this.toRevertCiTypeAttr
    },
    {
      name: "作废",
      handler: this.toDecoCiTypeAttr
    }
  ];

  handleEditorField = object => {
    const { editorValues } = this.state;
    let o = {};
    if (object.inputType) {
      o.propertyType = propertyTypeMap[object.inputType];
    }
    this.setState({
      editorValues: { ...editorValues, ...object, ...o }
    });
  };

  fetchCiTypeAttr = async () => {
    const { activedCI } = this.props;
    const data = await fetchCITypeAttrById(activedCI.ciTypeId);
    if (!(data instanceof Error)) {
      this.props.setCIAttributes(data);
    }
  };

  toShowEditor = (attrs = attributeEditorConfig) => {
    this.setState({
      editorVisible: true,
      editorValues: { ...attrs }
    });
  };

  toSubmit = async () => {
    const { activedCI } = this.props;
    const { editorValues } = this.state;
    if (this.mode === "new") {
      const res = await addCiTypeAttr(activedCI.ciTypeId, {
        ...editorValues,
        ciTypeId: activedCI.ciTypeId
      });
      if (!(res instanceof Error) && res.ciTypeAttrId) {
        CMDBMessage({
          message: "新增 CI Type 属性成功"
        });
        this.fetchCiTypeAttr();
        this.toHideEditor();
      }
    } else {
      const res = await updateCiTypeAttr(activedCI.ciTypeId, editorValues);
      if (res === "Success") {
        CMDBMessage({
          message: "修改 CI Type 属性成功"
        });
        this.fetchCiTypeAttr();
        this.toHideEditor();
      }
    }

    this.mode = "new";
  };

  toHideEditor = () => {
    this.setState({
      editorVisible: false,
      editorValues: { ...attributeEditorConfig }
    });

    this.mode = "new";
  };

  toGenUnionKey = () => {
    if (this.state.selectedAttrs.length < 2) {
      CMDBMessage({
        variant: "warning",
        message: "请先选择两个及以上属性"
      });
      return;
    }
    this.setState({ groupNameEditorVisible: true });
  };

  toDismissUnionGroup = () => {
    this.setState({ groupNameEditorVisible: false, groupName: "" });
  };

  setSelectedAttrs = attrs => this.setState({ selectedAttrs: attrs });

  toAddGroup = async () => {
    const { activedCI } = this.props;
    const { groupName, selectedAttrs } = this.state;
    const data = {
      ciTypeId: activedCI.ciTypeId,
      name: groupName,
      ciTypeAttrs: selectedAttrs.map(_ => ({ ciTypeAttrId: _ }))
    };
    const res = await addUnionGroup(data);
    if (res === "Success") {
      CMDBMessage({
        message: "新增联合唯一键成功"
      });

      this.setState({
        groupName: "",
        groupNameEditorVisible: false
      });

      const data = await fetchUnionGroup(activedCI.ciTypeId);
      if (!(data instanceof Error)) {
        this.props.setUnionGroup(data);
      }
    }
  };

  toDeleteGroup = async group => {
    const { activedCI } = this.props;
    const res = await deleteUnionGroup(group.attrGroupId);
    if (res === "Success") {
      CMDBMessage({
        message: "删除联合唯一键成功"
      });
      const data = await fetchUnionGroup(activedCI.ciTypeId);
      if (!(data instanceof Error)) {
        this.props.setUnionGroup(data);
      }
    }
  };

  render() {
    const {
      classes = {},
      ciTypeAttributes,
      unionGroup,
      activedCI
    } = this.props;
    const {
      editorVisible,
      editorValues,
      groupName,
      groupNameEditorVisible,
      groupListVisible
    } = this.state;

    return (
      <div className={classes.root}>
        <div className={classes.content}>
          <div className={classes.btns}>
            <span style={{ marginRight: 10 }}>
              {activedCI.name} CI Type 属性列表
            </span>
            <Tooltip title="添加 CI Type 属性">
              <IconButton
                aria-label="add ci type"
                onClick={() => this.toShowEditor()}
              >
                <AddIcon />
              </IconButton>
            </Tooltip>
            <Tooltip title="下载 CI Type 属性">
              <IconButton aria-label="download ci type">
                <CloudDownload />
              </IconButton>
            </Tooltip>
            <Tooltip title="生成联合唯一键">
              <IconButton
                aria-label="generate union group"
                onClick={this.toGenUnionKey}
              >
                <AddToQueue />
              </IconButton>
            </Tooltip>
            <Tooltip title="查看联合唯一键">
              <IconButton
                aria-label="view union group"
                onClick={() => this.setState({ groupListVisible: true })}
              >
                <RemoveRedEye />
              </IconButton>
            </Tooltip>
          </div>
          <CMDBTable
            select
            columns={columns}
            source={ciTypeAttributes.attributes || []}
            hasPagination={false}
            actions={this.tableActions}
            onSelectedChange={this.setSelectedAttrs}
          />
          <AttributeEditor
            values={editorValues}
            onFieldChange={this.handleEditorField}
            onCancel={this.toHideEditor}
            visible={editorVisible}
            onOk={this.toSubmit}
            mode={this.mode}
          />
          <CMDBDialog
            visible={groupNameEditorVisible}
            onCancel={this.toDismissUnionGroup}
            onOk={this.toAddGroup}
            title="组合键名称"
          >
            <form className={classes.form}>
              <TextField
                label="名称"
                placeholder="请输入组合键名称"
                value={groupName}
                // margin="normal"
                className={classes.input}
                onChange={e => this.setState({ groupName: e.target.value })}
              />
            </form>
          </CMDBDialog>

          <CMDBDialog
            visible={groupListVisible}
            onCancel={() => this.setState({ groupListVisible: false })}
            title="CI Type 属性联合唯一键列表"
          >
            {unionGroup.map(_ => {
              return (
                <div className={classes.unionGroup} key={_.name}>
                  <p className={classes.unionGroupName}>
                    <span
                      style={{
                        color: "#9e9e9e",
                        display: "inline-block",
                        width: 80,
                        textAlign: "right"
                      }}
                    >
                      键名：
                    </span>
                    {_.name}
                  </p>
                  <div className={classes.unionGroupList}>
                    <span
                      style={{
                        display: "inline-block",
                        width: 80,
                        position: "absolute",
                        color: "#9e9e9e"
                      }}
                    >
                      属性名称：
                    </span>
                    <div className={classes.list}>
                      <ul>
                        {_.ciTypeAttrs.map(attr => (
                          <li key={attr.propertyName}>
                            {attr.propertyName}({attr.description})
                          </li>
                        ))}
                      </ul>
                    </div>
                  </div>
                </div>
              );
            })}
          </CMDBDialog>
        </div>
      </div>
    );
  }
}

InfomationManagement.propTypes = {
  data: PropTypes.object,
  classes: PropTypes.object.isRequired
};

const mapState = state => {
  return {
    activedCI: state.configManagement.activedCI,
    ciTypeAttributes: state.configManagement.ciTypeAttributes,
    unionGroup: state.configManagement.unionGroup
  };
};

const mapDispatch = dispatch => {
  return {
    ...dispatch.configManagement
  };
};

export default connect(
  mapState,
  mapDispatch
)(withStyles(styles)(InfomationManagement));
