<template>
  <div class="ci-data-page">
    <Tabs type="card" :value="currentTab" closable @on-tab-remove="handleTabRemove" @on-click="handleTabClick">
      <TabPane :closable="false" name="CMDB" :label="$t('cmdb_model')">
        <card>
          <div class="graph-container" id="graph"></div>
          <Spin fix v-if="spinShow">
            <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
          </Spin>
        </card>
      </TabPane>
      <TabPane v-for="ci in tabList" :key="ci.id" :name="ci.id" :label="ci.name">
        <CMDBTable
          :ciTypeId="ci.id"
          :tableData="ci.tableData"
          :tableOuterActions="ci.outerActions"
          :tableInnerActions="ci.innerActions"
          :tableColumns="ci.tableColumns"
          :pagination="ci.pagination"
          :ascOptions="ci.ascOptions"
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
          tableHeight="650"
          :ref="'table' + ci.id"
        ></CMDBTable>
      </TabPane>
      <div slot="extra" class="history-query">
        <span class="filter-title">{{ $t('change_group') }}</span>
        <Select
          multiple
          filterable
          :max-tag-count="1"
          v-model="currentciGroup"
          style="flex: 1;width:180px;margin-right:20px"
        >
          <Option v-for="item in originciGroupList" :value="item.codeId" :key="item.codeId">
            {{ item.value }}
          </Option>
        </Select>
        <span class="filter-title">{{ $t('change_layer') }}</span>
        <Select multiple filterable :max-tag-count="1" v-model="currentciLayer" style="width: 180px;">
          <Option v-for="item in originciLayerList" :value="item.codeId" :key="item.codeId">
            {{ item.value }}
          </Option>
        </Select>
        <div class="label">{{ $t('update_time') }}</div>
        <DatePicker
          type="datetime"
          format="yyyy-MM-dd HH:mm"
          :options="options"
          :value="queryDate"
          @on-change="handleDateChange"
        />
        <div class="label">{{ $t('query_type') }}</div>
        <Select filterable v-model="queryType" @on-change="handleQueryEmit">
          <Option value="new">{{ $t('type_latest') }}</Option>
          <Option value="real">{{ $t('type_reality') }}</Option>
          <Option value="all">{{ $t('type_all') }}</Option>
        </Select>
        <Button type="primary" @click="newInitGraph" size="small" style="vertical-align: top;margin-left:20px">{{
          $t('confirm')
        }}</Button>
      </div>
    </Tabs>
    <!-- 对比 -->
    <Modal footer-hide v-model="compareVisible" width="90" class-name="compare-modal">
      <Table :columns="compareColumns" :max-height="MODALHEIGHT" :data="compareData" border />
    </Modal>
    <SelectFormOperation ref="selectForm" @callback="callback"></SelectFormOperation>
  </div>
