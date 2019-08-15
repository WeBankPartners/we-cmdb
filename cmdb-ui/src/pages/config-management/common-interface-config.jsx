import React from "react";
import { withStyles, createStyles } from "@material-ui/core/styles";
import {
  Paper,
  IconButton,
  FormControl,
  Input,
  InputLabel,
  Tooltip
} from "@material-ui/core";
import {
  Search as SearchIcon,
  Add as AddIcon,
  SaveAlt as SaveIcon
} from "@material-ui/icons";
import {
  fetchCatalogs,
  fetchQueries,
  fetchIntQueryById,
  saveIntQuery
} from "../../apis/endpoints";
import CiGraph from "./ci-graph";
import Menu from "../../components/menu";
import CMDBSelect from "../../components/cmdb-select";
import CMDBDialog from "../../components/cmdb-dialog";
import CMDBMessage from "../../components/cmdb-message";

const styles = createStyles({
  root: {
    position: "relative"
  },
  textField: {
    width: "80%"
  },
  form: {
    padding: "20px",
    display: "flex",
    justifyContent: "flex-end"
  },
  formControl: {
    width: 400
  },
  menu: {
    width: 200,
    position: "absolute",
    left: 0,
    top: 0,
    height: "100%",
    background: "#fff"
  },
  content: {
    marginLeft: 220,
    marginTop: 20,
    paddingRight: 20
  },
  attrs: {
    padding: "10px 20px",
    "& h4": {
      margin: 0
    },
    "& li": {
      float: "left",
      padding: "0 15px",
      display: "inline-block",
      position: "relative",
      "&::before": {
        content: '""',
        width: 6,
        height: 6,
        borderRadius: "100%",
        background: "#2196f3",
        position: "absolute",
        top: "50%",
        left: 0,
        transform: "translateY(-3px)"
      }
    },
    "& ul": {
      padding: "5px 0 0 0",
      margin: 0,
      "&::after": {
        display: "table",
        content: "' '",
        clear: "both"
      }
    }
  }
});

class CommonInterfaceConfig extends React.Component {
  state = {
    currentCi: {},
    ciTypeTree: [],
    visible: false,
    search: "",
    selectedQueryId: null,
    ciGraphData: null,
    attrs: [],
    name: ""
  };

  handleCiClick = async currentCi => {
    if (!currentCi) return;
    this.setState({ currentCi, ciGraphData: currentCi });

    this.searchQueryList = name => {
      return fetchQueries(this.state.currentCi.ciTypeId, name);
    };
  };

  searchQueryList = name => {
    return fetchQueries(this.state.currentCi.ciTypeId, name);
  };

  searchQueryById = async () => {
    const res = await fetchIntQueryById(
      this.state.currentCi.ciTypeId,
      this.state.selectedQuery.id
    );
    if (!(res instanceof Error)) {
      const attrs = this.calCiTypeAttrs(res);
      this.setState({ ciGraphData: res, attrs });
    }
  };

  handleMenuClick = () => {};

  dismissDialog = () => {
    this.setState({ visible: false });
  };

  handleInputChange = query => {
    this.setState({ selectedQuery: query[0] });
  };

  handleCiGraphChange = data => {
    this.ciGraphResult = data;
    const attrs =
      Object.keys(data).reduce((pre, cur) => {
        if (data[cur].node.attrs && data[cur].node.attrs.length) {
          return pre.concat({
            label: data[cur].node.label,
            attrList: data[cur].node.attrs.map(_ => _.name)
          });
        } else {
          return pre;
        }
      }, []) || [];

    this.setState({ attrs });
  };

  calCiTypeAttrs = cis => {
    const ret = [];

    function helper(root) {
      if (!root) return;
      if (root.attrAliases && root.attrAliases.length) {
        ret.push({ label: root.name, attrList: root.attrAliases });
      }
      if (root.children) {
        root.children.map(child => helper(child));
      }
    }

    helper(cis);
    return ret;
  };

