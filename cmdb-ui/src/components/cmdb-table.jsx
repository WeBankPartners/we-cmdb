import React from "react";
import PropTypes from "prop-types";
import { withStyles } from "@material-ui/core/styles";
import {
  Table,
  Checkbox,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
  Paper,
  TableFooter,
  TablePagination,
  Button,
  TableSortLabel
} from "@material-ui/core";
import IconButton from "@material-ui/core/IconButton";
import FirstPageIcon from "@material-ui/icons/FirstPage";
import KeyboardArrowLeft from "@material-ui/icons/KeyboardArrowLeft";
import KeyboardArrowRight from "@material-ui/icons/KeyboardArrowRight";
import LastPageIcon from "@material-ui/icons/LastPage";
import produce from "immer";
import { getValueByIndexCode } from "../utils/object";
const CustomTableCell = withStyles(theme => ({
  head: {
    backgroundColor: "#e0e0e0",
    borderRight: "1px solid gray",
    borderBottom: "1px solid gray",
    borderTop: "1px solid gray",
    "&:last-child": {
      borderRight: "none"
    }
  },
  body: {
    fontSize: 14
  }
}))(TableCell);

const styles = theme => ({
  root: {
    width: "100%",
    overflowX: "auto"
  },
  table: {
    minWidth: 700,
    tableLayout: "fixed"
  },
  row: {
    "&:nth-of-type(even)": {
      backgroundColor: theme.palette.background.default
    }
  }
});

const actionsStyles = theme => ({
  root: {
    flexShrink: 0,
    color: theme.palette.text.secondary,
    marginLeft: theme.spacing.unit * 2.5
  }
});

class TablePaginationActions extends React.Component {
  handleFirstPageButtonClick = event => {
    this.props.onChangePage(event, 0);
  };

  handleBackButtonClick = event => {
    this.props.onChangePage(event, this.props.page - 1);
  };

  handleNextButtonClick = event => {
    this.props.onChangePage(event, this.props.page + 1);
  };

  handleLastPageButtonClick = event => {
    this.props.onChangePage(
      event,
      Math.max(0, Math.ceil(this.props.count / this.props.rowsPerPage) - 1)
    );
  };

  render() {
    const { classes, count, page, rowsPerPage, theme } = this.props;

    return (
      <div className={classes.root}>
        <IconButton
          onClick={this.handleFirstPageButtonClick}
          disabled={page === 0}
          aria-label="First Page"
        >
          {theme.direction === "rtl" ? <LastPageIcon /> : <FirstPageIcon />}
        </IconButton>
        <IconButton
          onClick={this.handleBackButtonClick}
          disabled={page === 0}
          aria-label="Previous Page"
        >
          {theme.direction === "rtl" ? (
            <KeyboardArrowRight />
          ) : (
            <KeyboardArrowLeft />
          )}
        </IconButton>
        <IconButton
          onClick={this.handleNextButtonClick}
          disabled={page >= Math.ceil(count / rowsPerPage) - 1}
          aria-label="Next Page"
        >
          {theme.direction === "rtl" ? (
            <KeyboardArrowLeft />
          ) : (
            <KeyboardArrowRight />
          )}
        </IconButton>
        <IconButton
          onClick={this.handleLastPageButtonClick}
          disabled={page >= Math.ceil(count / rowsPerPage) - 1}
          aria-label="Last Page"
        >
          {theme.direction === "rtl" ? <FirstPageIcon /> : <LastPageIcon />}
        </IconButton>
      </div>
    );
  }
}

TablePaginationActions.propTypes = {
  classes: PropTypes.object.isRequired,
  count: PropTypes.number.isRequired,
  onChangePage: PropTypes.func.isRequired,
  page: PropTypes.number.isRequired,
  rowsPerPage: PropTypes.number.isRequired,
  theme: PropTypes.object.isRequired
};

const TablePaginationActionsWrapped = withStyles(actionsStyles, {
  withTheme: true
})(TablePaginationActions);

class CMDBTable extends React.Component {
  state = {
    selected: []
  };
  handleChangePage = (event, page) => {
    this.props.onPageChange && this.props.onPageChange(page);
  };

  handleChangeRowsPerPage = event => {
    this.props.onRowsPerPageChange &&
      this.props.onRowsPerPageChange(event.target.value);
  };

  handleRowCheckbox = row => {
    const id = row.ciTypeAttrId;
    const found = this.state.selected.indexOf(id);
    if (found === -1) {
      this.setState(
        produce(state => {
          state.selected.push(id);
        }),
        () => {
          this.props.onSelectedChange &&
            this.props.onSelectedChange(this.state.selected);
        }
      );
    } else {
      this.setState(
        produce(state => {
          state.selected.splice(found, 1);
        }),
        () => {
          this.props.onSelectedChange &&
            this.props.onSelectedChange(this.state.selected);
        }
      );
    }
  };

  handleSelectAll = e => {
    e.persist();
    if (e.target.checked) {
      this.setState(
        {
          selected: this.props.source.map(_ => _.ciTypeAttrId)
        },
        () => {
          this.props.onSelectedChange &&
            this.props.onSelectedChange(this.state.selected);
        }
      );
    } else {
      this.setState(
        {
          selected: []
        },
        () => {
          this.props.onSelectedChange &&
            this.props.onSelectedChange(this.state.selected);
        }
      );
    }
  };

