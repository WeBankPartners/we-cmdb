<template>
  <div>
    <Row>
      <Col span="4">
        <span style="margin-right: 10px">{{ $t('display_type') }}</span>
        <RadioGroup
          v-model="displayType"
          class="report-query-radio"
          type="button"
          button-style="solid"
          @on-change="onDisplayTypeRadioChange"
        >
          <Radio v-for="item in ['tree', 'table']" :key="item" :label="item" border>{{ item }}</Radio>
        </RadioGroup>
      </Col>
      <Col span="5">
        <span style="margin-right: 10px">{{ $t('report') }}</span>
        <Select
          v-model="currentReportId"
          @on-open-change="getReportList"
          @on-change="getReportFilterData"
          filterable
          clearable
          @on-clear="clearReport"
          style="width: 75%;"
        >
          <Option v-for="item in reportList" :value="item.id" :key="item.id">{{ item.name }}</Option>
        </Select>
      </Col>
      <Col span="8" v-if="displayType === 'tree'" style="margin-left: 15px">
        <span style="margin-right: 10px">{{ displayDataLable }}</span>
        <Select
          v-model="treeRoot"
          filterable
          multiple
          :max-tag-count="1"
          style="width: 60%;"
          @on-query-change="
            e => {
              rootCiKeyName = e
              debounceGetRootOptions()
            }
          "
          @on-open-change="onTreeRootOpenChange"
          @on-change="getReportData"
        >
          <Option
            v-for="item in treeRootOptions"
            :value="item.guid"
            :key="item.guid"
            :label="item.key_name + item.update_time"
          >
            <div style="display: flex; justify-content: space-between">
              <span>{{ item.key_name }}</span>
              <span style="display: inline-block;font-size: 12px; color: #A7ACB5; margin-right: 15px">{{
                item.update_time
              }}</span>
            </div>
          </Option>
        </Select>
        <Button
          v-if="currentReportId"
          style="margin-left: 5px"
          type="primary"
          shape="circle"
          size="small"
          icon="ios-funnel-outline"
          @click="onFilterButtonClick"
        ></Button>
      </Col>
      <div class="upload-content" v-if="displayType === 'tree'">
        <Button @click="enterImportHistoryPage" class="import-history-button">{{ $t('db_import_history') }}</Button>
        <Poptip confirm :title="$t('db_quick_confirm')" placement="left" @on-ok="onItemCopyConfirm">
          <Button style="margin-left: 10px" type="success" :disabled="!currentReportId || treeRoot.length === 0">{{
            $t('db_quick_copy')
          }}</Button>
        </Poptip>
        <Upload
          :action="uploadUrl"
          :show-upload-list="false"
          :max-size="1000"
          with-credentials
          :headers="{ Authorization: token }"
          :on-success="uploadSucess"
          :on-error="uploadFailed"
        >
          <Button class="btn-upload btn-left">
            <img src="@/styles/icon/UploadOutlined.png" class="upload-icon" />
            {{ $t('import') }}
          </Button>
        </Upload>
        <Button
          class="btn-upload"
          :disabled="!currentReportId || treeRoot.length === 0 || currentReportItem.usedByExport === 'no'"
          @click="exportReportData"
        >
          <img src="@/styles/icon/DownloadOutlined.png" class="upload-icon" alt="" />
          {{ $t('export') }}
        </Button>
      </div>
    </Row>
    <div v-show="displayType === 'table'">
      <Row v-if="filters.length > 0 && displayType === 'table'" style="margin: 16px 0">
        <span v-for="(filter, index) in filters" :key="index" class="report-filter">
          <Button
            size="small"
            :style="{ color: filter.isOpen ? '#5384FF' : '', 'border-color': filter.isOpen ? '#5384FF' : '' }"
            @click="openFilter(index)"
            >{{ filter.key }}</Button
          >
        </span>
      </Row>
      <Row v-if="filters.length > 0 && displayType === 'table'" style="margin: 16px 0">
        <Form :label-width="200">
          <span v-for="(filter, index) in filters" :key="index" class="report-filter">
            <template v-if="filter.isOpen">
              <template v-for="attrss in filter.params">
                <FormItem
                  v-if="attrss.querialbe === 'yes'"
                  :label="filter.key + '.' + attrss.dataTitleName"
                  style="display:inline-block;margin-bottom:0"
                  :key="attrss.id"
                >
                  <Input v-model="attrss.value" style="width:150px"></Input>
                </FormItem>
              </template>
            </template>
          </span>
          <Button type="primary" :disabled="filters.length === 0" :loading="btnLoading" @click="getReportData">{{
            $t('query')
          }}</Button>
        </Form>
      </Row>
      <Row v-if="hasTableData">
        <Button type="success" @click="ShowMessage" icon="ios-eye">{{ $t('show_message') }}</Button>
        <Table :columns="tableColumns" :data="tableData" border max-height="500"></Table>
        <Page
          :total="payload.pageable.total"
          :page-size="payload.pageable.pageSize"
          @on-page-size-change="changePageSize"
          :current="payload.pageable.current"
          @on-change="changePage"
          show-sizer
          show-total
        />
      </Row>
    </div>
    <div class="fix-right-icon" v-if="currentReportId" @click="onFixIconClick">
      <Icon type="md-git-merge" :size="25" />
      <span>{{ $t('db_report_template') }}</span>
    </div>
    <template v-if="displayType === 'tree' && treeSet.length > 0">
      <Tabs @on-click="changeTab" :value="treeSet[0].guid" v-if="showTab">
        <TabPane
          v-for="tree in treeSet"
          :label="'[' + tree.dataTitleName + '] ' + tree.key_name"
          :name="tree.guid"
          :key="tree.guid"
        >
          <Row>
            <Col span="7">
              <div :style="{ height: MODALHEIGHT + 'px', overflow: 'auto' }">
                <Tree :data="[tree]" @on-select-change="showDetail" :render="renderContent"></Tree>
              </div>
            </Col>
            <Col span="16" offset="1">
              <div :style="{ height: MODALHEIGHT + 'px', overflow: 'auto' }">
                <CiDisplay ref="ciDisplay"></CiDisplay>
              </div>
            </Col>
          </Row>
        </TabPane>
      </Tabs>
    </template>
    <Drawer
      v-model="isDrawerShow"
      :title="$t('db_report_template')"
      :width="70"
      :closable="true"
      :mask="true"
      :mask-style="{ opacity: 0.2 }"
    >
      <div class="drawer-tips" @click="onDrawerTipsClick">
        {{
          reportDetail.name +
            ' -【' +
            reportDetail.createUser +
            '】- ' +
            (reportDetail.updateTime || reportDetail.createTime)
        }}
      </div>
      <div v-if="isDrawerShow">
        <CiGraph
          class="ci-graph"
          :editorBoxInRight="true"
          :isPreviewState="true"
          :ciGraphData="ciGraphData"
          :attributeObject="attributeObject"
          :currentReportId="currentReportId"
          @onRefresh="getStrc"
        />
      </div>
    </Drawer>
    <Modal v-model="showRowData" :title="$t('basic_data')" width="700" footer-hide>
      <div :style="{ maxHeight: MODALHEIGHT + 'px', maxWidth: '700px', overflow: 'auto' }">
        <pre>{{ rowData }}</pre>
      </div>
    </Modal>

    <Modal v-model="filtersAndResultModal" :title="$t('message')" footer-hide width="75">
      <div style="max-height: 600px; overflow: auto;">
        <Row
          >{{ $t('request_url') }}
          <span>{{ requestURL }}</span>
        </Row>
        <Row>
          <Col span="11"
            >Payload:
            <pre>{{ payload }}</pre>
          </Col>
          <Col span="12" offset="1"
            >Result:
            <pre>{{ tableData }}</pre>
          </Col>
        </Row>
      </div>
    </Modal>

    <Modal
      v-model="isFilterModelShow"
      :title="displayDataLable"
      width="75"
      :ok-text="$t('search')"
      :mask-closable="false"
      @on-ok="filterTreeRoot"
    >
      <div class="filter-model-content">
        <div class="filter-content-item" v-for="(item, index) in filterSearchInfo" :key="index">
          <span class="filter-content-item-label">{{ item.description }}</span>
          <Input
            v-if="['text', 'textArea'].includes(item.inputType)"
            v-model="filterSearchValue[item.propertyName]"
            clearable
            style="width: 60%;"
          >
          </Input>
          <Select
            v-if="['select', 'ref'].includes(item.inputType)"
            v-model="filterSearchValue[item.propertyName]"
            filterable
            clearable
            style="width: 60%;"
            @on-open-change="isShow => getFilterRulesOptions(isShow, item)"
          >
            <Option
              v-for="single in item.options || []"
              :value="single.guid"
              :key="single.guid"
              :label="single.key_name"
            >
            </Option>
          </Select>
          <Select
            v-if="['multiSelect', 'multiRef'].includes(item.inputType)"
            v-model="filterSearchValue[item.propertyName]"
            filterable
            multiple
            style="width: 60%;"
            @on-open-change="isShow => getFilterRulesOptions(isShow, item)"
          >
            <Option
              v-for="single in item.options || []"
              :value="single.guid"
              :key="single.guid"
              :label="single.key_name"
            >
            </Option>
          </Select>
        </div>
      </div>
    </Modal>
  </div>