  treeifyCiTypes = () => {
    const { ciGraphResult } = this;
    if (!ciGraphResult) {
      return null;
    }
    const key = Object.keys(ciGraphResult).filter(
      // eslint-disable-next-line
      key => ciGraphResult[key].node.index == 1
    );
    const rootNode = ciGraphResult[key];

    function treefiy(root) {
      if (!root.from.length && !root.to.length)
        return {
          ciTypeId: root.node.ciTypeId,
          name: root.node.label,
          attrs: root.node.attrs
            ? root.node.attrs.map(_ => _ && _.ciTypeAttrId)
            : [],
          attrAliases: root.node.attrs
            ? root.node.attrs.map(_ => _ && _.name)
            : []
        };
      const t = {
        children: [],
        ciTypeId: root.node.ciTypeId,
        name: root.node.label,
        attrs: root.node.attrs
          ? root.node.attrs.map(_ => _ && _.ciTypeAttrId)
          : [],
        attrAliases: root.node.attrs
          ? root.node.attrs.map(_ => _ && _.name)
          : []
      };

      if (root.to) {
        t.children = [].concat(
          root.to.map(_ => {
            if (ciGraphResult[_.label]) {
              const ret = treefiy(ciGraphResult[_.label]);
              return {
                ...ret,
                attrs: _.attrs
                  ? _.attrs.map(attr => attr && attr.ciTypeAttrId)
                  : [],
                attrAliases: _.attrs ? _.attrs.map(_ => _ && _.name) : [],
                parentRs: {
                  attrId: _.refPropertyId,
                  isReferedFromParent: true
                }
              };
            } else {
              return {
                ciTypeId: _.ciTypeId,
                name: _.label,
                attrs: _.attrs
                  ? _.attrs.map(attr => attr && attr.ciTypeAttrId)
                  : [],
                attrAliases: _.attrs
                  ? _.attrs.map(attr => attr && attr.name)
                  : [],
                parentRs: {
                  attrId: _.refPropertyId,
                  isReferedFromParent: true
                }
              };
            }
          })
        );
      }

      if (root.from) {
        t.children = t.children.concat(
          root.from.map(_ => {
            if (ciGraphResult[_.label]) {
              const ret = treefiy(ciGraphResult[_.label]);
              return {
                ...ret,
                attrs: _.attrs
                  ? _.attrs.map(attr => attr && attr.ciTypeAttrId)
                  : [],
                attrAliases: _.attrs
                  ? _.attrs.map(attr => attr && attr.name)
                  : [],
                parentRs: {
                  attrId: _.refPropertyId,
                  isReferedFromParent: false
                }
              };
            } else {
              return {
                ciTypeId: _.ciTypeId,
                name: _.label,
                attrs: _.attrs
                  ? _.attrs.map(attr => attr && attr.ciTypeAttrId)
                  : [],
                attrAliases: _.attrs
                  ? _.attrs.map(attr => attr && attr.name)
                  : [],
                parentRs: {
                  attrId: _.refPropertyId,
                  isReferedFromParent: false
                }
              };
            }
          })
        );
      }

      return t;
    }

    return treefiy(rootNode);
  };

  save = async () => {
    if (!this.state.name.trim()) {
      CMDBMessage({
        variant: "warning",
        message: "请先添加综合查询接口名称"
      });
      return;
    }
    const reqData = this.treeifyCiTypes();
    if (!reqData) {
      CMDBMessage({
        variant: "warning",
        message: "请先添加CI配置"
      });
      return;
    }
    const res = await saveIntQuery(
      this.state.currentCi.ciTypeId,
      this.state.name,
      reqData
    );
    if (!(res instanceof Error)) {
      CMDBMessage({ message: "保存成功" });
    }
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
        break;
      }
    }
    this.setState({ currentCi, ciTypeTree, ciGraphData: currentCi });
  };

  render() {
    const { classes } = this.props;
    const { ciTypeTree, visible, ciGraphData, attrs } = this.state;
    return (
      <div className={classes.root}>
        <Menu
          dir="vertical"
          data={ciTypeTree}
          className={classes.menu}
          menuClasses={{ selected: "selected" }}
          onItemClick={this.handleCiClick}
        />
        <div className="global-main-content">
          <Paper className={classes.form} elevation={0}>
            <FormControl>
              <InputLabel>综合查询名称</InputLabel>
              <CMDBSelect
                onChange={this.handleInputChange}
                optLabels={["id", "name"]}
                onFetch={this.searchQueryList}
              />
            </FormControl>
            <IconButton onClick={this.searchQueryById}>
              <SearchIcon />
            </IconButton>
            <Tooltip title="添加综合查询接口名称" style={{ marginLeft: 10 }}>
              <IconButton onClick={() => this.setState({ visible: true })}>
                <AddIcon />
              </IconButton>
            </Tooltip>
            <Tooltip title="保存综合查询接口" style={{ marginLeft: 10 }}>
              <IconButton onClick={this.save}>
                <SaveIcon />
              </IconButton>
            </Tooltip>
          </Paper>
          <Paper elevation={0} style={{ marginTop: 20 }}>
            <CiGraph data={ciGraphData} onChange={this.handleCiGraphChange} />
          </Paper>

          <Paper elevation={0} style={{ marginTop: 20 }}>
            {attrs.map(attr => {
              return (
                <div className={classes.attrs} key={attr.label}>
                  <h4>{attr.label}</h4>
                  <ul>
                    {attr.attrList.map(_ => (
                      <li key={_}>{_}</li>
                    ))}
                  </ul>
                </div>
              );
            })}
          </Paper>
        </div>

        <CMDBDialog
          visible={visible}
          onCancel={this.dismissDialog}
          onOk={this.dismissDialog}
          title="添加综合查询接口名称"
        >
          <FormControl className={classes.formControl}>
            <InputLabel htmlFor="query">名称</InputLabel>
            <Input
              id="query"
              value={this.state.name}
              onChange={e => this.setState({ name: e.target.value })}
            />
          </FormControl>
        </CMDBDialog>
      </div>
    );
  }
}

export default withStyles(styles)(CommonInterfaceConfig);
