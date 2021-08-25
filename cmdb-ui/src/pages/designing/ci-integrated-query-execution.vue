<template>
  <div>
    <Row>
      <Col span="6">
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
      <Col span="6">
        <span style="margin-right: 10px">{{ $t('display_type') }}</span>
        <Select v-model="displayType" @on-change="changeReportType" style="width: 75%;">
          <Option v-for="item in ['table', 'tree']" :value="item" :key="item">{{ item }}</Option>
        </Select>
      </Col>
      <Col span="6" v-if="displayType === 'tree'">
        <span style="margin-right: 10px">{{ $t('display_type') }}</span>
        <Select v-model="treeRoot" filterable multiple style="width: 75%;">
          <Option v-for="item in treeRootOptions" :value="item.code" :key="item.code">{{ item.code }}</Option>
        </Select>
      </Col>
      <Button
        type="primary"
        :disabled="!currentReportId || treeRoot.length === 0"
        v-if="displayType !== 'table'"
        @click="getReportData"
        >{{ $t('query') }}</Button
      >
    </Row>
    <template v-if="displayType === 'table'">
      <Row v-if="filters.length > 0 && displayType === 'table'" style="margin: 16px 0">
        <span v-for="(filter, index) in filters" :key="index" class="report-filter">
          <Button
            size="small"
            :style="{ color: filter.isOpen ? '#2d8cf0' : '', 'border-color': filter.isOpen ? '#2d8cf0' : '' }"
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
          <Button type="primary" :disabled="filters.length === 0" @click="getReportData">{{ $t('query') }}</Button>
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
    </template>
    <template v-else>
      <Tabs @on-click="changeTab" :value="treeSet[0].code" v-if="showTab">
        <TabPane v-for="tree in treeSet" :label="tree.code" :name="tree.code" :key="tree.code">
          <Row>
            <Col span="8">
              <div :style="{ height: MODALHEIGHT + 'px', overflow: 'auto' }">
                <Tree :data="[tree]" @on-select-change="showDetail" :render="renderContent"></Tree>
              </div>
            </Col>
            <Col span="15" offset="1">
              <div :style="{ height: MODALHEIGHT + 'px', overflow: 'auto' }">
                <pre>{{ dataDetail.data }}</pre>
              </div>
            </Col>
          </Row>
        </TabPane>
      </Tabs>
    </template>
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
    <!-- <Modal v-model="dataDetail.isShow" :fullscreen="fullscreen" width="800" footer-hide>
      <p slot="header">
        <span>Detail</span>
        <Icon
          v-if="!fullscreen"
          @click="fullscreen = true"
          style="float: right;margin: 3px 40px 0 0 !important;"
          type="ios-expand"
        />
        <Icon
          v-else
          @click="fullscreen = false"
          style="float: right;margin: 3px 40px 0 0 !important;"
          type="ios-contract"
        />
      </p>
      <div :style="{ overflow: 'auto', 'max-height': fullscreen ? '' : '500px' }">
        <pre>{{ dataDetail.data }}</pre>
      </div>
    </Modal> -->
  </div>
</template>

