<template>
  <div class="physical-graph" id="physicalGraph"></div>
</template>

<script>
import * as d3 from 'd3-selection'
// eslint-disable-next-line no-unused-vars
import * as d3Graphviz from 'd3-graphviz'
import { colors, defaultFontSize as fontSize } from '../../const/graph-configuration'
import { NETWORK_SEGMENT_DESIGN, LAYER } from '@/const/init-params.js'

export default {
  data () {
    return {
      graph: null,
      nodesGuid: {}
    }
  },
  props: {
    graphData: {
      default: []
    },
    links: {
      default: []
    },
    callback: {
      type: Function
    },
    initParams: {
      type: Object
    }
  },
  methods: {
    initEvent () {
      let graph = d3.select('#physicalGraph')
      graph
        .on('dblclick.zoom', null)
        .on('wheel.zoom', null)
        .on('mousewheel.zoom', null)
      this.graph = graph
        .graphviz()
        .width(window.innerWidth - 20)
        .height(window.innerHeight - 230)
        .zoom(true)
        .fit(true)
      this.renderGraph(this.graphData)
    },
    renderGraph (idcData) {
      const children = idcData[0].children || []
      const DOTs = this.genDOT(idcData[0])
      this.graph.transition().renderDot(DOTs)
      const divWidth = window.innerWidth - 20
      const divHeight = window.innerHeight - 230
      let svg = d3.select('#physicalGraph').select('svg')
      svg
        .attr('width', divWidth)
        .attr('height', divHeight)
        .attr('viewBox', `0 0 ${divWidth} ${divHeight}`)

      children.forEach(zone => {
        d3.select(`#g_${zone.guid}`)
          .select('polygon')
          .attr('fill', colors[1])
        if (zone.children instanceof Array) {
          let points = d3
            .select(`#g_${zone.guid}`)
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
    },
    genDOT (data) {
      const label = data.data.name || data.data.key_name
      const tooltip = data.data.description || data.data.code
      let dots = [
        'digraph G{',
        'rankdir=TB nodesep=0.5;',
        `node[shape=box;fontsize=${fontSize};labelloc=t;penwidth=2];`,
        'Edge[fontsize=10,arrowhead="none"];',
        `subgraph cluster_${data.guid} {`,
        `style="filled";color="${colors[0]}";`,
        `tooltip="${tooltip}";`,
        `label="${label}";`,
        this.genChildren(data),
        this.genLink(),
        '}}'
      ]
      return dots.join('')
    },
    genChildren (idcData) {
      this.nodesGuid = {}
      const width = 16
      const height = 12
      let dots = []
      const children = idcData.children || []
      let layers = new Map()
      children.forEach(zone => {
        if (layers.has(zone.data[this.initParams[LAYER]])) {
          layers.get(zone.data[this.initParams[LAYER]]).push(zone)
        } else {
          layers.set(zone.data[this.initParams[LAYER]], [zone])
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
            this.nodesGuid[zone.guid] = zone
            dots.push(
              `g_${zone.guid}[id="g_${zone.guid}", label="${label}", width=${ll},height=${lg},style="filled",color="${colors[1]}"];`
            )
          })
          dots.push('}')
        })
      } else {
        this.nodesGuid[idcData.data.guid] = idcData.data
        dots.push(
          `g_${idcData.data.guid}[label=" ";style="filled";color="${colors[1]}";width="${width -
            0.5}";height="${height - 3}"]`
        )
      }
      return dots.join('')
    },
    genLink () {
      let dots = []
      let newworkToNode = {}
      const { nodesGuid, initParams } = this
      if (!initParams[NETWORK_SEGMENT_DESIGN]) return
      Object.keys(nodesGuid).forEach(guid => {
        if (nodesGuid[guid].data[this.initParams[NETWORK_SEGMENT_DESIGN]]) {
          newworkToNode[nodesGuid[guid].data[this.initParams[NETWORK_SEGMENT_DESIGN]].guid] = guid
        }
      })
      this.links.forEach(_ => {
        if (newworkToNode[_.from] && newworkToNode[_.to]) {
          dots.push(
            `g_${newworkToNode[_.from]} -> g_${newworkToNode[_.to]}[id=gl_${_.guid},tooltip="${_.label ||
              ''}",taillabel="${_.label || ''}"];`
          )
        }
      })
      return dots.join('')
    },
    setChildren (node, p1, pw, ph, tfsize, level) {
      let graph = d3.select('#physicalGraph').select(`#g_${node.guid}`)
      let n = node.children.length
      let w, h, mgap, fontsize, strokewidth
      let rx, ry, tx, ty, g
      let color = colors[level]
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
            .attr('id', `g_${node.children[i].guid}`)
          g.append('title').text(node.children[i].data.description || node.children[i].data.code)
          g.append('rect')
            .attr('x', rx)
            .attr('y', ry)
            .attr('width', w)
            .attr('height', h)
            .attr('stroke', 'black')
            .attr('fill', node.children[i].color || color)
            .attr('stroke-width', strokewidth)
          g.append('text')
            .attr('x', tx)
            .attr('y', ty)
            .text(node.children[i].data.code ? node.children[i].data.code : node.children[i].data.key_name)
            .attr('style', 'text-anchor:middle')
            .attr('font-size', fontsize)
          if (Array.isArray(node.children[i].children)) {
            this.setChildren(node.children[i], { x: rx, y: ry }, w, h, fontsize, level + 1)
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
        // eslint-disable-next-line no-redeclare
        for (var i = 0; i < n; i++) {
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
            .attr('id', `g_${node.children[i].guid}`)
          g.append('title').text(node.children[i].data.description || node.children[i].data.code)
          g.append('rect')
            .attr('x', rx)
            .attr('y', ry)
            .attr('width', w)
            .attr('height', h)
            .attr('stroke', 'black')
            .attr('fill', node.children[i].color || color)
            .attr('stroke-width', strokewidth)
          g.append('text')
            .attr('x', tx)
            .attr('y', ty)
            .text(node.children[i].data.code ? node.children[i].data.code : node.children[i].data.key_name)
            .attr('style', 'text-anchor:middle')
            .attr('font-size', fontsize)
          if (Array.isArray(node.children[i].children)) {
            this.setChildren(node.children[i], { x: rx, y: ry }, w, h, fontsize, level + 1)
          }
        }
      }
    },
    setCurrentGraph (name) {
      this.currentGraph = name
    }
  },
  mounted () {
    this.initEvent()
    this.callback()
  }
}
</script>

<style lang="scss" scoped>
.physical-graph {
  position: relative;
  min-height: 300px;
}
</style>
