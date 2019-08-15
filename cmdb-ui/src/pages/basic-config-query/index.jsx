import React from "react";
import { withStyles } from "@material-ui/core/styles";
import { Tooltip, IconButton, Paper } from "@material-ui/core";
import { Add as AddIcon, Edit as EditIcon } from "@material-ui/icons";
import {
  fetchBasicConfigCat,
  fetchCatCodes,
  deleteCatCodes,
  moveUpCatCodes,
  moveDownCatCodes,
  addCatCode,
  updateCatCode,
  addCategory,
  updateCategory
} from "../../apis/endpoints";
import Menu from "../../components/menu";
import CMDBTable from "../../components/cmdb-table";
import CMDBMessage from "../../components/cmdb-message";
import CodeEditor from "./code-editor";
import TypeEditor from "./type-editor";

const menuLabels = {
  parent: "catTypeName",
  child: "catName",
  childrenKey: "cats"
};

const columns = [
  {
    title: "编码",
    dataIndex: "code"
  },
  {
    title: "值",
    dataIndex: "value"
  },
  {
    title: "描述",
    dataIndex: "codeDescription"
  }
];
const styles = theme => ({
  root: {
    position: "relative",
    height: "100%"
  },
  menu: {
    width: "200px",
    position: "fixed",
    paddingTop: 84,
    paddingBottom: 84,
    top: 0,
    left: 0,
    background: "#fff",
    height: "100%",
    ul: {
      paddingBottom: 84
    },
    "&  li.selected": {
      background: "transparent",
      position: "relative",
      color: "#2196f3"
    }
  },
  btns: {
    margin: "10px 0"
  },
  content: {
    display: "flex",
    width: "100%",
    flexDirection: "column",
    padding: "0 20px"
  },
  currentCat: {
    margin: 0,
    borderBottom: "1px solid rgba(0,0,0,.1)",
    paddingBottom: 14
  },
  paper: {
    padding: 20
  }
});

class BasicConfigQuery extends React.Component {
  state = {
    catTypes: [],
    addCiVisible: false,
    catCodes: [],
    currentCat: {},
    currentCatType: {},
    codeEditorValues: {},
    codeEditorVisible: false,
    typeEditorValues: {},
    typeEditorVisible: false
  };

  mode = "edit";

  tempCat = {};

  tableActions = [
    {
      name: "上移",
      handler: row => this.moveUpCatCode(row)
    },
    {
      name: "下移",
      handler: row => this.moveDownCatCode(row)
    },
    {
      name: "编辑",
      handler: row => this.toEditCatCode(row)
    },
    {
      name: "删除",
      handler: row => this.deleteCatCode(row)
    }
  ];

  moveUpCatCode = async row => {
    const res = await moveUpCatCodes(row.codeId);
    if (res === "Success") {
      CMDBMessage({
        message: "上移成功"
      });
      this.fetchCode();
    }
  };

  moveDownCatCode = async row => {
    const res = await moveDownCatCodes(row.codeId);
    if (res === "Success") {
      CMDBMessage({
        message: "下移成功"
      });
      this.fetchCode();
    }
  };

  deleteCatCode = async row => {
    const res = await deleteCatCodes(row.codeId);
    if (res === "Success") {
      CMDBMessage({
        message: "删除编码成功"
      });

      this.fetchCode();
    }
  };

  fetchCode = async () => {
    const { currentCatType } = this.state;
    const catCodes = await fetchCatCodes(currentCatType.catId);
    if (!(catCodes instanceof Error)) {
      this.setState({ catCodes });
    }
  };

  toDismissCodeEditor = () => {
    this.setState({
      codeEditorValues: { id: this.state.currentCatType.catId },
      codeEditorVisible: false
    });
  };

  toDismissTypeEditor = () => {
    this.setState({
      typeEditorValues: { id: this.state.currentCatType.catId },
      typeEditorVisible: false
    });
  };

  acceptCodeEditorField = obj => {
    const { codeEditorValues } = this.state;
    this.setState({ codeEditorValues: { ...codeEditorValues, ...obj } });
  };

  acceptTypeEditorField = obj => {
    const { typeEditorValues } = this.state;
    this.setState({ typeEditorValues: { ...typeEditorValues, ...obj } });
  };

  toAddCatCode = () => {
    this.mode = "new";
    const { currentCatType } = this.state;
    this.setState({
      codeEditorVisible: true,
      codeEditorValues: {
        code: "",
        value: "",
        codeDescription: "",
        id: currentCatType.catId
      }
    });
  };

  toEditCatCode = code => {
    this.mode = "edit";
    this.setState({
      codeEditorVisible: true,
      codeEditorValues: {
        code: code.code,
        value: code.value,
        codeDescription: code.codeDescription,
        id: code.codeId
      }
    });
  };

