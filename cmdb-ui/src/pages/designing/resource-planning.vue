<template>
  <div>
    <Row class="graph-select-row">
      <Col span="6" class="resource-planning-title">
        <Select
          class="resource-planning-select"
          multiple
          v-model="selectedIdcs"
          :max-tag-count="2"
          :placeholder="$t('select_idc')"
        >
          <OptionGroup v-for="idc in realIdcs" :key="idc.guuid" :label="idc.name">
            <Option v-for="item in idc.logicIdcs" :value="item.guid" :key="item.guid">{{ item.name }}</Option>
          </OptionGroup>
        </Select>
      </Col>
      <Button @click="onIdcDataChange" type="primary">{{ $t('query') }}</Button>
    </Row>
    <Row class="graph-tabs">
      <Spin fix v-if="spinShow">
        <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
        <div>{{ $t('loading') }}</div>
      </Spin>
      <Tabs v-if="idcData.length" type="card" :value="currentTab" :closable="false" @on-click="handleTabClick">
        <TabPane :label="$t('resource_planning_diagram')" name="resource-design">
          <Alert show-icon closable v-if="isDataChanged">
            Data has beed changed, click Reload button to reload graph.
            <Button slot="desc" @click="reloadHandler">Reload</Button>
          </Alert>
          <div class="graph-container-big" id="resourcePlanningGraph"></div>
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
// eslint-disable-next-line
import * as d3Graphviz from 'd3-graphviz'
import {
  getAllIdcData,
  getIdcImplementTreeByGuid,
  getResourcePlanningCiData,
  getCiTypeAttributes,
  deleteCiDatas,
  createCiDatas,
  updateCiDatas,
  getEnumCodesByCategoryId,
  getResourcePlanningTabs,
  getAllZoneLinkGroupByIdc,
  operateCiState
} from '@/api/server'
import { outerActions, innerActions, pagination, components } from '@/const/actions.js'
import { formatData } from '../util/format.js'
import { getExtraInnerActions } from '../util/state-operations.js'

