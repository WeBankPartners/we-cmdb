<template>
  <div>
    <Row>
      <Col span="10">
        <span style="margin-right: 10px">{{ $t('report') }}</span>
        <Select
          v-model="currentReportId"
          @on-open-change="getReportList"
          @on-change="getReportFilterData"
          filterable
          style="width: 75%;"
        >
          <Option v-for="item in reportList" :value="item.id" :key="item.id">{{ item.name }}</Option>
        </Select>
        <Button type="primary" :disabled="filters.length === 0" @click="getReportData">{{ $t('query') }}</Button>
      </Col>
    </Row>
    <Row v-if="filters.length > 0" style="margin: 16px 0">
      <span v-for="(filter, index) in filters" :key="index" class="report-filter">
        <Button size="small" @click="openFilter(index)">{{ filter.key }}</Button>
        <template v-if="filter.isOpen">
          <Form :label-width="100" :key="index">
            <template v-for="attrss in filter.params">
              <FormItem
                v-if="attrss.querialbe === 'yes'"
                :label="attrss.dataTitleName"
                style="display:inline-block;margin-bottom:0"
                :key="attrss.id"
              >
                <Input v-model="attrss.value" style="width:150px"></Input>
              </FormItem>
            </template>
          </Form>
        </template>
      </span>
    </Row>
    <Row v-if="hasTableData">
      <Button type="success" @click="ShowMessage" icon="ios-eye">{{ $t('show_message') }}</Button>
      <Table :columns="tableColumns" :data="tableData" border height="500"></Table>
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
  </div>
</template>

<script>
import { getReportListByPermission, getReportData, getReportFilterData } from '@/api/server'
export default {
  components: {},
  data () {
    return {
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
        // sorting: {
        //   asc: true,
        //   field: ""
        // }
      },
      showRowData: false,
      rowData: '',
      filtersAndResultModal: false,
      showfiltersAndResultModalData: '',
      requestURL: '',
      MODALHEIGHT: 0
    }
  },
  created () {},
  mounted () {
    this.MODALHEIGHT = window.MODALHEIGHT
  },
  methods: {
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
      this.payload.filters = []
      this.filters.forEach(filter => {
        filter.params &&
          filter.params.forEach(p => {
            if (p.value !== '') {
              this.payload.filters.push({
                name: p.id,
                operator: 'eq',
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
