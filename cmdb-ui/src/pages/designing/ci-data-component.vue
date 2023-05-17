<template>
  <div class="ci-data-page">
    <!-- :guidFilters="tableFilters" -->
    <CMDBTable
      :ciTypeId="ci"
      :tableData="tableData"
      :tableOuterActions="outerActions"
      :tableInnerActions="innerActions"
      :tableColumns="tableColumns"
      :pagination="pagination"
      :ascOptions="ascOptions"
      :showCheckbox="needCheckout"
      :isRefreshable="true"
      :queryType="queryType"
      :guidFilters="tableFilters"
      :guidFilterEffects="tableFilterEffects"
      @actionFun="actionFun"
      @handleSubmit="handleSubmit"
      @sortHandler="sortHandler"
      @getSelectedRows="onSelectedRowsChange"
      @pageChange="pageChange"
      @pageSizeChange="pageSizeChange"
      @confirmAddHandler="confirmAddHandler"
      @confirmEditHandler="confirmEditHandler"
      tableHeight="650"
      :ref="'table'"
    ></CMDBTable>

    <!-- 对比 -->
    <Modal footer-hide v-model="compareVisible" width="90" class-name="compare-modal">
      <Table :columns="compareColumns" :data="compareData" border />
    </Modal>

    <!-- @on-cancel="cancel" -->
    <Modal v-model="rollbackConfig.isShow" width="900" @on-ok="okRollback" title="数据回退">
      <div>
        <CMDBTable
          :ciTypeId="rollbackConfig.id"
          :tableData="rollbackConfig.table.tableData"
          :tableColumns="rollbackConfig.table.tableColumns"
          :showCheckbox="needCheckout"
          :tableInnerActions="null"
          :isRefreshable="true"
          :filtersHidden="true"
          @getSelectedRows="onSelectedRowsChangeRollBack"
          tableHeight="650"
          :ref="'table' + 111"
        ></CMDBTable>
      </div>
    </Modal>
    <SelectFormOperation ref="selectForm" @callback="callback"></SelectFormOperation>
  </div>
