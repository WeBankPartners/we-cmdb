<template>
  <div>
    <Row>
      <Col span="10" class="header-query">
        <span>{{ $t('integrated_query_name') }}</span>
        <Select v-model="selectedQueryName" filterable @on-change="onQueryNameSelectChange">
          <OptionGroup v-for="ci in queryNameListByCiTypes" :key="ci.id" :label="ci.name">
            <Option v-for="item in ci.children" :value="item.id" :key="item.id">{{ item.name }}</Option>
          </OptionGroup>
        </Select>
      </Col>
    </Row>
    <Row v-if="!!selectedQueryName" style="margin-top: 20px;">
      <CMDBTable
        :tableData="tableData"
        :tableOuterActions="outerActions"
        :tableInnerActions="innerActions"
        :tableColumns="tableColumns"
        :pagination="pagination"
        :showCheckbox="false"
        :isColumnsFilterOn="false"
        @actionFun="actionFun"
        @pageChange="pageChange"
        @pageSizeChange="pageSizeChange"
        @sortHandler="sortHandler"
        @handleSubmit="handleSubmit"
        tableHeight="650"
        ref="table"
      ></CMDBTable>

      <Modal v-model="originDataModal" :title="$t('basic_data')" footer-hide>
        <highlight-code lang="json">{{ showRowOriginData }}</highlight-code>
      </Modal>

      <Modal v-model="filtersAndResultModal" :title="$t('message')" footer-hide width="75">
        <div style="max-height: 600px; overflow: auto;">
          <Row
            >{{ $t('request_url') }}
            <highlight-code lang="json">{{ requestURL }}</highlight-code>
          </Row>
          <Row>
            <Col span="11"
              >Payload:
              <highlight-code lang="json">{{ payload }}</highlight-code>
            </Col>
            <Col span="12" offset="1"
              >Result:
              <highlight-code lang="json">{{ tableData }}</highlight-code>
            </Col>
          </Row>
        </div>
      </Modal>
    </Row>
  </div>
</template>

<script>
import Vue from 'vue'
import { getAllCITypes, getQueryNames, queryIntHeader, excuteIntQuery, getEnumCodesByCategoryId } from '@/api/server'
import { components } from '../../const/actions.js'
import { pluginI18n } from '../../const/plugin-i18n.js'
const innerActions = [
  {
    label: window.vm ? pluginI18n('basic_data') : Vue.t('basic_data'),
    props: {
      type: 'info',
      size: 'small'
    },
    actionType: 'showOriginData'
  }
]
const outerActions = [
  {
    label: window.vm ? pluginI18n('show_message') : Vue.t('show_message'),
    props: {
      type: 'success',
      icon: 'ios-eye',
      disabled: false
    },
    actionType: 'showFiltersAndResult'
  }
]
export default {
  components: {},
  data () {
    return {
      allCiTypes: [],
      selectedQueryName: '',
      queryNameListByCiTypes: [],
      tableData: [],
      tableColumns: [],
      innerActions,
      outerActions,
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
        paging: true
        // sorting: {
        //   asc: true,
        //   field: ""
        // }
      },
      originDataModal: false,
      showRowOriginData: '',
      filtersAndResultModal: false,
      showfiltersAndResultModalData: '',
      requestURL: ''
    }
  },
  created () {
    this.getAllCITypes()
  },
  methods: {
    pageChange (current) {
      this.pagination.currentPage = current
      this.getTableData()
    },
    pageSizeChange (size) {
      this.pagination.pageSize = size
      this.getTableData()
    },
    async getAllCITypes () {
      let { statusCode, data } = await getAllCITypes()
      if (statusCode === 'OK') {
        this.allCiTypes = data
        this.getAllQueryName()
      }
    },
    async getAllQueryName () {
      let allRequest = []
      this.allCiTypes.forEach(Ci => {
        allRequest.push(getQueryNames(Ci.ciTypeId))
      })
      const allRes = await Promise.all(allRequest)
      allRes.forEach((query, index) => {
        if (query.statusCode === 'OK' && query.data.length > 0) {
          const obj = {
            id: this.allCiTypes[index].ciTypeId,
            name: this.allCiTypes[index].name,
            children: query.data
          }
          this.queryNameListByCiTypes.push(obj)
        }
      })
    },
    onQueryNameSelectChange (value) {
      if (value) {
        this.getTableHeader(value)
        this.requestURL = window.request
          ? `/wecmdb/wecmdb/intQuery/${value}/execute`
          : `/wecmdb/intQuery/${value}/execute`
      }
    },
    async getTableHeader (id) {
      this.currentSelectQueryNameId = id
      let { statusCode, data } = await queryIntHeader(id)

      if (statusCode === 'OK') {
        this.tableColumns = []
        data.forEach(_ => {
          if (_.attrUnits) {
            let children = _.attrUnits
              .map(child => {
                return {
                  title: child.attr.name,
                  parentTitle: _.ciTypeName,
                  key: child.attrKey,
                  inputKey: child.attrKey,
                  type: 'text',
                  ...components[child.attr.inputType],
                  placeholder: child.attr.name,
                  ...child.attr,
                  enumId: child.attr.referenceId ? child.attr.referenceId : null,
                  ciType: { id: child.attr.referenceId, name: '' }
                }
              })
              .filter(i => i.isDisplayed)
            this.tableColumns.push({
              title: _.ciTypeName,
              align: 'center',
              children
            })
          }
        })
        this.getTableData()
        // this.$nextTick(() => {
        //   this.getColumnOptions()
        // })
      }
    },
    getColumnOptions () {
      this.tableColumns.forEach(_ => {
        if (_.children) {
          _.children.forEach(async child => {
            if (child.inputType === 'select') {
              const { data, statusCode } = await getEnumCodesByCategoryId(0, child.referenceId)
              let opts = []
              if (statusCode === 'OK') {
                opts = data
                  .filter(i => i.status === 'active')
                  .map(_ => {
                    return {
                      value: _.codeId,
                      label: _.value
                    }
                  })
              }
              this.$set(child, 'options', opts)
            }
          })
        }
      })
    },
    async getTableData () {
      this.payload.pageable.pageSize = this.pagination.pageSize
      this.payload.pageable.startIndex = (this.pagination.currentPage - 1) * this.pagination.pageSize
      let { statusCode, data } = await excuteIntQuery(this.currentSelectQueryNameId, this.payload)
      if (statusCode === 'OK') {
        this.tableData = data.contents
        this.pagination.total = data.pageInfo.totalRows
      }
    },
    sortHandler (data) {
      this.payload.sorting = {
        asc: data.order === 'asc',
        field: data.key
      }
      this.getTableData()
    },

    handleSubmit (data) {
      this.payload.filters = data
      this.pagination.currentPage = 1
      this.getTableData()
    },
    actionFun (type, data) {
      if (type === 'showOriginData') {
        this.showRowOriginData = data.weTableForm
        this.originDataModal = true
      }
      if (type === 'showFiltersAndResult') {
        this.filtersAndResultModal = true
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
</style>
