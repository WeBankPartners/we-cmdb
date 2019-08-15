import React from "react";
import { connect } from "react-redux";
import { withStyles } from "@material-ui/core/styles";
import { Tooltip, IconButton, Paper } from "@material-ui/core";
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  DeleteForever as DeleteForEverIcon,
  Build as BuildIcon,
  RestoreFromTrash as RestoreFromTrashIcon
} from "@material-ui/icons";
import CiEditor, { ciEditorConfig } from "./ci-editor";
import Menu from "../../components/menu";
import InformationManagement from "./information-management";
import CMDBMessage from "../../components/cmdb-message";
import { pick } from "../../utils/object";
import {
  fetchCatalogs,
  fetchCITypeAttrById,
  fetchUnionGroup,
  updateCiType,
  addCiType,
  deleteCiType,
  implementCiType
} from "../../apis/endpoints";

const styles = theme => ({
  root: {
    position: "relative",
    height: "100%"
  },
  menu: {
    width: "200px",
    position: "fixed",
    top: 0,
    left: 0,
    height: "100%",
    paddingTop: 84,
    paddingBottom: 84,
    "& ul": {
      background: "#fff",
      paddingBottom: 84
    },
    "&  li.selected": {
      background: "transparent",
      position: "relative",
      color: "#2196f3"
    }
  },
  currentCatalog: {
    display: "flex",
    alignItems: "center",
    margin: "0px 20px",
    borderBottom: "1px solid rgba(0,0,0,.1)",
    paddingBottom: 14
  }
});

class ConfigManagement extends React.Component {
  state = {
    ciTypeTree: [],
    ciEditorVisible: false,
    ciEditorValues: { ...ciEditorConfig }
  };

  mode = "edit";

  handleCiClick = currentCi => {
    if (!currentCi) return;
    this.props.setActivedCI(currentCi);
    this.fetchCiTypeAttr(currentCi.ciTypeId);
  };

  handleMenuClick = menu => {
    this.props.setSelectedCatalog(menu);
    // this.fetchCiTypeAttr(menu.ciTypeId)
  };

  fetchCiTypeAttr = async id => {
    const data = await fetchCITypeAttrById(id);
    if (!(data instanceof Error)) {
      this.props.setCIAttributes(data);
    }
  };

  toAddCI = catalog => {
    this.setState({ ciEditorVisible: true });
  };

  toAddCi = () => {
    const { ciEditorValues } = this.state;
    const { selectedCatalog } = this.props;
    this.mode = "add";
    this.setState({
      ciEditorVisible: true,
      ciEditorValues: {
        ...ciEditorValues,
        catalogId: selectedCatalog.codeId
      }
    });
  };

  toEditCi = () => {
    const { ciTypeAttributes } = this.props;
    this.mode = "edit";
    this.setState({
      ciEditorVisible: true,
      ciEditorValues: pick(ciTypeAttributes, ciEditorConfig)
    });
  };

  toDeleteCi = async () => {
    const { activedCI } = this.props;
    if (activedCI.status === "notCreated") {
      const req = await deleteCiType(activedCI.ciTypeId);
      if (req === "Success") {
        CMDBMessage({
          message: "CI Type 删除成功"
        });

        this.resetSelectedCiType();
      }
    } else {
      CMDBMessage({
        message: `该 CI Type 状态为${activedCI.status}, 暂时无法被删除`,
        variant: "warning"
      });
    }
  };

  toApplyCi = async () => {
    const { activedCI } = this.props;
    if (activedCI.status === "notCreated" || activedCI.status === "dirty") {
      const req = await implementCiType(activedCI.ciTypeId, {
        operation: "apply"
      });
      if (req === "Success") {
        CMDBMessage({
          message: "CI Type 应用成功"
        });

        this.resetSelectedCiType();
      }
    } else {
      CMDBMessage({
        message: `该 CI Type 状态为${activedCI.status}, 暂时无法应用`,
        variant: "warning"
      });
    }
  };

  toRevertCiType = async () => {
    const { activedCI } = this.props;
    if (activedCI.status === "decommissioned") {
      const req = await implementCiType(activedCI.ciTypeId, {
        operation: "revert"
      });
      if (req === "Success") {
        CMDBMessage({
          message: "CI Type 回滚成功"
        });

        this.resetSelectedCiType();
      }
    } else {
      CMDBMessage({
        message: `该 CI Type 状态为${activedCI.status}, 暂时无法回滚`,
        variant: "warning"
      });
    }
  };

  toDecoCiType = async () => {
    const { activedCI } = this.props;
    if (activedCI.status === "created") {
      const res = await implementCiType(activedCI.ciTypeId, {
        operation: "deco"
      });
      if (res === "Success") {
        CMDBMessage({
          message: "CI Type 作废成功"
        });

        this.resetSelectedCiType();
      }
    } else {
      CMDBMessage({
        message: `该 CI Type 状态为${activedCI.status}, 暂时无法作废`,
        variant: "warning"
      });
    }
  };

