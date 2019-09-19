<template>
  <WeTable
    :tableData="tableData"
    :tableOuterActions="outerActions"
    :tableInnerActions="innerActions"
    :tableColumns="tableColumns"
    :pagination="pagination"
    :ascOptions="ascOptions"
    :showCheckbox="showCheckbox"
    @actionFun="actionFun"
    @getSelectedRows="onSelectedRowsChange"
    @handleSubmit="handleSubmit"
    @sortHandler="sortHandler"
    @pageChange="pageChange"
    @pageSizeChange="pageSizeChange"
    @getGroupList="getGroupList"
    tableHeight="650"
    ref="table"
  ></WeTable>
</template>

<script>
import {
  getAllSystemEnumCodes,
  getSystemCategories,
  getEffectiveStatus,
  createEnumCode,
  updateEnumCode,
  getGroupListByCodeId,
  deleteEnumCodes,
  getAllNonSystemEnumCodes,
  getNonSystemCategories
} from "@/api/server.js";
import { formatData } from "../util/format.js";
import { outerActions, innerActions } from "@/const/actions.js";

export default {
  data() {
    return {
      outerActions,
      innerActions,
      showCheckbox: true,
      tableData: [],
      seachFilters: {},
      tableColumns: [
        {
          title: "枚举名称",
          key: "catName",
          inputKey: "catId",
          searchSeqNo: 1,
          displaySeqNo: 1,
          component: "WeSelect",
          onChange: "getGroupList",
          disEditor: true, // 枚举名称不可改
          inputType: "select",
          placeholder: "catName",
          options: []
        },
        {
          title: "枚举键",
          key: "code",
          inputKey: "code",
          searchSeqNo: 2,
          displaySeqNo: 2,
          component: "Input",
          inputType: "text",
          placeholder: "code"
        },
        {
          title: "枚举值",
          key: "value",
          inputKey: "value",
          searchSeqNo: 3,
          displaySeqNo: 3,
          component: "Input",
          inputType: "text",
          placeholder: "value"
        },
        {
          title: "枚举类型",
          key: "catTypeName",
          inputKey: "cat.catType.catTypeName",
          searchSeqNo: 4,
          displaySeqNo: 4,
          component: "Input",
          disEditor: true, // 枚举类型不可改
          inputType: "text",
          placeholder: "catTypeName"
        },
        {
          title: "枚举组",
          key: "groupCodeId",
          inputKey: "groupCodeId",
          searchSeqNo: 5,
          displaySeqNo: 5,
          component: "WeSelect",
          inputType: "select",
          placeholder: "groupCodeId",
          optionKey: "catId"
        },
        {
          title: "状态",
          key: "status",
          inputKey: "status",
          searchSeqNo: 6,
          displaySeqNo: 6,
          component: "WeSelect",
          inputType: "select",
          placeholder: "status",
          options: []
        }
      ],
      pagination: {
        pageSize: 10,
        currentPage: 1,
        total: 0
      },
      payload: {
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true,
        sorting: {
          asc: true,
          field: ""
        },
        refResources: ["cat"]
      },
      ascOptions: {},
      seletedRows: []
    };
  },
  props: {
    catId: {}
  },
  watch: {
    catId: {
      handler(val) {
        this.queryData();
        if (val) {
          this.getGroupList(val);
        }
      },
      immediate: true
    }
  },
  beforeRouteLeave(to, from, next) {
    this.$destroy();
    next();
  },
  methods: {
    pageChange(current) {
      this.pagination.currentPage = current;
      this.queryData();
    },
    pageSizeChange(size) {
      this.pagination.pageSize = size;
      this.queryData();
    },
    sortHandler(data) {
      this.payload.sorting = {
        asc: data.order === "asc",
        field: data.key
      };
      this.queryData();
    },
    handleSubmit(data) {
      this.payload.filters = data;
      this.pagination.currentPage = 1;
      this.queryData();
    },
    setNewAddedRow(index, key, v) {
      this.$refs.table.data[index][key] = v;
    },
    async getGroupList(catId) {
      if (catId) {
        const { data, status, message } = await getGroupListByCodeId(catId);
        let opts = [];
        if (status === "OK") {
          opts = data.map(_ => {
            return {
              value: _.codeId,
              label: _.value
            };
          });
        }
        this.$set(this.ascOptions, catId, opts);
      }
      this.$refs.table.form.groupCodeId = "";
    },
    getAsyncOptions(rows, disable) {
      rows.forEach(async _ => {
        if (!this.ascOptions[_.catId] && _.catId > 0) {
          this.getGroupList(_.catId);
        }
      });
      this.$refs.table.setTableData(disable);
    },
    async queryData() {
      this.payload.pageable.pageSize = this.pagination.pageSize;
      this.payload.pageable.startIndex =
        (this.pagination.currentPage - 1) * this.pagination.pageSize;
      if (this.catId > -1) {
        const found = this.payload.filters.find(_ => _.name === "catId");
        if (found) {
          found.value = this.catId;
        } else {
          this.payload.filters.push({
            name: "catId",
            operator: "eq",
            value: this.catId
          });
        }
      }
      const { status, message, data } =
        this.$route.name === "baseData"
          ? await getAllSystemEnumCodes(this.payload)
          : await getAllNonSystemEnumCodes(this.payload);
      if (status === "OK") {
        this.pagination.total = data.pageInfo.totalRows;
        this.tableData = data.contents.map(_ => {
          return {
            ..._,
            ..._.cat,
            catTypeName:
              _.cat.catType.catTypeName === "sys"
                ? "系统枚举"
                : _.cat.catType.catTypeName === "common"
                ? "共有枚举"
                : _.cat.catType.catTypeName
          };
        });
      }
    },
    async getEnumNames() {
      const { status, message, data } =
        this.$route.name === "baseData"
          ? await getSystemCategories()
          : await getNonSystemCategories();
      if (status === "OK") {
        this.tableColumns[0].options = data.map(_ => {
          // this.getGroupList(_.catId);
          return {
            value: _.catId,
            label: _.catName
          };
        });
      }
    },
    async getEnumsStatus() {
      const { status, message, data } = await getEffectiveStatus();
      if (status === "OK") {
        this.tableColumns[this.tableColumns.length - 1].options = data.map(
          _ => {
            return {
              value: _,
              label: _
            };
          }
        );
      }
    },

    actionFun(type, data) {
      switch (type) {
        case "export":
          this.exportHandler();
          break;
        case "add":
          this.addHandler();
          break;
        case "edit":
          this.editHandler();
          break;
        case "save":
          this.saveHandler(data);
          break;
        case "delete":
          this.deleteHandler(data);
          break;
        case "cancel":
          this.cancelHandler();
          break;
        case "innerCancel":
          this.$refs.table.rowCancelHandler(data.weTableRowId);
          break;
        default:
          break;
      }
    },
    cancelHandler() {
      this.$refs.table.setAllRowsUneditable();
      this.$refs.table.setCheckoutStatus();
      this.outerActions &&
        this.outerActions.forEach(_ => {
          _.props.disabled = !(
            _.actionType === "add" ||
            _.actionType === "export" ||
            _.actionType === "cancel"
          );
        });
    },
    addHandler() {
      let emptyRowData = {};
      this.tableColumns.forEach(_ => {
        if (_.inputType === "multiSelect" || _.inputType === "multiRef") {
          emptyRowData[_.inputKey] = [];
        } else {
          emptyRowData[_.inputKey] = "";
        }
      });
      emptyRowData["isRowEditable"] = true;
      emptyRowData["isNewAddedRow"] = true;
      emptyRowData["weTableRowId"] = new Date().getTime();
      emptyRowData["catId"] = this.catId ? this.catId : "";
      this.tableData.unshift(emptyRowData);
      this.$nextTick(() => {
        this.$refs.table.pushNewAddedRowToSelections();
        this.$refs.table.setCheckoutStatus(true);
      });
      this.outerActions.forEach(_ => {
        _.props.disabled = _.actionType === "add";
      });
    },
    editHandler() {
      this.$refs.table.swapRowEditable(true);
      this.outerActions.forEach(_ => {
        if (_.actionType === "save") {
          _.props.disabled = false;
        }
      });
      this.$nextTick(() => {
        this.$refs.table.setCheckoutStatus(true);
      });
    },
    deleteHandler(deleteData) {
      this.$Modal.confirm({
        title: "确认删除？",
        "z-index": 1000000,
        onOk: async () => {
          const payload = deleteData.map(_ => _.codeId);
          const { status, message, data } = await deleteEnumCodes(payload);
          if (status === "OK") {
            this.$Notice.success({
              title: "Delete Enum Success",
              desc: message
            });
            this.outerActions.forEach(_ => {
              _.props.disabled =
                _.actionType === "save" ||
                _.actionType === "edit" ||
                _.actionType === "delete";
            });
            this.queryData();
          }
        },
        onCancel: () => {}
      });
      document.querySelector(".ivu-modal-mask").click();
    },
    async saveHandler(data) {
      let setBtnsStatus = () => {
        this.outerActions.forEach(_ => {
          _.props.disabled = !(
            _.actionType === "add" || _.actionType === "export"
          );
        });
        this.$refs.table.setAllRowsUneditable();
        this.$nextTick(() => {
          /* to get iview original data to set _ischecked flag */
          let objData = this.$refs.table.$refs.table.$refs.tbody.objData;
          for (let obj in objData) {
            objData[obj]._isChecked = false;
            objData[obj]._isDisabled = false;
          }
        });
      };
      let d = JSON.parse(JSON.stringify(data));
      let addObj = d.find(_ => _.isNewAddedRow);
      let editAry = d.filter(_ => !_.isNewAddedRow);
      if (addObj) {
        let payload = {
          callbackId: 1,
          catId: addObj.catId || this.catId,
          code: addObj.code,
          status: addObj.status,
          value: addObj.value,
          groupCodeId: addObj.groupCodeId
        };
        const { status, message, data } = await createEnumCode(payload);
        if (status === "OK") {
          this.$Notice.success({
            title: "Add Enum Success",
            desc: message
          });
          setBtnsStatus();
          this.queryData();
        }
      }
      if (editAry.length > 0) {
        let payload = editAry.map(_ => {
          return {
            callbackId: _.weTableRowId,
            catId: _.catId,
            code: _.code,
            codeId: _.codeId,
            groupCodeId: _.groupCodeId,
            status: _.status,
            value: _.value
          };
        });
        const { status, message, data } = await updateEnumCode(payload);
        if (status === "OK") {
          this.$Notice.success({
            title: "Update Enum Success",
            desc: message
          });
          setBtnsStatus();
          this.queryData();
        }
      }
    },
    onSelectedRowsChange(rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        this.outerActions.forEach(_ => {
          _.props.disabled = _.actionType === "add";
        });
      } else {
        this.outerActions.forEach(_ => {
          _.props.disabled = !(
            _.actionType === "add" ||
            _.actionType === "export" ||
            _.actionType === "cancel"
          );
        });
      }
      this.seletedRows = rows;
      this.getAsyncOptions(rows, checkoutBoxdisable);
    },
    async exportHandler() {
      const { status, message, data } =
        this.$route.name === "baseData"
          ? await getAllSystemEnumCodes({ ...this.payload, paging: false })
          : await getAllNonSystemEnumCodes({ ...this.payload, paging: false });

      if (status === "OK") {
        this.$refs.table.export({
          filename:
            this.$route.name === "baseData" ? "Basic Enums Data" : "Enums Data",
          data: data.contents.map(_ => {
            const formatValue = _.value ? _.value.replace(/,/g, ";") : "";
            const formatCode = _.code ? _.code.replace(/,/g, ";") : "";
            return {
              ..._,
              code: formatCode,
              value: formatValue,
              groupCodeId: _.groupCodeId ? _.groupCodeId.value : "",
              catName: _.cat.catName
            };
          })
        });
      }
    },
    setActionsParams() {
      const routerFlag = this.$route.name === "enumEnquiry";
      this.outerActions = routerFlag ? null : outerActions;
      this.innerActions = routerFlag ? null : innerActions;
      this.showCheckbox = routerFlag ? false : true;
    }
  },
  created() {
    if (this.catId) {
      this.tableColumns.shift();
    } else {
      this.setActionsParams();
      this.getEnumNames();
    }
    this.queryData();
    this.getEnumsStatus();
  },
  mounted() {
    this.cancelHandler();
  }
};
</script>

<style lang="scss" scoped></style>
