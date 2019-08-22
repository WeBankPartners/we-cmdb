import React from "react";
import produce from "immer";
import { withStyles } from "@material-ui/core/styles";
import { Grid, Tabs, Tab, IconButton, Paper, Tooltip } from "@material-ui/core";
import { Search as SearchIcon, Clear as ClearIcon } from "@material-ui/icons";
import CMDBTable from "../../components/cmdb-table";
import QueryHeader from "../../components/query-header";
import { logQuerys, fetchLogQuerys } from "../../apis/endpoints";
import { genFilters, genIndexValue } from "../../utils/object";

const styles = theme => ({
  root: {
    position: "relative",
    height: "100%",
    padding: 20
  },
  paper: {
    padding: 20
  },
  menu: {
    width: "200px",
    position: "absolute",
    left: 0,
    top: 0,
    background: "#fff",
    height: "100%",
    "&  li.selected": {
      background: "transparent",
      position: "relative",
      color: "#2196f3"
    }
  },
  main: {
    width: "100%",
    paddingLeft: 200,
    boxSizing: "border-box"
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
  tabSelected: {},
  paperTable: {
    marginTop: 20
  },
  tools: {
    marginTop: 20
  },
  popoverContent: {
    padding: 20
  },
  timePicker: {
    display: "flex"
  }
});

class QueryLog extends React.Component {
  state = {
    headers: [],
    tabValue: 0,
    tableData: [],
    columns: [],
    filters: {},
    paging: true,
    pageable: {
      pageSize: 10,
      startIndex: 0,
      totalRows: 0,
      currentPage: 0
    }
  };

  sortring = {};
  paging = true;

  handleTabChange = (event, tabValue) => {
    this.setState({ tabValue });
  };

  handleQueryHeaderChange = (key, value, operator) => {
    let { filters } = this.state;
    if (Array.isArray(value) && !value.length && filters[key]) {
      delete filters[key];
    } else {
      filters = { ...filters, [key]: { name: key, value, operator } };
    }
    this.setState({
      filters
    });
  };

  clearAllFilters = () => {
    this.setState(
      {
        filters: {}
      },
      this.search
    );
  };

  search = async () => {
    const { pageable } = this.state;
    const { paging } = this;
    const { contents: tableData, pageInfo } = await fetchLogQuerys({
      filters: genFilters(this.state.filters),
      sorting: this.sorting,
      paging,
      pageable
    });
    if (tableData) {
      this.setState({ tableData, pageable: { ...pageable, ...pageInfo } });
    }
  };

  handleSortChange = item => {
    const { columns } = this.state;
    const index = columns.findIndex(_ => _ === item);
    item.order = item.order === "desc" ? "asc" : "desc";
    this.setState(
      produce(state => {
        state.columns.splice(index, 1, item);
      })
    );

    this.sorting = {
      asc: item.order === "desc" ? false : true,
      field: item.propertyName
    };

    this.search();
  };

  handleTablePage = currentPage => {
    const { pageable } = this.state;
    this.setState(
      {
        pageable: {
          ...pageable,
          currentPage,
          startIndex: currentPage * pageable.pageSize
        }
      },
      this.search
    );
  };

  handleRowsPerPageChange = num => {
    this.setState(
      produce(state => {
        state.pageable.pageSize = num;
      })
    );
  };

  componentDidMount = async () => {
    const headers = await logQuerys();
    await this.search();

    const columns = headers.map(_ => {
      return {
        title: _.name,
        dataIndex: genIndexValue(_.name, _.inputType),
        selected: true,
        order: "asc",
        propertyName: _.name //排序时传参
      };
    });

    this.setState({ headers, columns });
  };

  render() {
    const {
      headers,
      tabValue,
      tableData,
      columns,
      filters,
      pageable
    } = this.state;
    const { classes } = this.props;

    return (
      <div className={classes.root}>
        <div>
          <Paper className={classes.paper} elevation={0}>
            <Tabs
              value={tabValue}
              onChange={this.handleTabChange}
              classes={{
                root: classes.tabsRoot,
                indicator: classes.tabsIndicator
              }}
            >
              <Tab
                label="查询条件"
                classes={{
                  root: classes.tabRoot,
                  selected: classes.tabSelected
                }}
              />
              <Tab
                label="高级查询"
                classes={{
                  root: classes.tabRoot,
                  selected: classes.tabSelected
                }}
              />
            </Tabs>
            {tabValue === 0 && (
              <QueryHeader
                isQuery={true}
                columns={headers.slice(0, 4)}
                data={filters}
                keys={["name", "name"]}
                onChange={this.handleQueryHeaderChange}
              />
            )}
            {tabValue === 1 && (
              <QueryHeader
                isQuery={true}
                data={filters}
                keys={["name", "name"]}
                columns={headers}
                onChange={this.handleQueryHeaderChange}
              />
            )}
            <Grid container justify="flex-end" className={classes.tools}>
              <Grid item>
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
                  <IconButton onClick={this.search}>
                    <SearchIcon />
                  </IconButton>
                </Tooltip>
              </Grid>
            </Grid>
          </Paper>
          <Paper className={classes.paperTable} elevation={0}>
            <CMDBTable
              select={false}
              columns={columns.filter(_ => _.selected)}
              source={tableData}
              hasPagination
              onSort={this.handleSortChange}
              rowsPerPage={pageable.pageSize}
              count={pageable.totalRows}
              currentPage={pageable.currentPage}
              onPageChange={this.handleTablePage}
              onRowsPerPageChange={this.handleRowsPerPageChange}
            />
          </Paper>
        </div>
      </div>
    );
  }
}

export default withStyles(styles)(QueryLog);
