<template>
  <div>
    <Tabs type="card" :value="currentTab" closable @on-tab-remove="handleTabRemove" @on-click="handleTabClick">
      <TabPane :closable="false" name="CMDB" :label="$t('cmdb_model')">
        <card>
          <div class="graph-container" id="graph"></div>
        </card>
      </TabPane>
      <TabPane v-for="ci in tabList" :key="ci.id" :name="ci.id" :label="ci.name">
        <WeCMDBTable
          :tableData="ci.tableData"
          :tableOuterActions="ci.outerActions"
          :tableInnerActions="ci.innerActions"
          :tableColumns="ci.tableColumns"
          :pagination="ci.pagination"
          :ascOptions="ci.ascOptions"
          :showCheckbox="needCheckout"
          :isRefreshable="true"
          @actionFun="actionFun"
          @handleSubmit="handleSubmit"
          @sortHandler="sortHandler"
          @getSelectedRows="onSelectedRowsChange"
          @pageChange="pageChange"
          @pageSizeChange="pageSizeChange"
          tableHeight="650"
          :ref="'table' + ci.id"
        ></WeCMDBTable>
        <Modal footer-hide v-model="compareVisible" width="90" class-name="compare-modal">
          <Table :columns="ci.tableColumns.filter(x => x.isDisplayed || x.displaySeqNo)" :data="compareData" border />
        </Modal>
      </TabPane>
      <div slot="extra" class="history-query">
        <span class="filter-title">{{ $t('change_layer') }}</span>
        <Button
          class="filter-col-icon"
          @click="changeLayer(-1)"
          :disabled="currentZoomLevelId === 1"
          icon="md-arrow-round-up"
          size="small"
        ></Button>
        <Button
          class="filter-col-icon"
          @click="changeLayer(1)"
          :disabled="currentZoomLevelId === zoomLevelIdList[zoomLevelIdList.length - 1]"
          icon="md-arrow-round-down"
          size="small"
        ></Button>
        <div class="label">{{ $t('updated_time') }}</div>
        <DatePicker
          type="datetime"
          format="yyyy-MM-dd HH:mm"
          :options="options"
          :value="queryDate"
          @on-change="handleDateChange"
        />
        <div class="label">{{ $t('query_type') }}</div>
        <Select v-model="queryType" @on-change="handleQueryEmit">
          <Option value="1">{{ $t('type_latest') }}</Option>
          <Option value="2">{{ $t('type_reality') }}</Option>
          <Option value="3">{{ $t('type_all') }}</Option>
        </Select>
      </div>
    </Tabs>
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
  getAllLayers,
  queryCiData,
  queryCiDataByType,
  getCiTypeAttributes,
  deleteCiDatas,
  createCiDatas,
  updateCiDatas,
  operateCiState
} from '@/api/server'
import { setHeaders, baseURL } from '@/api/base.js'
import { outerActions, innerActions, pagination, components, exportOuterActions } from '@/const/actions.js'
import { formatData } from '../util/format.js'
import { getExtraInnerActions } from '../util/state-operations.js'
import { deepClone } from '../util/common-func.js'
const defaultCiTypePNG = require('@/assets/ci-type-default.png')
export default {
  data () {
    return {
      baseURL,
      currentZoomLevelId: 1,
      tabList: [],
      currentTab: 'CMDB',
      payload: {
        dialect: {
          showCiHistory: false
        },
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true
      },
      source: {},
      layers: [],
      graph: {},
      ciTypesName: {},
      compareVisible: false,
      compareData: [],
      options: {
        disabledDate (date) {
          return date && date.valueOf() > Date.now()
        }
      },
      queryType: '1', // 1 - 最新； 2 - 现实； 3 - 所有；
      queryDate: null,
      zoomLevelIdList: [1]
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
            name: 'updated_date',
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
      let dateObjIdx = this.payload.filters.findIndex(x => x.name === 'updated_date')
      if (!this.queryDate) {
        if (~dateObjIdx) this.payload.filters.splice(dateObjIdx, 1)
      } else {
        if (~dateObjIdx) {
          let filters = this.payload.filters
          filters[dateObjIdx].value = moment(this.queryDate).format('YYYY-MM-DD HH:mm:ss')
          this.payload.filters = filters
        } else {
          this.payload.filters.push({
            name: 'updated_date',
            operator: 'lt',
            value: moment(this.queryDate).format('YYYY-MM-DD HH:mm:ss')
          })
        }
      }
      this.payload.dialect.showCiHistory = this.queryType === '3'
      if (this.currentTab !== 'CMDB') this.queryCiData()
    },
    handleTabRemove (name) {
      this.tabList.forEach((_, index) => {
        if (_.id === name) {
          this.tabList.splice(index, 1)
          this.payload.filters = this.payload.filters.filter(x => x.name === 'update_date')
        }
      })
      this.currentTab = 'CMDB'
    },
    handleTabClick (name) {
      this.payload.filters = this.payload.filters.filter(x => x.name === 'update_date')
      this.currentTab = name
    },
    async initGraph (filters = ['created', 'dirty']) {
      let graph

      const initEvent = () => {
        graph = d3.select('#graph')
        graph
          .on('dblclick.zoom', null)
          .on('wheel.zoom', null)
          .on('mousewheel.zoom', null)

        this.graph.graphviz = graph
          .graphviz()
          .zoom(true)
          .scale(1.2)
          .width(window.innerWidth - 92)
          .height(window.innerHeight - 190)
          .attributer(function (d) {
            if (d.attributes.class === 'edge') {
              var keys = d.key.split('->')
              var from = keys[0].trim()
              var to = keys[1].trim()
              d.attributes.from = from
              d.attributes.to = to
            }

            if (d.tag === 'text') {
              var key = d.children[0].text
              d3.select(this).attr('text-key', key)
            }
          })
      }

      this.zoomLevelIdList = [1]
      let layerResponse = await getAllLayers()
      if (layerResponse.statusCode === 'OK') {
        let tempLayer = layerResponse.data
          .filter(i => i.status === 'active')
          .map(_ => {
            return { name: _.value, layerId: _.codeId, ..._ }
          })
        this.layers = tempLayer.sort((a, b) => {
          return a.seqNo - b.seqNo
        })
        let ciResponse = await getAllCITypesByLayerWithAttr(filters)
        if (ciResponse.statusCode === 'OK') {
          this.source = ciResponse.data
          this.source.forEach(_ => {
            _.ciTypes &&
              _.ciTypes.forEach(async i => {
                if (this.zoomLevelIdList.indexOf(i.zoomLevelId) < 0) {
                  this.zoomLevelIdList.push(i.zoomLevelId)
                  this.zoomLevelIdList.sort((a, b) => a - b)
                }
                this.ciTypesName[i.ciTypeId] = i.name
                let imgFileSource =
                  i.imageFileId === 0 || i.imageFileId === undefined
                    ? defaultCiTypePNG.substring(0, defaultCiTypePNG.length - 4)
                    : `${baseURL}/files/${i.imageFileId}`
                this.$set(i, 'form', {
                  ...i,
                  imgSource: imgFileSource,
                  imgUploadURL: `${baseURL}/ci-types/${i.ciTypeId}/icon`
                })
                i.attributes &&
                  i.attributes.forEach(j => {
                    this.$set(j, 'form', {
                      ...j,
                      isAccessControlled: j.isAccessControlled ? 'yes' : 'no',
                      isNullable: j.isNullable ? 'yes' : 'no',
                      isSystem: j.isSystem ? 'yes' : 'no'
                    })
                  })
              })
          })
          let uploadToken = document.cookie.split(';').find(i => i.indexOf('XSRF-TOKEN') !== -1)
          setHeaders({
            'X-XSRF-TOKEN': uploadToken && uploadToken.split('=')[1]
          })
          initEvent()
          this.renderGraph(ciResponse.data)
        }
      }
    },
    genDOT (data) {
      let nodes = []
      data.forEach(_ => {
        if (_.ciTypes) nodes = nodes.concat(_.ciTypes)
      })
      var dots = [
        'digraph  {',
        'bgcolor="transparent";',
        'Node [fontname=Arial,shape="ellipse", fixedsize="true", width="1.1", height="1.1", color="transparent" ,fontsize=11];',
        'Edge [fontname=Arial,minlen="1", color="#7f8fa6", fontsize=10];',
        'ranksep = 1.1; nodesep=.7; size = "11,8";rankdir=TB'
      ]
      let layerTag = `node [];`

      // generate group
      let tempClusterObjForGraph = {}
      let tempClusterAryForGraph = []
      this.layers.map((_, index) => {
        if (index !== this.layers.length - 1) {
          layerTag += `"layer_${_.layerId}"->`
        } else {
          layerTag += `"layer_${_.layerId}"`
        }
        tempClusterObjForGraph[index] = [
          `{ rank=same; "layer_${_.layerId}"[id="layerId_${_.layerId}",class="layer",label="${_.name}",tooltip="${_.name}"];`
        ]
        nodes.forEach((node, nodeIndex) => {
          if (node.layerId === _.layerId && node.zoomLevelId === this.currentZoomLevelId) {
            tempClusterObjForGraph[index].push(
              `"ci_${node.ciTypeId}"[id="${node.ciTypeId}",label="${node.name}",tooltip="${node.name}",class="ci",image="${node.form.imgSource}.png", labelloc="b"]`
            )
          }
          if (nodeIndex === nodes.length - 1) {
            tempClusterObjForGraph[index].push('} ')
          }
        })
        if (nodes.length === 0) {
          tempClusterObjForGraph[index].push('} ')
        }
        tempClusterAryForGraph.push(tempClusterObjForGraph[index].join(''))
      })

      dots.push(tempClusterAryForGraph.join(''))
      dots.push('{' + layerTag + '[style=invis]}')

      // generate edges
      nodes.forEach(node => {
        node.attributes &&
          node.attributes.forEach(attr => {
            if (attr.inputType === 'ref' || attr.inputType === 'multiRef') {
              var target = nodes.find(_ => _.ciTypeId === attr.referenceId)
              if (target && node.zoomLevelId === target.zoomLevelId && node.zoomLevelId === this.currentZoomLevelId) {
                dots.push(this.genEdge(nodes, node, attr))
              }
            }
          })
      })
      dots.push('}')
      return dots.join('')
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
    renderGraph (data) {
      let nodesString = this.genDOT(data)
      this.loadImage(nodesString)
      this.graph.graphviz.renderDot(nodesString)
      this.shadeAll()
      addEvent('.node', 'mouseover', async e => {
        e.preventDefault()
        e.stopPropagation()
        d3.selectAll('g').attr('cursor', 'pointer')
        var g = e.currentTarget
        var nodeName = g.children[0].innerHTML.trim()
        this.shadeAll()
        this.colorNode(nodeName)
      })

      addEvent('svg', 'mouseover', e => {
        this.shadeAll()
        e.preventDefault()
        e.stopPropagation()
      })

      addEvent('.node', 'click', async e => {
        e.preventDefault()
        e.stopPropagation()
        var g = e.currentTarget
        let isLayerSelected = g.getAttribute('class').indexOf('layer') >= 0
        if (isLayerSelected) {
          return
        }
        const found = this.tabList.find(_ => _.id === g.id)
        if (!found) {
          const ci = {
            name: g.children[1].children[0].getAttribute('title'),
            id: g.id,
            tableData: [],
            outerActions:
              this.$route.name === 'ciDataEnquiry'
                ? JSON.parse(JSON.stringify(exportOuterActions))
                : JSON.parse(JSON.stringify(outerActions)),
            innerActions:
              this.$route.name === 'ciDataEnquiry'
                ? null
                : deepClone(
                  innerActions.concat(await getExtraInnerActions()).concat([
                    {
                      label: this.$t('compare'),
                      props: {
                        type: 'info',
                        size: 'small'
                      },
                      actionType: 'compare',
                      isDisabled: row => !row.weTableForm.p_guid,
                      isLoading: row => !!row.weTableForm.compareLoading
                    }
                  ])
                ),
            tableColumns: [],
            pagination: JSON.parse(JSON.stringify(pagination)),
            ascOptions: {}
          }
          const query = {
            id: g.id,
            queryObject: this.payload
          }
          this.tabList.push(ci)
          this.currentTab = g.id
          this.queryCiAttrs(g.id)
          this.queryCiData(query)
        } else {
          this.currentTab = g.id
        }
      })
    },

    onSelectedRowsChange (rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        let isUpdateableAry = []
        let isDeleteableAry = []

        rows.forEach((r, index) => {
          isUpdateableAry.push(!!r.nextOperations.find(op => op === 'update'))
          isDeleteableAry.push(!!r.nextOperations.find(op => op === 'delete'))
        })
        let isValueTrue = val => {
          return val === true
        }
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              switch (_.actionType) {
                case 'add':
                  _.props.disabled = _.actionType === 'add'
                  break
                case 'edit':
                  _.props.disabled = !isUpdateableAry.every(isValueTrue)
                  break
                case 'delete':
                  _.props.disabled = !isDeleteableAry.every(isValueTrue)
                  break
                default:
                  break
              }
            })
          }
        })
      } else {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              _.props.disabled = !(_.actionType === 'add' || _.actionType === 'export' || _.actionType === 'cancel')
            })
          }
        })
      }
      this.$refs[this.tableRef][0].setTableData(checkoutBoxdisable)
    },
    actionFun (type, data) {
      switch (type) {
        case 'export':
          this.exportHandler()
          break
        case 'add':
          this.addHandler()
          break
        case 'edit':
          this.editHandler()
          break
        case 'save':
          this.saveHandler(data)
          break
        case 'delete':
          this.deleteHandler(data)
          break
        case 'cancel':
          this.cancelHandler()
          break
        case 'innerCancel':
          this.$refs[this.tableRef][0].rowCancelHandler(data.weTableRowId)
          break
        case 'compare':
          this.compareHandler(data)
          break
        default:
          this.defaultHandler(type, data)
          break
      }
    },
    async compareHandler (row) {
      this.$set(row.weTableForm, 'compareLoading', true)
      const query = {
        id: this.currentTab,
        queryObject: {
          dialect: { showCiHistory: true },
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
        this.compareData = data && data.contents && data.contents.map(x => x.data)
        this.compareData = this.compareData
          .map(x => {
            for (let k in x) {
              if (typeof x[k] === 'object' && x[k] !== null) x[k] = x[k].value
            }
            return x
          })
          .map((x, idx) => {
            if (x.guid === row.weTableForm.guid) {
              x.cellClassName = {}
              for (let k in x) {
                if (this.compareData[1 - idx] && x[k] !== this.compareData[1 - idx][k]) {
                  x.cellClassName[k] = 'highlight'
                }
              }
            }
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
          title: 'Success',
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
              emptyRowData[_.inputKey] = []
            } else {
              emptyRowData[_.inputKey] = ''
            }
          })
          emptyRowData['isRowEditable'] = true
          emptyRowData['isNewAddedRow'] = true
          emptyRowData['weTableRowId'] = 1
          emptyRowData['nextOperations'] = []
          ci.tableData.unshift(emptyRowData)
          this.$nextTick(() => {
            this.$refs[this.tableRef][0].pushNewAddedRowToSelections()
            this.$refs[this.tableRef][0].setCheckoutStatus(true)
          })
          ci.outerActions.forEach(_ => {
            _.props.disabled = _.actionType === 'add'
          })
        }
      })
    },
    cancelHandler () {
      this.$refs[this.tableRef][0].setAllRowsUneditable()
      this.$refs[this.tableRef][0].setCheckoutStatus()
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.outerActions.forEach(_ => {
            _.props.disabled = !(_.actionType === 'add' || _.actionType === 'export' || _.actionType === 'cancel')
          })
        }
      })
      this.queryCiData()
    },
    deleteHandler (deleteData) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        'z-index': 1000000,
        onOk: async () => {
          const payload = {
            id: this.currentTab,
            deleteData: deleteData.map(_ => _.guid)
          }
          const { statusCode, message } = await deleteCiDatas(payload)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: 'Deleted successfully',
              desc: message
            })
            this.tabList.forEach(ci => {
              if (ci.id === this.currentTab) {
                ci.outerActions.forEach(_ => {
                  _.props.disabled = _.actionType === 'save' || _.actionType === 'edit' || _.actionType === 'delete'
                })
              }
            })
            this.queryCiData()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    editHandler () {
      this.$refs[this.tableRef][0].swapRowEditable(true)
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.outerActions.forEach(_ => {
            if (_.actionType === 'save') {
              _.props.disabled = false
            }
          })
        }
      })
      this.$nextTick(() => {
        this.$refs[this.tableRef][0].setCheckoutStatus(true)
      })
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
    async saveHandler (data) {
      let setBtnsStatus = () => {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              _.props.disabled = !(_.actionType === 'add' || _.actionType === 'export' || _.actionType === 'cancel')
            })
          }
        })
        this.$refs[this.tableRef][0].setAllRowsUneditable()
        this.$nextTick(() => {
          /* to get iview original data to set _ischecked flag */
          let objData = this.$refs[this.tableRef][0].$refs.table.$refs.tbody.objData
          for (let obj in objData) {
            objData[obj]._isChecked = false
            objData[obj]._isDisabled = false
          }
        })
      }
      let d = JSON.parse(JSON.stringify(data))
      let addAry = d.filter(_ => _.isNewAddedRow)
      let editAry = d.filter(_ => !_.isNewAddedRow)
      if (addAry.length > 0) {
        const found = this.tabList.find(_ => _.id === this.currentTab)
        if (found) {
          found.outerActions.forEach(_ => {
            if (_.actionType === 'save') {
              _.props.loading = true
            }
          })
        }
        const deleteAttrs = this.deleteAttr()
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
        let payload = {
          id: this.currentTab,
          createData: addAry
        }
        const { statusCode, message } = await createCiDatas(payload)
        if (found) {
          found.outerActions.forEach(_ => {
            if (_.actionType === 'save') {
              _.props.loading = false
            }
          })
        }
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: 'Added successfully',
            desc: message
          })
          setBtnsStatus()
          this.queryCiData()
        }
      }
      if (editAry.length > 0) {
        const found = this.tabList.find(_ => _.id === this.currentTab)
        if (found) {
          found.outerActions.forEach(_ => {
            if (_.actionType === 'save') {
              _.props.loading = true
            }
          })
        }
        editAry.forEach(_ => {
          delete _.isRowEditable
          delete _.weTableForm
          delete _.weTableRowId
          delete _.isNewAddedRow
          delete _.nextOperations
        })
        let payload = {
          id: this.currentTab,
          updateData: editAry
        }
        const { statusCode, message } = await updateCiDatas(payload)
        if (found) {
          found.outerActions.forEach(_ => {
            if (_.actionType === 'save') {
              _.props.loading = false
            }
          })
        }
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: 'Updated successfully',
            desc: message
          })
          setBtnsStatus()
          this.queryCiData()
        }
      }
    },
    async exportHandler () {
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
        queryObject: {}
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
          data: formatData(data.contents.map(_ => _.data))
        })
      }
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
      const method = this.queryType === '2' ? queryCiDataByType : queryCiData
      const { statusCode, data } = await method(query)
      if (statusCode === 'OK') {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.tableData = data.contents.map(_ => {
              return {
                ..._.data,
                nextOperations: _.meta.nextOperations || []
              }
            })
            ci.pagination.total = data.pageInfo.totalRows
          }
        })
      }
    },
    async queryCiAttrs (id) {
      const { statusCode, data } = await getCiTypeAttributes(id)
      if (statusCode === 'OK') {
        let columns = []
        data.forEach(_ => {
          let renderKey = _.propertyName
          if (_.status !== 'decommissioned' && _.status !== 'notCreated') {
            columns.push({
              ..._,
              tooltip: true,
              title: _.name,
              renderHeader: (h, params) => (
                <Tooltip content={_.description} placement="top">
                  <span>{_.name}</span>
                </Tooltip>
              ),
              key: renderKey,
              inputKey: _.propertyName,
              inputType: _.inputType,
              referenceId: _.referenceId,
              disEditor: !_.isEditable,
              disAdded: !_.isEditable,
              placeholder: _.name,
              component: 'Input',
              filterRule: !!_.filterRule,
              ciType: { id: _.referenceId, name: _.name },
              type: 'text',
              isMultiple: _.inputType === 'multiSelect',
              ...components[_.inputType]
            })
          }
        })
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.tableColumns = columns
          }
        })
      }
    },
    changeLayer (v) {
      let currentZoomLevelIdIndex =
        this.zoomLevelIdList.indexOf(this.currentZoomLevelId) >= 0
          ? this.zoomLevelIdList.indexOf(this.currentZoomLevelId)
          : 1
      currentZoomLevelIdIndex += v
      this.currentZoomLevelId = this.zoomLevelIdList[currentZoomLevelIdIndex]
      this.initGraph()
    }
  },
  mounted () {
    this.initGraph()
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

    .ivu-select-placeholder,
    .ivu-select-selected-value {
      height: 28px;
      line-height: 28px;
    }
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
