<template>
  <div class="ci-data-page">
    <div class="refresh-tips" v-if="isRefreshTipsShow">
      <Icon type="ios-alert-outline" size="32" color="#2d8cf0" />
      <div style="position: relative; display: inline-block; bottom: 4px">
        {{ $t('db_refresh_tips') }}
      </div>
      <Icon type="ios-close" size="32" @click="isRefreshTipsShow = false" class="plugin-load-close-btn" color="#999" />
    </div>
    <div class="ci-header-info">
      <div class="ci-header-info-first">
        <Icon size="22" class="arrow-back" type="md-arrow-back" @click="returnPreviousPage"></Icon>
        <div>{{ $t('report') + '【' + reportName + '】' }}</div>
        <div>{{ $t('db_root_ci') + '【' + rootCiName + '】' }}</div>
        <div>{{ $t('refrence_object') + '【' + objectName + '】' }}</div>
        <div class="action-button">
          <Button
            type="primary"
            :disabled="detailStatus === 'confirmed'"
            v-show="true"
            @click="refreshVerificationResults"
          >
            <Icon type="md-refresh" />
            {{ $t('db_refresh_verification_results') }}
          </Button>
          <Poptip
            class="confirm-button"
            confirm
            transfer
            :title="processConfirmTips('confirm')"
            placement="left"
            @on-ok="confirmSingleData(guid)"
          >
            <Tooltip :max-width="500" placement="top-start" transfer :content="processConfirmTooltip()">
              <Button :disabled="failedVerificationNumber > 0 || detailStatus !== 'created'" type="success">
                {{ $t('db_confirme') }}
              </Button>
            </Tooltip>
          </Poptip>
          <Poptip confirm :title="processConfirmTips('withdraw')" placement="left" @on-ok="withdrawSingleData(guid)">
            <Button :disabled="detailStatus !== 'created'" type="error">
              {{ $t('db_withdraw') }}
            </Button>
          </Poptip>
        </div>
      </div>
      <Row>
        <Col span="2"
          >{{ $t('db_total_number') + ': '
          }}<span style="color: #5a88e2">{{ reportTotalNumber + $t('db_item') }}</span></Col
        >
        <Col span="3" style="margin-left: -20px"
          >{{ $t('db_failed_verification_data') + ': '
          }}<span style="color: #db4f2b">{{ failedVerificationNumber + $t('db_item') }}</span></Col
        >
        <Col span="3">{{ $t('db_executor') + ': ' + this.executorName }}</Col>
        <Col span="4">{{ $t('db_execution_time') + ': ' + this.executionTime }}</Col>
        <Col span="3">{{ $t('db_updater') + ': ' + this.updaterName }}</Col>
        <Col span="4">{{ $t('update_time') + ': ' + this.updateTime }}</Col>
        <Col span="4">{{ $t('db_confirmation_time') + ': ' + this.confirmTime }}</Col>
      </Row>
    </div>
    <Tabs type="card" v-model="currentTab" closable @on-click="handleTabClick">
      <TabPane
        v-for="ci in tabList"
        :key="ci.ciType"
        :name="ci.ciType"
        :label="renderLabel(ci)"
        :disabled="ci.totalCount === 0"
      >
      </TabPane>
    </Tabs>
    <CMDBTable
      :key="tableKey"
      class="import-data-table"
      ref="cmdbTable"
      :ciTypeId="currentTab"
      :tableData="allTableData"
      :tableOuterActions="outerActions"
      :tableInnerActions="innerActions"
      :tableColumns="tableColumns"
      :pagination="pagination"
      :ascOptions="ascOptions"
      :showCheckbox="needCheckout"
      :isRefreshable="true"
      :queryType="queryType"
      @actionFun="actionFun"
      @handleSubmit="handleSubmit"
      @sortHandler="sortHandler"
      @getSelectedRows="onSelectedRowsChange"
      @pageChange="pageChange"
      @pageSizeChange="pageSizeChange"
      @confirmAddHandler="confirmAddHandler"
      @confirmEditHandler="confirmEditHandler"
      @resetSearchForm="onSearchFormReset"
      tableHeight="650"
    ></CMDBTable>
    <!-- 对比 -->
    <Modal
      v-model="compareVisible"
      :title="$t('version_change') + $t('compare')"
      footer-hide
      width="90"
      class-name="compare-modal"
    >
      <Table class="test" :columns="compareColumns" :max-height="MODALHEIGHT" :data="compareData" border />
    </Modal>
    <SelectFormOperation ref="selectForm" @callback="callback"></SelectFormOperation>
  </div>