const fontSize = 16
const colors = ['#bbdefb', '#90caf9', '#64b5f6', '#42a5f5', '#2196f3', '#1e88e5', '#1976d2']
export default {
  data () {
    return {
      allIdcs: {},
      realIdcs: [],
      selectedIdcs: [],
      tabList: [],
      payload: {
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true
      },
      graph: {},
      idcData: [],
      currentTab: 'resource-design',
      clickedTab: [],
      currentGraph: '',
      spinShow: false,
      isDataChanged: false,
      lineData: [],
      graphNodes: {}
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
    async getAllIdcData () {
      const { data, statusCode } = await getAllIdcData()
      if (statusCode === 'OK') {
        this.allIdcs = {}
        this.realIdcs = []
        data.forEach(_ => {
          if (!_.data.regional_data_center) {
            this.realIdcs.push({
              guid: _.data.guid,
              name: _.data.name,
              logicIdcs: []
            })
          }
        })
        data.forEach(_ => {
          this.realIdcs.find((idc, i) => {
            if (_.data.regional_data_center && idc.guid === _.data.regional_data_center.guid) {
              this.realIdcs[i].logicIdcs.push({
                guid: _.data.guid,
                name: _.data.name,
                realIdcGuid: idc.guid
              })
              return true
            } else if (!_.data.regional_data_center && idc.guid === _.data.guid) {
              this.realIdcs[i].logicIdcs.unshift({
                guid: _.data.guid,
                name: _.data.name,
                realIdcGuid: idc.guid
              })
            }
          })
          this.allIdcs[_.data.guid] = {
            guid: _.data.guid,
            name: _.data.name,
            realIdcGuid: _.data.regional_data_center ? _.data.regional_data_center.guid : _.data.guid
          }
        })
      }
    },
    async reloadHandler () {
      this.onIdcDataChange()
      this.isDataChanged = false
    },
    async onIdcDataChange () {
      this.handleTabClick(this.currentTab)
      let willSelectIdc = {}
      this.selectedIdcs.forEach(_ => {
        const realIdcGuid = this.allIdcs[_].realIdcGuid
        if (!this.selectedIdcs.find(guid => realIdcGuid === guid)) {
          willSelectIdc[realIdcGuid] = realIdcGuid
        }
      })
      Object.keys(willSelectIdc).forEach(guid => {
        this.selectedIdcs.push(guid)
      })
      if (this.selectedIdcs.length) {
        this.spinShow = true
        const promiseArray = [getIdcImplementTreeByGuid(this.selectedIdcs), getAllZoneLinkGroupByIdc()]
        const [idcData, links] = await Promise.all(promiseArray)
        if (idcData.statusCode === 'OK' && links.statusCode === 'OK') {
          this.idcData = []
          let logicNetZone = {}
          idcData.data.forEach(_ => {
            if (!_.data.regional_data_center) {
              let obj = {
                ciTypeId: _.ciTypeId,
                guid: _.guid,
                data: _.data
              }
              if (_.children instanceof Array) {
                obj.children = _.children.filter(zone => zone.ciTypeId !== _.ciTypeId)
              }
              this.idcData.push(obj)
            } else if (_.data.regional_data_center && _.children instanceof Array) {
              _.children.forEach(zone => {
                logicNetZone[zone.guid] = zone
              })
            }
          })
          idcData.data.forEach(_ => {
            if (!_.data.regional_data_center && _.children instanceof Array) {
              _.children.forEach(zone => {
                if (zone.children instanceof Array) {
                  zone.children = zone.children.filter(item => !!logicNetZone[item.guid])
                }
              })
            }
          })
          let allZoneLinkObj = {}
          links.data.forEach(_ => {
            if (_.linkList instanceof Array) {
              _.linkList.forEach(link => {
                allZoneLinkObj[link.data.guid] = link.data
              })
            }
          })
          this.lineData = []
          Object.keys(allZoneLinkObj).forEach(guid => {
            const line = {
              guid,
              from: allZoneLinkObj[guid].network_zone_1.guid,
              to: allZoneLinkObj[guid].network_zone_2.guid,
              label: allZoneLinkObj[guid].code,
              state: allZoneLinkObj[guid].state.code
            }
            this.lineData.push(line)
          })
          this.$nextTick(() => {
            this.initGraph()
          })
        }
      } else {
        this.idcData = []
        this.lineData = []
      }
    },
    initGraph () {
      let graph
      const initEvent = () => {
        graph = d3.select('#resourcePlanningGraph')
        graph
          .on('dblclick.zoom', null)
          .on('wheel.zoom', null)
          .on('mousewheel.zoom', null)
        this.graph.graphviz = graph
          .graphviz()
          .fit(true)
          .zoom(true)
          .scale(1.2)
          .width(window.innerWidth * 0.96)
          .height(window.innerHeight * 0.8)
      }
      initEvent()
      this.renderGraph()
      this.spinShow = false
    },
    renderGraph () {
      const nodesString = this.genDOT(this.idcData)
      this.graph.graphviz.renderDot(nodesString)
      let width = window.innerWidth
      let height = window.innerHeight
      let svg = d3.select('#resourcePlanningGraph').select('svg')
      svg
        .attr('width', width)
        .attr('height', height)
        .attr('viewBox', `0 0 ${width} ${height}`)

      this.idcData.forEach(_ => {
        const children = _.children || []
        children.forEach(zone => {
          d3.select(`#n_${zone.guid}`)
            .select('polygon')
            .attr('fill', colors[1])
          if (zone.children instanceof Array) {
            let points = d3
              .select(`#n_${zone.guid}`)
              .select('polygon')
              .attr('points')
              .split(' ')
            let p = {
              x: parseInt(points[1].split(',')[0]),
              y: parseInt(points[1].split(',')[1])
            }
            const pw = parseInt(points[0].split(',')[0] - points[1].split(',')[0])
            const ph = parseInt(points[2].split(',')[1] - points[1].split(',')[1])
            this.setChildren(zone, p, pw, ph, fontSize, 1)
          }
        })
      })
    },
    genDOT (data) {
      this.graphNodes = {}
      const width = 16
      const height = 12
      let dots = [
        'digraph G{',
        'rankdir=TB;nodesep=0.5;',
        `Node[shape=box,fontsize=${fontSize},labelloc=t,penwidth=2];`,
        'Edge[fontsize=6];',
        `size="${width},${height}";`
      ]
      data.forEach(idc => {
        dots.push(
          `subgraph cluster_${idc.guid} {`,
          `style="filled";color="${colors[0]}";`,
          `tooltip="${idc.data.description}";`,
          `label="${idc.data.name}";`,
          this.genChildren(idc.children || [], 1),
          '}'
        )
      })
      dots.push(this.genLines(), '}')
      return dots.join('')
    },
    genChildren (data) {
      const width = 16
      const height = 12
      let dots = []
      let layers = {}
      data.forEach(_ => {
        const layerCode = _.data.network_zone_layer ? _.data.network_zone_layer.code : 'otherLayer'
        if (layers[layerCode]) {
          layers[layerCode].push(_)
        } else {
          layers[layerCode] = [_]
        }
      })
      if (layers) {
        Object.keys(layers).forEach(guid => {
          const layer = layers[guid]
          dots.push('{rank=same;')
          let n = Object.keys(layers).length
          let lg = (height - 3) / n
          let ll = (width - 0.5 * layer.length) / layer.length
          layer.forEach(zone => {
            let label
            if (zone.data.code && zone.data.code !== null && zone.data.code !== '') {
              label = zone.data.code
            } else {
              label = zone.data.key_name
            }
            this.graphNodes[zone.guid] = zone
            dots.push(
              `n_${zone.guid}[id="n_${zone.guid}",color="${colors[1]}",label="${label}",width=${ll},height=${lg}];`
            )
          })
          dots.push('}')
        })
      } else {
        dots.push(`n_${data.data.guid}[label=" ",color="${colors[0]}",width="${width - 0.5}",height="${height - 3}"]`)
      }
      return dots.join('')
    },
    genLines () {
      let dots = []
      this.lineData.forEach(_ => {
        if (this.graphNodes[_.from] && this.graphNodes[_.to]) {
          dots.push(
            `n_${_.from} -> n_${_.to}[id=gl_${_.guid},tooltip="${_.label || ''}",taillabel="${_.label || ''}"];`
          )
        }
      })
      return dots.join('')
    },
    genLink (links) {
      let result = ''
      links.forEach(link => {
        result += `${link.azone}->${link.bzone}[arrowhead="none"];`
      })
      return result
    },
    setChildren (node, p1, pw, ph, tfsize, deep, idcName) {
      let graph = d3.select('#resourcePlanningGraph').select('#n_' + node.guid)
      let n = node.children.length
      let w, h, mgap, fontsize, strokewidth
      let rx, ry, tx, ty, g
      let color = colors[deep + 1]
      if (pw > ph * 1.2) {
        if (pw / n > ph - tfsize) {
          mgap = (ph - tfsize) * 0.04
          fontsize = tfsize * 0.8 > (ph - tfsize) * 0.1 ? (ph - tfsize) * 0.1 : tfsize * 0.8
          strokewidth = (ph - tfsize) * 0.005
        } else {
          mgap = (pw / n) * 0.04
          fontsize = tfsize * 0.8 > (pw / n) * 0.1 ? (pw / n) * 0.1 : tfsize * 0.8
          strokewidth = (pw / n) * 0.005
        }
        w = (pw - mgap) / n - mgap
        h = ph - tfsize - 2 * mgap
        for (var i = 0; i < n; i++) {
          rx = p1.x + (w + mgap) * i + mgap
          ry = p1.y + tfsize + mgap
          tx = p1.x + (w + mgap) * i + w * 0.5 + mgap
          if (Array.isArray(node.children[i].children)) {
            ty = p1.y + tfsize + mgap + fontsize
          } else {
            ty = p1.y + tfsize + mgap + h * 0.5
          }
          g = graph
            .append('g')
            .attr('class', 'node')
            .attr('id', `n_${node.children[i].guid}`)
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
            .text(node.children[i].data.code ? node.children[i].data.code : node.children[i].data.key_name)
            .attr('style', 'text-anchor:middle')
            .attr('font-size', fontsize)
          if (Array.isArray(node.children[i].children)) {
            this.setChildren(node.children[i], { x: rx, y: ry }, w, h, fontsize, deep + 1, idcName)
          }
        }
      } else {
        if ((ph - tfsize) / n > pw) {
          mgap = pw * 0.04
          fontsize = tfsize * 0.8 > pw * 0.1 ? pw * 0.1 : tfsize * 0.8
          strokewidth = pw * 0.005
        } else {
          mgap = ((ph - tfsize) / n) * 0.04
          fontsize = tfsize * 0.8 > ((ph - tfsize) / n) * 0.1 ? ((ph - tfsize) / n) * 0.1 : tfsize * 0.8
          strokewidth = ((ph - tfsize) / n) * 0.005
        }
        w = pw - 2 * mgap
        h = (ph - tfsize - mgap) / n - mgap
        for (let i = 0; i < n; i++) {
          rx = p1.x + mgap
          ry = p1.y + tfsize + (h + mgap) * i + mgap
          tx = p1.x + w * 0.5 + mgap
          if (Array.isArray(node.children[i].children)) {
            ty = p1.y + tfsize + (h + mgap) * i + fontsize + mgap
          } else {
            ty = p1.y + tfsize + (h + mgap) * i + h * 0.5 + mgap
          }
          g = graph
            .append('g')
            .attr('class', 'node')
            .attr('id', `n_${node.children[i].guid}`)
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
            .text(node.children[i].data.code ? node.children[i].data.code : node.children[i].data.key_name)
            .attr('style', 'text-anchor:middle')
            .attr('font-size', fontsize)
          if (Array.isArray(node.children[i].children)) {
            this.setChildren(node.children[i], { x: rx, y: ry }, w, h, fontsize, deep + 1, idcName)
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
      const { statusCode, message } = await operateCiState(this.currentTab, row.guid, type)
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
              title: this.$t('delete_data_success'),
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
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: this.$t('add_data_success'),
            desc: message
          })
          this.isDataChanged = true
          setBtnsStatus()
          this.queryCiData()
        }
      }
      if (editAry.length > 0) {
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
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: this.$t('update_data_success'),
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
      const { statusCode, data } = await getResourcePlanningCiData({
        idcGuid: this.selectedIdcs.join(','),
        id: found.codeId,
        queryObject: this.payload
      })
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
      this.getAllIdcData()
      this.payload.pageable.pageSize = 10
      this.payload.pageable.startIndex = 0
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          this.payload.pageable.pageSize = ci.pagination.pageSize
          this.payload.pageable.startIndex = (ci.pagination.currentPage - 1) * ci.pagination.pageSize
        }
      })
      const found = this.tabList.find(_ => _.code === this.currentTab)
      const { statusCode, data } = await getResourcePlanningCiData({
        idcGuid: this.selectedIdcs.join(','),
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
              title: _.name,
              key: renderKey,
              inputKey: _.propertyName,
              inputType: _.inputType,
              referenceId: _.referenceId,
              disEditor: !_.isEditable,
              disAdded: !_.isEditable,
              placeholder: _.name,
              component: 'Input',
              ciType: { id: _.referenceId, name: _.name },
              type: 'text',
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
    async getTabList () {
      const { statusCode, data } = await getResourcePlanningTabs()
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
            innerActions: JSON.parse(JSON.stringify(innerActions.concat(allInnerActions))),
            pagination: JSON.parse(JSON.stringify(pagination)),
            ascOptions: {}
          }
        })
      }
    }
  },
  created () {
    this.getAllIdcData()
    this.getTabList()
  }
}
</script>

<style lang="scss" scoped>
.graph-select-row {
  margin-bottom: 10px;
}
.graph-tabs {
  min-height: 400px;
  position: relative;
}
.ivu-card-head p {
  height: 30px;
  line-height: 30px;
}
.filter-title {
  margin-right: 10px;
}
.graph-list {
  overflow-x: auto;
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
.resource-planning-title {
  display: flex;
  margin-right: 10px;
  & > span {
    line-height: 32px;
  }
}
.resource-planning-select {
  flex: 1;
  margin-left: 10px;
}
</style>
