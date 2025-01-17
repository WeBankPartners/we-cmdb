<template>
  <div>
    <div class="search-top">
      <div class="refresh-tips" v-if="isRefreshTipsShow">
        <Icon type="ios-alert-outline" size="32" color="#2d8cf0" />
        <div style="position: relative; display: inline-block; bottom: 4px">
          {{ $t('db_refresh_tips') }}
        </div>
        <Icon
          type="ios-close"
          size="32"
          @click="isRefreshTipsShow = false"
          class="plugin-load-close-btn"
          color="#999"
        />
      </div>
      <DateGroup
        :initialDateTime="searchForm.updateTime"
        :label="$t('db_execution_time')"
        :typeList="updateTimeTypeOptions"
        :dateTypeNumber="searchForm.dateType"
        @change="onDateGroupChange"
      >
      </DateGroup>
      <Select
        v-model="searchForm.report"
        style="width:200px"
        filterable
        clearable
        :placeholder="$t('report')"
        @on-open-change="getReportList"
        @on-change="onReportChange"
      >
        <Option v-for="item in reportOptions" :value="item.id" :key="item.id" :label="item.name">{{
          item.name
        }}</Option>
      </Select>
      <Select
        v-model="searchForm.keyName"
        :disabled="!searchForm.report"
        style="width:200px"
        filterable
        clearable
        :placeholder="$t('import') + $t('refrence_object')"
        @on-change="
          () => {
            pagination.page = 1
            pagination.size = 40
            getTableData()
          }
        "
      >
        <Option v-for="item in keyNameOptions" :value="item.guid" :key="item.guid" :label="item.key_name">{{
          item.key_name
        }}</Option>
      </Select>
      <Select
        v-model="searchForm.createUser"
        style="width:200px"
        filterable
        clearable
        :placeholder="$t('db_executor')"
        @on-open-change="getCreateUserList"
        @on-change="
          () => {
            pagination.page = 1
            pagination.size = 40
            getTableData()
          }
        "
      >
        <Option v-for="user in createUserOptions" :value="user" :key="user" :label="user">
          {{ user }}
        </Option>
      </Select>
      <div style="display: flex; margin-left: auto">
        <Button type="primary" v-show="true" @click="onRefreshButtonClick">
          <Icon type="md-refresh" />
          {{ $t('db_refresh_verification_results') }}
        </Button>
        <Upload
          class="btn-left"
          :action="uploadUrl"
          :show-upload-list="false"
          :max-size="1000"
          with-credentials
          :headers="{ Authorization: token }"
          :on-success="uploadSucess"
          :on-error="uploadFailed"
        >
          <Button type="primary">
            <img src="../../assets/import.png" class="btn-img" alt="" />
            {{ $t('import') }}
          </Button>
        </Upload>
      </div>
    </div>
    <div class="content-table">
      <div class="import-history-table">
        <Table size="small" :columns="importHistoryTableColumns" :data="historyData" :max-height="tableMaxHeight" />
      </div>
      <Page
        class="table-pagination"
        :total="pagination.total"
        @on-change="
          e => {
            pagination.page = e
            this.getTableData()
          }
        "
        @on-page-size-change="
          e => {
            pagination.page = 1
            pagination.size = e
            this.getTableData()
          }
        "
        :current="pagination.page"
        :page-size="pagination.size"
        show-total
        show-sizer
      />
    </div>
  </div>
</template>

<script>
import { cloneDeep, isEmpty } from 'lodash'
import { getCookie } from '@/pages/util/cookie'
import DateGroup from '@/pages/components/date-group'
import {
  withdrawSingleImportData,
  confirmSingleImportData,
  getReportListByPermission,
  graphQueryRootCI,
  searchHistoryRecord,
  getAllCreateUser,
  refreshImportList
} from '@/api/server.js'

const initSearchForm = {
  updateTime: [],
  report: '',
  keyName: '',
  createUser: '',
  dateType: 3
}