</template>
<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line
import * as d3Graphviz from 'd3-graphviz'
import moment from 'moment'
import { addEvent } from '../util/event.js'
import {
  getAllCITypesByLayerWithAttr,
  getEnumCodesByCategoryId,
  getCiTypeAttributes,
  queryCiData,
  tableOptionExcute,
  operateCiState,
  getEnumCategoriesById,
  getStateTransition,
  importReport
} from '@/api/server'
import { baseURL } from '@/api/base.js'
import { pagination, components } from '@/const/actions.js'
// import { resetButtonDisabled } from '@/const/tableActionFun.js'
import { formatData } from '../util/format.js'
import { CI_LAYER, CI_GROUP } from '@/const/init-params.js'
import SelectFormOperation from '@/pages/components/select-form-operation'
export default {
  provide () {
    return {
      ciDataManagementQueryType: this.queryType
    }
  },
  data () {
    return {
      spinShow: false,
      baseURL,
      currentZoomLevelId: [],
      tabList: [],
      currentTab: 'CMDB',
      payload: {
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
      },
      source: {},
      layers: [],
      graph: {},
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
      queryDate: null,
      zoomLevelIdList: [],
      copyRows: [],
      copyEditData: null,
      isHandleNodeClick: false,

      currentStatus: ['created', 'dirty'],
      originciLayerList: [],
      originciGroupList: [],
      currentciGroup: [],
      currentciLayer: [],
      ciLayerList: [],
      ciGroupList: [],
      originCITypesByLayerWithAttr: [],
      MODALHEIGHT: 0
    }
  },
  computed: {
    tableRef () {
      return 'table' + this.currentTab
    },
    needCheckout () {
      return this.$route.name !== 'ciDataEnquiry'
    },
    filterByDate () {
      if (this.queryDate) {
        return [
          {
            name: 'update_time',
            operator: 'lt',
            value: moment(this.queryDate).format('YYYY-MM-DD HH:mm:ss')
          }
        ]
      } else {
        return null
      }
    }
  },
  watch: {
    currentTab () {
      this.copyRows = []
      this.copyEditData = null
    }
  },
  methods: {
    callback () {
      this.queryCiData()
    },
    handleDateChange (date) {
      if (date !== '') {
        if (
          moment(date).isSame(moment(), 'day') &&
          (this.queryDate === null || !moment(date).isSame(moment(this.queryDate), 'day'))
        ) {
          this.queryDate = moment().format('YYYY-MM-DD HH:mm')
        } else if (
          moment(date).isBefore(moment(), 'day') &&
          (this.queryDate === null || !moment(date).isSame(moment(this.queryDate), 'day'))
        ) {
          this.queryDate = moment(date)
            .endOf('day')
            .format('YYYY-MM-DD HH:mm')
        } else {
          this.queryDate = date
        }
      } else {
        this.queryDate = date
      }
      this.handleQueryEmit()
    },
    handleQueryEmit () {
      this.payload.dialect.queryMode = this.queryType
      let dateObjIdx = this.payload.filters.findIndex(x => x.name === 'update_time')
      if (!this.queryDate) {
        if (~dateObjIdx) this.payload.filters.splice(dateObjIdx, 1)
      } else {
        if (~dateObjIdx) {
          let filters = this.payload.filters
          filters[dateObjIdx].value = moment(this.queryDate).format('YYYY-MM-DD HH:mm:ss')
          this.payload.filters = filters
        } else {
          this.payload.filters.push({
            name: 'update_time',
            operator: 'lt',
            value: moment(this.queryDate).format('YYYY-MM-DD HH:mm:ss')
          })
        }
      }
      if (this.currentTab !== 'CMDB') this.queryCiData()
    },
    handleTabRemove (name) {
      this.tabList.forEach((_, index) => {
        if (_.id === name) {
          this.tabList.splice(index, 1)
          this.payload.filters = this.payload.filters.filter(x => x.name === 'update_time')
        }
      })
      this.currentTab = 'CMDB'
    },
    handleTabClick (name) {
      this.payload.filters = this.payload.filters.filter(x => x.name === 'update_time')
      delete this.payload.sorting
      this.currentTab = name
    },
    genEdge (nodes, from, to) {
      const target = nodes.find(_ => _.ciTypeId === to.referenceId)
      let labels = to.referenceName ? to.referenceName.trim() : ''
      return `"ci_${from.ciTypeId}"->"ci_${target.ciTypeId}"[taillabel="${labels}",labeldistance=3];`
    },

    loadImage (nodesString) {
      ;(nodesString.match(/image=[^,]*(files\/\d*|png)/g) || [])
        .filter((value, index, self) => {
          return self.indexOf(value) === index
        })
        .map(keyvaluepaire => keyvaluepaire.substr(7))
        .forEach(image => {
          this.graph.graphviz.addImage(image, '48px', '48px')
        })
    },
    shadeAll () {
      d3.selectAll('g path')
        .attr('stroke', '#7f8fa6')
        .attr('stroke-opacity', '.2')
      d3.selectAll('g polygon')
        .attr('stroke', '#7f8fa6')
        .attr('stroke-opacity', '.2')
        .attr('fill', '#7f8fa6')
        .attr('fill-opacity', '.2')
      d3.selectAll('.edge text').attr('fill', '#7f8fa6')
    },
    colorNode (nodeName) {
      d3.selectAll('g[from="' + nodeName + '"] path')
        .attr('stroke', 'red')
        .attr('stroke-opacity', '1')
      d3.selectAll('g[from="' + nodeName + '"] text').attr('fill', 'red')
      d3.selectAll('g[from="' + nodeName + '"] polygon')
        .attr('stroke', 'red')
        .attr('fill', 'red')
        .attr('fill-opacity', '1')
        .attr('stroke-opacity', '1')
      d3.selectAll('g[to="' + nodeName + '"] path')
        .attr('stroke', 'green')
        .attr('stroke-opacity', '1')
      d3.selectAll('g[to="' + nodeName + '"] text').attr('fill', 'green')
      d3.selectAll('g[to="' + nodeName + '"] polygon')
        .attr('stroke', 'green')
        .attr('fill', 'green')
        .attr('fill-opacity', '1')
        .attr('stroke-opacity', '1')
    },
    async handleNodeMouseover (e) {
      e.preventDefault()
      e.stopPropagation()
      d3.selectAll('g').attr('cursor', 'pointer')
      var g = e.currentTarget
      var nodeName = g.firstElementChild.textContent.trim()
      this.shadeAll()
      this.colorNode(nodeName)
    },
    handleSvgMouseover (e) {
      this.shadeAll()
      e.preventDefault()
      e.stopPropagation()
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
      stateBtn.push({
        operation: this.$t('export'),
        operationFormType: 'export_form',
        operationMultiple: 'yes',
        class: 'xxx',
        operation_en: 'Export',
        props: {
          type: 'primary',
          disabled: false
        }
      })
      stateBtn.push({
        operation: this.$t('import'),
        operationFormType: 'import_form',
        // operationMultiple: 'yes',
        class: 'xxx',
        operation_en: 'Import',
        props: {
          type: 'primary',
          disabled: false
        }
      })
      return stateBtn
    },
    async handleNodeClick (e) {
      if (this.isHandleNodeClick) return
      this.isHandleNodeClick = true
      e.preventDefault()
      e.stopPropagation()
      var g = e.currentTarget
      let isLayerSelected = g.getAttribute('class').indexOf('group') >= 0
      if (isLayerSelected) {
        return
      }
      const found = this.tabList.find(_ => _.id === g.id)
      if (!found) {
        const stateTransition = await this.getStateTransition(g.id)
        const ci = {
          name: g.lastElementChild.textContent.trim() || 'Default',
          id: g.id,
          tableData: [],
          outerActions: stateTransition,
          innerActions: [
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
          ],
          tableColumns: await this.queryCiAttrs(g.id),
          pagination: JSON.parse(JSON.stringify(pagination)),
          ascOptions: {}
        }
        const query = {
          id: g.id,
          queryObject: this.payload
        }
        this.tabList.push(ci)
        this.currentTab = g.id
        this.$nextTick(() => {
          this.queryCiData(query)
        })
      } else {
        this.currentTab = g.id
      }
      setTimeout(() => {
        this.isHandleNodeClick = false
      }, 500)
    },
    onSelectedRowsChange (rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        let opArray = []
        rows.forEach(r => {
          opArray = opArray.concat(r.nextOperations)
        })
        const activeBtn = new Set(opArray)
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              _.props.disabled = !(activeBtn.has(_.operation_en) || ['Add', 'Export'].includes(_.operation_en))
              if (rows.length > 1 && _.operationMultiple !== 'yes') {
                _.props.disabled = true
              }
            })
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
        case 'import_form':
          this.importHandler(cols, filters)
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
      this.$refs[this.tableRef][0].showCopyModal()
    },
    async compareHandler (row) {
      // this.$set(row.weTableForm, 'compareLoading', true)
      const found = this.tabList.find(_ => _.id === this.currentTab)
      if (found) {
        this.compareColumns = found.tableColumns.map(item => {
          item.width = 120
          return item
        })
      }
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
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.pagination.currentPage = 1
        }
      })
      this.queryCiData()
    },
    async defaultHandler (type, row) {
      this.$set(row.weTableForm, `${type}Loading`, true)
      const { statusCode, message } = await operateCiState(this.currentTab, row.guid, type)
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
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          let emptyRowData = {}
          ci.tableColumns.forEach(_ => {
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
          this.$refs[this.tableRef][0].pushNewAddedRowToSelections(emptyRowData)
          this.$refs[this.tableRef][0].showAddModal()
        }
      })
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
            this.queryCiData()
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
          const { statusCode, message } = await tableOptionExcute('Delete', this.currentTab, payload)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: 'Deleted successfully',
              desc: message
            })
            this.queryCiData()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    editHandler (operateType) {
      if (operateType === 'Add') {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            let emptyRowData = {}
            ci.tableColumns.forEach(_ => {
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
            this.$refs[this.tableRef][0].pushNewAddedRowToSelections(emptyRowData)
            this.$refs[this.tableRef][0].showAddModal()
          }
        })
      } else {
        this.$refs[this.tableRef][0].showEditModal()
      }
    },
    deleteAttr () {
      let attrs = []
      const found = this.tabList.find(_ => _.id === this.currentTab)
      found.tableColumns.forEach(i => {
        if (i.isAuto) {
          attrs.push(i.propertyName)
        }
      })
      return attrs
    },
    confirmAddHandler (data, operateType) {
      this.confirmEditHandler(data, operateType)
    },
    async confirmEditHandler (data, operateType) {
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
      const { statusCode, message } = await tableOptionExcute(operateType, this.currentTab, addAry)
      this.$refs[this.tableRef][0].resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('add_data_success'),
          desc: message
        })
        this.queryCiData()
        this.$refs[this.tableRef][0].closeEditModal(false)
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
      const { statusCode, message } = await tableOptionExcute('Update', this.currentTab, editAry)
      this.$refs[this.tableRef][0].resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('update_data_success'),
          desc: message
        })
        this.queryCiData()
        this.$refs[this.tableRef][0].closeEditModal(false)
      }
    },
    setBtnsStatus () {
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.outerActions.forEach(_ => {
            _.props.disabled = !['Add', 'Export'].includes(_.operation_en)
          })
        }
      })
    },
    async exportHandler (filters) {
      const found = this.tabList.find(_ => _.id === this.currentTab)
      if (found) {
        found.outerActions.forEach(_ => {
          if (_.actionType === 'export') {
            _.props.loading = true
          }
        })
      }
      const { statusCode, data } = await queryCiData({
        id: this.currentTab,
        queryObject: {
          filters: filters,
          dialect: { queryMode: this.queryType }
        }
      })
      if (found) {
        found.outerActions.forEach(_ => {
          if (_.actionType === 'export') {
            _.props.loading = false
          }
        })
      }
      if (statusCode === 'OK') {
        this.$refs[this.tableRef][0].export({
          filename: this.ciTypesName[this.currentTab],
          data: formatData(data.contents)
        })
      }
    },
    async importHandler (citypeId, file) {
      var FR = new FileReader()
      FR.onload = async ev => {
        if (ev.target && typeof ev.target.result === 'string') {
          const parmas = new FormData()
          parmas.append('file', file)
          const pram = {
            ciType: citypeId,
            data: parmas
          }
          const { statusCode } = await importReport(pram)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: 'Success',
              desc: 'Success'
            })
            this.queryCiData()
          }
        }
      }
      FR.readAsDataURL(file)
      return false
    },
    pageChange (current) {
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.pagination.currentPage = current
        }
      })
      this.queryCiData()
    },
    pageSizeChange (size) {
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.pagination.pageSize = size
        }
      })
      this.queryCiData()
    },
    async queryCiData () {
      this.payload.pageable.pageSize = 10
      this.payload.pageable.startIndex = 0
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          this.payload.pageable.pageSize = ci.pagination.pageSize
          this.payload.pageable.startIndex = (ci.pagination.currentPage - 1) * ci.pagination.pageSize
        }
      })
      const query = {
        id: this.currentTab,
        queryObject: this.payload
      }
      const method = queryCiData
      this.$refs[this.tableRef][0].isTableLoading(true)
      const { statusCode, data } = await method(query)
      this.$refs[this.tableRef][0].isTableLoading(false)
      if (statusCode === 'OK') {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.tableData = data.contents.map(_ => {
              return {
                ..._
                // nextOperations: _.meta.nextOperations || []
              }
            })
            ci.pagination.total = data.pageInfo.totalRows
          }
        })
      }
      this.setBtnsStatus()
    },
    async queryCiAttrs (id) {
      const { statusCode, data } = await getCiTypeAttributes(id)
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
    async getInitGraphData () {
      this.spinShow = true
      let [ciResponse, _ciLayerList, _ciGroupList] = await Promise.all([
        getAllCITypesByLayerWithAttr(['created', 'dirty']),
        getEnumCodesByCategoryId(CI_LAYER),
        getEnumCodesByCategoryId(CI_GROUP)
      ])
      if (ciResponse.statusCode === 'OK' && _ciLayerList.statusCode === 'OK' && _ciGroupList.statusCode === 'OK') {
        this.originciLayerList = _ciLayerList.data
        this.originciGroupList = _ciGroupList.data
        this.originCITypesByLayerWithAttr = ciResponse.data
        // this.currentciGroup = this.originciGroupList.map(item => item.codeId)
        this.currentciGroup =
          this.currentciGroup.length > 0 ? this.currentciGroup : this.originciGroupList.map(item => item.codeId)
        this.currentciLayer = this.currentciLayer.length > 0 ? this.currentciLayer : [_ciLayerList.data[0].codeId]

        // 初始化自动填充数据
        let allCiTypesWithAttr = []
        let allCiTypesFormatByCiTypeId = {}
        ciResponse.data.forEach(layer => {
          layer.ciTypes &&
            layer.ciTypes.forEach(_ => {
              this.ciTypesName[_.ciTypeId] = _.name
              allCiTypesWithAttr.push(_)
              allCiTypesFormatByCiTypeId[_.ciTypeId] = _
            })
        })
        this.allCiTypesWithAttr = allCiTypesWithAttr
        this.allCiTypesFormatByCiTypeId = allCiTypesFormatByCiTypeId

        this.newInitGraph()
      }
    },
    async newInitGraph () {
      let graph
      const graphEl = document.getElementById('graph')
      const initEvent = () => {
        graph = d3.select('#graph')
        graph
          .on('dblclick.zoom', null)
          .on('wheel.zoom', null)
          .on('mousewheel.zoom', null)

        this.graph.graphviz = graph
          .graphviz()
          .zoom(true)
          .fit(true)
          .height(window.innerHeight - 178)
          .width(graphEl.offsetWidth)
          .attributer(function (d) {
            if (d.attributes.class === 'edge') {
              const keys = d.key.split('->')
              const from = keys[0].trim()
              const to = keys[1].trim()
              d.attributes.from = from
              d.attributes.to = to
            }

            if (d.tag === 'text') {
              const key = d.children[0].text
              d3.select(this).attr('text-key', key)
            }
          })
      }
      initEvent()
      this.$nextTick(() => {
        this.renderGraph()
      })
    },
    renderGraph () {
      let nodesString = this.genDOT()
      this.loadImage(nodesString)
      this.graph.graphviz
        .transition()
        .renderDot(nodesString)
        .on('end', () => {
          this.shadeAll()
          addEvent('svg', 'mouseover', e => {
            this.shadeAll()
            e.preventDefault()
            e.stopPropagation()
          })
          addEvent('.node', 'mouseover', this.handleNodeMouseover)
          addEvent('svg', 'mouseover', this.handleSvgMouseover)
          addEvent('.node', 'click', this.handleNodeClick)
        })
      this.spinShow = false
    },
    genDOT () {
      const status = this.currentStatus
      const groups = this.currentciGroup
      const layers = this.currentciLayer
      const data = this.originCITypesByLayerWithAttr
      var groupSet = new Set(groups)
      var layerSet = new Set()
      var ciTypeSet = new Set()
      var statusSet = new Set(status)
      var refSet = new Set()
      var groupDot = '{ node[];'
      groups.forEach((group, index) => {
        if (index === groups.length - 1) {
          groupDot += '"' + group + '"[penwidth=0]}; '
        } else {
          groupDot += '"' + group + '"->'
        }
      })
      layers.forEach(layer => {
        layerSet.add(layer.codeId)
      })
      var dot = ''
      var statusColors = new Map([
        ['created', 'black'],
        ['notCreated', 'green4'],
        ['dirty', 'dodgerblue'],
        ['deleted', 'firebrick3']
      ])
      dot =
        'digraph{bgcolor="transparent";ranksep=1.1;nodesep=.7;size="11,8";rankdir=TB\nNode [fontname=Arial, shape="ellipse", fixedsize="true", width="1.1", height="1.1", color="transparent" ,fontsize=12];\nEdge [fontname=Arial, minlen="1", color="#7f8fa6", fontsize=10];\n'
      data.forEach(dataGroup => {
        if (groupSet.has(dataGroup.codeId)) {
          dot +=
            '{rank=same;\n"' +
            dataGroup.codeId +
            '"[id="' +
            dataGroup.codeId +
            '";class="group";label="' +
            dataGroup.value +
            '";tooltip="' +
            dataGroup.value +
            '"];\n'
          dataGroup.ciTypes.forEach(ciType => {
            if (
              layerSet.has(ciType.codeId) &&
              statusSet.has(ciType.status) &&
              this.currentciLayer.includes(ciType.ciLayer)
            ) {
              dot +=
                '"' +
                ciType.ciTypeId +
                '"[id="' +
                ciType.ciTypeId +
                '",label="' +
                ciType.name +
                '";tootip="' +
                ciType.description +
                '";class="ci";' +
                'fontcolor="' +
                statusColors.get(ciType.status) +
                '";image="/wecmdb/fonts/' +
                ciType.imageFile +
                '";labelloc="b"]\n'
              ciTypeSet.add(ciType.ciTypeId)
              ciType.attributes.forEach(attr => {
                if (attr.inputType === 'ref' || attr.inputType === 'multiRef') {
                  refSet.add(attr)
                }
              })
            }
          })
          dot += '}\n'
        }
      })
      refSet.forEach(ref => {
        if (ciTypeSet.has(ref.referenceId) && statusSet.has(ref.status)) {
          dot +=
            '"' +
            ref.ciTypeId +
            '"->"' +
            ref.referenceId +
            '"[taillabel="' +
            ref.referenceName +
            '";labeldistance=3;fontcolor="' +
            statusColors.get(ref.status) +
            '"]\n'
        }
      })
      dot += groupDot + '}'
      return dot
    }
  },
  mounted () {
    this.MODALHEIGHT = window.MODALHEIGHT
    this.getInitGraphData()
  },
  components: {
    SelectFormOperation
  }
}
</script>

<style lang="scss" scoped>
/deep/ .compare-modal .ivu-modal-body {
  padding-top: 40px;
}
/deep/ .ivu-table td.highlight {
  color: rgba(#ff6600, 0.9);
}

/deep/ .copy-modal {
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
#graph {
  position: relative;
  height: calc(100vh - 200px);
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

  /deep/ .ivu-input,
  /deep/ .ivu-select-selection {
    height: 28px;
    min-height: 28px !important;
    .ivu-select-placeholder,
    .ivu-select-selected-value {
      height: 28px;
      line-height: 28px;
    }
  }

  /deep/ .ivu-select-multiple .ivu-tag {
    height: 21px;
    line-height: 21px;
  }

  /deep/ .ivu-input-suffix i {
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
