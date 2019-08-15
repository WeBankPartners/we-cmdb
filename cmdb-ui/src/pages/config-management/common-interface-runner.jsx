import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  Paper,
  IconButton,
  FormControl,
  InputLabel,
  Tabs,
  Tab,
  Grid,
  Tooltip
} from "@material-ui/core";
import {
  Search as SearchIcon,
  RemoveRedEye as RemoveRedEyeIcon,
  Clear as ClearIcon
} from "@material-ui/icons";
import {
  fetchQueries,
  fetchCatalogs,
  executeIntQuery,
  fetchIntQueryHeader
} from "../../apis/endpoints";
import CMDBSelect from "../../components/cmdb-select";
import Menu from "../../components/menu";
import CMDBMessage from "../../components/cmdb-message";
import CMDBTable from "../../components/cmdb-table";
import QueryHeader from "../../components/query-header";

const styles = theme => ({
  root: {
    position: "relative",
    margin: "0 20px",
    height: "100%"
  },
  menu: {
    width: 200,
    position: "absolute",
    left: 0,
    top: 0,
    height: "100%",
    background: "#fff"
  },
  form: {
    display: "flex",
    padding: 20,
    justifyContent: "flex-end"
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
    "&$tabSelected": {
      color: "#1890ff",
      fontWeight: theme.typography.fontWeightMedium
    },
    "&:focus": {
      color: "#40a9ff"
    }
  },
  tabSelected: {}
});

class CommonInterfaceRunner extends React.Component {
  state = {
    currentCi: {},
    ciTypeTree: [],
    input: null,
    tableContent: {},
    tableData: [],
    tabValue: 0,
    filters: {},
    headers: []
  };

  handleInputChange = value => {
    if (Array.isArray(value) && value.length) {
      this.setState({ input: value[0].id });
    }
  };

  searchQueryHeaders = async () => {
    const res = await fetchIntQueryHeader(this.state.input);
    if (!(res instanceof Error)) {
      const headers = res.reduce((pre, cur) => {
        if (cur.attrUnits) {
          pre = pre.concat({
            title: cur.ciTypeName,
            children: cur.attrUnits.map(attrs => {
              let propertyName = "";
              if (
                attrs.attr.inputType === "ref" ||
                attrs.attr.inputType === "multiRef"
              ) {
                propertyName = attrs.attrKey + ".key_name";
              } else if (
                attrs.attr.inputType === "select" ||
                attrs.attr.inputType === "multiSelect"
              ) {
                propertyName = attrs.attrKey + ".value";
              } else {
                propertyName = attrs.attrKey;
              }
              return {
                ...attrs.attr,
                propertyName,
                title: attrs.attr.name,
                dataIndex: propertyName
              };
            })
          });
        }

        return pre;
      }, []);

      this.searchTable();

      this.setState({ headers, tabValue: 0 });
    }
  };

  handleTabChange = (event, tabValue) => {
    this.setState({ tabValue });
  };

  handleCiClick = async currentCi => {
    if (!currentCi) return;
    this.setState({ currentCi, ciGraphData: currentCi });
  };

  searchQueryList = name => {
    return fetchQueries(this.state.currentCi.ciTypeId, name);
  };

  searchTable = async () => {
    const { input } = this.state;
    if (!input) {
      CMDBMessage({
        message: "请先选择综合查询实例",
        variant: "warning"
      });

      return;
    }
    const res = await executeIntQuery(input);
    if (!(res instanceof Error)) {
      this.setState({ tableData: res.contents });
    }
  };

  handleQueryHeaderChange = (key, value) => {
    const { filters } = this.state;
    this.setState({ filters: { ...filters, [key]: value } });
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
    this.setState({ currentCi, ciTypeTree });
  };

  render() {
    const { classes } = this.props;
    const { ciTypeTree, tableData, tabValue, headers, filters } = this.state;

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
            <IconButton onClick={this.searchQueryHeaders}>
              <SearchIcon />
            </IconButton>
          </Paper>
          <Paper elevation={0} style={{ marginTop: 20, padding: 20 }}>
            <Tabs
              value={tabValue}
              onChange={this.handleTabChange}
              classes={{
                root: classes.tabsRoot,
                indicator: classes.tabsIndicator
              }}
            >
              {headers.map(header => {
                return (
                  <Tab
                    key={header.title}
                    label={header.title}
                    classes={{
                      root: classes.tabRoot,
                      selected: classes.tabSelected
                    }}
                  />
                );
              })}
            </Tabs>
            {headers.map((header, index) => {
              return (
                tabValue === index && (
                  <QueryHeader
                    key={header.title}
                    columns={header.children}
                    data={filters}
                    keys={["name", "propertyName"]}
                    onChange={this.handleQueryHeaderChange}
                  />
                )
              );
            })}

            <Grid container justify="flex-end" className={classes.tools}>
              <Grid item>
                <Tooltip
                  title={`显示隐藏列`}
                  style={{ marginLeft: 10 }}
                  placement="top"
                >
                  <IconButton
                    onClick={this.toShowColumnsPopover}
                    // aria-owns={open ? "simple-popper" : undefined}
                    aria-haspopup="true"
                  >
                    <RemoveRedEyeIcon />
                    {/* <ColumnFilters
									columns={columns}
									anchorEl={anchorEl}
									onClose={this.toDismissColumnFilters}
									onChange={this.handleColumnChange}
									/> */}
                  </IconButton>
                </Tooltip>
                <Tooltip
                  title={`清空`}
                  style={{ marginLeft: 10 }}
                  placement="top"
                >
                  <IconButton onClick={this.clearAllFilters}>
                    <ClearIcon />
                  </IconButton>
                </Tooltip>
                <Tooltip
                  title={`搜索`}
                  style={{ marginLeft: 10 }}
                  placement="top"
                >
                  <IconButton onClick={this.searchTable}>
                    <SearchIcon />
                  </IconButton>
                </Tooltip>
              </Grid>
            </Grid>
          </Paper>
          <Paper elevation={0} style={{ marginTop: 20 }}>
            <CMDBTable
              select={false}
              columns={headers}
              source={tableData}
              hasPagination={false}
              onSort={this.handleSortChange}
            />
          </Paper>
        </div>
      </div>
    );
  }
}

export default withStyles(styles)(CommonInterfaceRunner);
