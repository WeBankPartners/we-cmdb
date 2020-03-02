<template>
  <div>
    <Row class="resource-design-select-row">
      <span>{{ $t('select_idc') }}：</span>
      <Select :placeholder="$t('select_idc')" v-model="selectedIdc" class="graph-select" @on-change="onIdcDataChange">
        <Option v-for="item in allIdcs" :value="item.guid" :key="item.guid">
          {{ item.name }}
        </Option>
      </Select>
    </Row>
    <Row class="resource-design-tab-row">
      <Spin fix v-if="spinShow">
        <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
        <div>{{ $t('loading') }}</div>
      </Spin>
      <Tabs v-if="idcDesignData" type="card" :value="currentTab" :closable="false" @on-click="handleTabClick">
        <TabPane :label="$t('planning_design_diagram')" name="resource-design">
          <Alert show-icon closable v-if="isDataChanged">
            Data has beed changed, click Reload button to reload graph.
            <Button slot="desc" @click="reloadHandler">Reload</Button>
          </Alert>
          <div class="graph-container-big" id="graph"></div>
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
            @sortHandler="sortHandler"
            @handleSubmit="handleSubmit"
            @getSelectedRows="onSelectedRowsChange"
            @pageChange="pageChange"
            @pageSizeChange="pageSizeChange"
            tableHeight="650"
            :ref="'table' + ci.id"
          ></WeCMDBTable>
        </TabPane>
      </Tabs>
    </Row>
  </div>
</template>

<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line no-unused-vars
import * as d3Graphviz from 'd3-graphviz'
import {
  getPlanningDesignsCiData,
  getCiTypeAttributes,
  deleteCiDatas,
  createCiDatas,
  updateCiDatas,
  getEnumCodesByCategoryId,
  getPlanningDesignTabs,
  getAllIdcDesignData,
  getIdcDesignTreeByGuid,
  getAllZoneLinkDesignGroupByIdcDesign,
  operateCiState
} from '@/api/server'
import { outerActions, innerActions, pagination, components } from '@/const/actions.js'
import { formatData } from '../util/format.js'
import { getExtraInnerActions } from '../util/state-operations.js'
import { colors } from '../../const/graph-configuration'