<script>
import {
  getReportListByPermission,
  getReportData,
  queryCiData,
  getReportFilterData,
  graphQueryRootCI,
  getReportStruct
} from '@/api/server'
export default {
  components: {},
  data () {
    return {
      MODALHEIGHT: 500,
      fullscreen: false,
      dataDetail: {
        isShow: false,
        data: ''
      },
      showTab: false,
      displayType: 'table',
      strcData: [],
      treeRoot: [],
      treeRootOptions: [],
      treeSet: [],
      currentReportId: '',
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
      requestURL: ''
      // MODALHEIGHT: 600
    }
  },
  created () {},
  mounted () {
    this.MODALHEIGHT = document.body.scrollHeight - 200
  },
  methods: {
    changeReportType () {
      this.currentReportId = ''
      this.clearReport()
    },
    clearReport () {
      this.showTab = false
      this.filters = []
      this.hasTableData = false
      this.treeRootOptions = []
      this.treeRoot = []
    },
    changeTab () {
      this.dataDetail.data = ''
    },
    renderContent (h, { root, node, data }) {
      return h(
        'span',
        {
          style: {
            display: 'inline-block',
            width: '100%'
          }
        },
        [h('a', [h('span', data.title)])]
      )
    },
    async showDetail (itemArray, itemSingle) {
      const item = itemArray[0] || itemSingle
      const payload = {
        id: item.guid.substring(0, item.guid.length - 17),
        queryObject: {
          dialect: { queryMode: 'new' },
          filters: [{ name: 'guid', operator: 'eq', value: item.guid }],
          paging: false,
          sorting: {}
        }
      }
      const { data, statusCode } = await queryCiData(payload)
      if (statusCode === 'OK') {
        this.dataDetail.data = ''
        this.dataDetail.isShow = true
        this.dataDetail.data = data.contents
      }
    },
    async displayTree () {
      await this.getStrc()
      this.getData()
      this.showTab = true
    },
    async getData () {
      this.treeSet = []
      this.treeRootOptions.forEach(d => {
        if (this.treeRoot.includes(d.code)) {
          this.treeSet.push(d)
          this.treeSet.forEach(tree => {
            this.singleTree(tree)
          })
        }
      })
    },
    singleTree (tree) {
      tree.title = tree.key_name
      // tree.expand = true
      const keys = Object.keys(tree)
      let tmp = []
      keys.forEach(key => {
        if (Array.isArray(tree[key])) {
          const find = this.strcData.find(item => item === key + '*-*' + 'parent')
          if (find) {
            let tmpChildren = tree[key]
            tmpChildren.forEach(t => {
              t.parent = key
            })
            tmp = tmp.concat(tmpChildren)
          }
        }
      })
      tree.children = tmp
      this.managementData(tree.children)
    },
    managementData (children) {
      children.forEach(child => {
        child.title = child.key_name
        // child.expand = true
        const keys = Object.keys(child)
        let tmp = []
        keys.forEach(key => {
          if (Array.isArray(child[key])) {
            const find = this.strcData.find(item => item === child.parent + '*-*' + key)
            if (find) {
              let tmpChildren = child[key]
              tmpChildren.forEach(t => {
                t.parent = key
              })
              tmp = tmp.concat(tmpChildren)
            }
          }
        })
        child.children = tmp
        this.managementData(child.children)
      })
    },
    async getStrc () {
      const { statusCode, data } = await getReportStruct(this.currentReportId)
      if (statusCode === 'OK') {
        const oriData = data.object[0].object
        oriData.forEach(ori => {
          this.strcData.push(ori.dataName + '*-*' + 'parent')
        })
        this.returnPath(oriData)
      }
    },
    returnPath (data) {
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
    changeReport () {
      this.filters = []
      this.tableData = []
      this.tableColumns = []
    },
    ShowMessage () {
      this.filtersAndResultModal = true
    },
    openFilter (index) {
      this.filters[index].isOpen = !this.filters[index].isOpen
    },
    async getReportList () {
      const { statusCode, data } = await getReportListByPermission('USE')
      if (statusCode === 'OK') {
        this.reportList = data
      }
    },
    async getReportFilterData () {
      if (!this.currentReportId) return
      if (this.displayType === 'tree') {
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
    async getReportRoot () {
      this.treeRoot = []
      let params = {
        reportId: this.currentReportId
      }
      const { statusCode, data } = await graphQueryRootCI(params)
      if (statusCode === 'OK') {
        this.treeRootOptions = data
      }
    },
    showRowDataFun (row) {
      const newRow = JSON.parse(JSON.stringify(row))
      delete newRow._index
      delete newRow._rowKey
      this.rowData = newRow
      this.showRowData = true
    },
    changePageSize (pageSize) {
      this.payload.pageable.pageSize = pageSize
      this.payload.pageable.startIndex = (this.payload.pageable.current - 1) * this.payload.pageable.pageSize
      this.getReportData(false)
    },
    changePage (page) {
      this.payload.pageable.current = page
      this.payload.pageable.startIndex = (this.payload.pageable.current - 1) * this.payload.pageable.pageSize
      this.getReportData(false)
    },
    async getReportData (tag = true) {
      if (this.displayType !== 'table') {
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
      const { statusCode, data } = await getReportData(this.currentReportId, this.payload)
      if (statusCode === 'OK') {
        this.hasTableData = true
        this.tableData = data.contents
        this.payload.pageable.total = data.pageInfo.totalRows
      }
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
// .report-filter /deep/
</style>
