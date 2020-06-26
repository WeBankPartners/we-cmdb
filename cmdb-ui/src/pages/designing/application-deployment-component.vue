<template>
  <div>
    <Row class="artifact-management">
      <Col span="6">
        <span style="margin-right: 10px">{{ $t('system') }}</span>
        <Select filterable @on-change="onSystemDesignSelect" v-model="systemVersion" label-in-name style="width: 70%;">
          <Option v-for="item in systems" :value="item.guid" :key="item.guid">{{ item.key_name }}</Option>
        </Select>
      </Col>
      <Col span="3">
        <Button type="info" @click="querySysTree">{{ $t('query') }}</Button>
      </Col>
    </Row>
    <hr style="margin: 10px 0" />
    <!-- <div class="graph-container" id="graph">
      <Spin size="large" fix v-if="spinShow">
        <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
        <div>{{ $t('loading') }}</div>
      </Spin>
      <div v-else-if="!systemData.length" class="no-data">
        {{ $t('no_data') }}
      </div>
    </div> -->
    <Row class="resource-design-tab-row">
      <Spin fix v-if="spinShow">
        <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
        <div>{{ $t('loading') }}</div>
      </Spin>
      <Row>
        <Col span="16">
          <Card>
            <div class="graph-container" id="graph"></div>
          </Card>
        </Col>
        <Col span="8" class="operation-zone">
          <Card>
            <Operation ref="transferData"></Operation>
          </Card>
        </Col>
      </Row>
    </Row>
  </div>
</template>