export default {
  data () {
    return {
      allIdcs: [],
      selectedIdc: '',
      tabList: [],
      payload: {
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true
      },
      graph: new Map(),
      idcDesignData: null,
      zoneLinkDesignData: new Map(),
      currentTab: 'resource-design',
      currentGraph: '',
      spinShow: false,
      isDataChanged: false
    }
  },
  computed: {
    tableRef () {
      return 'table' + this.currentTab
    },
    needCheckout () {
      return this.$route.name !== 'ciDataEnquiry'
    }
  },
  methods: {
    async onIdcDataChange (guid) {
      this.handleTabClick(this.currentTab)
      this.spinShow = true
      const { data, statusCode } = await getIdcDesignTreeByGuid([guid])
      if (statusCode === 'OK') {
        const formatTree = array =>
          array.map(_ => {
            let result = {
              ..._
            }
            if (_.data.network_segment_design) {
              result.text = [_.data.code, _.data.network_segment_design.code]
            } else {
              result.text = [_.data.code]
            }
            if (_.children instanceof Array && _.children.length) {
              result.children = formatTree(_.children)
            }
            return result
          })
        this.idcDesignData = formatTree(data)[0]
        this.getZoneLink()
      }
    },
    async reloadHandler () {
      this.onIdcDataChange(this.selectedIdc)
      this.isDataChanged = false
    },
    initGraph (filters = {}) {
      let graph
      graph = d3.select('#graph')
      graph
        .on('dblclick.zoom', null)
        .on('wheel.zoom', null)
        .on('mousewheel.zoom', null)

      let graphZoom = graph
        .graphviz()
        .width(window.innerWidth * 0.96)
        .height(window.innerHeight * 1.2)
        .zoom(true)
      if (this.graph.has(this.idcDesignData.guid)) {
        this.graph[this.idcDesignData.guid] = graphZoom
      } else {
        this.graph.set(this.idcDesignData.guid, graphZoom)
      }
      this.renderGraph(this.idcDesignData)
      this.spinShow = false
    },
    genDOT (idcData, linkData) {
      let links = linkData || []
      let fsize = 16
      let width = 16
      let height = 12
      let dots = [
        'digraph G {',
        'rankdir=TB nodesep=0.5;',
        `node [shape="box", fontsize="${fsize}", labelloc="t", penwidth="2"];`,
        `subgraph cluster_${idcData.data.guid} {`,
        `style="filled";color="${colors[0]}";`,
        `label="${idcData.data.name || idcData.data.description || idcData.data.code}";`,
        `size="${width},${height}";`,
        this.genChildren(idcData),
        this.genLink(links),
        '}}'
      ]
      return dots.join('')
    },
    genChildren (idcData) {
      const width = 16
      const height = 12
      let dots = []
      const children = idcData.children || []
      let layers = new Map()
      children.forEach(zone => {
        if (layers.has(zone.data.network_zone_layer.value)) {
          layers.get(zone.data.network_zone_layer.value).push(zone)
        } else {
          let layer = []
          layer.push(zone)
          layers.set(zone.data.network_zone_layer.value, layer)
        }
      })
      if (layers.size) {
        layers.forEach(layer => {
          dots.push('{rank = "same";')
          let n = layers.size
          let lg = (height - 3) / n
          let ll = (width - 0.5 * layer.length) / layer.length
          layer.forEach(zone => {
            let label
            if (zone.data.code && zone.data.code !== null && zone.data.code !== '') {
              label = zone.data.code
            } else {
              label = zone.data.key_name
            }
            dots.push(
              `g_${zone.guid}[id="g_${zone.guid}",color="${colors[1]}",label="${label}",width=${ll},height=${lg}];`
            )
          })
          dots.push('}')
        })
      } else {
        dots.push(
          `g_${idcData.data.guid}[label=" ";color="${colors[0]}";width="${width - 0.5}";height="${height - 3}"]`
        )
      }
      return dots.join('')
    },
    genLink (links) {
      let result = ''
      links.forEach(link => {
        result += `${link.azone}->${link.bzone}[arrowhead="none"];`
      })
      return result
    },
    renderGraph (idcData) {
      let nodesString = this.genDOT(idcData, this.zoneLinkDesignData.get(idcData.guid))
      this.graph.get(idcData.guid).renderDot(nodesString)
      let fsize = 16
      let divWidth = window.innerWidth
      let divHeight = window.innerHeight - 220
      let children = idcData.children || []
      let svg = d3.select('#graph').select('svg')
      svg.attr('width', divWidth).attr('height', divHeight)
      svg.attr('viewBox', '0 0 ' + divWidth + ' ' + divHeight)

      children.forEach(zone => {
        d3.select(`#g_${zone.guid}`)
          .select('polygon')
          .attr('fill', colors[1])
        if (Array.isArray(zone.children)) {
          let points = d3
            .select('#g_' + zone.guid)
            .select('polygon')
            .attr('points')
            .split(' ')
          let p = {
            x: parseInt(points[1].split(',')[0]),
            y: parseInt(points[1].split(',')[1])
          }
          let pw = parseInt(points[0].split(',')[0] - points[1].split(',')[0])
          let ph = parseInt(points[2].split(',')[1] - points[1].split(',')[1])
          this.setChildren(zone, p, pw, ph, fsize, 1, 1)
        }
      })
    },
    setChildren (node, p1, pw, ph, tfsize, tlength = 1, deep) {
      let graph = d3.select('#graph').select('#g_' + node.guid)
      const n = node.children.length
      let w, h, mgap, fontsize, strokewidth
      let rx, ry, tx, ty, g
      let color = colors[deep + 1]
      if (pw > ph * 1.2) {
        if (pw / n > ph - tfsize * tlength) {
          mgap = (ph - tfsize * tlength) * 0.04
          fontsize = tfsize * 0.8 > (ph - tfsize) * 0.2 ? (ph - tfsize) * 0.2 : tfsize * 0.8
          strokewidth = (ph - tfsize) * 0.005
        } else {
          mgap = (pw / n) * 0.04
          fontsize = tfsize * 0.8 > (pw / n) * 0.2 ? (pw / n) * 0.2 : tfsize * 0.8
          strokewidth = (pw / n) * 0.005
        }
        w = (pw - mgap) / n - mgap
        h = ph - tfsize * tlength - 2 * mgap
        for (let i = 0; i < n; i++) {
          const _tlength = node.children[i].text.length
          rx = p1.x + (w + mgap) * i + mgap
          ry = p1.y + tfsize * tlength + mgap
          tx = p1.x + (w + mgap) * i + w * 0.5 + mgap
          g = graph
            .append('g')
            .attr('class', 'node')
            .attr('id', `g_${node.children[i].guid}`)
          let _ry = ry
          let _h = h
          if (Array.isArray(node.children[i].children)) {
            ty = p1.y + tfsize * tlength + mgap + fontsize
          } else {
            _ry = ry
            _h = h
            ty = p1.y + tfsize * tlength + mgap + _h * 0.5
          }
          g.append('rect')
            .attr('x', rx)
            .attr('y', _ry)
            .attr('width', w)
            .attr('height', _h)
            .attr('stroke', 'black')
            .attr('fill', color)
            .attr('stroke-width', strokewidth)
          g.append('text')
            .attr('x', tx)
            .attr('y', ty)
            .attr('style', 'text-anchor:middle')
          node.children[i].text.forEach((_, index) => {
            const _fontsize = (2 * w) / _.length < fontsize ? (2 * w) / _.length : fontsize
            g.select('text')
              .append('tspan')
              .attr('font-size', _fontsize)
              .attr('x', tx)
              .attr('y', ty + fontsize * index)
              .attr('title', _)
              .text(_)
          })
          if (Array.isArray(node.children[i].children)) {
            this.setChildren(node.children[i], { x: rx, y: _ry }, w, _h, fontsize, _tlength, deep + 1)
          }
        }
      } else {
        if ((ph - tfsize) / n > pw) {
          mgap = pw * 0.04
          fontsize = tfsize * 0.8 > pw * 0.2 ? pw * 0.2 : tfsize * 0.8
          strokewidth = pw * 0.005
        } else {
          mgap = ((ph - tfsize) / n) * 0.04
          fontsize = tfsize * 0.8 > ((ph - tfsize) / n) * 0.2 ? ((ph - tfsize) / n) * 0.2 : tfsize * 0.8
          strokewidth = ((ph - tfsize) / n) * 0.005
        }
        w = pw - 2 * mgap
        h = (ph - tfsize * tlength - mgap) / n - mgap
        for (let i = 0; i < n; i++) {
          const _tlength = node.children[i].text.length
          rx = p1.x + mgap
          ry = p1.y + tfsize * tlength + (h + mgap) * i + mgap
          tx = p1.x + w * 0.5 + mgap
          if (Array.isArray(node.children[i].children)) {
            ty = p1.y + tfsize + (h + mgap) * i + fontsize + mgap
          } else {
            ty = p1.y + mgap + fontsize * (tlength + 1) + (h + mgap) * i + h * 0.5
          }
          g = graph
            .append('g')
            .attr('class', 'node')
            .attr('id', `g_${node.children[i].guid}`)
          g.append('rect')
            .attr('x', rx)
            .attr('y', ry)
            .attr('width', w)
            .attr('height', h)
            .attr('stroke', 'black')
            .attr('fill', color)
            .attr('stroke-width', strokewidth)
          g.append('text')
            .attr('x', tx)
            .attr('y', ty)
            .attr('style', 'text-anchor:middle')
          node.children[i].text.forEach((_, index) => {
            const _fontsize = (2 * w) / _.length < fontsize ? (2 * w) / _.length : fontsize
            g.select('text')
              .append('tspan')
              .attr('font-size', _fontsize)
              .attr('x', tx)
              .attr('y', ty + fontsize * index)
              .text(_)
          })
          if (Array.isArray(node.children[i].children)) {
            this.setChildren(node.children[i], { x: rx, y: ry }, w, h, fontsize, _tlength, deep + 1)
          }
        }
      }
    },
    handleTabClick (name) {
      this.payload.filters = []
      this.currentTab = name
      if (this.currentTab !== 'resource-design') {
        this.getCurrentData()
      }
    },
    setCurrentGraph (name) {
      this.currentGraph = name
    },
    onSelectedRowsChange (rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              _.props.disabled = _.actionType === 'add'
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
        default:
          this.defaultHandler(type, data)
          break
      }
    },
    async defaultHandler (type, row) {
      this.$set(row.weTableForm, `${type}Loading`, true)
      const { statusCode, message } = await operateCiState(this.currentTab, row.guid, type)
      this.$set(row.weTableForm, `${type}Loading`, false)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: type,
          desc: message
        })
        this.queryCiData()
      }
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
      this.queryCiData()
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
              title: 'Delete data Success',
              desc: message
            })
            this.isDataChanged = true
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
              _.props.disabled = !(_.actionType === 'add' || _.actionType === 'export')
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
        const found = this.tabList.find(i => i.id === this.currentTab)
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
            title: 'Add data Success',
            desc: message
          })
          this.isDataChanged = true
          setBtnsStatus()
          this.queryCiData()
        }
      }
      if (editAry.length > 0) {
        const found = this.tabList.find(i => i.id === this.currentTab)
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
            title: 'Update data Success',
            desc: message
          })
          this.isDataChanged = true
          setBtnsStatus()
          this.queryCiData()
        }
      }
    },
    async exportHandler () {
      const found = this.tabList.find(_ => _.code === this.currentTab)
      if (found) {
        found.outerActions.forEach(_ => {
          if (_.actionType === 'export') {
            _.props.loading = true
          }
        })
      }
      const { statusCode, data } = await getPlanningDesignsCiData({
        idcGuid: this.selectedIdc,
        id: found.codeId,
        queryObject: this.payload
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
          filename: 'Ci Data',
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
      this.getAllIdcDesignData()
      this.payload.pageable.pageSize = 10
      this.payload.pageable.startIndex = 0
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          this.payload.pageable.pageSize = ci.pagination.pageSize
          this.payload.pageable.startIndex = (ci.pagination.currentPage - 1) * ci.pagination.pageSize
        }
      })
      const found = this.tabList.find(_ => _.code === this.currentTab)
      const { statusCode, data } = await getPlanningDesignsCiData({
        idcGuid: this.selectedIdc,
        id: found.codeId,
        queryObject: this.payload
      })
      if (statusCode === 'OK') {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.tableData = data.contents.map(_ => {
              return {
                ..._.data,
                ..._.meta
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
            ci.tableColumns = this.getSelectOptions(columns)
          }
        })
      }
    },
    getSelectOptions (columns) {
      columns.forEach(async _ => {
        if (_.inputType === 'select' || _.inputType === 'multiSelect') {
          const { data } = await getEnumCodesByCategoryId(0, _.referenceId)
          _['options'] = data
            .filter(j => j.status === 'active')
            .map(i => {
              return {
                label: i.value,
                value: i.codeId
              }
            })
        }
      })
      return columns
    },
    getCurrentData () {
      this.queryCiAttrs(this.currentTab)
      this.queryCiData()
    },
    async getZoneLink () {
      this.zoneLinkDesignData = new Map()
      const { statusCode, data } = await getAllZoneLinkDesignGroupByIdcDesign()
      if (statusCode === 'OK') {
        const idcLink = data.find(_ => _.idcGuid === this.selectedIdc)
        if (idcLink && idcLink.linkList) {
          idcLink.linkList.forEach(_ => {
            let zoneLink = {}
            if (
              _.data.network_zone_design_1.data_center_design === this.selectedIdc &&
              _.data.network_zone_design_2.data_center_design === this.selectedIdc
            ) {
              zoneLink.azone = `g_${_.data.network_zone_design_1.guid}`
              zoneLink.bzone = `g_${_.data.network_zone_design_2.guid}`
              const guid = this.idcDesignData.data.guid
              if (this.zoneLinkDesignData.has(guid)) {
                this.zoneLinkDesignData.get(guid).push(zoneLink)
              } else {
                this.zoneLinkDesignData.set(guid, [zoneLink])
              }
            }
          })
        }
      }
      this.initGraph()
    },
    async getTabLists () {
      const { statusCode, data } = await getPlanningDesignTabs()
      if (statusCode === 'OK') {
        let allInnerActions = await getExtraInnerActions()
        this.tabList = data.map(_ => {
          return {
            ..._,
            name: _.value,
            id: _.code,
            tableData: [],
            tableColumns: [],
            outerActions: JSON.parse(JSON.stringify(outerActions)),
            innerActions: innerActions.concat(allInnerActions),
            pagination: JSON.parse(JSON.stringify(pagination)),
            ascOptions: {}
          }
        })
        this.tabList = this.tabList.filter(tab => tab)
      }
    },
    async getAllIdcDesignData () {
      const { statusCode, data } = await getAllIdcDesignData()
      if (statusCode === 'OK') {
        this.allIdcs = data.map(_ => _.data)
      }
    }
  },
  mounted () {
    this.getTabLists()
    this.getAllIdcDesignData()
  }
}
</script>

<style lang="scss" scoped>
.resource-design-select-row {
  margin-bottom: 10px;
  display: flex;
  align-items: center;
}
.resource-design-tab-row {
  min-height: 50vh;
}
.graph-select {
  width: 400px;
}
.ivu-card-head p {
  height: 30px;
  line-height: 30px;
}
.filter-title {
  margin-right: 10px;
}
.graph-list {
  overflow-x: scroll;
  display: flex;
}
.graph-list > div {
  cursor: pointer;
}
.graph-container {
  width: 160px;
  height: 120px;
  float: left;
  margin-right: 5px;
  text-align: center;
}
.graph-container-big {
  margin-top: 20px;
}
</style>