</template>
<script>
import moment from 'moment'
import { finalDataForRequest } from '../util/component-util'
import { components } from '@/const/actions.js'
import SelectFormOperation from '@/pages/components/select-form-operation'
import {
  getCiTypeAttributes,
  queryCiData,
  // getRollbackData,
  tableOptionExcute,
  operateCiState,
  getEnumCategoriesById,
  getStateTransition
} from '@/api/server'
import { baseURL } from '@/api/base.js'
import { formatData } from '../util/format.js'
export default {
  provide () {
    return {
      ciDataManagementQueryType: this.queryType
    }
  },
  watch: {
    isEdit: {
      handler: function (val) {
        if (val) {
          this.outerActions = this.ciOuterActions
        } else {
          this.outerActions = []
        }
      },
      deep: true,
      immediate: true
    }
  },
  data () {
    return {
      tableColumns: [],
      tableData: [],
      ciOuterActions: [],
      outerActions: [],
      innerActions: [
        {
          operation: '对比',
          operationFormType: 'compare_form',
          operationMultiple: 'yes',
          operation_en: 'Compare',
          props: {
            type: 'primary',
            disabled: false
          }
        }
      ],
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0
      },
      ascOptions: {},
      needCheckout: true,
      queryType: 'new',

      rollbackConfig: {
        isShow: false,
        table: {
          tableData: [],
          tableColumns: []
        }
      },
      baseURL,
      payload: {
        dialect: {
          queryMode: 'new'
        },
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true
      },
      compareColumns: [],
      compareVisible: false,
      compareData: [],
      copyRows: [],
      copyEditData: null
    }
  },
  props: ['ci', 'ciTypeName', 'tableFilters', 'tableFilterEffects', 'isEdit'],
  computed: {
    filterByDate () {
      if (this.queryDate) {
        return [
          {
            name: 'updated_time',
            operator: 'lt',
            value: moment(this.queryDate).format('YYYY-MM-DD HH:mm:ss')
          }
        ]
      } else {
        return null
      }
    }
  },
  methods: {
    callback (ci, items) {
      this.queryCiData()
      this.$emit('editCiRowData', ci, items)
    },
    async getStateTransition (ciTypeId) {
      const { statusCode, data } = await getStateTransition(ciTypeId)
      if (statusCode === 'OK') {
        let stateBtn = data.map(item => {
          item.props = {}
          item.props.type = 'primary'
          item.props.disabled = !['Add'].includes(item.operation_en)
          return item
        })
        stateBtn.push({
          operation: '导出',
          operationFormType: 'export_form',
          operationMultiple: 'yes',
          class: 'xxx',
          operation_en: 'Export',
          props: {
            type: 'primary',
            disabled: false
          }
        })
        return stateBtn
      }
    },
    onSelectedRowsChange (rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        let opArray = []
        rows.forEach(r => {
          opArray = opArray.concat(r.nextOperations)
        })
        const activeBtn = new Set(opArray)
        this.outerActions.forEach(_ => {
          _.props.disabled = !(activeBtn.has(_.operation_en) || ['Add', 'Export'].includes(_.operation_en))
          if (rows.length > 1 && _.operationMultiple !== 'yes') {
            _.props.disabled = true
          }
        })
      } else {
        this.setBtnsStatus()
      }
    },
    actionFun (operate, data, cols, filters) {
      switch (operate.operationFormType) {
        case 'export_form':
          this.exportHandler(filters)
          break
        case 'editable_form':
          this.editHandler(operate.operation_en)
          break
        case 'compare_form':
          this.compareHandler(data)
          break
        case 'confirm_form':
          this.confirmHandler(operate.operation_en, data)
          break
        case 'select_form':
          this.selectHandler(operate.operation_en, data)
          break
      }
    },
    copyHandler (rows = [], cols) {
      this.$refs.table.showCopyModal()
    },
    async compareHandler (row) {
      // this.$set(row.weTableForm, 'compareLoading', true)
      this.compareColumns = this.tableColumns
      const query = {
        id: this.ci,
        queryObject: {
          dialect: { queryMode: this.queryType },
          filters: [
            {
              name: 'guid',
              operator: 'in',
              value: [row.weTableForm.guid, row.weTableForm.p_guid]
            }
          ]
        }
      }
      const { statusCode, data } = await queryCiData(query)
      this.$set(row.weTableForm, 'compareLoading', false)
      if (statusCode === 'OK') {
        this.compareData = data && data.contents
        this.compareData = this.compareData
          .map(x => {
            for (let k in x) {
              if (typeof x[k] === 'object' && x[k] !== null) x[k] = x[k].value || x[k].key_name
            }
            return x
          })
          .map((x, idx) => {
            const len = this.compareData.length
            // if (x.guid === row.weTableForm.guid) {
            x.cellClassName = {}
            for (let k in x) {
              if (this.compareData[len - idx] && x[k] !== this.compareData[len - idx][k]) {
                x.cellClassName[k] = 'highlight'
              }
            }
            // }
            return x
          })
      }
      this.compareVisible = true
    },
    sortHandler (data) {
      if (data.order === 'normal') {
        delete this.payload.sorting
      } else {
        this.payload.sorting = {
          asc: data.order === 'asc',
          field: data.key
        }
      }
      this.queryCiData()
    },
    handleSubmit (data) {
      if (this.filterByDate) {
        this.payload.filters = this.filterByDate.concat(data)
      } else {
        this.payload.filters = data
      }
      this.pagination.currentPage = 1
      this.queryCiData()
    },
    async defaultHandler (type, row) {
      this.$set(row.weTableForm, `${type}Loading`, true)
      const { statusCode, message } = await operateCiState(this.ci, row.guid, type)
      this.$set(row.weTableForm, `${type}Loading`, false)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('success'),
          desc: message
        })
        this.queryCiData()
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
      emptyRowData['weTableRowId'] = 1
      emptyRowData['nextOperations'] = []
      this.$refs.table.pushNewAddedRowToSelections(emptyRowData)
      this.$refs.table.showAddModal()
    },
    async selectHandler (operationType, rollbackData) {
      const params = {
        operation: operationType,
        ciType: this.ci,
        guid: rollbackData[0].guid
      }
      this.$refs.selectForm.initFormData(params)
    },
    onSelectedRowsChangeRollBack (rows) {
      this.rollbackConfig.selectData = rows
    },
    async okRollback () {
      const finalData = finalDataForRequest(this.rollbackConfig.selectData)
      const { statusCode, message } = await tableOptionExcute('Rollback', this.ci, finalData)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('success'),
          desc: message
        })
        this.queryCiData()
      }
    },
    confirmHandler (operateType, confirmData) {
      this.$Modal.confirm({
        title: this.$t('confirm_action'),
        'z-index': 1000000,
        onOk: async () => {
          const payload = confirmData.map(_ => {
            return {
              guid: _.guid
            }
          })
          const resp = await tableOptionExcute(operateType, this.ci, payload)
          if (resp.statusCode === 'OK') {
            this.$Notice.success({
              title: operateType + ' successfully',
              desc: resp.message
            })
            // NOTE: hard to reconize with delete and confirm, so don't remove filter
            // resp.data.forEach(el => {
            //   let idx = this.tableFilters[this.ci].indexOf(el.guid)
            //   if (idx >= 0) {
            //     this.tableFilters[this.ci].splice(idx, 1)
            //   }
            // })
            this.queryCiData()
            this.$emit('confirmCiRowData', this.ci, resp.data)
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    deleteHandler (deleteData) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        'z-index': 1000000,
        onOk: async () => {
          const payload = deleteData.map(_ => {
            return {
              guid: _.guid
            }
          })
          const resp = await tableOptionExcute('Delete', this.ci, payload)
          if (resp.statusCode === 'OK') {
            this.$Notice.success({
              title: 'Deleted successfully',
              desc: resp.message
            })
            // NOTE: hard to reconize with delete and confirm, so don't remove filter
            // resp.data.forEach(el => {
            //   let idx = this.tableFilters[this.ci].indexOf(el.guid)
            //   if (idx >= 0) {
            //     this.tableFilters[this.ci].splice(idx, 1)
            //   }
            // })
            this.queryCiData()
            this.$emit('confirmCiRowData', this.ci, resp.data)
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    editHandler (operateType) {
      if (operateType === 'Add') {
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
        emptyRowData['weTableRowId'] = 1
        emptyRowData['nextOperations'] = []
        this.$refs.table.pushNewAddedRowToSelections(emptyRowData)
        this.$refs.table.showAddModal()
      } else {
        this.$refs.table.showEditModal()
      }
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
    async confirmAddHandler (data, operateType) {
      this.confirmEditHandler(data, operateType, true)
    },
    async confirmEditHandler (data, operateType, isAdd = false) {
      // const deleteAttrs = this.deleteAttr()
      let addAry = JSON.parse(JSON.stringify(data))
      addAry.forEach(_ => {
        // deleteAttrs.forEach(attr => {
        //   delete _[attr]
        // })
        delete _.isRowEditable
        delete _.weTableForm
        delete _.weTableRowId
        delete _.isNewAddedRow
        delete _.nextOperations
      })
      const resp = await tableOptionExcute(operateType, this.ci, addAry)
      this.$refs.table.resetModalLoading()
      if (resp.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('add_data_success'),
          desc: resp.message
        })
        if (isAdd) {
          resp.data.forEach(el => {
            this.tableFilters[this.ci].push(el.guid)
          })
        }
        this.queryCiData()
        this.$refs.table.closeEditModal(false)
        if (isAdd) {
          this.$emit('addCiRowData', this.ci, resp.data)
        } else {
          this.$emit('editCiRowData', this.ci, resp.data)
        }
      }
    },
    async confirmEditHandlerOld (data) {
      let editAry = JSON.parse(JSON.stringify(data))
      editAry.forEach(_ => {
        delete _.isRowEditable
        delete _.weTableForm
        delete _.weTableRowId
        delete _.isNewAddedRow
        delete _.nextOperations
        // delete _.confirm_time
      })
      const { statusCode, message } = await tableOptionExcute('Update', this.ci, editAry)
      this.$refs.table.resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('update_data_success'),
          desc: message
        })
        this.queryCiData()
        this.$refs.table.closeEditModal(false)
      }
    },
    setBtnsStatus () {
      this.outerActions.forEach(_ => {
        _.props.disabled = !['Add', 'Export'].includes(_.operation_en)
      })
    },
    async exportHandler (filters) {
      this.outerActions.forEach(_ => {
        if (_.actionType === 'export') {
          _.props.loading = true
        }
      })
      const { statusCode, data } = await queryCiData({
        id: this.ci,
        queryObject: {
          filters: filters,
          dialect: { queryMode: this.queryType }
        }
      })
      this.outerActions.forEach(_ => {
        if (_.actionType === 'export') {
          _.props.loading = false
        }
      })
      if (statusCode === 'OK') {
        this.$refs.table.export({
          filename: this.ciTypeName,
          data: formatData(data.contents)
        })
      }
    },
    pageChange (current) {
      this.pagination.currentPage = current
      this.queryCiData()
    },
    pageSizeChange (size) {
      this.pagination.pageSize = size
      this.queryCiData()
    },
    async queryCiData () {
      this.payload.sorting = { asc: false, field: 'update_time' }
      this.payload.pageable.pageSize = 10
      this.payload.pageable.startIndex = 0
      this.payload.pageable.pageSize = this.pagination.pageSize
      this.payload.pageable.startIndex = (this.pagination.currentPage - 1) * this.pagination.pageSize
      let guids = this.tableFilters[this.ci] || []
      if (guids.length) {
        let query = JSON.parse(
          JSON.stringify({
            id: this.ci,
            queryObject: this.payload
          })
        )
        query.queryObject.filters.push({ name: 'guid', operator: 'in', value: guids })
        const method = queryCiData
        this.$refs.table.isTableLoading(true)
        const { statusCode, data } = await method(query)
        this.$refs.table.isTableLoading(false)
        if (statusCode === 'OK') {
          this.tableData = data.contents.map(_ => {
            return {
              ..._
              // nextOperations: _.meta.nextOperations || []
            }
          })
          this.pagination.total = data.pageInfo.totalRows
        }
      }
      this.setBtnsStatus()
    },
    async queryCiAttrs (id) {
      const { statusCode, data } = await getCiTypeAttributes(id)
      if (statusCode === 'OK') {
        let columns = []
        for (let index = 0; index < data.length; index++) {
          let renderKey = data[index].propertyName
          if (data[index].status !== 'deleted' && data[index].status !== 'notCreated') {
            if (['select', 'multiSelect'].includes(data[index].inputType) && data[index].selectList !== '') {
              const res = await getEnumCategoriesById(data[index].selectList)
              if (res.statusCode === 'OK') {
                data[index].options = res.data.map(item => {
                  return {
                    label: item.value,
                    value: item.code
                  }
                })
              }
            }
            columns.push({
              ...data[index],
              tooltip: true,
              title: data[index].name,
              renderHeader: (h, params) => {
                const d = {
                  props: {
                    'min-width': '130px',
                    'max-width': '500px'
                  }
                }
                return (
                  <Tooltip {...d} content={data[index].description} placement="top">
                    <span style="white-space:normal">{data[index].name}</span>
                  </Tooltip>
                )
              },
              key: renderKey,
              inputKey: data[index].propertyName,
              inputType: data[index].inputType,
              referenceId: data[index].referenceId,
              disEditor: !data[index].isEditable,
              disAdded: !data[index].isEditable,
              placeholder: data[index].name,
              component: 'Input',
              referenceFilter: !!data[index].referenceFilter,
              ciType: { id: data[index].referenceId, name: data[index].name },
              type: 'text',
              isMultiple: data[index].inputType === 'multiSelect',
              ...components[data[index].inputType],
              options: data[index].options
            })
          }
        }
        return columns
      }
    },
    async init () {
      this.ciOuterActions = await this.getStateTransition(this.ci)
      this.tableColumns = await this.queryCiAttrs(this.ci)
      if (this.isEdit) {
        this.outerActions = this.ciOuterActions
      }
      await this.queryCiData()
    }
  },
  mounted () {
    this.init()
  },
  components: {
    SelectFormOperation
  }
}
</script>

<style lang="scss" scoped>
::v-deep .compare-modal .ivu-modal-body {
  padding-top: 40px;
}
::v-deep .ivu-table td.highlight {
  color: rgba(#ff6600, 0.9);
}

::v-deep .copy-modal {
  .ivu-modal-body {
    max-height: 450px;
    overflow-y: auto;
  }
  .ivu-select-selection {
    min-height: 24px !important;
    height: 26px !important;
  }
  .copy-form {
    display: flex;
    flex-flow: column nowrap;
  }

  .copy-input {
    display: flex;
    flex-flow: row nowrap;
    margin-top: 20px;
    align-items: center;

    .ivu-input-number {
      flex: 1;
      margin-right: 15px;
    }
  }
}

.history-query {
  display: flex;
  flex-flow: row nowrap;
  justify-content: flex-end;
  align-items: center;

  .label {
    white-space: nowrap;
    margin: 0 5px 0 20px;
  }

  ::v-deep .ivu-input,
  ::v-deep .ivu-select-selection {
    height: 28px;
    min-height: 28px !important;
    .ivu-select-placeholder,
    .ivu-select-selected-value {
      height: 28px;
      line-height: 28px;
    }
  }

  ::v-deep .ivu-select-multiple .ivu-tag {
    height: 21px;
    line-height: 21px;
  }

  ::v-deep .ivu-input-suffix i {
    line-height: 28px;
  }

  .ivu-date-picker {
    width: 160px;
  }

  .ivu-select {
    width: 100px;
  }

  .filter-title {
    margin-right: 5px;
  }

  .filter-col-icon {
    margin-right: 5px;
  }
}
</style>