  toDismissCiEditor = () => {
    this.setState({
      ciEditorVisible: false,
      ciEditorValues: { ...ciEditorConfig }
    });
  };

  toSubmit = async () => {
    if (this.mode === "edit") {
      const res = await updateCiType(this.state.ciEditorValues);
      if (res === "Success") {
        CMDBMessage({
          message: "编辑CI成功"
        });

        this.toDismissCiEditor();
        this.resetSelectedCiType();
      }
    } else {
      const res = await addCiType({
        ...this.state.ciEditorValues,
        ciTypeId: null
      });
      if (!(res instanceof Error) && res.ciTypeId) {
        CMDBMessage({
          message: "新增CI成功"
        });

        this.toDismissCiEditor();
        this.resetSelectedCiType();
      }
    }
  };

  resetSelectedCiType = async () => {
    const ciTypeTree = await fetchCatalogs();
    if (!(ciTypeTree instanceof Error)) {
      const { selectedCatalog, activedCI } = this.props;
      const matchedCat = ciTypeTree.find(
        _ => _.codeId === selectedCatalog.codeId
      );
      const matchedCiType = matchedCat.ciTypes.find(
        _ => _.ciTypeId === activedCI.ciTypeId
      );

      this.setState({ ciTypeTree });
      this.props.setActivedCI(matchedCiType);
      this.props.setSelectedCatalog(matchedCat);
    }
  };

  fetchCIUnionGroup = async id => {
    const data = await fetchUnionGroup(id);
    if (!(data instanceof Error)) {
      this.props.setUnionGroup(data);
    }
  };

  acceptEditorField = o => {
    const { ciEditorValues } = this.state;
    this.setState({ ciEditorValues: { ...ciEditorValues, ...o } });
  };

  componentDidMount = async () => {
    const ciTypeTree = await fetchCatalogs();
    if (ciTypeTree instanceof Error) {
      return;
    }
    let currentCi;
    for (let i = 0; i < ciTypeTree.length; i++) {
      if (ciTypeTree[i].ciTypes[0].ciTypeId) {
        currentCi = ciTypeTree[i].ciTypes[0];
        this.props.setSelectedCatalog(ciTypeTree[i]);
        break;
      }
    }

    this.props.setActivedCI(currentCi);

    this.setState({ ciTypeTree });
    this.fetchCiTypeAttr(currentCi.ciTypeId);
    this.fetchCIUnionGroup(currentCi.ciTypeId);
  };

  render() {
    const { classes, selectedCatalog, activedCI } = this.props;
    const { ciTypeTree, ciEditorVisible, ciEditorValues } = this.state;
    const { mode } = this;

    return (
      <div className={classes.root}>
        <Menu
          dir="vertical"
          data={ciTypeTree}
          className={classes.menu}
          menuClasses={{ selected: "selected" }}
          onItemClick={this.handleCiClick}
          onMenuClick={this.handleMenuClick}
        />
        <div className="global-main-content">
          <Paper elevation={0}>
            <p className={classes.currentCatalog}>
              {selectedCatalog.value} > {activedCI.name}
              <Tooltip title="添加 CI Type" style={{ marginLeft: 10 }}>
                <IconButton aria-label="add ci type" onClick={this.toAddCi}>
                  <AddIcon />
                </IconButton>
              </Tooltip>
              <Tooltip title="编辑 CI Type">
                <IconButton aria-label="edit ci type" onClick={this.toEditCi}>
                  <EditIcon />
                </IconButton>
              </Tooltip>
              <Tooltip title="删除 CI Type">
                <IconButton
                  aria-label="delete ci type"
                  onClick={this.toDeleteCi}
                >
                  <DeleteForEverIcon />
                </IconButton>
              </Tooltip>
              <Tooltip title="应用 CI Type">
                <IconButton aria-label="apply ci type" onClick={this.toApplyCi}>
                  <BuildIcon />
                </IconButton>
              </Tooltip>
              <Tooltip title="作废 CI Type">
                <IconButton
                  aria-label="deco ci type"
                  onClick={this.toDecoCiType}
                >
                  <DeleteIcon />
                </IconButton>
              </Tooltip>
              <Tooltip title="回滚 CI Type">
                <IconButton
                  aria-label="revert ci type"
                  onClick={this.toRevertCiType}
                >
                  <RestoreFromTrashIcon />
                </IconButton>
              </Tooltip>
            </p>
            <InformationManagement />
          </Paper>
        </div>
        <CiEditor
          mode={mode}
          values={ciEditorValues}
          open={ciEditorVisible}
          onCancel={this.toDismissCiEditor}
          onOk={this.toSubmit}
          onFieldChange={this.acceptEditorField}
        />
      </div>
    );
  }
}

const mapState = state => {
  return {
    activedCI: state.configManagement.activedCI,
    selectedCatalog: state.configManagement.selectedCatalog,
    ciTypeAttributes: state.configManagement.ciTypeAttributes
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
)(withStyles(styles)(ConfigManagement));