export default {
  data () {
    return {
      searchForm: cloneDeep(initSearchForm),
      updateTimeTypeOptions: [
        {
          label: this.$t('db_last_three_days'),
          type: 'day',
          value: 3,
          dateType: 1
        },
        {
          label: this.$t('db_last_week'),
          type: 'day',
          value: 7,
          dateType: 2
        },
        {
          label: this.$t('db_last_month'),
          type: 'month',
          value: 1,
          dateType: 3
        },
        {
          label: this.$t('customizable'),
          dateType: 4
        } // 自定义
      ],
      reportOptions: [],
      keyNameOptions: [],
      createUserOptions: [],
      importHistoryTableColumns: [
        {
          title: this.$t('db_import_report'),
          width: 100,
          key: 'reportName',
          render: (h, params) => <div>{params.row.reportName || '-'}</div>
        },
        {
          title: this.$t('db_import_root_model'),
          width: 150,
          key: 'rootCiTypeName',
          render: (h, params) => (params.row.rootCiTypeName ? <Tag>{params.row.rootCiTypeName}</Tag> : <div>-</div>)
        },
        {
          title: this.$t('db_association_model'),
          width: 250,
          key: 'ciTypeNames',
          render: (h, params) => {
            if (!params.row.ciTypeNames) {
              return <div>-</div>
            }
            const arr = params.row.ciTypeNames.split(',')
            return (
              <Tooltip placement="left">
                <template slot="content">
                  <div domPropsInnerHTML={this.processAssociationModalTips(arr)}></div>
                </template>
                <div class="association-modal-content">
                  {arr.map(item => (
                    <Tag>{item}</Tag>
                  ))}
                </div>
              </Tooltip>
            )
          }
        },
        {
          title: this.$t('db_import_root_objects'),
          width: 250,
          key: 'keyNames',
          render: (h, params) => {
            if (!params.row.keyNames) {
              return <div>-</div>
            }
            const arr = params.row.keyNames.split(',')
            return (
              <Tooltip placement="left">
                <template slot="content">
                  <div domPropsInnerHTML={this.processAssociationModalTips(arr)}></div>
                </template>
                <div class="association-modal-content">
                  {arr.map(item => (
                    <Tag>{item}</Tag>
                  ))}
                </div>
              </Tooltip>
            )
          }
        },
        {
          title: this.$t('db_import_data'),
          width: 150,
          key: 'totalCount',
          render: (h, params) => <div style="color: #5a88e2">{params.row.totalCount + this.$t('db_item')}</div>
        },
        {
          title: this.$t('db_failed_verification_data'),
          width: 150,
          key: 'notPassCount',
          render: (h, params) => (
            <div style={params.row.notPassCount > 0 ? 'color: #db4f2b' : 'color: #b3ed67'}>
              {params.row.notPassCount + this.$t('db_item')}
            </div>
          )
        },
        {
          title: this.$t('db_import_status'),
          minWidth: 100,
          key: 'status',
          render: (h, params) => (
            <Tag color={this.importStatusMap[params.row.status].color}>
              {this.importStatusMap[params.row.status].text}
            </Tag>
          )
        },
        {
          title: this.$t('db_confirmation_time'),
          width: 150,
          key: 'confirmTime',
          render: (h, params) => <div>{params.row.confirmTime || '-'}</div>
        },
        {
          title: this.$t('db_executor'),
          width: 150,
          key: 'createUser',
          render: (h, params) => <div>{params.row.createUser || '-'}</div>
        },
        {
          title: this.$t('db_execution_time'),
          width: 150,
          key: 'createTime',
          render: (h, params) => <div>{params.row.createTime || '-'}</div>
        },
        {
          title: this.$t('db_updater'),
          width: 150,
          key: 'updateUser',
          render: (h, params) => <div>{params.row.updateUser || '-'}</div>
        },
        {
          title: this.$t('update_time'),
          width: 150,
          key: 'updateTime',
          render: (h, params) => <div>{params.row.updateTime || '-'}</div>
        },
        {
          title: this.$t('actions'),
          key: 'action',
          fixed: 'right',
          width: 150,
          render: (h, params) => (
            <div class="table-action">
              <Tooltip max-width={400} placement="top" transfer content={this.$t('view')}>
                <Button
                  disabled={params.row.status === 'canceled' || params.row.totalCount === 0}
                  size="small"
                  type="info"
                  on-click={() => this.showSingleDataDetail(params.row)}
                >
                  <Icon type="md-eye" size="16" />
                </Button>
              </Tooltip>
              <Poptip
                confirm
                transfer
                title={this.processConfirmTips(params.row, 'confirm')}
                placement="left-end"
                on-on-ok={() => {
                  this.confirmSingleData(params.row)
                }}
              >
                <Tooltip
                  max-width={500}
                  placement="top-start"
                  transfer
                  content={this.processConfirmTooltip(params.row)}
                >
                  <Button
                    disabled={
                      params.row.status !== 'created' || params.row.notPassCount > 0 || params.row.totalCount === 0
                    }
                    size="small"
                    class="mr-1"
                    type="success"
                  >
                    <Icon type="ios-checkmark-circle" size="16" />
                  </Button>
                </Tooltip>
              </Poptip>
              <Poptip
                confirm
                transfer
                title={this.processConfirmTips(params.row, 'withdraw')}
                placement="left-end"
                on-on-ok={() => {
                  this.withdrawSingleData(params.row)
                }}
              >
                <Tooltip max-width={400} placement="top" transfer content={this.$t('db_withdraw')}>
                  <Button
                    disabled={params.row.status !== 'created' || params.row.totalCount === 0}
                    size="small"
                    type="error"
                  >
                    <Icon type="ios-redo" size="16" />
                  </Button>
                </Tooltip>
              </Poptip>
            </div>
          )
        }
      ],
      historyData: [],
      pagination: {
        page: 1,
        size: 40,
        total: 0
      },
      importStatusMap: {
        canceled: {
          text: this.$t('db_withdrawn'),
          color: 'default'
        },
        created: {
          text: this.$t('db_to_be_confirmed'),
          color: '#b088f1'
        },
        confirmed: {
          text: this.$t('db_confirmed'),
          color: '#bfeb79'
        }
      },
      uploadUrl: '/wecmdb/api/v1/ci-data/import/app_system_design',
      token: '',
      isRefreshTipsShow: false,
      refreshId: null,
      tableMaxHeight: 0
    }
  },
  components: {
    DateGroup
  },
  beforeMount () {
    if (this.$route.query.needCache === 'yes') {
      const allFilterForm = window.sessionStorage.getItem('cmdb-data-import-filter-form') || ''
      if (allFilterForm) {
        const { searchForm, pagination } = JSON.parse(allFilterForm)
        this.searchForm = searchForm
        this.pagination = pagination
        this.searchForm.updateTime = searchForm.updateTime
        this.getReportList(true)
        this.getKeyNameOptions()
        this.getCreateUserList(true)
        window.sessionStorage.removeItem('cmdb-data-import-filter-form')
      }
      this.tableMaxHeight = window.innerHeight - 200
    }
  },
  mounted () {
    this.token = getCookie('accessToken')
  },
  methods: {
    async getTableData () {
      const params = {
        dialect: {
          queryMode: 'new'
        },
        filters: [
          {
            name: 'updateTime',
            operator: 'lt',
            value: this.searchForm.updateTime[1] ? this.searchForm.updateTime[1] + ' 23:59:59' : ''
          },
          {
            name: 'updateTime',
            operator: 'gt',
            value: this.searchForm.updateTime[0]
          },
          {
            name: 'report',
            operator: 'contains',
            value: this.searchForm.report || ''
          },
          {
            name: 'keyNames',
            operator: 'contains',
            value: this.searchForm.keyName || ''
          }
        ],
        pageable: {
          pageSize: this.pagination.size,
          startIndex: (this.pagination.page - 1) * this.pagination.size
        },
        sorting: {
          asc: false,
          field: 'updateTime'
        },
        paging: true
      }
      if (this.searchForm.createUser) {
        params.filters.push({
          name: 'createUser',
          operator: 'eq',
          value: this.searchForm.createUser
        })
      }
      const { statusCode, data } = await searchHistoryRecord(params)
      if (statusCode === 'OK') {
        this.pagination.total = data.pageInfo.totalRows
        this.historyData = data.contents
      }
    },
    showSingleDataDetail (rowData) {
      const params = {
        searchForm: this.searchForm,
        pagination: this.pagination
      }
      window.sessionStorage.setItem('cmdb-data-import-filter-form', JSON.stringify(params))
      this.$router.push({ path: '/wecmdb/designing/data-import-detail', query: { guid: rowData.guid } })
    },
    // 撤回某条数据
    async withdrawSingleData (rowData) {
      await withdrawSingleImportData({ guid: rowData.guid })
      this.$Message.success(this.$t('success'))
      this.getTableData()
    },
    async confirmSingleData (rowData) {
      await confirmSingleImportData({ guid: rowData.guid })
      this.$Message.success(this.$t('success'))
      this.getTableData()
    },
    processConfirmTips (rowData, type = 'confirm') {
      const localUserName = localStorage.getItem('username')
      if (localUserName !== rowData.createUser) {
        return this.$t('db_not_executor_tips')
      }
      if (type === 'confirm') {
        return this.$t('db_confirm_tips')
      } else {
        return this.$t('db_withdraw_tips').replace('xx', rowData.totalCount)
      }
    },
    uploadSucess (res) {
      if (res.statusCode === 'OK') {
        this.$Message.success(this.$t('db_import_tips_success'))
        this.getTableData()
      } else {
        this.$Message.error(res.statusMessage)
      }
    },
    uploadFailed () {
      this.$Message.error(this.$t('db_import_tips_failed'))
    },
    async getReportList (isShow) {
      if (isShow) {
        const { statusCode, data } = await getReportListByPermission('USE')
        if (statusCode === 'OK') {
          this.reportOptions = data
        }
      }
    },
    onReportChange () {
      this.pagination.page = 1
      this.pagination.size = 40
      this.getKeyNameOptions()
    },
    async getKeyNameOptions () {
      if (this.searchForm.report) {
        let params = {
          reportId: this.searchForm.report,
          withoutChildren: true
        }
        const { statusCode, data } = await graphQueryRootCI(params)
        if (statusCode === 'OK') {
          this.keyNameOptions = data
        }
        this.getTableData()
      } else {
        this.searchForm.keyName = ''
        this.keyNameOptions = []
        this.getTableData()
      }
    },
    onDateGroupChange (arr, dateType) {
      this.searchForm.updateTime = cloneDeep(arr)
      this.searchForm.dateType = dateType
      this.getTableData()
    },
    async getCreateUserList (isShow) {
      if (isShow) {
        const { statusCode, data } = await getAllCreateUser()
        if (statusCode === 'OK') {
          this.createUserOptions = data
        }
      }
    },
    processConfirmTooltip (rowData) {
      if (rowData.status === 'created' && rowData.notPassCount > 0) {
        return this.$t('db_confirm_tooltip_text').replace('xx', rowData.notPassCount)
      }
      return this.$t('db_confirme')
    },
    processAssociationModalTips (arr) {
      if (isEmpty(arr)) {
        return '-'
      }
      return arr.join('<br>')
    },
    async refreshVerificationResults () {
      this.isRefreshTipsShow = true
      await refreshImportList()
      this.$Message.success(this.$t('db_refresh_success'))
      clearInterval(this.refreshId)
      this.refreshId = null
      this.isRefreshTipsShow = false
      this.pagination.page = 1
      this.pagination.size = 40
      this.getTableData()
    },
    onRefreshButtonClick () {
      this.refreshVerificationResults()
      this.refreshId = setInterval(() => {
        this.refreshVerificationResults()
      }, 300000)
    }
  }
}
</script>

<style lang="scss">
.import-history-table {
  .ivu-table-fixed-body {
    height: calc(100vh - 235px) !important;
  }
  .association-modal-content {
    width: 250px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .table-action {
    display: flex;
    justify-content: space-around;
  }
}
</style>
<style scoped lang="scss">
.search-top {
  position: relative;
  display: flex;
  justify-content: flex-start;
  align-items: center;
  .refresh-tips {
    position: absolute;
    top: -80px;
    right: -20px;
    z-index: 1000000;
    padding: 16px;
    border-radius: 4px;
    box-shadow: 0 1px 6px rgba(0, 0, 0, 0.2);
    background: #fff;
  }
  .btn-left {
    margin-left: 15px;
    .btn-img {
      width: 16px;
      vertical-align: middle;
    }
  }
}
.search-top > div {
  margin-right: 15px;
}
.content-table {
  margin-top: 15px;
  .table-pagination {
    position: fixed;
    bottom: 10px;
    right: 10px;
  }
}
</style>
