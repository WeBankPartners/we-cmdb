import "./table.scss";
import moment from "moment";
const DEFAULT_FILTER_NUMBER = 5;
const DATE_FORMAT = "YYYY-MM-DD HH:mm:ss";

export default {
  name: "WeTable",
  props: {
    tableColumns: { default: () => [], require: true },
    tableData: { default: () => [] },
    showCheckbox: { default: () => true },
    highlightRow: { default: () => false },
    filtersHidden: { default: () => false },
    tableOuterActions: { default: () => [] },
    tableInnerActions: { default: () => [] },
    pagination: { type: Object },
    ascOptions: { type: Object }
  },
  data() {
    return {
      form: {},
      selectedRows: [],
      data: [],
      isShowHiddenFilters: false
    };
  },
  mounted() {
    this.formatTableData();
  },
  watch: {
    tableData(val) {
      this.formatTableData();
      this.selectedRows = [];
    },
    tableColumns: {
      handler(val, oldval) {
        this.calColumn();
        this.tableColumns.forEach(_ => {
          if (_.children) {
            _.children.forEach(j => {
              if (!j.isNotFilterable) {
                this.$set(this.form, j.inputKey, "");
              }
            });
          } else {
            if (!_.isNotFilterable) {
              this.$set(this.form, _.inputKey, "");
            }
          }
        });
      },
      deep: true,
      immediate: true
    },
    ascOptions: {
      handler(val, oldval) {
        this.calColumn();
      },
      deep: true,
      immediate: true
    }
  },
  computed: {},
  methods: {
    pushNewAddedRowToSelections() {
      this.selectedRows.push(this.data[0]);
      this.$emit("getSelectedRows", this.selectedRows, true);
    },

    setAllRowsUneditable() {
      this.data.forEach(_ => (_.isRowEditable = false));
      this.selectedRows = [];
    },
    setTableData(disable) {
      const keys = Object.keys(this.data[0]);
      this.selectedRows.forEach(_ => {
        this.data.forEach(i => {
          if (i.weTableRowId === _.weTableRowId) {
            keys.forEach(k => {
              if (k !== "isRowEditable") {
                i[k] = _[k];
              }
            });
          }
        });
      });
      this.$nextTick(() => {
        this.setCheckoutStatus(disable);
      });
    },
    setCheckoutStatus(disable) {
      let objData = this.$refs.table.$refs.tbody.objData;
      for (let obj in objData) {
        objData[obj]._isChecked = false;
        objData[obj]._isDisabled = false;
      }
      this.selectedRows.forEach(_ => {
        const index = this.data.findIndex(
          el => el.weTableRowId === _.weTableRowId
        );
        objData[index]._isChecked = true;
        objData[index]._isDisabled = disable;
      });
    },
    rowCancelHandler(weId) {
      const index = this.selectedRows.findIndex(el => el.weTableRowId === weId);
      this.selectedRows.splice(index, 1);
      this.data.forEach(_ => {
        if (_.weTableRowId === weId) {
          _.isRowEditable = false;
        }
      });
      this.$nextTick(() => this.setCheckoutStatus(true));
      this.$emit("getSelectedRows", this.selectedRows, true);
    },
    swapRowEditable(status) {
      this.selectedRows.forEach(row => {
        this.data.forEach(_ => {
          if (_.weTableRowId === row.weTableRowId) {
            _.isRowEditable = status;
          }
        });
      });
    },
    formatTableData() {
      this.data = this.tableData.map((_, index) => {
        return {
          ..._,
          weTableRowId: index + 1,
          isRowEditable:
            _.isRowEditable && index === 0 ? _.isRowEditable : false,
          weTableForm: { ..._ }
        };
      });
      this.data.forEach(_ => {
        for (let i in _["weTableForm"]) {
          if (
            typeof _["weTableForm"][i] === "object" &&
            _["weTableForm"][i] !== null &&
            !Array.isArray(_["weTableForm"][i])
          ) {
            _[i] = _["weTableForm"][i].codeId || _["weTableForm"][i].guid;
            _["weTableForm"][i] =
              _["weTableForm"][i].value || _["weTableForm"][i].key_name;
          } else {
            if (Array.isArray(_["weTableForm"][i]) && i !== "nextOperations") {
              _["weTableForm"][i] = _["weTableForm"][i];
              const found = this.tableColumns.find(q => q.inputKey === i);

              if (found && found.inputType === "multiSelect") {
                _[i] = _["weTableForm"][i].map(j => j.codeId);
              }
              if (found && found.inputType === "multiRef") {
                _[i] = _["weTableForm"][i].map(j => j.guid);
              }
            }
          }
          // const found = this.tableColumns.find(q => q.inputKey === i);
          // if (found && found.isRefreshable) {
          //   _[i] = "";
          // }
        }
      });
    },
    handleSubmit(ref) {
      const generateFilters = (type, i) => {
        switch (type) {
          case "text":
          case "textArea":
            filters.push({
              name: i,
              operator: "contains",
              value: this.form[i]
            });
            break;
          case "select":
          case "ref":
            filters.push({
              name: i,
              operator: "eq",
              value: this.form[i]
            });
            break;
          case "date":
            if (this.form[i][0] !== "" && this.form[i][1] !== "") {
              filters.push({
                name: i,
                operator: "gt",
                value: moment(this.form[i][0]).format(DATE_FORMAT)
              });
              filters.push({
                name: i,
                operator: "lt",
                value: moment(this.form[i][1]).format(DATE_FORMAT)
              });
            }
            break;

          case "multiSelect":
          case "multiRef":
            filters.push({
              name: i,
              operator: "in",
              value: this.form[i]
            });
            break;

          default:
            filters.push({
              name: i,
              operator: "contains",
              value: this.form[i]
            });
            break;
        }
      };

      let filters = [];
      for (let i in this.form) {
        if (!!this.form[i] && this.form[i] !== "" && this.form[i] !== 0) {
          this.tableColumns
            .filter(_ => _.searchSeqNo || _.children)
            .forEach(_ => {
              if (_.children) {
                _.children.forEach(j => {
                  if (i === j.inputKey) {
                    generateFilters(j.inputType, i);
                  }
                });
              } else {
                if (i === _.inputKey) {
                  generateFilters(_.inputType, i);
                }
              }
            });
        }
      }
      this.$emit("handleSubmit", filters);
    },
    reset(ref) {
      this.tableColumns.forEach(_ => {
        if (_.children) {
          _.children.forEach(j => {
            if (!j.isNotFilterable) {
              this.form[j.inputKey] = "";
            }
          });
        } else {
          if (!_.isNotFilterable) {
            this.form[_.inputKey] = "";
          }
        }
      });
    },
    getTableOuterActions() {
      return (
        this.tableOuterActions &&
        this.tableOuterActions.map(_ => {
          return (
            <Button
              style="margin-right: 10px"
              {..._}
              onClick={() => {
                this.$emit("actionFun", _.actionType, this.selectedRows);
              }}
            >
              {_.label}
            </Button>
          );
        })
      );
    },
    renderFormItem(item, index = 0) {
      if (item.isNotFilterable) return;
      const data = {
        props: {
          ...item
        },
        style: {
          width: "100%"
        }
      };

      let renders = item => {
        switch (item.component) {
          case "WeSelect":
            return (
              <item.component
                onInput={v => (this.form[item.inputKey] = v)}
                onChange={v => item.onChange && this.$emit(item.onChange, v)}
                value={this.form[item.inputKey]}
                filterable
                clearable
                {...data}
                options={
                  item.optionKey
                    ? this.ascOptions[this.form[item.optionKey]]
                    : item.options
                }
              />
            );
          case "RefSelect":
            return (
              <item.component
                onInput={v => (this.form[item.inputKey] = v)}
                value={this.form[item.inputKey]}
                {...data}
              />
            );
          default:
            return (
              <item.component
                value={this.form[item.inputKey]}
                onInput={v => (this.form[item.inputKey] = v)}
                {...data}
              />
            );
        }
      };
      return (
        <Col
          span={item.span || 3}
          class={
            index < DEFAULT_FILTER_NUMBER
              ? ""
              : this.isShowHiddenFilters
              ? "hidden-filters-show"
              : "hidden-filters"
          }
        >
          <FormItem label={item.title} prop={item.inputKey} key={item.inputKey}>
            {renders(item)}
          </FormItem>
        </Col>
      );
    },
    getFormFilters() {
      let compare = (a, b) => {
        if (a.searchSeqNo < b.searchSeqNo) {
          return -1;
        }
        if (a.searchSeqNo > b.searchSeqNo) {
          return 1;
        }
        return 0;
      };
      return (
        <Form ref="form" label-position="top" inline>
          <Row>
            {this.tableColumns
              .filter(_ => !!_.children || !!_.searchSeqNo)
              .sort(compare)
              .map((_, index) => {
                if (_.children) {
                  return (
                    <Row>
                      <Col span={3}>
                        <strong>{_.title}</strong>
                      </Col>
                      <Col span={21}>
                        {_.children
                          .filter(_ => !!_.searchSeqNo)
                          .sort(compare)
                          .map(j => this.renderFormItem(j))}
                      </Col>
                    </Row>
                  );
                }
                return this.renderFormItem(_, index);
              })}
            <Col span={6}>
              <div style="display: flex; margin-bottom: 20px">
                {this.tableColumns.filter(_ => !!_.searchSeqNo).sort(compare)
                  .length > DEFAULT_FILTER_NUMBER &&
                  (!this.isShowHiddenFilters ? (
                    <FormItem style="position: relative; bottom: -22px;">
                      <Button
                        type="info"
                        ghost
                        shape="circle"
                        icon="ios-arrow-down"
                        onClick={() => {
                          this.isShowHiddenFilters = true;
                        }}
                      >
                        更多条件
                      </Button>
                    </FormItem>
                  ) : (
                    <FormItem style="position: relative; bottom: -22px;">
                      <Button
                        type="info"
                        ghost
                        shape="circle"
                        icon="ios-arrow-up"
                        onClick={() => {
                          this.isShowHiddenFilters = false;
                        }}
                      >
                        更少条件
                      </Button>
                    </FormItem>
                  ))}

                <FormItem style="position: relative; bottom: -22px;">
                  <Button
                    type="primary"
                    icon="ios-search"
                    onClick={() => this.handleSubmit("form")}
                  >
                    搜索
                  </Button>
                </FormItem>
                <FormItem style="position: relative; bottom: -22px;">
                  <Button icon="md-refresh" onClick={() => this.reset("form")}>
                    重置
                  </Button>
                </FormItem>
              </div>
            </Col>
          </Row>
        </Form>
      );
    },
    onCheckboxSelect(selection) {
      this.selectedRows = selection;
      this.$emit("getSelectedRows", selection, false);
    },
    onRadioSelect(current, old) {
      this.$emit("getSelectedRows", [current], false);
    },
    cancelSelected() {
      this.$refs["table"].selectAll(false);
      this.selectedRows = [];
    },
    sortHandler(sort) {
      this.$emit("sortHandler", sort);
    },
    export(data) {
      this.$refs.table.exportCsv({
        filename: data.filename,
        columns: this.columns,
        data: data.data
      });
    },
    calColumn() {
      let compare = (a, b) => {
        if (a.displaySeqNo < b.displaySeqNo) {
          return -1;
        }
        if (a.displaySeqNo > b.displaySeqNo) {
          return 1;
        }
        return 0;
      };
      this.columns = this.tableColumns
        .filter(_ => _.isDisplayed || _.displaySeqNo || _.children)
        .sort(compare)
        .map(_ => {
          if (_.children) {
            return {
              ..._,
              children: _.children
                .filter(_ => _.isDisplayed || _.displaySeqNo)
                .sort(compare)
                .map(j => {
                  return this.renderCol(j);
                })
            };
          } else {
            return this.renderCol(_);
          }
        });

      if (this.showCheckbox && !this.highlightRow) {
        this.columns.unshift({
          type: "selection",
          width: 60,
          align: "center",
          fixed: "left"
        });
      }
      this.tableInnerActions &&
        this.columns.push({
          title: "Actions",
          fixed: "right",
          key: "actions",
          maxWidth: 500,
          minWidth: 200,
          render: (h, params) => {
            return (
              <div>
                {this.tableInnerActions.map(_ => {
                  if (
                    _.visible
                      ? _.visible.key === "nextOperations"
                        ? !!params.row[_.visible.key].find(
                            op => op === _.actionType
                          ) && _.visible.value === !params.row["isRowEditable"]
                        : _.visible.value === !!params.row[_.visible.key]
                      : true
                  ) {
                    return (
                      <Button
                        {...{ props: { ..._.props } }}
                        style="marginRight: 5px"
                        onClick={() => {
                          this.$emit("actionFun", _.actionType, params.row);
                        }}
                      >
                        {_.label}
                      </Button>
                    );
                  }
                })}
              </div>
            );
          }
        });
    },
    renderCol(col) {
      let setValueHandler = (_this, v, col, params) => {
        _this.selectedRows.forEach(_ => {
          if (_.weTableRowId === params.row.weTableRowId) {
            _[col.inputKey] = v;
          }
        });
        this.$emit("getSelectedRows", _this.selectedRows, true);
      };

      return {
        ...col,
        maxWidth: 500,
        minWidth: 200,
        sortable: "custom",
        render: (h, params) => {
          if (
            params.row.isRowEditable &&
            (!params.column.disEditor || params.row.isNewAddedRow) &&
            !params.column.disAdded
          ) {
            const _this = this;

            const props =
              params.column.component === "WeSelect"
                ? {
                    value: params.column.isRefreshable
                      ? params.column.inputType === "multiSelect"
                        ? []
                        : ""
                      : params.column.inputType === "multiSelect"
                      ? Array.isArray(params.row[col.inputKey])
                        ? params.row[col.inputKey]
                        : ""
                      : params.row[col.inputKey],
                    filterParams: params.column.filterRule
                      ? {
                          attrId: params.column.ciTypeAttrId,
                          params: params.row
                        }
                      : null,
                    isMultiple: params.column.isMultiple,
                    options: params.column.optionKey
                      ? _this.ascOptions[params.row[col.optionKey]]
                      : params.column.options
                  }
                : {
                    value: params.column.isRefreshable
                      ? ""
                      : params.column.inputType === "multiRef"
                      ? Array.isArray(params.row[col.inputKey])
                        ? params.row[col.inputKey]
                        : ""
                      : params.row[col.inputKey] || "",
                    filterParams: params.column.filterRule
                      ? {
                          attrId: params.column.ciTypeAttrId,
                          params: params.row
                        }
                      : null,
                    ciType:
                      params.column.component === "refSelect"
                        ? params.column.ciType
                        : null,
                    ...params.column,
                    type:
                      params.column.component === "DatePicker"
                        ? "date"
                        : params.column.type,
                    guid: params.row.guid ? params.row.guid : "123"
                  };
            const fun =
              params.column.component === "DatePicker"
                ? {
                    "on-change": v => {
                      setValueHandler(_this, v, col, params);
                    }
                  }
                : {
                    input: v => {
                      setValueHandler(_this, v, col, params);
                    }
                  };
            const data = {
              props,
              on: fun
            };
            return <params.column.component {...data} />;
          } else {
            let content = "";
            if (Array.isArray(params.row.weTableForm[col.key])) {
              if (params.column.inputType === "multiSelect") {
                content = params.row.weTableForm[col.key]
                  .map(_ => _.value)
                  .toString();
              }
              if (params.column.inputType === "multiRef") {
                content = params.row.weTableForm[col.key]
                  .map(_ => _.key_name)
                  .toString();
              }
            } else {
              content = params.row.weTableForm[col.key];
            }

            const d = {
              props: {
                content: content,
                "max-width": "100px"
              }
            };
            const len = content ? content.toString().length : 0;
            // show tooltip when string length greater than 15
            return len > 10 ? (
              <Tooltip {...d}>
                <span style="display: inline-block;max-width: 75%;white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                  {content}
                </span>
                {params.column.propertyName === "orchestration" &&
                  this.$route.name === "workflowExecution" && (
                    <orchestration
                      onHandleSubmit={this.handleSubmit}
                      col={params.column}
                      row={params.row}
                    />
                  )}
              </Tooltip>
            ) : (
              <span>
                {content}{" "}
                {params.column.propertyName === "orchestration" &&
                  this.$route.name === "workflowExecution" && (
                    <orchestration
                      onHandleSubmit={this.handleSubmit}
                      col={params.column}
                      row={params.row}
                    />
                  )}
              </span>
            );
          }
        }
      };
    }
  },
  render(h) {
    const { data, columns, pagination, highlightRow, filtersHidden } = this;
    return (
      <div>
        {!filtersHidden && <div>{this.getFormFilters()}</div>}
        <Row style="margin-bottom:10px">{this.getTableOuterActions()}</Row>
        <Table
          ref="table"
          border
          data={data}
          columns={columns}
          highlight-row={highlightRow}
          on-on-selection-change={this.onCheckboxSelect}
          on-on-current-change={this.onRadioSelect}
          on-on-sort-change={this.sortHandler}
          size="small"
        />
        {pagination && (
          <Page
            total={pagination.total}
            page-size={pagination.pageSize}
            current={pagination.currentPage}
            on-on-change={v => this.$emit("pageChange", v)}
            on-on-page-size-change={v => this.$emit("pageSizeChange", v)}
            show-elevator
            show-sizer
            show-total
            style="float: right; margin: 10px 0;"
          />
        )}
      </div>
    );
  }
};
