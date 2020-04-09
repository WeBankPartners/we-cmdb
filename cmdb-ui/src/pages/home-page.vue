<template>
  <card style="height: calc(100vh - 60px);">
    <div id="graph" class="home-page"></div>
  </card>
</template>

<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line
import * as d3Graphviz from 'd3-graphviz'
import { getAllLayers, getAllCITypesByLayerWithAttr, getEnumCodesByCategoryId } from '@/api/server'
import { setHeaders, baseURL } from '@/api/base.js'
import { addEvent } from './util/event.js'
import { ZOOM_LEVEL_CAT } from '@/const/init-params.js'
export default {
  data () {
    return {
      currentZoomLevelId: [],
      baseURL,
      layers: [],
      graph: {},
      g: null,
      selectedStatus: ['notCreated', 'created']
    }
  },
  methods: {
    async initGraph (status = []) {
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
          .height(window.innerHeight - 92)
          .attributer(function (d) {
            if (d.attributes.class === 'edge') {
              let keys = d.key.split('->')
              let from = keys[0].trim()
              let to = keys[1].trim()
              d.attributes.from = from
              d.attributes.to = to
            }

            if (d.tag === 'text') {
              let key = d.children[0].text
              d3.select(this).attr('text-key', key)
            }
          })
      }

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
        let [ciResponse, _zoomLevelIdList] = await Promise.all([
          getAllCITypesByLayerWithAttr(this.selectedStatus),
          getEnumCodesByCategoryId(1, ZOOM_LEVEL_CAT)
        ])
        if (ciResponse.statusCode === 'OK' && _zoomLevelIdList.statusCode === 'OK') {
          if (_zoomLevelIdList.data.length) {
            this.currentZoomLevelId = [_zoomLevelIdList.data[0].codeId]
          }
          this.source = []
          this.source = ciResponse.data
          this.source.forEach(_ => {
            _.ciTypes &&
              _.ciTypes.forEach(async i => {
                let imgFileSource = `${baseURL}/files/${i.imageFileId}`
                this.$set(i, 'form', {
                  ...i,
                  imgSource: imgFileSource,
                  imgUploadURL: `${baseURL}/ci-types/${i.ciTypeId}/icon`
                })
                i.attributes &&
                  i.attributes.forEach(j => {
                    this.$set(j, 'form', {
                      ...j,
                      isRefreshable: j.isRefreshable ? 'yes' : 'no',
                      isDisplayed: j.isDisplayed ? 'yes' : 'no',
                      isAccessControlled: j.isAccessControlled ? 'yes' : 'no',
                      isNullable: j.isNullable ? 'yes' : 'no',
                      isAuto: j.isAuto ? 'yes' : 'no',
                      isEditable: j.isEditable ? 'yes' : 'no',
                      searchSeqNo: j.searchSeqNo || 0
                    })
                  })

                this.renderRightPanels()
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
    renderGraph (data) {
      let nodesString = this.genDOT(data)
      this.loadImage(nodesString)
      this.graph.graphviz.renderDot(nodesString).transition()
      let svg = d3.select('#graph').select('svg')
      svg.append('g').lower()
      addEvent('svg', 'mouseover', e => {
        this.shadeAll()
        e.preventDefault()
        e.stopPropagation()
      })
      this.shadeAll()
      addEvent('.node', 'mouseover', async e => {
        e.preventDefault()
        e.stopPropagation()
        d3.selectAll('g').attr('cursor', 'pointer')

        this.g = e.currentTarget
        this.nodeName = this.g.children[0].innerHTML.trim()
        this.shadeAll()
        this.colorNode(this.nodeName)
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
    renderRightPanels () {
      if (!this.nodeName) return
      if (this.isLayerSelected) {
        this.currentSelectedLayer = this.layers.find(_ => _.name === this.nodeName)
        this.updatedLayerNameValue = {
          codeId: this.currentSelectedLayer.layerId,
          code: this.currentSelectedLayer.name
        }
        this.handleLayerSelect(this.nodeName)
      } else {
        this.source.forEach(_ => {
          _.ciTypes &&
            _.ciTypes.forEach(i => {
              if (i.ciTypeId && i.ciTypeId === +this.g.id) {
                this.currentSelectedCI = i
                this.currentSelectedCIChildren =
                  (i.attributes &&
                    i.attributes.sort((a, b) => {
                      return a.displaySeqNo - b.displaySeqNo
                    })) ||
                  []
              }
            })
        })
        this.updatedCINameValue = {
          ciTypeId: this.g.id,
          name: this.currentSelectedCI.name
        }
        this.getAllEnumTypes()
        this.getAllEnumCategories()
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
        'Node [fontname=Arial, shape="ellipse", fixedsize="true", width="1.1", height="1.1", color="transparent" ,fontsize=12];',
        'Edge [fontname=Arial, minlen="1", color="#7f8fa6", fontsize=10];',
        'ranksep = 1.1; nodesep=.7; size = "11,8"; rankdir=TB'
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
        nodes.length > 0 &&
          nodes.forEach((node, nodeIndex) => {
            if (node.layerId === _.layerId && this.currentZoomLevelId.indexOf(node.zoomLevelId) >= 0) {
              let fontcolor = node.status === 'notCreated' ? '#10a34e' : 'black'
              tempClusterObjForGraph[index].push(
                `"ci_${node.ciTypeId}"[id="${node.ciTypeId}",label="${node.name}",tooltip="${node.name}",class="ci",fontcolor="${fontcolor}", image="${node.form.imgSource}.png", labelloc="b"]`
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
              const target = nodes.find(_ => _.ciTypeId === attr.referenceId)
              if (
                target &&
                node.zoomLevelId === target.zoomLevelId &&
                this.currentZoomLevelId.indexOf(node.zoomLevelId) >= 0
              ) {
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
    }
  },
  mounted () {
    this.initGraph()
  }
}
</script>

<style lang="scss" scoped>
.home-page {
  align-items: center;
  background-color: #fff;
  display: flex;
  font-size: 75px;
  font-weight: 600;
  height: 100%;
  justify-content: center;
}
</style>
