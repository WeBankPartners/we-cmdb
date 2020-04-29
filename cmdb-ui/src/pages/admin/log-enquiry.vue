<template>
  <CMDBTable
    :tableData="tableData"
    :tableColumns="columns"
    :tableOuterActions="null"
    :tableInnerActions="null"
    :showCheckbox="false"
    :pagination="pageInfo"
    @sortHandler="sortHandler"
    @pageChange="pageChange"
    @pageSizeChange="pageSizeChange"
    @handleSubmit="handleSubmit"
    ref="table"
  ></CMDBTable>
</template>

<script>
import { queryLogHeader, queryLog } from '@/api/server'
import { components } from '@/const/actions'
export default {
  data () {
    return {
      columns: [],
      tableData: [],
      pageInfo: {
        pageSize: 10,
        currentPage: 1,
        total: 0
      },
      filters: [],
      sorting: null
    }
  },
  methods: {
    async fetchColumns () {
      const { data, statusCode } = await queryLogHeader()
      if (statusCode === 'OK') {
        this.columns = data.map(_ => {
          let result = {
            inputType: _.inputType,
            title: _.name,
            key: _.key,
            inputKey: _.key,
            disEditor: true,
            displaySeqNo: 1,
            searchSeqNo: 1
          }
          if (_.vals) {
            result.options = _.vals.map(opt => {
              return {
                value: opt,
                label: opt
              }
            })
          }
          return { ...components[_.inputType], ...result }
        })
      }
      this.fetchTableData()
    },
    async fetchTableData () {
      const { data, statusCode } = await queryLog({
        sorting: this.sorting,
        paging: true,
        pageable: {
          pageSize: this.pageInfo.pageSize,
          startIndex: (this.pageInfo.currentPage - 1) * this.pageInfo.pageSize
        },
        filters: this.filters
      })
      if (statusCode === 'OK') {
        this.tableData = data.contents
        this.pageInfo.total = data.pageInfo.totalRows
      }
    },
    pageChange (currentPage) {
      this.pageInfo.currentPage = currentPage
      this.$refs.table.handleSubmit()
    },
    pageSizeChange (size) {
      this.pageInfo.pageSize = size
      this.$refs.table.handleSubmit()
    },
    sortHandler (data) {
      if (data.order === 'normal') {
        delete this.sorting
      } else {
        this.sorting = {
          asc: data.order === 'asc',
          field: data.key
        }
      }
      this.fetchTableData()
    },
    handleSubmit (v) {
      this.filters = v
      this.fetchTableData()
    }
  },
  mounted () {
    this.fetchColumns()
  }
}
</script>

<style lang="scss" scoped></style>