</template>
<script>
import { cloneDeep, isEmpty, find, remove } from 'lodash'
import {
  getReportImportAttributes,
  queryCiData,
  tableOptionExcute,
  getEnumCategoriesById,
  getStateTransition,
  confirmSingleImportData,
  getSingleImportRecordInfo,
  queryImportData,
  withdrawSingleImportData,
  refreshImportSingleItem
} from '@/api/server'
import { pagination, components } from '@/const/actions.js'
import SelectFormOperation from '@/pages/components/select-form-operation'

const initPayload = {
  dialect: {
    queryMode: 'new'
  },
  filters: [],
  pageable: {
    pageSize: 10,
    startIndex: 0
  },
  sorting: { asc: false, field: 'update_time' },
  paging: true
}

export default {
  provide () {
    return {
      ciDataManagementQueryType: this.queryType
    }
  },
  data () {
    return {
      spinShow: false,
      tabList: [],
      currentTab: '',
      payload: cloneDeep(initPayload),
      source: {},
      ciTypesName: {},
      compareColumns: [],
      compareVisible: false,
      compareData: [],
      options: {
        disabledDate (date) {
          return date && date.valueOf() > Date.now()
        }
      },
      queryType: 'new', // new - 最新； real - 现实； all - 所有；
      MODALHEIGHT: 500,
      reportName: '',
      objectName: '',
      rootCiName: '',
      reportTotalNumber: 0,
      failedVerificationNumber: 0,
      executorName: '',
      executionTime: '',
      updaterName: '',
      updateTime: '',
      allTableData: [],
      outerActions: [],
      innerActions: [],
      tableColumns: [],
      pagination: cloneDeep(pagination),
      ascOptions: {},
      guid: '',
      detailStatus: '',
      tableKey: '',
      isRefreshTipsShow: false,
      confirmTime: ''
    }
  },
  computed: {
    needCheckout () {
      return this.$route.name !== 'ciDataEnquiry'
    }
  },
  async mounted () {
    // this.MODALHEIGHT = window.MODALHEIGHT
    if (this.$route.query.guid) {
      this.guid = this.$route.query.guid
      await this.getSingleRecordInfo()
      this.initPageInfo()
    } else {
      this.$router.push({ path: '/wecmdb/designing/data-management-import' })
    }
  },
  methods: {
    getSingleRecordInfo (currentTab = '') {
      return new Promise(async resolve => {
        let { statusCode, data } = await getSingleImportRecordInfo(this.guid)
        if (statusCode === 'OK') {
          this.reportName = data.reportHistoryObject.reportName || '-'
          this.objectName = data.reportHistoryObject.keyNames || '-'
          this.rootCiName = data.reportHistoryObject.rootCiTypeName || '-'
          this.reportTotalNumber = data.reportHistoryObject.totalCount
          this.failedVerificationNumber = data.reportHistoryObject.notPassCount
          this.executorName = data.reportHistoryObject.createUser || '-'
          this.executionTime = data.reportHistoryObject.createTime || '-'
          this.updaterName = data.reportHistoryObject.updateUser || '-'
          this.updateTime = data.reportHistoryObject.updateTime || '-'
          this.confirmTime = data.reportHistoryObject.confirmTime || '-'
          this.tabList = data.reportHistoryCiDataStatistics
          this.detailStatus = data.reportHistoryObject.status
          if (!isEmpty(this.tabList)) {
            this.currentTab = currentTab || this.tabList[0].ciType
            resolve(this.currentTab)
          }
        }
      })
    },
    callback () {
      this.queryCiData()
    },
    async getStateTransition (ciTypeId) {
      let stateBtn = []
      if (this.$route.name !== 'ciDataEnquiry') {
        const { statusCode, data } = await getStateTransition(ciTypeId)
        if (statusCode === 'OK') {
          stateBtn = data.map(item => {
            item.props = {}
            item.props.type = 'primary'
            item.props.disabled = !['Add'].includes(item.operation_en)
            return item
          })
        }
      }
      return stateBtn
    },
    async initPageInfo () {
      let stateTransition = await this.getStateTransition(this.currentTab)
      this.outerActions = []
      if (find(stateTransition, { operation: '删除' })) {
        this.outerActions.push(find(stateTransition, { operation: '删除' }))
      }
      if (find(stateTransition, { operation: '更新' })) {
        this.outerActions.push(find(stateTransition, { operation: '更新' }))
      } else {
        if (find(stateTransition, { operation: '变更' })) {
          this.outerActions.push(find(stateTransition, { operation: '变更' }))
        }
      }
      await this.getTableColumns()
      this.innerActions = [
        {
          operation: this.$t('compare'),
          operationFormType: 'compare_form',
          operationMultiple: 'yes',
          operation_en: 'Compare',
          props: {
            type: 'primary',
            disabled: false
          }
        }
      ]
      this.tableKey = +new Date() + ''
      setTimeout(() => {
        this.onSearchFormReset()
      }, 300)
    },
    async getTableColumns () {
      return new Promise(async resolve => {
        this.tableColumns = await this.queryCiAttrs(this.currentTab)
        this.tableColumns.forEach(item => {
          item.uiFormLabelShow = false
        })
        resolve()
      })
    },
    async queryCiData () {
      this.payload.pageable.pageSize = 10
      this.payload.pageable.startIndex = 0
      this.payload.pageable.pageSize = this.pagination.pageSize
      this.payload.pageable.startIndex = (this.pagination.currentPage - 1) * this.pagination.pageSize
      const queryObject = cloneDeep(this.payload)
      const findCheckResult = find(queryObject.filters, {
        name: 'check_result'
      })
      if (!isEmpty(findCheckResult)) {
        const checkResultVal = findCheckResult.value
        if (checkResultVal === 'nameDuplicate') {
          queryObject.filters.push({
            name: 'is_unique',
            operator: 'eq',
            value: 0
          })
        } else if (checkResultVal === 'requiredNotFilled') {
          queryObject.filters.push({
            name: 'is_not_empty',
            operator: 'eq',
            value: 0
          })
        } else if (checkResultVal === 'pass') {
          queryObject.filters.push(
            ...[
              {
                name: 'is_unique',
                operator: 'eq',
                value: 1
              },
              {
                name: 'is_not_empty',
                operator: 'eq',
                value: 1
              }
            ]
          )
        }
        remove(queryObject.filters, item => item.name === 'check_result')
      }
      queryObject.filters.push({
        name: 'report_import_guid',
        operator: 'eq',
        value: this.guid
      })
      const query = {
        id: this.currentTab,
        queryObject
      }
      this.$refs.cmdbTable.isTableLoading(true)
      const { statusCode, data } = await queryImportData(query)
      this.$refs.cmdbTable.isTableLoading(false)
      if (statusCode === 'OK') {
        this.pagination.total = data.pageInfo.totalRows
        this.allTableData = data.contents
      }
      this.setBtnsStatus()
    },
    onSelectedRowsChange (rows) {
      if (rows.length > 0 && this.detailStatus !== 'confirmed') {
        this.outerActions.forEach(_ => {
          _.props.disabled = false
        })
      } else {
        this.setBtnsStatus()
      }
    },
    actionFun (operate, data) {
      switch (operate.operationFormType) {
        case 'editable_form': // 更新弹窗
          data.forEach(item => {
            delete item.check_result
            delete item.is_not_empty
            delete item.is_unique
          })
          this.editHandler(operate.operation_en)
          break
        case 'compare_form':
          this.compareHandler(data)
          break
        case 'confirm_form': // 删除单条
          this.confirmHandler(operate.operation_en, data)
          break
        case 'select_form':
          this.selectHandler(operate.operation_en, data)
          break
      }
    },
    async compareHandler (row) {
      this.compareColumns = this.tableColumns.map(item => {
        item.width = 120
        return item
      })
      remove(this.compareColumns, item => item.key === 'check_result')
      const query = {
        id: this.currentTab,
        queryObject: {
          dialect: { queryMode: 'all' },
          filters: [
            {
              name: 'guid',
              operator: 'in',
              value: [row.weTableForm.guid]
            }
          ],
          sorting: { asc: false, field: 'update_time' }
        }
      }
      const { statusCode, data } = await queryCiData(query)
      this.$set(row.weTableForm, 'compareLoading', false)
      if (statusCode === 'OK') {
        this.compareData = data && data.contents
        this.compareData = this.compareData.map(x => {
          for (let k in x) {
            if (typeof x[k] === 'object' && x[k] !== null) x[k] = x[k].value || x[k].key_name
          }
          return x
        })
        for (let i = 0; i < this.compareData.length - 1; i++) {
          const pre = this.compareData[i]
          const cur = this.compareData[i + 1]
          for (let key in cur) {
            cur.cellClassName = cur.cellClassName || {}
            if (cur[key] !== pre[key]) {
              cur.cellClassName[key] = 'highlightTableCell'
            }
          }
        }
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
      this.payload.filters = data
      this.pagination.currentPage = 1
      this.queryCiData()
    },
    async selectHandler (operationType, rollbackData) {
      const params = {
        operation: operationType,
        ciType: this.currentTab,
        guid: rollbackData[0].guid
      }
      this.$refs.selectForm.initFormData(params)
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
          const { statusCode, message } = await tableOptionExcute(operateType, this.currentTab, payload)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: operateType + ' successfully',
              desc: message
            })
            await this.getSingleRecordInfo(this.currentTab)
            this.queryCiData()
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
        this.$refs.cmdbTable.pushNewAddedRowToSelections(emptyRowData)
        this.$refs.cmdbTable.showAddModal()
      } else {
        this.$refs.cmdbTable.showEditModal()
      }
    },
    confirmAddHandler (data, operateType) {
      this.confirmEditHandler(data, operateType)
    },
    async confirmEditHandler (data, operateType) {
      let addAry = JSON.parse(JSON.stringify(data))
      addAry.forEach(_ => {
        delete _.isRowEditable
        delete _.weTableForm
        delete _.weTableRowId
        delete _.isNewAddedRow
        delete _.nextOperations
      })
      const { statusCode, message } = await tableOptionExcute(operateType, this.currentTab, addAry)
      this.$refs.cmdbTable.resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('update_data_success'),
          desc: message
        })
        await this.getSingleRecordInfo(this.currentTab)
        this.queryCiData()
        this.$refs.cmdbTable.closeEditModal(false)
      }
    },
    setBtnsStatus () {
      this.outerActions.forEach(_ => {
        _.props.disabled = !['Add', 'Export'].includes(_.operation_en)
      })
    },
    pageChange (current) {
      this.pagination.currentPage = current
      this.queryCiData()
    },
    pageSizeChange (size) {
      this.pagination.pageSize = size
      this.queryCiData()
    },
    async queryCiAttrs (id) {
      const { statusCode, data } = await getReportImportAttributes(id) // 最新的
      if (statusCode === 'OK') {
        let columns = []
        for (let index = 0; index < data.length; index++) {
          let renderKey = data[index].propertyName
          if (data[index].status !== 'decommissioned' && data[index].status !== 'notCreated') {
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
            const columnItem = {
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
              referenceFilter: data[index].referenceFilter,
              ciType: { id: data[index].referenceId, name: data[index].name },
              type: 'text',
              isMultiple: data[index].inputType === 'multiSelect',
              ...components[data[index].inputType],
              options: data[index].options
            }

            if (columnItem.propertyName === 'check_result') {
              Object.assign(columnItem, {
                component: 'WeCMDBRadioRroup',
                span: 6,
                options: [
                  {
                    label: 'all',
                    text: '所有'
                  },
                  {
                    label: 'nameDuplicate',
                    text: '唯一名重复'
                  },
                  {
                    label: 'requiredNotFilled',
                    text: '必填项未填'
                  },
                  {
                    label: 'pass',
                    text: '通过'
                  }
                ],
                groupType: 'button',
                colWidth: 250,
                radioText: 'db_verification_status',
                tagOptions: [
                  {
                    color: '#bfeb79',
                    value: '11',
                    label: '通过'
                  },
                  {
                    color: '#f4cc45',
                    value: '10',
                    label: '必填项未填'
                  },
                  {
                    color: '#cb5a38',
                    value: '01',
                    label: '唯一性校验不通过'
                  }
                ]
              })
            }
            columns.push(columnItem)
          }
        }
        return columns
      }
    },
    renderLabel (item) {
      const type = item.isRootCiType ? 'ios-flag' : 'ios-leaf'
      const color = item.isRootCiType ? '#db4f2b' : '#5a88e2'
      return h =>
        h('div', {}, [
          h('Icon', {
            props: {
              type,
              color,
              size: '20'
            }
          }),
          h('span', { style: {} }, item.ciTypeDisplayName + '('),
          h('span', { style: { color: '#5a88e2' } }, item.totalCount),
          h('span', { style: {} }, '/'),
          h('span', { style: { color: '#db4f2b' } }, item.notPassCount),
          h('span', { style: {} }, ')')
        ])
    },
    async confirmSingleData (guid) {
      const { statusCode } = await confirmSingleImportData({ guid })
      if (statusCode === 'OK') {
        await this.getSingleRecordInfo()
        this.initPageInfo()
        this.$Message.success(this.$t('success'))
      } else {
        this.$Message.error(this.$t('db_action_failed'))
      }
    },
    processConfirmTips (type = 'confirm') {
      const localUserName = localStorage.getItem('username')
      if (localUserName !== this.executorName) {
        return this.$t('db_not_executor_tips')
      }
      if (type === 'confirm') {
        return this.$t('db_confirm_tips')
      } else {
        return this.$t('db_withdraw_tips').replace('xx', this.reportTotalNumber)
      }
    },
    async withdrawSingleData (guid) {
      const { statusCode } = await withdrawSingleImportData({ guid })
      if (statusCode === 'OK') {
        this.$router.push({ path: '/wecmdb/designing/data-management-import' })
      } else {
        this.$Message.error(this.$t('db_action_failed'))
      }
    },
    onSearchFormReset () {
      this.$refs.cmdbTable.form.check_result = 'all'
      this.$refs.cmdbTable.form.key_name = ''
      this.$refs.cmdbTable.form.state = ''
      this.$refs.cmdbTable.form.code = ''
      this.pagination.pageSize = 10
      this.pagination.currentPage = 1
      this.payload = cloneDeep(initPayload)
      this.queryCiData()
    },
    processConfirmTooltip () {
      if (this.failedVerificationNumber > 0) {
        return this.$t('db_confirm_tooltip_text').replace('xx', this.failedVerificationNumber)
      }
      return this.$t('db_confirme')
    },
    processObjectNameTooltipText (name) {
      if (!name || name === '-') {
        return name
      }
      return name.split(',').join('<br>')
    },
    handleTabClick () {
      this.initPageInfo()
    },
    returnPreviousPage () {
      window.history.back()
    },
    async refreshVerificationResults () {
      this.isRefreshTipsShow = true
      await refreshImportSingleItem(this.guid)
      this.isRefreshTipsShow = false
      this.$Message.success(this.$t('db_refresh_success'))
      await this.getSingleRecordInfo()
      this.initPageInfo()
    }
  },
  components: {
    SelectFormOperation
  }
}
</script>
<style lang="scss">
.import-data-table {
  .cmdb-table-content {
    max-height: calc(100vh - 370px);
    overflow-y: auto;
  }
  .form-filter {
    .ivu-col-span-6 {
      min-width: 420px;
    }
  }
}
.highlightTableCell {
  color: rgba(#ff6600, 0.9) !important;
}
</style>
<style lang="scss" scoped>
.ci-data-page {
  position: relative;
  .refresh-tips {
    position: absolute;
    top: -80px;
    right: 0px;
    z-index: 1000000;
    padding: 16px;
    border-radius: 4px;
    box-shadow: 0 1px 6px rgba(0, 0, 0, 0.2);
    background: #fff;
  }
}

::deep .compare-modal .ivu-modal-body {
  padding-top: 40px;
}

::deep .copy-modal {
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

.ci-header-info {
  margin-bottom: 10px;
  .ci-header-info-first {
    display: flex;
    align-items: center;
    font-size: 16px;
    margin-bottom: 8px;
  }
  .ci-header-info-first > div {
    margin-right: 10px;
  }
  .action-button {
    margin-left: auto;
    .confirm-button {
      margin: 0 10px;
    }
  }
  .object-name-text {
    display: inline-block;
    width: 190px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .update-info {
    margin-bottom: 10px;
  }
  .arrow-back {
    cursor: pointer;
    width: 28px;
    height: 24px;
    color: #fff;
    border-radius: 2px;
    background: #2d8cf0;
    margin-right: 12px;
  }
}
</style>
