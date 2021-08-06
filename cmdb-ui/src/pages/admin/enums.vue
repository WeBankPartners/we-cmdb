<template>
  <CMDBTable
    :tableData="tableData"
    :tableOuterActions="outerActions"
    :tableInnerActions="null"
    :tableColumns="tableColumns"
    :pagination="pagination"
    :ascOptions="ascOptions"
    :showCheckbox="showCheckbox"
    :isSortable="false"
    @actionFun="actionFun"
    @getSelectedRows="onSelectedRowsChange"
    @handleSubmit="handleSubmit"
    @sortHandler="sortHandler"
    @pageChange="pageChange"
    @pageSizeChange="pageSizeChange"
    @confirmAddHandler="confirmAddHandler"
    @confirmEditHandler="confirmEditHandler"
    tableHeight="650"
    ref="table"
  ></CMDBTable>
</template>

<script>
import {
  getAllSystemEnumCodesWithPayload,
  getAllEnumCategories,
  createEnumCode,
  updateEnumCode,
  deleteEnumCodes,
  getAllNonSystemEnumCodes
} from '@/api/server.js'
import { resetButtonDisabled } from '@/const/tableActionFun.js'
import { newExportOuterActions, newOuterActions } from '@/const/actions.js'

export default {
  data () {
    return {
      outerActions: [],
      showCheckbox: true,
      tableData: [],
      seachFilters: {},
      tableColumns: [
        {
          title: this.$t('table_enum_name'),
          key: 'catName',
          inputKey: 'catId',
          propertyName: 'catId',
          uiSearchOrder: 1,
          uiFormOrder: 1,
          component: 'WeCMDBSelect',
          disEditor: true, // 枚举名称不可改
          inputType: 'select',
          placeholder: 'catName',
          options: [],
          optionKey: 'catOpts',
          editable: 'yes',
          isAuto: false,
          displayByDefault: 'yes'
        },
        {
          title: this.$t('table_enum_key'),
          key: 'code',
          inputKey: 'code',
          propertyName: 'code',
          uiSearchOrder: 2,
          uiFormOrder: 2,
          component: 'Input',
          inputType: 'text',
          placeholder: 'code',
          editable: 'yes',
          isAuto: false,
          displayByDefault: 'yes'
        },
        {
          title: this.$t('table_enum_value'),
          key: 'value',
          inputKey: 'value',
          propertyName: 'value',
          uiSearchOrder: 3,
          uiFormOrder: 3,
          component: 'Input',
          inputType: 'text',
          placeholder: 'value',
          editable: 'yes',
          isAuto: false,
          displayByDefault: 'yes'
        },
        {
          title: this.$t('state'),
          key: 'status',
          inputKey: 'status',
          propertyName: 'status',
          uiSearchOrder: 6,
          uiFormOrder: 6,
          component: 'WeCMDBSelect',
          inputType: 'select',
          placeholder: 'status',
          optionKey: 'statusOpts',
          options: [],
          editable: 'yes',
          isAuto: false,
          displayByDefault: 'yes'
        },
        {
          title: this.$t('description'),
          key: 'codeDescription',
          inputKey: 'codeDescription',
          propertyName: 'codeDescription',
          uiSearchOrder: 0,
          uiFormOrder: 7,
          component: 'Input',
          inputType: 'text',
          placeholder: 'codeDescription',
          editable: 'yes',
          isAuto: false,
          displayByDefault: 'yes'
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
          field: 'catId'
        }
      },
      ascOptions: {},
      seletedRows: []
    }
  },
  props: {
    catId: {}
  },
  watch: {
    catId: {
      handler (val) {
        this.queryData()
      },
      immediate: true
    }
  },
  beforeRouteLeave (to, from, next) {
    this.$destroy()
    next()
  },
  methods: {
    pageChange (current) {
      this.pagination.currentPage = current
      this.queryData()
    },
    pageSizeChange (size) {
      this.pagination.pageSize = size
      this.queryData()
    },
    sortHandler (data) {
      this.payload.sorting = {
        asc: data.order === 'asc',
        field: data.key
      }
      this.queryData()
    },
    handleSubmit (data) {
      this.payload.filters = data
      this.pagination.currentPage = 1
      this.queryData()
    },
    setNewAddedRow (index, key, v) {
      this.$refs.table.data[index][key] = v
    },
    async queryData () {
      this.payload.pageable.pageSize = this.pagination.pageSize
      this.payload.pageable.startIndex = (this.pagination.currentPage - 1) * this.pagination.pageSize
      if (this.catId > -1) {
        const found = this.payload.filters.find(_ => _.name === 'catId')
        if (found) {
          found.value = this.catId
        } else {
          this.payload.filters.push({
            name: 'catId',
            operator: 'eq',
            value: this.catId
          })
        }
      }
      // this.$refs.table.isTableLoading(true)
      const { statusCode, data } =
        this.$route.name === 'baseData'
          ? await getAllSystemEnumCodesWithPayload(this.payload)
          : await getAllNonSystemEnumCodes(this.payload)
      if (statusCode === 'OK') {
        this.pagination.total = data.pageInfo.totalRows
        this.tableData = data.contents.map(_ => {
          return {
            ..._,
            ..._.cat
          }
        })
      }
      // this.$refs.table.isTableLoading(true)
    },
    async getEnumNames () {
      const { statusCode, data } = await getAllEnumCategories()
      if (statusCode === 'OK') {
        const catOpt = data.contents.map(_ => {
          return {
            value: _.catId,
            label: _.catName
          }
        })
        this.tableColumns[0].options = catOpt
        this.$set(this.ascOptions, 'catOpts', catOpt)
      }
    },
    async getEnumsStatus () {
      const status = [
        { value: 'active', label: 'active' },
        { value: 'inactive', label: 'inactive' }
      ]
      this.tableColumns[3].options = status
      // this.$set(this.ascOptions, 'statusOpts', status)
    },

    actionFun (type, data, cols) {
      switch (type.actionType) {
        case 'export':
          this.exportHandler()
          break
        case 'add':
          this.addHandler()
          break
        case 'edit':
          this.editHandler()
          break
        case 'delete':
          this.deleteHandler(data)
          break
        case 'copy':
          this.copyHandler(data, cols)
          break
        case 'innerCancel':
          this.$refs.table.rowCancelHandler(data.weTableRowId)
          break
        default:
          break
      }
    },
    addHandler () {
      let emptyRowData = {}
      this.tableColumns.forEach(_ => {
        if (_.inputType === 'multiSelect' || _.inputType === 'multiRef') {
          emptyRowData[_.inputKey] = '[]'
        } else {
          emptyRowData[_.inputKey] = ''
        }
      })
      emptyRowData['isRowEditable'] = true
      emptyRowData['isNewAddedRow'] = true
      emptyRowData['weTableRowId'] = new Date().getTime()
      emptyRowData['catId'] = this.catId ? this.catId : ''
      this.$refs.table.pushNewAddedRowToSelections(emptyRowData)
      this.$refs.table.showAddModal(emptyRowData)
    },
    editHandler () {
      this.$refs.table.showEditModal()
    },
    deleteHandler (deleteData) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        'z-index': 1000000,
        onOk: async () => {
          const payload = deleteData.map(_ => {
            return { codeId: _.codeId }
          })
          const { statusCode, message } = await deleteEnumCodes(payload)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: this.$t('delete_enum_success_message'),
              desc: message
            })
            this.outerActions.forEach(_ => {
              _.props.disabled = _.actionType === 'copy' || _.actionType === 'edit' || _.actionType === 'delete'
            })
            this.queryData()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    copyHandler (rows = [], cols) {
      this.$refs.table.showCopyModal()
    },
    deleteAttr () {
      let attrs = []
      this.tableColumns.forEach(i => {
        if (i.isAuto) {
          attrs.push(i.propertyName)
        }
      })
      return attrs
    },
    async confirmAddHandler (data) {
      const deleteAttrs = this.deleteAttr()
      let addAry = JSON.parse(JSON.stringify(data))
      addAry.forEach(_ => {
        deleteAttrs.forEach(attr => {
          delete _[attr]
        })
        delete _.isRowEditable
        delete _.weTableForm
        delete _.weTableRowId
        delete _.isNewAddedRow
        delete _.nextOperations
      })
      const payload = addAry.map(_ => {
        return {
          ..._
        }
      })
      const { statusCode, message } = await createEnumCode(payload)
      this.$refs.table.resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('add_enum_success_message'),
          desc: message
        })
        this.setBtnsStatus()
        this.queryData()
        this.$refs.table.closeEditModal(false)
      }
    },
    async confirmEditHandler (data) {
      let editAry = JSON.parse(JSON.stringify(data))
      editAry.forEach(_ => {
        delete _.isRowEditable
        delete _.weTableForm
        delete _.weTableRowId
        delete _.isNewAddedRow
        delete _.nextOperations
      })
      const payload = editAry.map(_ => {
        return {
          ..._
        }
      })
      const { statusCode, message } = await updateEnumCode(payload)
      this.$refs.table.resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('update_enum_success_message'),
          desc: message
        })
        this.setBtnsStatus()
        this.queryData()
        this.$refs.table.closeEditModal(false)
      }
    },
    setBtnsStatus () {
      this.outerActions.forEach(_ => {
        _.props.disabled = resetButtonDisabled(_)
      })
    },
    onSelectedRowsChange (rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        this.outerActions.forEach(_ => {
          _.props.disabled = _.actionType === 'add'
        })
      } else {
        this.outerActions.forEach(_ => {
          _.props.disabled = resetButtonDisabled(_)
        })
      }
    },
    async exportHandler () {
      this.outerActions.forEach(_ => {
        if (_.actionType === 'export') {
          _.props.loading = true
        }
      })
      const { statusCode, data } =
        this.$route.name === 'baseData'
          ? await getAllSystemEnumCodesWithPayload({ ...this.payload, paging: false })
          : await getAllNonSystemEnumCodes({ ...this.payload, paging: false })
      this.outerActions.forEach(_ => {
        if (_.actionType === 'export') {
          _.props.loading = false
        }
      })
      if (statusCode === 'OK') {
        this.$refs.table.export({
          filename: this.$route.name === 'baseData' ? 'Basic Enums Data' : 'Enums Data',
          data: data.contents.map(_ => {
            const formatValue = _.value ? _.value.replace(/,/g, ';') : ''
            const formatCode = _.code ? _.code.replace(/,/g, ';') : ''
            return {
              ..._,
              code: formatCode,
              value: formatValue,
              catName: _.cat.catName
            }
          })
        })
      }
    },
    async setActionsParams () {
      const routerFlag = this.$route.name === 'enumEnquiry'
      this.outerActions = routerFlag ? newExportOuterActions : newOuterActions
      this.showCheckbox = !routerFlag
    }
  },
  mounted () {
    if (this.catId) {
      this.tableColumns.shift()
    } else {
      this.setActionsParams()
      this.getEnumNames()
    }
    this.queryData()
    this.getEnumsStatus()
  }
}
</script>

<style lang="scss" scoped></style>