  submitCodeEditor = async () => {
    if (this.mode === "new") {
      const res = await addCatCode(this.state.codeEditorValues);
      if (!(res instanceof Error) && res.id) {
        CMDBMessage({
          message: "新增编码成功"
        });

        this.fetchCode();

        this.setState({ codeEditorVisible: false });
      }
    } else {
      const res = await updateCatCode(this.state.codeEditorValues);
      if (!(res instanceof Error) && res === "Success") {
        CMDBMessage({
          message: "编辑编码成功"
        });

        this.fetchCode();
        this.setState({ codeEditorVisible: false });
      }
    }
  };

  submitTypeEditor = async () => {
    if (this.mode === "edit") {
      const res = await updateCategory(this.state.typeEditorValues);
      if (res === "Success") {
        CMDBMessage({
          message: "编辑属性成功"
        });
        this.setState({
          typeEditorVisible: false,
          typeEditorValues: {}
        });
      }
    } else {
      const res = await addCategory(this.state.typeEditorValues);
      if (!(res instanceof Error) && res.catId) {
        CMDBMessage({
          message: "新增属性成功"
        });
        this.setState({
          typeEditorVisible: false,
          typeEditorValues: {}
        });
      }
    }
  };

  toAddType = () => {
    this.mode = "new";
    this.setState({
      typeEditorVisible: true,
      typeEditorValues: {
        id: this.state.currentCat.catTypeId
      }
    });
  };

  toEditType = () => {
    this.mode = "edit";
    const { currentCat, currentCatType } = this.state;

    this.setState({
      typeEditorVisible: true,
      typeEditorValues: {
        catName: currentCatType.catName,
        description: currentCatType.description,
        id: currentCat.catTypeId
      }
    });
  };

  componentDidMount = async () => {
    const data = await fetchBasicConfigCat();
    if (data instanceof Error) {
      return;
    }
    this.setState({ catTypes: data });
    const currentCat = data[0];
    const currentCatType = currentCat.cats[0];
    this.setState(
      {
        currentCatType,
        currentCat,
        codeEditorValues: { id: data[0].catTypeId }
      },
      this.fetchCode
    );
  };

  handleMenuClick = currentCat => {
    this.tempCat = currentCat;

    if (currentCat.cats.length === 0) {
      this.setState({
        currentCatType: {},
        catCodes: [],
        currentCat
      });
    }
  };

  handleTypeClick = type => {
    if (!type) return;
    this.setState(
      {
        currentCatType: type,
        currentCat: this.tempCat
      },
      this.fetchCode
    );
  };

  render() {
    const { classes } = this.props;
    const {
      catTypes,
      catCodes,
      currentCat,
      currentCatType,
      codeEditorValues,
      codeEditorVisible,
      typeEditorValues,
      typeEditorVisible
    } = this.state;

    return (
      <div className={classes.root}>
        <Menu
          dir="vertical"
          data={catTypes}
          className={classes.menu}
          menuClasses={{ selected: "selected" }}
          labels={menuLabels}
          onItemClick={this.handleTypeClick}
          onMenuClick={this.handleMenuClick}
          //   menuActions={[{ comp: Add, handler: this.toAddCI }]}
        />
        <div className="global-main-content">
          <Paper elevation={0} className={classes.paper}>
            <p className={classes.currentCat}>
              {currentCatType.catName
                ? `${currentCat.catTypeName} > ${currentCatType.catName}`
                : currentCat.catTypeName}
              <Tooltip
                title={`新增 ${currentCat.catTypeName} 类属性`}
                style={{ marginLeft: 10 }}
              >
                <IconButton aria-label="add  type" onClick={this.toAddType}>
                  <AddIcon />
                </IconButton>
              </Tooltip>
            </p>
            <div className={classes.btns}>
              <span>{currentCatType.catName} 编码列表</span>
              <Tooltip
                title={`编辑 ${currentCatType.catName} 属性`}
                style={{ marginLeft: 10 }}
              >
                <IconButton aria-label="edit type" onClick={this.toEditType}>
                  <EditIcon />
                </IconButton>
              </Tooltip>
              <Tooltip
                title={`新增 ${currentCatType.catName} 编码`}
                style={{ marginLeft: 10 }}
              >
                <IconButton
                  aria-label="add type code"
                  onClick={this.toAddCatCode}
                >
                  <AddIcon />
                </IconButton>
              </Tooltip>
            </div>
            <CMDBTable
              select={false}
              columns={columns}
              source={catCodes}
              hasPagination={false}
              actions={this.tableActions}
            />
          </Paper>
        </div>
        <CodeEditor
          values={codeEditorValues}
          onCancel={this.toDismissCodeEditor}
          onOk={this.submitCodeEditor}
          visible={codeEditorVisible}
          onFieldChange={this.acceptCodeEditorField}
          mode={this.mode}
        />
        <TypeEditor
          values={typeEditorValues}
          onCancel={this.toDismissTypeEditor}
          onOk={this.submitTypeEditor}
          visible={typeEditorVisible}
          onFieldChange={this.acceptTypeEditorField}
          mode={this.mode}
        />
      </div>
    );
  }
}

export default withStyles(styles)(BasicConfigQuery);