</template>

<script>
import { isEmpty, debounce, cloneDeep, find } from 'lodash'
import {
  getReportListByPermission,
  getReportData,
  exportReport,
  queryCiData,
  getReportFilterData,
  getCiTypeAttr,
  graphQueryRootCI,
  getReportStruct,
  getCiTypeNameMap,
  getCiTypeAttributes,
  queryReferenceCiData,
  reportCopyQuick,
  getEnumCategoriesById
} from '@/api/server'
import CiDisplay from '@/pages/designing/report-query-tree-attr'
import CiGraph from '../components/ci-graph.js'
import { getCookie } from '@/pages/util/cookie'
import { intervalTips } from '../util/format.js'

const operatorMap = {
  text: 'contains',
  textArea: 'contains',
  select: 'eq',
  ref: 'eq',
  multiSelect: 'in',
  multiRef: 'in'
}

export const custom_api_enum = [
  {
    url: '/wecmdb/api/v1/ci-data/import/app_system_design',
    method: 'POST'
  }
]

export default {
  components: {
    CiDisplay,
    CiGraph
  },
  data() {
    return {
      MODALHEIGHT: 500,
      btnLoading: false,
      fullscreen: false,
      dataDetail: {
        isShow: false,
        data: ''
      },
      showTab: false,
      displayType: 'tree',
      strcData: [],
      treeRoot: [],
      treeRootOptions: [],
      treeSet: [],
      currentReportId: '',
      currentCiType: '',
      reportList: [],
      filters: [],
      allCiTypes: [],
      selectedQueryName: '',
      tableData: [],
      hasTableData: false,
      tableColumns: [],
      payload: {
        filters: [],
        pageable: {
          total: 0,
          current: 1,
          pageSize: 10,
          startIndex: 0
        },
        paging: true
      },
      showRowData: false,
      rowData: '',
      filtersAndResultModal: false,
      showfiltersAndResultModalData: '',
      requestURL: '',
      currentTabIndex: 0,
      token: '',
      uploadUrl: '/wecmdb/api/v1/ci-data/import/app_system_design',
      oriDataMap: {},
      isDrawerShow: false,
      ciGraphData: null,
      attributeObject: {},
      reportDetail: {},
      rootCiKeyName: '',
      isFilterModelShow: false,
      filterSearchValue: {},
      filterSearchInfo: [],
      filterAllInputType: ['text', 'textArea', 'select', 'ref', 'multiSelect', 'multiRef'],
      find: find,
      intervalId: ''
    }
  },
  computed: {
    currentReportItem() {
      const item = this.reportList.find(item => item.id === this.currentReportId) || {}
      return item
    },
    displayDataLable() {
      let label = this.$t('db_root_objects')
      if (this.reportDetail.ciType) {
        label = label + '[' + this.oriDataMap[this.reportDetail.ciType] + ']'
      }
      return label
    }
  },
  beforeDestroy() {
    clearInterval(this.intervalId)
  },
  async mounted() {
    this.MODALHEIGHT = document.body.scrollHeight - 200
    this.token = getCookie('accessToken')
    const { data, statusCode } = await getCiTypeNameMap()
    if (statusCode === 'OK') {
      this.oriDataMap = data
    }
    this.getReportList('init')
    this.intervalId = setInterval(() => {
      if (
        (this.displayType === 'tree' && this.currentReportId && !isEmpty(this.treeRoot)) ||
        (this.displayType === 'table' && this.currentReportId)
      ) {
        this.getReportData(false)
        this.$Notice.success({
          title: '',
          desc: '',
          render: h => intervalTips(h)
        })
      }
    }, 3 * 60 * 1000)
  },
  methods: {
    changeReportType() {
      this.currentReportId = ''
      this.currentCiType = ''
      this.clearReport()
    },
    clearReport() {
      this.showTab = false
      this.filters = []
      this.hasTableData = false
      this.treeRootOptions = []
      this.treeRoot = []
      this.reportDetail = {}
      this.currentReportId = ''
      this.currentCiType = ''
    },
    changeTab(val) {
      this.currentTabIndex = this.treeSet.findIndex(item => item.key_name === val)
    },
    renderContent(h, { root, node, data }) {
      return h(
        'span',
        {
          style: {
            display: 'inline-block',
            width: '100%'
          }
        },
        [
          h(
            'Button',
            {
              props: {
                size: 'small'
              },
              style: {
                display: data.dataTitleName ? 'inline-block' : 'none',
                marginRight: '10px'
              }
            },
            data.dataTitleName
          ),
          h('span', [h('span', data.title)])
        ]
      )
    },
    async showDetail(itemArray, itemSingle) {
      const item = itemArray[0] || itemSingle
      const index = item.guid.lastIndexOf('_')
      const ci = item.guid.substring(0, index)
      const payload = {
        id: ci,
        queryObject: {
          dialect: { queryMode: 'new' },
          filters: [{ name: 'guid', operator: 'eq', value: item.guid }],
          paging: false,
          sorting: {}
        }
      }
      let [ciData, ciAttr] = await Promise.all([queryCiData(payload), getCiTypeAttr(ci)])
      if (ciData.statusCode === 'OK' && ciAttr.statusCode === 'OK') {
        this.$refs.ciDisplay[this.currentTabIndex].initData(ciAttr.data, ciData.data.contents)
      }
    },
    async displayTree() {
      this.treeSet = []
      await this.getStrc()
      await this.getData()
      this.showTab = true
    },
    async getData() {
      if (this.treeRoot.length === 0) {
        return
      }
      let params = {
        reportId: this.currentReportId,
        withoutChildren: false,
        rootCiList: this.treeRoot
      }
      let { statusCode, data } = await graphQueryRootCI(params)
      if (statusCode === 'OK') {
        let treeOptions = data || []
        this.treeSet = []
        treeOptions.forEach(tree => {
          this.treeSet.push(tree)
          this.singleTree(tree)
        })
      }
    },
    singleTree(tree) {
      tree.title = tree.key_name
      tree.expand = true
      tree.dataTitleName = this.oriDataMap[this.splitString(tree.guid)]
      const keys = Object.keys(tree)
      let tmp = []
      keys.forEach(key => {
        if (Array.isArray(tree[key])) {
          const resKey = key + '*-*' + 'parent'
          const find = this.strcData.find(item => item === resKey)
          if (find) {
            let tmpChildren = tree[key]
            tmpChildren.forEach(t => {
              t.parent = key
              t.dataTitleName = this.oriDataMap[this.splitString(t.guid)]
            })
            tmp = tmp.concat(tmpChildren)
          }
        }
      })
      tree.children = tmp
      this.managementData(tree.children)
    },
    managementData(children) {
      children.forEach(child => {
        child.title = child.key_name
        const keys = Object.keys(child)
        let tmp = []
        keys.forEach(key => {
          if (Array.isArray(child[key])) {
            const resKey = child.parent + '*-*' + key
            const find = this.strcData.find(item => item === resKey)
            if (find) {
              let tmpChildren = child[key]
              tmpChildren.forEach(t => {
                t.parent = key
                t.dataTitleName = this.oriDataMap[this.splitString(t.guid)]
              })
              tmp = tmp.concat(tmpChildren)
            }
          }
        })
        child.children = tmp
        this.managementData(child.children)
      })
    },
    splitString(str) {
      if (str) {
        return str.substring(0, str.lastIndexOf('_'))
      }
      return ''
    },
    async getStrc() {
      const { statusCode, data } = await getReportStruct(this.currentReportId)
      if (statusCode === 'OK') {
        this.reportDetail = data
        const oriData = data.object[0].object
        oriData.forEach(ori => {
          this.strcData.push(ori.dataName + '*-*' + 'parent')
        })
        this.ciGraphData = this.formatAttr(data.object)[0]
        // this.attrs = this.calCiTypeAttrs(data.object)
        this.returnPath(oriData)
      }
    },
    returnPath(data) {
      data.map(d => {
        if (d.object.length > 0) {
          d.object.forEach(obj => {
            this.strcData.push(d.dataName + '*-*' + obj.dataName)
            obj.parent = d.dataName
          })
          this.returnPath(d.object)
        }
      })
    },
    changeReport() {
      this.filters = []
      this.tableData = []
      this.tableColumns = []
    },
    ShowMessage() {
      this.filtersAndResultModal = true
    },
    openFilter(index) {
      this.filters[index].isOpen = !this.filters[index].isOpen
    },
    async getReportList(type = '') {
      const { statusCode, data } = await getReportListByPermission('USE')
      if (statusCode === 'OK') {
        this.reportList = data
        if (type === 'init' && !isEmpty(this.reportList)) {
          // 路由携带reportId, 默认选择
          if (this.$route.query.reportId) {
            this.currentReportId = this.$route.query.reportId
            this.getReportFilterData()
          } else {
            this.currentReportId = this.reportList[0].id
            this.currentCiType = this.reportList[0].ciType
            this.getReportFilterData()
            setTimeout(() => {
              if (!isEmpty(this.treeRootOptions)) {
                this.treeRoot = [this.treeRootOptions[0].guid]
                this.getReportData(true)
              }
            }, 800)
          }
        }
      }
    },
    async getReportFilterData() {
      if (!this.currentReportId) return
      const findOne = find(this.reportList, { id: this.currentReportId })
      this.currentCiType = findOne.ciType
      await this.getStrc()
      if (this.displayType === 'tree') {
        this.filterSearchValue = {}
        this.filterSearchInfo = []
        this.treeRoot = []
        this.getReportRoot()
        return
      }
      this.hasTableData = false
      const { statusCode, data } = await getReportFilterData(this.currentReportId)
      if (statusCode === 'OK') {
        this.filters = []
        data.object.forEach(filter => {
          this.filters.push({
            key: filter.dataTitleName,
            isOpen: false,
            params:
              filter.attr &&
              filter.attr.map(item => {
                item.value = ''
                return item
              })
          })
        })
        this.tableColumns = []
        data.object.forEach(filter => {
          let tmp = {}
          tmp.title = filter.dataTitleName
          tmp.width = 200
          tmp.align = 'center'
          if (filter.attr && filter.attr.length > 0) {
            tmp.children = []
            filter.attr.forEach(attr => {
              tmp.children.push({
                title: attr.dataTitleName,
                key: attr.id,
                width: 200,
                align: 'center'
              })
            })
          }
          this.tableColumns.push(tmp)
        })
        this.tableColumns.push({
          title: 'Action',
          key: 'action',
          fixed: 'right',
          width: 150,
          align: 'center',
          render: (h, params) => {
            return h('div', [
              h(
                'Button',
                {
                  props: {
                    type: 'primary',
                    size: 'small'
                  },
                  style: {
                    marginRight: '5px'
                  },
                  on: {
                    click: event => {
                      this.showRowDataFun(params.row)
                    }
                  }
                },
                this.$t('view')
              )
            ])
          }
        })
      }
    },
    async filterTreeRoot() {
      if (isEmpty(this.filterSearchValue)) {
        return
      }
      const filters = []
      for (let key in this.filterSearchValue) {
        if (isEmpty(this.filterSearchValue[key])) {
          continue
        }
        const findOne = find(this.filterSearchInfo, { propertyName: key })
        filters.push({
          name: key,
          operator: operatorMap[findOne.inputType],
          value: this.filterSearchValue[key]
        })
      }
      if (isEmpty(filters)) {
        return
      }
      this.treeRoot = []
      const query = {
        id: this.currentCiType,
        queryObject: {
          dialect: { queryMode: 'new' },
          filters,
          sorting: { asc: false, field: 'update_time' }
        }
      }
      const { statusCode, data } = await queryCiData(query)
      if (statusCode === 'OK') {
        !isEmpty(data.contents) &&
          data.contents.forEach(item => {
            this.treeRoot.push(item.guid)
          })
      }
    },
    async getReportRoot() {
      if (!this.currentCiType) return
      const query = {
        id: this.currentCiType,
        queryObject: {
          dialect: { queryMode: 'new' },
          filters: [],
          sorting: { asc: false, field: 'update_time' }
        }
      }
      const { statusCode, data } = await queryCiData(query)
      if (statusCode === 'OK') {
        this.treeRootOptions = data.contents || []
      }
    },
    showRowDataFun(row) {
      const newRow = JSON.parse(JSON.stringify(row))
      delete newRow._index
      delete newRow._rowKey
      this.rowData = newRow
      this.showRowData = true
    },
    changePageSize(pageSize) {
      this.payload.pageable.pageSize = pageSize
      this.payload.pageable.startIndex = (this.payload.pageable.current - 1) * this.payload.pageable.pageSize
      this.getReportData(false)
    },
    changePage(page) {
      this.payload.pageable.current = page
      this.payload.pageable.startIndex = (this.payload.pageable.current - 1) * this.payload.pageable.pageSize
      this.getReportData(false)
    },
    async getReportData(tag = true) {
      if (this.displayType !== 'table') {
        this.currentTabIndex = 0
        this.displayTree()
        return
      }
      this.payload.filters = []
      this.filters.forEach(filter => {
        filter.params &&
          filter.params.forEach(p => {
            if (p.value !== '') {
              this.payload.filters.push({
                name: p.id,
                operator: 'contains',
                value: p.value
              })
            }
          })
      })
      if (tag) {
        this.payload.pageable.current = 1
        this.payload.pageable.startIndex = 0
      }
      this.requestURL = `/report-data/${this.currentReportId}`
      this.btnLoading = true
      setTimeout(() => {
        this.btnLoading = false
      }, 5000)
      const { statusCode, data } = await getReportData(this.currentReportId, this.payload)
      this.btnLoading = false
      if (statusCode === 'OK') {
        this.hasTableData = true
        this.tableData = data.contents
        this.payload.pageable.total = data.pageInfo.totalRows
      }
    },
    async exportReportData() {
      let params = {
        reportId: this.currentReportId,
        rootCiData: this.treeRoot
      }
      const { statusCode, data } = await exportReport(params)
      if (statusCode === 'OK') {
        this.download(data)
      }
    },
    download(res) {
      const filename = `${res.reportId}copy.json`
      res = JSON.stringify(res, undefined, 4)
      var blob = new Blob([res], { type: 'text/json' })
      var e = document.createEvent('MouseEvents')
      var a = document.createElement('a')
      a.download = filename
      a.href = window.URL.createObjectURL(blob)
      a.dataset.downloadurl = ['text/json', a.download, a.href].join(':')
      e.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null)
      a.dispatchEvent(e)
    },
    uploadFailed() {
      this.$Message.error(this.$t('db_import_tips_failed'))
    },
    uploadSucess(res) {
      if (res.statusCode === 'OK') {
        this.$router.push('/wecmdb/designing/data-management-import')
      } else {
        this.$Message.error({
          content: res.statusMessage || this.$t('db_request_error'),
          duration: 4
        })
      }
    },
    enterImportHistoryPage() {
      this.$router.push('/wecmdb/designing/data-management-import')
    },
    onFixIconClick() {
      this.isDrawerShow = true
    },
    formatAttr(data) {
      return data.map(_ => {
        let result = {
          ..._,
          attributeList: _.attr
            ? _.attr.map((attrId, index) => {
                let _result = {
                  ciTypeAttrId: attrId.id
                }
                _result.name = _.dataTitleName
                _result.attrKeyName = _.dataName
                this.attributeObject[attrId.id] = _result
                return _result
              })
            : []
        }
        if (_.object instanceof Array) {
          result.object = this.formatAttr(_.object)
        }
        return result
      })
    },
    onDrawerTipsClick() {
      this.$router.push({ path: '/wecmdb/report-configuration', query: { reportId: this.currentReportId } })
    },
    onDisplayTypeRadioChange() {
      this.currentReportId = ''
      this.currentCiType = ''
      this.treeRoot = []
      this.treeRootOptions = []
      this.filterSearchValue = {}
      this.filterSearchInfo = []
      this.treeSet = []
    },
    onTreeRootOpenChange(status) {
      if (status) {
        this.getReportRoot()
      }
    },
    debounceGetRootOptions: debounce(function() {
      this.getReportRoot()
    }, 800),
    async onItemCopyConfirm() {
      const params = {
        reportId: this.currentReportId,
        rootCiData: this.treeRoot
      }
      const { statusCode } = await reportCopyQuick(params)
      if (statusCode === 'OK') {
        this.$router.push('/wecmdb/designing/data-management-import')
      }
    },
    async onFilterButtonClick() {
      if (isEmpty(this.filterSearchValue) && isEmpty(this.filterSearchInfo)) {
        const { statusCode, data } = await getCiTypeAttributes(this.currentCiType)

        if (statusCode === 'OK') {
          const filterSearchArr = data.filter(item => {
            if (item.uiSearchOrder > 0 && this.filterAllInputType.includes(item.inputType)) {
              return item
            }
          })
          for (let index = 0; index < filterSearchArr.length; index++) {
            const filterItem = filterSearchArr[index]
            this.filterSearchValue[filterItem.propertyName] = ''
            filterItem.options = filterItem.options || []
            if (filterItem.status !== 'decommissioned' && filterItem.status !== 'notCreated') {
              if (['select', 'multiSelect'].includes(filterItem.inputType) && filterItem.selectList !== '') {
                const res = await getEnumCategoriesById(filterItem.selectList)
                if (res.statusCode === 'OK') {
                  filterItem.options = res.data.map(item => {
                    return {
                      key_name: item.value,
                      guid: item.code
                    }
                  })
                }
              }
            }
          }
          this.filterSearchInfo = cloneDeep(filterSearchArr)
        }
      }
      this.isFilterModelShow = true
    },
    async getFilterRulesOptions(isShow, item) {
      if (isShow && ['ref', 'multiRef'].includes(item.inputType)) {
        item.options = await this.getAllDataWithoutPaging(item.ciTypeAttrId)
      }
    },
    async getAllDataWithoutPaging(ciTypeAttrId) {
      return new Promise(async resolve => {
        const { statusCode, data } = await queryReferenceCiData({
          attrId: ciTypeAttrId,
          queryObject: { filters: [], paging: false, dialect: { associatedData: {} } }
        })
        if (statusCode === 'OK') {
          resolve(data)
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.header-query {
  display: flex;
  justify-content: center;
  > span {
    height: 32px;
    line-height: 32px;
    margin-right: 10px;
  }
  > div {
    flex: 1;
  }
}

.fix-right-icon {
  position: fixed;
  top: calc(50% - 14px);
  right: 0;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 5px;
  border: 1px solid #a7acb5;
  z-index: 3;
  opacity: 1;
  background-color: #5bb4ef;
  font-size: 12px;
}

.drawer-tips {
  margin-top: -5px;
  margin-bottom: 5px;
  display: inline-block;
  width: 100%;
  height: 32px;
  line-height: 1.5;
  font-size: 14px;
  color: rgb(6, 156, 236);
  cursor: pointer;
  padding: 4px 20px;
  border-width: 1px;
  border-style: solid;
  border-color: rgb(6, 156, 236);
  border-image: initial;
  border-radius: 4px;
}

.upload-content {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  .btn-left {
    margin: 0 10px;
  }
  .btn-img {
    width: 16px;
    vertical-align: middle;
  }
}

.filter-model-content {
  display: flex;
  flex-wrap: wrap;
  .filter-content-item {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    width: 30%;
    margin-top: 20px;
    margin-left: 15px;
    .filter-content-item-label {
      display: flex;
      width: 120px;
      justify-content: center;
    }
  }
}
</style>

<style lang="scss">
.report-query-radio {
  .ivu-radio-wrapper-checked.ivu-radio-border {
    background-color: #5384FF;;
    color: #fff;
  }
}
.ci-graph {
  .ci-graph-root {
    height: 87vh;
    max-width: 35% !important;
    border: 1px solid #bbbbbb;
    border-right: 0px;
  }
  .editor-box-right {
    margin-left: 0;
    width: 65% !important;
    border: 1px solid #bbbbbb;
    .first-tab-pane {
      max-height: 80vh;
    }
  }
  .attribute-content {
    max-height: 80vh;
  }
}
</style>