<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line no-unused-vars
import * as d3Graphviz from 'd3-graphviz'
import { getSystems, getEnumCodesByCategoryId, getAllDeployTreesFromSystemCi } from '@/api/server.js'
import { colors, stateColor } from '../../const/graph-configuration'
import {
  VIEW_CONFIG_PARAMS,
  UNIT_ID,
  BUSINESS_APP_INSTANCE_ID,
  INVOKE_ID,
  INVOKE_UNIT,
  INVOKED_UNIT
} from '@/const/init-params.js'
import Operation from './operation'
export default {
  components: {
    Operation
  },
  data () {
    return {
      initParams: {},
      systems: [],
      systemVersion: '',
      env: '',
      selectedDeployItems: [],
      graphs: {},
      spinShow: false,
      graph: {},
      systemData: [],
      systemLines: {},
      graphNodes: {}
    }
  },
  methods: {
    initADGraph () {
      this.spinShow = true
      const initEvent = () => {
        let graph = d3.select('#graph')

        graph
          .on('dblclick.zoom', null)
          .on('wheel.zoom', null)
          .on('mousewheel.zoom', null)
        const width = (window.innerWidth / 24) * 18
        this.graph.graphviz = graph
          .graphviz()
          .width(width - 80)
          .height(window.innerHeight - 190)
          .zoom(true)
          .fit(true)
      }

      initEvent()
      this.renderADGraph(this.systemData)
      this.spinShow = false
    },
    renderADGraph (data) {
      let nodesString = this.genADDOT(data)
      this.graph.graphviz.transition().renderDot(nodesString)
      let svg = d3.select('#graph').select('svg')
      let width = svg.attr('width')
      let height = svg.attr('height')
      svg.attr('viewBox', '0 0 ' + width + ' ' + height)
    },
    genADDOT (data) {
      this.graphNodes = {}
      if (!data.length) {
        return 'digraph G{}'
      }
      let width = 16
      let height = 12
      let dots = [
        'digraph G{',
        'rankdir=LR;nodesep=0.5;',
        'Node[fontname=Arial,fontsize=12,shape=box,style=filled];',
        'Edge[fontname=Arial,minlen="1",fontsize=12,labeldistance=1.5];',
        `size="${width},${height}";`,
        `subgraph cluster_${data[0].guid}{`,
        `style="filled";color="${colors[0]}";`,
        `tooltip="${data[0].data.code}";`,
        `label="${data[0].data.code}";`,
        this.genADChildrenDot(data[0].children || [], 1),
        '}',
        this.genADLines(),
        '}'
      ]
      return dots.join('')
    },
    genADChildrenDot (data, level) {
      const width = 12
      const height = 9
      let dots = []
      if (data.length) {
        data.forEach(_ => {
          let color = ''
          if (!_.fixedDate) {
            color = stateColor[_.data.state.code]
          }
          if (_.children instanceof Array && _.children.length) {
            dots.push(
              `subgraph cluster_${_.guid}{`,
              `id="g_${_.guid}";`,
              `color="${color || colors[level]}";`,
              `style="filled";fillcolor="${colors[level]}";`,
              `label=${_.label};`,
              `tooltip="${_.tooltip}";`,
              this.genADChildrenDot(_.children, level + 1),
              '}'
            )
          } else {
            this.graphNodes[_.guid] = _
            dots.push(
              `"n_${_.guid}"`,
              `[id="n_${_.guid}",shape="none",`,
              `fillcolor="${color || colors[level]}";`,
              `label=${_.label}`,
              '];'
            )
          }
        })
      } else {
        dots.push(`g[label=" ",color="${colors[level - 1]}";width="${width}";height="${height - 3}"];`)
      }
      return dots.join('')
    },
    genADLines () {
      const result = []
      Object.keys(this.systemLines).forEach(guid => {
        const node = this.systemLines[guid]

        let color = '#000'
        if (!node.fixedDate) {
          color = stateColor[node.state]
        }
        result.push(
          `n_${node.from}->n_${node.to}`,
          `[id="gl_${node.id}",`,
          `color="${color}"`,
          `tooltip="${node.label || ''}",`,
          `taillabel="${node.label || ''}"];`
        )

        const formatLabel = (keyName, guid) => {
          if (this.instancesInUnit[guid]) {
            let label = [
              '<<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" COLOR="#000">',
              `<TR><TD>${keyName}</TD></TR>`
            ]
            this.instancesInUnit[guid].forEach(_ => {
              label.push(`<TR><TD>${_.key_name}</TD></TR>`)
            })
            label.push('</TABLE>>')
            return label.join('')
          } else {
            return `"${keyName}"`
          }
        }

        if (!this.graphNodes[node.from]) {
          const _fromNode = node.data[this.initParams[INVOKE_UNIT]]
          result.push(
            `n_${_fromNode.guid}`,
            `[label=${formatLabel(_fromNode.key_name, _fromNode.guid)},`,
            this.instancesInUnit[_fromNode.guid] ? 'color="#d3d3d3"' : '',
            `tooltip="${_fromNode.key_name || ''}"];`
          )
        } else if (!this.graphNodes[node.to]) {
          const _fromTo = node.data[this.initParams[INVOKED_UNIT]]
          result.push(
            `n_${_fromTo.guid}`,
            `[label=${formatLabel(_fromTo.key_name, _fromTo.guid)},`,
            this.instancesInUnit[_fromTo.guid] ? 'color="#d3d3d3"' : '',
            `tooltip="${_fromTo.key_name || ''}"];`
          )
        }
      })
      return result.join('')
    },
    onSystemDesignSelect (key) {
      this.systemData = []
      this.systemTreeData = []
      this.systemLines = {}
      this.graphNodes = {}
      this.initADGraph()
    },
    async getSystems () {
      let { statusCode, data } = await getSystems()
      if (statusCode === 'OK') {
        this.systems = data.contents.map(_ => _.data)
      }
    },
    async querySysTree () {
      if (!this.systemVersion) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('please_select_system')
        })
        return
      }
      this.spinShow = true
      this.getAllDeployTreesFromSystemCi()
    },
    async getAllDeployTreesFromSystemCi () {
      const { initParams } = this
      const { statusCode, data } = await getAllDeployTreesFromSystemCi(this.systemVersion)
      if (statusCode === 'OK') {
        this.systemTreeData = data
        this.systemLines = {}

        const formatADData = array => {
          return array.map(_ => {
            let result = {
              ciTypeId: _.ciTypeId,
              guid: _.guid,
              data: _.data,
              label: `"${_.data.code}"`,
              tooltip: _.data.description || '',
              fixedDate: +new Date(_.data.fixed_date)
            }
            if (_.children instanceof Array && _.children.length && _.ciTypeId !== initParams[UNIT_ID]) {
              result.children = formatADData(_.children)
            }
            if (_.ciTypeId === initParams[UNIT_ID]) {
              let label = ['<<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">', `<TR><TD>${_.data.code}</TD></TR>`]
              if (_.children instanceof Array && _.children.length) {
                _.children.forEach(item => {
                  if (initParams[BUSINESS_APP_INSTANCE_ID].split(',').indexOf(item.ciTypeId + '') >= 0) {
                    label.push(`<TR><TD>${item.data.code}</TD></TR>`)
                  }
                })
              }
              label.push('</TABLE>>')
              result.label = label.join('')
            }
            return result
          })
        }
        const formatADLine = array => {
          array.forEach(_ => {
            if (_.ciTypeId === this.initParams[INVOKE_ID]) {
              this.systemLines[_.guid] = {
                ..._,
                from: _.data[this.initParams[INVOKE_UNIT]].guid,
                to: _.data[this.initParams[INVOKED_UNIT]].guid,
                id: _.guid,
                label: _.data.invoke_type,
                state: _.data.state.code,
                fixedDate: +new Date(_.data.fixed_date)
              }
            }
            if (_.children instanceof Array && _.children.length) {
              formatADLine(_.children)
            }
          })
        }

        const fetchOtherSystemInstances = async () => {
          this.instancesInUnit = {}
          this.graphNodes = {}
          this.genADChildrenDot(this.systemData[0].children || [], 1)
          this.initADGraph()
        }
        this.systemData = formatADData(data)
        formatADLine(data)
        fetchOtherSystemInstances()
      }
    },
    async getConfigParams () {
      const { statusCode, data } = await getEnumCodesByCategoryId(0, VIEW_CONFIG_PARAMS)
      if (statusCode === 'OK') {
        this.initParams = {}
        data.forEach(_ => {
          this.initParams[_.code] = Number(_.value) ? Number(_.value) : _.value
        })
        this.getSystems()
      }
    }
  },
  created () {
    this.getConfigParams()
  }
}
</script>

<style lang="scss" scoped>
.no-data {
  text-align: center;
}

.copy-modal {
  .ivu-modal-body {
    max-height: 450px;
    overflow-y: auto;
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
</style>
