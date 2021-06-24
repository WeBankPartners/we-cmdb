<template>
  <CMDBTable
    :tableData="tableData"
    :tableColumns="columns"
    :ascOptions="ascOptions"
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
import { queryLog, queryLogOperation } from '@/api/server'
export default {
  data () {
    return {
      columns: [
        {
          component: 'Input',
          type: 'text',
          inputType: 'text',
          title: 'Guid',
          key: 'dataGuid',
          inputKey: 'dataGuid',
          editable: 'no',
          uiFormOrder: 1,
          uiSearchOrder: 1,
          displayByDefault: 'yes'
        },
        {
          component: 'Input',
          type: 'text',
          inputType: 'text',
          title: 'Key Name',
          key: 'dataCiType',
          inputKey: 'dataCiType',
          editable: 'no',
          uiFormOrder: 1,
          uiSearchOrder: 1,
          displayByDefault: 'yes'
        },
        {
          component: 'DatePicker',
          type: 'datetimerange',
          inputType: 'date',
          title: 'Created Date',
          key: 'createdDate',
          inputKey: 'createdDate',
          editable: true,
          uiFormOrder: 1,
          uiSearchOrder: 1,
          displayByDefault: 'yes'
        },
        {
          component: 'Input',
          type: 'text',
          inputType: 'text',
          title: 'User',
          key: 'operator',
          inputKey: 'operator',
          editable: 'no',
          uiFormOrder: 1,
          uiSearchOrder: 1,
          displayByDefault: 'yes'
        },
        {
          component: 'Input',
          type: 'text',
          inputType: 'text',
          title: 'Client Host',
          key: 'clientHost',
          inputKey: 'clientHost',
          editable: 'no',
          uiFormOrder: 1,
          uiSearchOrder: 1,
          displayByDefault: 'yes'
        },
        {
          component: 'WeCMDBSelect',
          options: [
            {
              value: 'Permission Management',
              label: 'Permission Management'
            },
            {
              value: 'Base Data Management',
              label: 'Base Data Management'
            },
            {
              value: 'CI Type Management',
              label: 'CI Type Management'
            },
            {
              value: 'CI Data Management',
              label: 'CI Data Management'
            }
          ],
          inputType: 'select',
          title: 'Category',
          key: 'logCat',
          inputKey: 'logCat',
          editable: 'no',
          uiFormOrder: 1,
          uiSearchOrder: 1,
          displayByDefault: 'yes'
        },
        {
          component: 'Input',
          type: 'text',
          inputType: 'text',
          title: 'Content',
          key: 'content',
          inputKey: 'content',
          editable: 'no',
          uiFormOrder: 1,
          uiSearchOrder: 1,
          displayByDefault: 'yes'
        },
        {
          component: 'WeCMDBSelect',
          optionKey: 'operationOpts',
          options: [],
          inputType: 'select',
          title: 'Operation',
          key: 'operation',
          inputKey: 'operation',
          editable: 'no',
          uiFormOrder: 1,
          uiSearchOrder: 1,
          displayByDefault: 'yes'
        },
        {
          component: 'Input',
          type: 'text',
          inputType: 'text',
          title: 'Request Url',
          key: 'requestUrl',
          inputKey: 'requestUrl',
          editable: 'no',
          uiFormOrder: 1,
          uiSearchOrder: 1,
          displayByDefault: 'yes'
        }
      ],
      tableData: [],
      ascOptions: {},
      pageInfo: {
        pageSize: 10,
        currentPage: 1,
        total: 0
      },
      filters: [],
      sorting: { asc: false, field: 'createdDate' }
    }
  },
  methods: {
    async queryLogOperation () {
      const { statusCode, data } = await queryLogOperation()
      if (statusCode === 'OK') {
        const operationOpts = data.map(_ => {
          return {
            value: _,
            label: _
          }
        })
        this.$set(this.ascOptions, 'operationOpts', operationOpts)
      }
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
    this.queryLogOperation()
    this.fetchTableData()
  }
}
</script>

<style lang="scss" scoped></style>
