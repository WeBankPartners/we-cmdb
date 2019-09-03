<template>
  <div>
    <SimpleTable
      :columns="columns"
      :data="tableData"
      :page="pageInfo"
      @pageChange="pageChange"
      @pageSizeChange="pageSizeChange"
    ></SimpleTable>
  </div>
</template>

<script>
import { queryLogHeader, queryLog } from "@/api/server";
export default {
  data() {
    return {
      columns: [],
      tableData: [],
      pageInfo: {
        pageSize: 10,
        currentPage: 1,
        total: 0
      }
    };
  },
  methods: {
    async fetchColumns() {
      const { data, statusCode } = await queryLogHeader();
      if (statusCode === "OK") {
        this.columns = data.map(_ => {
          return {
            title: _.name,
            key: _.name
          };
        });
      }
      this.fetchTableData();
    },
    async fetchTableData() {
      const { data, statusCode } = await queryLog({
        sorting: {
          asc: false,
          field: "createdDate"
        },
        paging: true,
        pageable: {
          pageSize: this.pageInfo.pageSize,
          startIndex: (this.pageInfo.currentPage - 1) * this.pageInfo.pageSize
        }
      });
      if (statusCode === "OK") {
        this.tableData = data.contents;
        this.pageInfo.total = data.pageInfo.totalRows;
      }
    },
    pageChange(v) {
      this.pageInfo.currentPage = v;
      this.fetchTableData();
    },
    pageSizeChange(v) {
      this.pageInfo.pageSize = v;
      this.fetchTableData();
    }
  },
  mounted() {
    this.fetchColumns();
  }
};
</script>

<style lang="scss" scoped></style>
