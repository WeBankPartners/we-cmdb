import React from "react";
import produce from "immer";
import { withStyles } from "@material-ui/core/styles";
import { Grid, Tabs, Tab, IconButton, Paper, Tooltip } from "@material-ui/core";
import {
  Search as SearchIcon,
  Add as AddIcon,
  RemoveRedEye as RemoveRedEyeIcon,
  CloudDownload as DownloadIcon,
  CloudUpload as UploadIcon,
  Clear as ClearIcon
} from "@material-ui/icons";
import Menu from "../../components/menu";
import CMDBTable from "../../components/cmdb-table";
import CMDBMessage from "../../components/cmdb-message";
import {
  fetchCatalogs,
  fetchCiFilters,
  fetchCis,
  addCi,
  updateCi,
  deleteCi
} from "../../apis/endpoints";
import ColumnFilters from "./column-filters";
import QueryHeader from "../../components/query-header";
import CiEditor from "./ci-editor";
import {
  genFilters,
  genIndexCode,
  genIndexValue,
  getValueByIndexCode
} from "../../utils/object";

const styles = theme => ({
  root: {
    position: "relative",
    height: "100%"
  },
  paper: {
    padding: 20
  },
  menu: {
    width: "200px",
    position: "fixed",
    left: 0,
    top: 0,
    background: "#fff",
    height: "100%",
    paddingTop: 84,
    paddingBottom: 84,
    ul: {
      paddingBottom: 84
    },
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
  }
});

const menuLabels = {
  parent: "value",
  child: "name",
  childrenKey: "ciTypes"
};

class QueryConfig extends React.Component {
  state = {
    catTypes: [],
    currentCi: {},
    headers: [],
    tabValue: 0,
    tableData: [],
    columns: [],
    filters: {},
    anchorEl: null,
    visible: false,
    pageable: {
      pageSize: 10,
      startIndex: 0,
      totalRows: 0,
      currentPage: 0
    },
    ciEditorValues: {}
  };

  tempCatTypes = {};
  sortring = {};
  paging = true;
  ciEditorMode = "edit"; // edit or new

  tableActions = [
    {
      name: "编辑",
      handler: row => this.toEditCi(row)
    },
    {
      name: "删除",
      handler: row => this.toDeleteCi(row)
    }
  ];

  toDeleteCi = async row => {
    const res = await deleteCi(this.state.currentCi.ciTypeId, row.guid);
    if (!(res instanceof Error)) {
      CMDBMessage({
        message: "删除 CI 成功"
      });

      this.search();
    }
  };

  toAddCi = () => {
    this.ciEditorMode = "new";
    this.setState({ visible: true });
  };

  toEditCi = async row => {
    this.ciEditorMode = "edit";
    const keys = Object.keys(row);
    const o = {};
    keys.forEach(k => {
      const headerItem = this.state.headers.find(
        header => header.propertyName === k
      );
      if (headerItem) {
        if (!headerItem.isHidden) {
          o[k] = {
            name: k,
            value: getValueByIndexCode(
              row,
              genIndexCode(headerItem.propertyName, headerItem.inputType)
            )
          };
        }
      }
    });

    this.setState({ ciEditorValues: o, visible: true });
  };
  handleMenuClick = currentCat => {
    this.setState({ currentCat: currentCat });
  };

  handleTabChange = (event, tabValue) => {
    this.setState({ tabValue });
  };

  handleTypeClick = async type => {
    if (!type) return;
    const headersSource = await fetchCiFilters(type.ciTypeId);
    const { contents: cis } = await fetchCis(type.ciTypeId);
    this.setState({ currentCi: type });
    if (!(headersSource instanceof Error)) {
      const { headers, columns } = this.genHeadersAndColumns(headersSource);
      this.setState({ headers, columns });
    }
    if (cis && !(cis instanceof Error)) {
      const tableData = cis.map(_ => _.data);
      this.setState({ tableData });
    }
  };

  handleQueryHeaderChange = (key, value, operator) => {
    const { filters } = this.state;
    this.setState({
      filters: { ...filters, [key]: { name: key, value, operator } }
    });
  };

  handleAddRowChange = (key, value) => {
    const { addRowParams } = this.state;
    this.setState({ addRowParams: { ...addRowParams, [key]: value } });
  };

  toShowColumnsPopover = event => {
    event.stopPropagation();
    this.setState({
      anchorEl: event.currentTarget
    });
  };