  isSelected = id => {
    return this.state.selected.indexOf(id) > -1;
  };

  displayText = t => {
    if (typeof t === "boolean") {
      return t ? "是" : "否";
    } else {
      return t;
    }
  };

  render() {
    const {
      classes,
      columns,
      source,
      hasPagination,
      actions,
      select
    } = this.props;
    const { selected } = this.state;
    const { rowsPerPage, count, currentPage } = this.props;
    const numSelected = selected.length;

    if (!columns.length) {
      return null;
    }

    let nestedHeaders = columns.reduce((pre, cur) => {
      pre = pre.concat(cur.children ? cur.children : []);
      return pre;
    }, []);

    return (
      <Paper className={classes.root} elevation={0}>
        <Table className={classes.table}>
          <TableHead>
            <TableRow>
              {select && (
                <CustomTableCell
                  padding="none"
                  className={classes.head}
                  rowSpan={nestedHeaders.length ? 2 : 1}
                  width={60}
                  align="center"
                >
                  <Checkbox
                    indeterminate={
                      numSelected > 0 && numSelected < source.length
                    }
                    checked={numSelected > 0 && numSelected === source.length}
                    onChange={this.handleSelectAll}
                  />
                </CustomTableCell>
              )}
              {columns.map(c => {
                return (
                  <CustomTableCell
                    align="center"
                    padding="none"
                    width={c.width}
                    key={c.title}
                    className={classes.head}
                    colSpan={c.children ? c.children.length : 1}
                  >
                    {this.props.onSort ? (
                      <TableSortLabel
                        active={true}
                        direction={c.order}
                        onClick={() => this.props.onSort(c)}
                      >
                        {c.title}
                      </TableSortLabel>
                    ) : (
                      c.title
                    )}
                  </CustomTableCell>
                );
              })}
              {(actions || this.props.renderActions) && (
                <CustomTableCell
                  key="操作"
                  align="center"
                  padding="none"
                  className={classes.head}
                  width={
                    actions
                      ? actions[0].size
                        ? actions[0].size
                        : actions.length * 70
                      : 120
                  }
                  style={{ color: "rgba(0, 0, 0, 0.87)" }}
                >
                  操作
                </CustomTableCell>
              )}
            </TableRow>
            {nestedHeaders.length ? (
              <TableRow>
                {nestedHeaders.map((header, index) => {
                  return (
                    <CustomTableCell
                      key={header.title + index}
                      align={"left"}
                      padding="none"
                      width={header.width}
                    >
                      {header.title}
                    </CustomTableCell>
                  );
                })}
              </TableRow>
            ) : null}
          </TableHead>
          <TableBody>
            {source.map((row, index) => {
              return (
                <TableRow className={classes.row} key={index}>
                  {select && (
                    <TableCell padding="none" width={60} align="center">
                      <Checkbox
                        checked={this.isSelected(row.ciTypeAttrId)}
                        onChange={() => this.handleRowCheckbox(row)}
                      />
                    </TableCell>
                  )}
                  {(nestedHeaders.length ? nestedHeaders : columns).map(
                    (_, index) => (
                      <CustomTableCell
                        align="center"
                        padding="none"
                        key={index}
                      >
                        {this.displayText(
                          _.valueMap
                            ? _.valueMap[getValueByIndexCode(row, _.dataIndex)]
                            : getValueByIndexCode(row, _.dataIndex)
                        )}
                      </CustomTableCell>
                    )
                  )}
                  {actions && actions.length ? (
                    <TableCell
                      //   colSpan={actions.length}
                      align="center"
                      padding="none"
                    >
                      {actions.map(action => {
                        return (
                          <Button
                            key={action.name}
                            onClick={() => action.handler(row)}
                          >
                            {action.name}
                          </Button>
                        );
                      })}
                    </TableCell>
                  ) : this.props.renderActions ? (
                    this.props.renderActions(row)
                  ) : null}
                </TableRow>
              );
            })}
          </TableBody>
          {hasPagination && (
            <TableFooter className="footer">
              <TableRow>
                <TablePagination
                  rowsPerPageOptions={[5, 10, 25]}
                  colSpan={4}
                  count={count}
                  rowsPerPage={rowsPerPage}
                  page={currentPage}
                  onChangePage={this.handleChangePage}
                  onChangeRowsPerPage={this.handleChangeRowsPerPage}
                  ActionsComponent={TablePaginationActionsWrapped}
                />
              </TableRow>
            </TableFooter>
          )}
        </Table>
      </Paper>
    );
  }
}

CMDBTable.defaultProps = {
  hasPagination: true,
  select: false
};

CMDBTable.propTypes = {
  classes: PropTypes.object,
  columns: PropTypes.array.isRequired,
  source: PropTypes.array.isRequired,
  hasPagination: PropTypes.bool,
  select: PropTypes.bool,
  renderActions: PropTypes.func
};

export default withStyles(styles)(CMDBTable);
