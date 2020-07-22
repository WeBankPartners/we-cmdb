<template>
  <Row>
    <Spin fix v-if="spinShow">
      <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
      <div>{{ $t('loading') }}</div>
    </Spin>
    <Row>
      <Col span="24">
        <Card>
          <div class="container-height" id="appLogicGraph"></div>
          <div class="operation-area">
            <Collapse>
              <Panel name="1">
                {{ $t('operating_area') }}
                <div slot="content">
                  <Operation
                    class="operation-container"
                    ref="transferData"
                    :hideNextOperations="hideNextOperations"
                    :ignoreOpera="ignoreOpera"
                    @operationReload="operationReload"
                    @markZone="markZone"
                    @markEdge="markEdge"
                  ></Operation>
                </div>
              </Panel>
            </Collapse>
          </div>
        </Card>
      </Col>
    </Row>
  </Row>
</template>

<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line no-unused-vars
import * as d3Graphviz from 'd3-graphviz'
import { getEnumCodesByCategoryId, getAllDesignTreeFromSystemDesign } from '@/api/server'
import { addEvent } from '../util/event.js'
import { colors, stateColor } from '../../const/graph-configuration'
import {
  VIEW_CONFIG_PARAMS,
  UNIT_DESIGN_ID,
  INVOKE_DESIGN_ID,
  INVOKE_DIAGRAM_LINK_FROM,
  INVOKE_DIAGRAM_LINK_TO,
  INVOKE_TYPE
} from '@/const/init-params.js'
import Operation from './application-operation'
export default {
  components: {
    Operation
  },
  data () {
    return {
      originData: null,
      graphCiTypeId: 37,
      ignoreOpera: ['confirm'],
      graphData: null,
      graphDataWithGuid: {},
      operateNodeData: {},
      idPath: [], // 缓存点击图形区域从内向外容器ID值
      cacheIdPath: [], // 缓存点击图形区域从内向外容器ID值
      cacheIndex: [], // 缓存点击图形区域从内向外容器ID值
      levelData: [], // 缓存层级数据备用
      activeNodeInfo: {
        id: '',
        type: '',
        color: ''
      },
      activeLineGuid: '',

      systemDesignVersion: '',
      isTableViewOnly: false,

      graph: {},
      systemDesignData: [],
      appLogicData: [],
      graphNodes: {},
      spinShow: false,
      invokeLines: [],
      appInvokeLines: {},
      systemDesignFixedDate: 0,
      initParams: {},

      editPath: [],
      editIndex: []
    }
  },
  props: ['hideNextOperations'],
  watch: {
    cacheIdPath: function (val) {
      // 选中节点颜色控制
      if (this.activeNodeInfo.id) {
        d3.select('#appLogicGraph')
          .select(`#` + this.activeNodeInfo.id)
          .select(this.activeNodeInfo.type)
          .attr('fill', this.activeNodeInfo.color)
        this.activeNodeInfo = {}
      }
      const id = val[val.length - 1]
      this.activeNodeInfo.type = d3
        .select('#appLogicGraph')
        .select(`#` + id)
        .select('polygon')._groups[0][0]
        ? 'polygon'
        : 'rect'
      const color = d3
        .select('#appLogicGraph')
        .select(`#` + id)
        .select(this.activeNodeInfo.type)
        .attr('fill')
      this.activeNodeInfo.id = id
      this.activeNodeInfo.color = color
      d3.select('#appLogicGraph')
        .select(`#` + id)
        .select(this.activeNodeInfo.type)
        .attr('fill', '#ff9900')
    }
  },
  methods: {
    markZone (guid) {
      const nodeKeys = Object.keys(this.graphDataWithGuid)
      this.cacheIdPath = nodeKeys.includes(`n_${guid}`) ? [`n_${guid}`] : [`g_${guid}`]
    },
    markEdge (guid) {
      if (this.activeLineGuid) {
        d3.select('#appLogicGraph')
          .select(`#gl_` + this.activeLineGuid)
          .select('path')
          .attr('stroke', '#000000')
        d3.select('#appLogicGraph')
          .select(`#a_gl_` + this.activeLineGuid + '-taillabel')
          .select('a')
          .select('text')
          .attr('fill', '#000000')
      }
      this.activeLineGuid = guid
      d3.select('#appLogicGraph')
        .select(`#gl_` + guid)
        .select('path')
        .attr('stroke', '#ff9900')
      d3.select('#appLogicGraph')
        .select(`#a_gl_` + guid + '-taillabel')
        .select('a')
        .select('text')
        .attr('fill', '#ff9900')
    },
    findParentGuid (guid) {
      if (guid !== 'p') {
        const xParent = this.graphDataWithGuid[`n_${guid}`] || this.graphDataWithGuid[`g_${guid}`]
        const xGuid = xParent.parentGuid
        this.editPath.unshift(xGuid)
        this.findParentGuid(xGuid)
      }
    },
    operationReload (pGuid, editNode, editNodeIndex, type) {
      let originData = JSON.parse(JSON.stringify(this.originData[0]))
      if (type === 'confirm') {
        this.loadMap([originData], pGuid)
        return
      }
      this.editPath = []
      this.editIndex = []
      this.findParentGuid(pGuid)
      this.editPath.push(pGuid)
      this.editPath = this.editPath.slice(1)
      let tmpData = originData
      let tmp = JSON.parse(JSON.stringify(this.originData[0]))
      if (type === 'parentNode') {
        // TODO 更新父节点，需先点击外层才生效？
        this.editPath.forEach(guid => {
          if (guid !== originData.guid) {
            // eslint-disable-next-line no-unused-vars
            tmp = tmp.children.find((child, i) => {
              if (child.guid === guid) {
                this.editIndex.push(i)
                return child
              }
            })
          }
        })
        if (this.editIndex.length > 0) {
          if (this.editIndex.length < 2) {
            this.editIndex.forEach((no, index) => {
              if (this.editIndex.length - 1 !== index) {
                tmpData = originData.children[no]
              } else {
                tmpData = tmpData.children
                if (Array.isArray(tmpData)) {
                  const index = tmpData.findIndex(child => {
                    return child.guid === pGuid
                  })
                  tmpData = tmpData[index]
                  tmpData.data = editNode.data
                }
              }
            })
          } else {
            this.editIndex.forEach((no, index) => {
              if (this.editIndex.length !== index) {
                tmpData = tmpData.children[no]
              }
            })
            tmpData.data = editNode.data
          }
        } else {
          originData.data = editNode.data
        }
        this.loadMap([originData], pGuid)
        return
      }
      if (type === 'addNode') {
        this.addNode(pGuid, editNode, editNodeIndex, type)
        return
      }
      if (type === 'deleteNode') {
        this.deleteNode(pGuid, editNode, editNodeIndex, type)
        return
      }

      // 更新子节点
      // let tmp = JSON.parse(JSON.stringify(this.originData[0]))
      this.editPath.forEach(guid => {
        if (guid === originData.guid) {
          tmp = tmp.children
        } else {
          if (Array.isArray(tmp)) {
            tmp = tmp.find((child, index) => {
              if (child.guid === guid) {
                this.editIndex.push(index)
                return child
              }
            }).children
          }
        }
      })
      // eslint-disable-next-line no-unused-vars
      // let tmpData = originData
      if (this.editIndex.length > 0) {
        if (this.editIndex.length < 2) {
          this.editIndex.forEach((no, index) => {
            if (this.editIndex.length - 1 !== index) {
              tmpData = originData.children[no]
            } else {
              tmpData = tmpData.children
              if (Array.isArray(tmp)) {
                const index = tmpData.findIndex(child => {
                  return child.guid === pGuid
                })
                tmpData = tmpData[index]
                tmpData.children[editNodeIndex] = editNode
              }
            }
          })
        } else {
          this.editIndex.forEach((no, index) => {
            if (this.editIndex.length !== index) {
              tmpData = tmpData.children[no]
            }
          })
          tmpData.children[editNodeIndex] = editNode
        }
      } else {
        originData.children[editNodeIndex] = editNode
      }
      this.loadMap([originData], pGuid)
    },
    addNode (pGuid, editNode, editNodeIndex, type) {
      let originData = JSON.parse(JSON.stringify(this.originData[0]))
      let tmp = JSON.parse(JSON.stringify(this.originData[0]))
      this.editPath.forEach(guid => {
        if (guid === originData.guid) {
          tmp = tmp.children
        } else {
          if (Array.isArray(tmp)) {
            tmp = tmp.find((child, index) => {
              if (child.guid === guid) {
                this.editIndex.push(index)
                return child
              }
            }).children
          }
        }
      })
      // eslint-disable-next-line no-unused-vars
      let tmpData = originData
      if (this.editIndex.length > 0) {
        if (this.editIndex.length < 2) {
          this.editIndex.forEach((no, index) => {
            if (this.editIndex.length - 1 !== index) {
              tmpData = originData.children[no]
            } else {
              tmpData = tmpData.children
              if (Array.isArray(tmpData)) {
                const index = tmpData.findIndex(child => {
                  return child.guid === pGuid
                })
                tmpData = tmpData[index]
                tmpData.children = tmpData.children || []
                tmpData.children.push(editNode)
              }
            }
          })
        } else {
          this.editIndex.forEach((no, index) => {
            if (this.editIndex.length !== index) {
              tmpData = tmpData.children[no]
            }
          })
          tmpData.children = tmpData.children || []
          tmpData.children.push(editNode)
        }
      } else {
        tmpData.children = tmpData.children || []
        originData.children.push(editNode)
      }
      this.loadMap([originData], pGuid)
    },
    deleteNode (pGuid, editNode, editNodeIndex, type) {
      let originData = JSON.parse(JSON.stringify(this.originData[0]))
      let tmp = JSON.parse(JSON.stringify(this.originData[0]))
      this.editPath.forEach(guid => {
        if (guid === originData.guid) {
          tmp = tmp.children
        } else {
          if (Array.isArray(tmp)) {
            tmp = tmp.find((child, index) => {
              if (child.guid === guid) {
                this.editIndex.push(index)
                return child
              }
            }).children
          }
        }
      })
      // eslint-disable-next-line no-unused-vars
      let tmpData = originData
      if (this.editIndex.length > 0) {
        if (this.editIndex.length < 2) {
          this.editIndex.forEach((no, index) => {
            if (this.editIndex.length - 1 !== index) {
              tmpData = originData.children[no]
            } else {
              tmpData = tmpData.children
              if (Array.isArray(tmp)) {
                const index = tmpData.findIndex(child => {
                  return child.guid === pGuid
                })
                tmpData = tmpData[index]
                if (tmpData.children.length === 1) {
                  delete tmpData.children
                } else {
                  tmpData.children.splice(editNodeIndex, 1)
                }
              }
            }
          })
        } else {
          this.editIndex.forEach((no, index) => {
            if (this.editIndex.length !== index) {
              tmpData = tmpData.children[no]
            }
          })
          if (tmpData.children.length === 1) {
            delete tmpData.children
          } else {
            tmpData.children.splice(editNodeIndex, 1)
          }
        }
      } else {
        if (tmpData.children.length === 1) {
          delete tmpData.children
        } else {
          tmpData.children.splice(editNodeIndex, 1)
        }
      }
      this.loadMap([originData], pGuid)
    },
    loadMap (updatedOriginData, pGuid) {
      // this.originData = updatedOriginData
      this.systemTreeData = updatedOriginData
      this.systemLines = {}
      this.originData = JSON.parse(JSON.stringify(updatedOriginData))
      this.appInvokeLines = {}
      this.graphDataWithGuid = {}
      const formatAppLogicTree = (array, parentGuid) =>
        array.map(_ => {
          let result = {
            ciTypeId: _.ciTypeId,
            guid: _.guid,
            data: _.data,
            children_x: _.children,
            fixedDate: +new Date(_.data.fixed_date)
          }
          if (_.children instanceof Array && _.children.length && _.ciTypeId !== this.initParams[UNIT_DESIGN_ID]) {
            result.children = formatAppLogicTree(_.children, _.guid)
            _.parentGuid = parentGuid
            this.graphDataWithGuid['g_' + _.guid] = _
          } else {
            _.parentGuid = parentGuid
            this.graphDataWithGuid['n_' + _.guid] = _
          }
          return result
        })
      const formatAppLogicLine = array =>
        array.forEach(_ => {
          if (_.ciTypeId === this.initParams[INVOKE_DESIGN_ID]) {
            this.appInvokeLines[_.guid] = {
              from: _.data[this.initParams[INVOKE_DIAGRAM_LINK_FROM]],
              to: _.data[this.initParams[INVOKE_DIAGRAM_LINK_TO]],
              id: _.guid,
              label: _.data[this.initParams[INVOKE_TYPE]],
              tooltip: _.data.description || '-',
              state: _.data.state.code,
              fixedDate: +new Date(_.data.fixed_date)
            }
            _.data.ciTypeId = this.initParams[INVOKE_DESIGN_ID]
          }
          if (_.children instanceof Array && _.children.length) {
            formatAppLogicLine(_.children)
          }
        })
      this.appLogicData = formatAppLogicTree(updatedOriginData, 'p')
      this.operateNodeData = this.appLogicData[0]
      this.$refs.transferData.graphCiTypeId = this.graphCiTypeId
      this.$refs.transferData.managementData(
        this.graphDataWithGuid[`n_${pGuid}`] || this.graphDataWithGuid[`g_${pGuid}`]
      )
      formatAppLogicLine(updatedOriginData)
      this.initGraph()
    },
    async getAllDesignTreeFromSystemDesign (systemDesignVersion, isTableViewOnly) {
      this.systemDesignVersion = systemDesignVersion
      this.isTableViewOnly = isTableViewOnly
      const treeData = await getAllDesignTreeFromSystemDesign(this.systemDesignVersion)
      if (treeData.statusCode === 'OK') {
        this.originData = JSON.parse(JSON.stringify(treeData.data))
        this.appInvokeLines = {}
        this.systemDesignFixedDate = +new Date(treeData.data[0].data.fixed_date)
        this.graphDataWithGuid = {}
        const formatAppLogicTree = (array, parentGuid) =>
          array.map(_ => {
            let result = {
              ciTypeId: _.ciTypeId,
              guid: _.guid,
              data: _.data,
              children_x: _.children,
              fixedDate: +new Date(_.data.fixed_date)
            }
            if (_.children instanceof Array && _.children.length && _.ciTypeId !== this.initParams[UNIT_DESIGN_ID]) {
              result.children = formatAppLogicTree(_.children, _.guid)
              _.parentGuid = parentGuid
              this.graphDataWithGuid['g_' + _.guid] = _
            } else {
              _.parentGuid = parentGuid
              this.graphDataWithGuid['n_' + _.guid] = _
            }
            return result
          })
        const formatAppLogicLine = array =>
          array.forEach(_ => {
            if (_.ciTypeId === this.initParams[INVOKE_DESIGN_ID]) {
              this.appInvokeLines[_.guid] = {
                from: _.data[this.initParams[INVOKE_DIAGRAM_LINK_FROM]],
                to: _.data[this.initParams[INVOKE_DIAGRAM_LINK_TO]],
                id: _.guid,
                label: _.data[this.initParams[INVOKE_TYPE]],
                tooltip: _.data.description || '-',
                state: _.data.state.code,
                fixedDate: +new Date(_.data.fixed_date)
              }
              _.data.ciTypeId = this.initParams[INVOKE_DESIGN_ID]
            }
            if (_.children instanceof Array && _.children.length) {
              formatAppLogicLine(_.children)
            }
          })
        this.appLogicData = formatAppLogicTree(treeData.data, 'p')
        this.graphData = this.appLogicData
        this.operateNodeData = this.appLogicData[0]
        this.$refs.transferData.graphCiTypeId = this.graphCiTypeId
        this.$refs.transferData.managementData(this.operateNodeData)
        formatAppLogicLine(treeData.data)
        this.initGraph()
      }
    },
    initGraph () {
      this.spinShow = true
      let graph
      const initEvent = id => {
        graph = d3.select(id)
        graph
          .on('dblclick.zoom', null)
          .on('wheel.zoom', null)
          .on('mousewheel.zoom', null)
        this.graph.graphviz = graph
          .graphviz()
          .width(window.innerWidth - 60)
          .height(window.innerHeight - 293)
          .fit(true)
          .zoom(true)
      }
      // 应用逻辑图
      initEvent('#appLogicGraph')
      this.renderGraph('#appLogicGraph', this.appLogicData, this.appInvokeLines)
      // 服务调用图
      this.spinShow = false
    },
    renderGraph (id, data, linesData) {
      let nodesString = this.genDOT(id, data, linesData)
      this.graph.graphviz
        .transition()
        .renderDot(nodesString)
        .on('end', () => {
          addEvent('.node', 'click', this.handleNodeClick)
          addEvent('.cluster', 'click', this.handleNodeClick)
        })
      // 最外图层选中处理
      d3.select('#clust1').on('click', () => {
        this.$refs.transferData.managementData(this.graphData[0])
        if (this.activeNodeInfo.id) {
          d3.select('#appLogicGraph')
            .select(`#` + this.activeNodeInfo.id)
            .select(this.activeNodeInfo.type)
            .attr('fill', this.activeNodeInfo.color)
          this.activeNodeInfo = {}
        }
      })

      let svg = d3.select(id).select('svg')
      let width = svg.attr('width')
      let height = svg.attr('height')
      svg.attr('viewBox', '0 0 ' + width + ' ' + height)
    },
    handleNodeClick (e) {
      if (e.currentTarget.id === 'clust1') {
        return
      }
      const guid = e.currentTarget.id
      this.operateNodeData = this.graphDataWithGuid[guid]
      this.cacheIdPath = [guid]
      this.$refs.transferData.managementData(this.operateNodeData)
    },
    genDOT (id, sysData, linesData) {
      this.graphNodes[id] = {}
      this.invokeLines = []
      const width = 16
      const height = 12
      let dots = [
        'digraph G{',
        'rankdir=LR;nodesep=0.5;',
        'Node[fontname=Arial,fontsize=12,shape=box,style=filled];',
        'Edge[fontname=Arial,minlen="2",fontsize=6,labeldistance=1.5];',
        `size="${width},${height}";`,
        `subgraph cluster_${sysData[0].guid} {`,
        `style="filled";color="${colors[0]}";`,
        `tooltip="${'(' + sysData[0].data.key_name + ')' + sysData[0].data.description}";`,
        `label="${sysData[0].data.name}";`,
        this.genChildrenDot(id, sysData[0].children || [], 1),
        '}',
        this.genLines(id, linesData),
        '}'
      ]
      return dots.join('')
    },
    genChildrenDot (id, data, level) {
      const width = 12
      const height = 9
      let dots = []
      if (data.length) {
        data.forEach(_ => {
          let color = ''
          if (this.isTableViewOnly && this.systemDesignFixedDate) {
            if (this.systemDesignFixedDate <= _.fixedDate) {
              color = stateColor[_.data.state.code]
            }
          } else if (!_.fixedDate) {
            color = stateColor[_.data.state.code]
          }
          if (_.children instanceof Array && _.children.length) {
            dots = dots.concat([
              `subgraph cluster_${_.guid}{`,
              `id="g_${_.guid}";`,
              `color="${color || colors[level]}";`,
              `style="filled";fillcolor="${colors[level]}";`,
              `label="${_.data.code || _.data.key_name}";`,
              `tooltip="${'(' + _.data.key_name + ')' + _.data.description}"`,
              this.genChildrenDot(id, _.children, level + 1),
              '}'
            ])
          } else {
            this.graphNodes[id][_.guid] = _
            dots = dots.concat([
              `"n_${_.guid}"`,
              `[id="n_${_.guid}";`,
              `label="${_.data.code || _.data.key_name}";`,
              `color="${color || colors[level]}";`,
              `fillcolor="${colors[level]}";`,
              `tooltip="${'(' + _.data.key_name + ')' + _.data.description}"];`
            ])
          }
        })
      } else {
        dots.push(`g[label=" ",color="${colors[0]}";width="${width}";height="${height - 3}"]`)
      }
      return dots.join('')
    },
    genLines (id, linesData) {
      let otherNodes = []
      const result = Object.keys(linesData).map(guid => {
        const node = linesData[guid]
        let color = '#000'
        if (this.isTableViewOnly && this.systemDesignFixedDate) {
          if (this.systemDesignFixedDate <= node.fixedDate) {
            color = stateColor[node.state]
          }
        } else if (!node.fixedDate) {
          color = stateColor[node.state]
        }
        if (!this.graphNodes[id][node.from.guid]) {
          otherNodes.push(node.from)
        }
        if (!this.graphNodes[id][node.to.guid]) {
          otherNodes.push(node.to)
        }
        return `n_${node.from.guid} -> n_${node.to.guid}[id="gl_${node.id}",color="${color}",
        tooltip="${node.from.key_name + '-->' + node.to.key_name}",tailtooltip="${node.from.key_name +
          '-->' +
          node.to.key_name}",taillabel="${node.label || ''}"];`
      })
      let nodes = []
      otherNodes.forEach(_ => {
        nodes = nodes.concat([
          `"n_${_.guid}"`,
          `[id="n_${_.guid}";`,
          `label="${_.key_name}";`,
          'shape=box;',
          `style="filled";`,
          `title="${_.tooltip}"`,
          `tooltip="${_.tooltip}"];`
        ])
      })
      return result.join('') + nodes.join('')
    },
    async getConfigParams () {
      const { statusCode, data } = await getEnumCodesByCategoryId(0, VIEW_CONFIG_PARAMS)
      if (statusCode === 'OK') {
        this.initParams = {}
        data.forEach(_ => {
          this.initParams[_.code] = Number(_.value) ? Number(_.value) : _.value
        })
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
.container-height {
  height: calc(100vh - 290px);
}
.operation-area {
  position: absolute;
  width: 450px;
  top: 10px;
  right: 0px;
}
.operation-container {
  height: calc(100vh - 350px);
}
</style>