  toDismissColumnFilters = event => {
    event.stopPropagation();
    this.setState({
      anchorEl: void 0
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
    const { pageable, currentCi } = this.state;
    const { paging } = this;
    const { contents: cis, pageInfo } = await fetchCis(currentCi.ciTypeId, {
      filters: genFilters(this.state.filters),
      sorting: this.sorting,
      paging,
      pageable
    });
    if (cis && !(cis instanceof Error)) {
      const tableData = cis.map(_ => _.data);
      this.setState({ tableData, pageable: { ...pageable, ...pageInfo } });
    }
  };

  handleColumnChange = item => {
    const { columns } = this.state;
    const index = columns.findIndex(_ => _ === item);
    item.selected = !item.selected;
    this.setState(
      produce(state => {
        state.columns.splice(index, 1, item);
      })
    );
  };

  onOk = () => {
    if (this.ciEditorMode === "new") {
      this.submitAddCi();
    } else {
      this.submitUpdateCi();
    }
  };

  submitAddCi = async () => {
    const o = this.getFormData();
    const { currentCi } = this.state;
    const res = await addCi(currentCi.ciTypeId, o);
    if (!(res instanceof Error)) {
      CMDBMessage({
        message: "新增 CI 成功"
      });

      this.setState({ visible: false, ciEditorValues: {} });
      this.search();
    }
  };

  submitUpdateCi = async () => {
    const o = this.getFormData();
    const { currentCi } = this.state;
    const res = await updateCi(currentCi.ciTypeId, o);
    if (!(res instanceof Error)) {
      CMDBMessage({
        message: "更新 CI 成功"
      });

      this.setState({ visible: false, ciEditorValues: {} });
      this.search();
    }
  };

  getFormData = () => {
    const o = {};
    const { ciEditorValues } = this.state;
    Object.keys(ciEditorValues).forEach(k => {
      if (Array.isArray(ciEditorValues[k].value)) {
        o[k] = ciEditorValues[k].value.join(",");
      } else {
        o[k] = ciEditorValues[k].value;
      }
    });
    return o;
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

  handleCiEditorChange = (name, value) => {
    this.setState(
      produce(state => {
        state.ciEditorValues[name] = { name, value };
      })
    );
  };

  genHeadersAndColumns = source => {
    const headers = source.filter(header => {
      if (header.isHidden === true) {
        return false;
      } else {
        if (header.status === "created" || header.status === "dirty") {
          return true;
        } else {
          return false;
        }
      }
    });

    const columns = headers.map(_ => {
      return {
        title: _.name,
        dataIndex: genIndexValue(_.propertyName, _.inputType || ""),
        selected: true,
        order: "asc",
        propertyName: _.propertyName, //排序时传参
        width: 120
      };
    });

    return { headers, columns };
  };

  componentDidMount = async () => {
    const catTypes = await fetchCatalogs();
    let currentCi;
    for (let i = 0; i < catTypes.length; i++) {
      if (catTypes[i].ciTypes[0].ciTypeId) {
        currentCi = catTypes[i].ciTypes[0];
        break;
      }
    }

    const source = await fetchCiFilters(currentCi.ciTypeId);
    const { headers, columns } = this.genHeadersAndColumns(source);

    this.setState(
      {
        headers,
        currentCi,
        catTypes,
        columns
      },
      this.search
    );
  };

  render() {
    const {
      catTypes,
      headers,
      tabValue,
      tableData,
      columns,
      filters,
      anchorEl,
      visible,
      pageable,
      ciEditorValues
    } = this.state;
    const { classes } = this.props;
    const open = Boolean(anchorEl);
    // 只有status为created和dirty时， 才能添加数据
    const ciEditorHeaders = headers.map(header => {
      if (header.inputType === "date") {
        return { ...header, inputType: "datetime" };
      } else {
        return header;
      }
    });

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
        />
        <div className="global-main-content">
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
                keys={["name", "propertyName"]}
                data={filters}
                onChange={this.handleQueryHeaderChange}
              />
            )}
            {tabValue === 1 && (
              <QueryHeader
                isQuery={true}
                data={filters}
                columns={headers}
                keys={["name", "propertyName"]}
                onChange={this.handleQueryHeaderChange}
              />
            )}
            <Grid container justify="flex-end" className={classes.tools}>
              <Grid item>
                <Tooltip
                  title={`新增`}
                  style={{ marginLeft: 10 }}
                  placement="top"
                >
                  <IconButton onClick={this.toAddCi}>
                    <AddIcon />
                  </IconButton>
                </Tooltip>
                <Tooltip
                  title={`下载`}
                  style={{ marginLeft: 10 }}
                  placement="top"
                >
                  <IconButton onClick={this.toAddType}>
                    <DownloadIcon />
                  </IconButton>
                </Tooltip>
                <Tooltip
                  title={`显示隐藏列`}
                  style={{ marginLeft: 10 }}
                  placement="top"
                >
                  <IconButton
                    onClick={this.toShowColumnsPopover}
                    aria-owns={open ? "simple-popper" : undefined}
                    aria-haspopup="true"
                  >
                    <RemoveRedEyeIcon />
                    <ColumnFilters
                      columns={columns}
                      anchorEl={anchorEl}
                      onClose={this.toDismissColumnFilters}
                      onChange={this.handleColumnChange}
                    />
                  </IconButton>
                </Tooltip>
                <Tooltip
                  title={`上传数据`}
                  style={{ marginLeft: 10 }}
                  placement="top"
                >
                  <IconButton onClick={this.toAddType}>
                    <UploadIcon />
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
              actions={this.tableActions}
            />
          </Paper>
        </div>
        <CiEditor
          title={this.ciEditorMode === "new" ? "新增" : "编辑"}
          values={ciEditorValues}
          visible={visible}
          columns={ciEditorHeaders}
          onOk={this.onOk}
          onCancel={() => this.setState({ visible: false, ciEditorValues: {} })}
          onChange={this.handleCiEditorChange}
        />
      </div>
    );
  }
}

export default withStyles(styles)(QueryConfig);
