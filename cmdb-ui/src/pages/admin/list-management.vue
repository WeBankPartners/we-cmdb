<template>
  <div class=" ">
    <CMDBTable
      :tableData="listTableData"
      :filtersHidden="true"
      :tableOuterActions="newOuterActions"
      :tableInnerActions="null"
      :ascOptions="ascOptions"
      :tableColumns="listColumns"
      :showCheckbox="true"
      @getSelectedRows="onSelectedRowsChange"
      @confirmAddHandler="confirmAddHandler"
      @confirmEditHandler="confirmEditHandler"
      @actionFun="actionFun"
      tableHeight="650"
      ref="listTable"
    ></CMDBTable>
  </div>
</template>

<script>
import { getPermissionList, addPermissionList, editPermissionList, deletePermissionList } from '@/api/server.js'
import { newOuterActions } from '@/const/actions.js'
import { formatData } from '../util/format.js'
export default {
  name: '',
  data () {
    return {
      listRoleCiTypeId: '',
      listColumns: [],
      ascOptions: {},
      defaultOptionAttrs: {
        component: 'WeCMDBRadioRroup',
        defaultValue: 'Y',
        options: [
          {
            text: this.$t('yes'),
            label: 'Y'
          },
          {
            text: this.$t('no'),
            label: 'N'
          }
        ],
        editable: 'yes',
        isAuto: false
      },
      newOuterActions,
      listTableData: []
    }
  },
  mounted () {},
  methods: {
    getListTableData (listRoleCiTypeId, ciTypeId, listColumns) {
      this.listColumns = listColumns
      this.listRoleCiTypeId = listRoleCiTypeId
      this.getTableData()
    },
    async getTableData () {
      let { statusCode, data } = await getPermissionList(this.listRoleCiTypeId)
      if (statusCode === 'OK') {
        this.listTableData = data
      }
    },
    actionFun (type, data) {
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
        case 'copy':
          this.copyHandler()
          break
        case 'delete':
          this.deleteHandler(data)
          break
        default:
          break
      }
    },
    copyHandler (rows = [], cols) {
      this.$refs.listTable.showCopyModal()
    },
    addHandler () {
      let emptyRowData = {}
      this.listColumns.forEach(_ => {
        if (['ref', 'multiRef', 'select', 'multiSelect'].indexOf(_.inputType) >= 0) {
          emptyRowData[_.inputKey] = []
        } else {
          emptyRowData[_.inputKey] = ''
        }
      })
      emptyRowData['isRowEditable'] = true
      emptyRowData['isNewAddedRow'] = true
      emptyRowData['weTableRowId'] = new Date().getTime()
      this.$refs.listTable.pushNewAddedRowToSelections(emptyRowData)
      this.$refs.listTable.showAddModal()
    },
    editHandler (operateType) {
      if (operateType === 'add') {
        let emptyRowData = {}
        this.listColumns.forEach(_ => {
          if (_.inputType === 'multiSelect' || _.inputType === 'multiRef') {
            emptyRowData[_.inputKey] = []
          } else {
            emptyRowData[_.inputKey] = ''
          }
        })
        emptyRowData['isRowEditable'] = true
        emptyRowData['isNewAddedRow'] = true
        emptyRowData['weTableRowId'] = 1
        emptyRowData['nextOperations'] = []
        this.$refs.listTable.pushNewAddedRowToSelections(emptyRowData)
        this.$refs.listTable.showAddModal()
      } else {
        this.$refs.listTable.showEditModal()
      }
    },
    async confirmAddHandler (data, operateType) {
      let addAry = JSON.parse(JSON.stringify(data))
      addAry.forEach(_ => {
        delete _.isRowEditable
        delete _.weTableForm
        delete _.weTableRowId
        delete _.isNewAddedRow
        delete _.nextOperations
      })
      const { statusCode, message } = await addPermissionList(this.listRoleCiTypeId, addAry)
      this.$refs.listTable.resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('add_data_success'),
          desc: message
        })
        this.getTableData()
        this.setBtnsStatus()
        this.$refs.listTable.closeEditModal(false)
      }
    },
    async confirmEditHandler (data, operateType) {
      // const deleteAttrs = this.deleteAttr()
      let addAry = JSON.parse(JSON.stringify(data))
      addAry.forEach(_ => {
        delete _.isRowEditable
        delete _.weTableForm
        delete _.weTableRowId
        delete _.isNewAddedRow
        delete _.nextOperations
      })
      const { statusCode, message } = await editPermissionList(this.listRoleCiTypeId, addAry)
      this.$refs.listTable.resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('add_data_success'),
          desc: message
        })
        this.getTableData()
        this.setBtnsStatus()
        this.$refs.listTable.closeEditModal(false)
      }
    },
    deleteHandler (deleteData) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        'z-index': 1000000,
        onOk: async () => {
          const payload = deleteData.map(_ => _.guid)
          const { statusCode, message } = await deletePermissionList(this.listRoleCiTypeId, payload)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: this.$t('delete_permission_success'),
              desc: message
            })
            this.getTableData()
            this.setBtnsStatus()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    async exportHandler () {
      this.$refs.listTable.export({
        filename: 'permission-list',
        data: formatData(this.listTableData)
      })
    },
    onSelectedRowsChange (rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        this.newOuterActions.forEach(_ => {
          _.props.disabled = false
        })
      } else {
        this.setBtnsStatus()
      }
    },
    setBtnsStatus () {
      this.newOuterActions.forEach(_ => {
        _.props.disabled = !['add', 'export'].includes(_.actionType)
      })
    }
  }
}
</script>

<style scoped lang="scss"></style>
