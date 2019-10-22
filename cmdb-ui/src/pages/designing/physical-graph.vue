<template>
  <div class="physical-graph">
    <div class="graph-list">
      <div
        v-for="item in graphData"
        class="graph-container"
        :id="`graph_${item.guid}`"
      >
        <span>{{ item.data.name }}</span>
      </div>
    </div>
    <div class="graph-container-big" id="graphBig"></div>
  </div>
</template>

<script>
import * as d3 from "d3-selection";
import * as d3Graphviz from "d3-graphviz";

const width = 16;
const height = 12;
const fontSize = 16;
const colors = [
  "#bbdefb",
  "#90caf9",
  "#64b5f6",
  "#42a5f5",
  "#2196f3",
  "#1e88e5",
  "#1976d2"
];

export default {
  data() {
    return {
      graph: {},
      graphBig: {},
      idcs: {},
      currentGraph: ""
    };
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
    }
  },
  methods: {
    initEvent() {
      this.graphData.forEach(_ => {
        let graph = d3.select(`#graph_${_.guid}`);
        graph.on("dblclick.zoom", null);
        let g = graph.graphviz().zoom(true);
        this.graph[_.guid] = g;
        this.renderGraph(_);
      });
    },
    renderGraph(idcData) {
      this.idcs[idcData.guid] = [];
      const children = idcData.children || [];
      children.forEach(_ => {
        this.idcs[idcData.guid].push(_.guid);
      });
      const DOTs = this.genDOT(idcData);
      this.graph[idcData.guid].renderDot(DOTs);
      const divWidth = 160;
      const divHeight = 95;
      let svg = d3.select(`#graph_${idcData.guid}`).select("svg");
      svg
        .attr("width", divWidth)
        .attr("height", divHeight)
        .attr("viewBox", `0 0 ${divWidth} ${divHeight}`);
      svg.append("g").lower();

      children.forEach(zone => {
        d3.select(`#g_${zone.guid}`)
          .select("polygon")
          .attr("fill", colors[1]);
        if (zone.children instanceof Array) {
          let points = d3
            .select(`#g_${zone.guid}`)
            .select("polygon")
            .attr("points")
            .split(" ");
          let p = {
            x: parseInt(points[1].split(",")[0]),
            y: parseInt(points[1].split(",")[1])
          };
          const pw = parseInt(
            points[0].split(",")[0] - points[1].split(",")[0]
          );
          const ph = parseInt(
            points[2].split(",")[1] - points[1].split(",")[1]
          );
          this.setChildren(zone, p, pw, ph, fontSize, 1, idcData.guid);
        }
      });

      const _this = this;
      this.translateAndScale(_this, idcData.guid, divWidth, divHeight);
    },
    genDOT(data) {
      const label = data.data.code || data.data.key_name;
      const tooltip = data.data.description || data.data.code;
      let dots = [
        "digraph G{",
        "rankdir=TB nodesep=0.5;",
        `node[shape=box;fontsize=${fontSize};labelloc=t;penwidth=2];`,
        `subgraph cluster_${data.guid} {`,
        `style="filled";color="${colors[0]}";`,
        `tooltip="${tooltip}";`,
        `label="${label}";`,
        this.genArea(data),
        this.genLink(data.guid),
        "}}"
      ];
      return dots.join("");
    },
    genArea(data) {
      let result = "";
      let layers = new Map();
      if (data.children instanceof Array) {
        data.children.forEach(_ => {
          const layerName = _.data.zone_layer.value;
          if (!layers.has(layerName)) {
            layers.set(layerName, []);
          }
          layers.get(layerName).push(_);
        });
        const n = layers.size;
        const lh = (height - 3) / n;
        layers.forEach(layer => {
          const lw = (width - 0.5 * layer.length) / layer.length;
          let dots = ["{rank=same;", "}"];
          layer.forEach(_ => {
            dots.splice(
              -1,
              0,
              `g_${_.guid}`,
              `[id="g_${_.guid}";`,
              `label="${_.data.code || _.data.key_name}";`,
              `tooltip="${_.data.description || _.data.code}";`,
              `width="${lw}";`,
              `height="${lh}"]`
            );
          });
          result += dots.join("");
        });
      } else {
        const dots = [
          "{rank=same;",
          `g_${data.guid}`,
          `[id="g_${data.guid}";`,
          `label=" ";`,
          `color="${colors[0]}"`,
          `tooltip="${data.data.description || data.data.code}";`,
          `width="${width - 0.5}";`,
          `height="${height - 3}"]`,
          "}"
        ];
        result = dots.join("");
      }
      return result;
    },
    genLink(guid) {
      let result = "";
      const linkData =
        (this.links.find(_ => _.idcGuid === guid) &&
          this.links.find(_ => _.idcGuid === guid).linkList) ||
        [];
      linkData.forEach(_ => {
        let zoneName = "";
        if (_.data.zone_design1) {
          if (
            this.idcs[guid].indexOf(_.data.zone_design1.guid) >= 0 &&
            this.idcs[guid].indexOf(_.data.zone_design2.guid) >= 0
          ) {
            result += `g_${_.data.zone_design1.guid}->g_${_.data.zone_design2.guid}[arrowhead=none];`;
          }
        } else {
          if (
            this.idcs[guid].indexOf(_.data.zone1.guid) >= 0 &&
            this.idcs[guid].indexOf(_.data.zone2.guid) >= 0
          ) {
            result += `g_${_.data.zone1.guid}->g_${_.data.zone2.guid}[arrowhead=none];`;
          }
        }
      });
      return result;
    },
    setChildren(node, p1, pw, ph, tfsize, level, rootGuid) {
      let graph;
      if (rootGuid) {
        graph = d3.select(`#graph_${rootGuid}`).select(`#g_${node.guid}`);
      } else {
        graph = d3.select("#graphBig").select(`#g_${node.guid}`);
      }
      let n = node.children.length;
      let w, h, mgap, fontsize, strokewidth;
      let rx, ry, tx, ty, g;
      let color = colors[level];
      if (pw > ph * 1.2) {
        if (pw / n > ph - tfsize) {
          mgap = (ph - tfsize) * 0.04;
          fontsize =
            tfsize * 0.8 > (ph - tfsize) * 0.1
              ? (ph - tfsize) * 0.1
              : tfsize * 0.8;
          strokewidth = (ph - tfsize) * 0.005;
        } else {
          mgap = (pw / n) * 0.04;
          fontsize =
            tfsize * 0.8 > (pw / n) * 0.1 ? (pw / n) * 0.1 : tfsize * 0.8;
          strokewidth = (pw / n) * 0.005;
        }
        w = (pw - mgap) / n - mgap;
        h = ph - tfsize - 2 * mgap;
        for (var i = 0; i < n; i++) {
          rx = p1.x + (w + mgap) * i + mgap;
          ry = p1.y + tfsize + mgap;
          tx = p1.x + (w + mgap) * i + w * 0.5 + mgap;
          if (Array.isArray(node.children[i].children)) {
            ty = p1.y + tfsize + mgap + fontsize;
          } else {
            ty = p1.y + tfsize + mgap + h * 0.5;
          }

          g = graph
            .append("g")
            .attr("class", "node")
            .attr("id", `g_${node.children[i].guid}`);
          g.append("title").text(
            node.children[i].data.description || node.children[i].data.code
          );
          g.append("rect")
            .attr("x", rx)
            .attr("y", ry)
            .attr("width", w)
            .attr("height", h)
            .attr("stroke", "black")
            .attr("fill", color)
            .attr("stroke-width", strokewidth);
          g.append("text")
            .attr("x", tx)
            .attr("y", ty)
            .text(
              node.children[i].data.code
                ? node.children[i].data.code
                : node.children[i].data.key_name
            )
            .attr("style", "text-anchor:middle")
            .attr("font-size", fontsize);
          if (Array.isArray(node.children[i].children)) {
            this.setChildren(
              node.children[i],
              { x: rx, y: ry },
              w,
              h,
              fontsize,
              level + 1,
              rootGuid
            );
          }
        }
      } else {
        if ((ph - tfsize) / n > pw) {
          mgap = pw * 0.04;
          fontsize = tfsize * 0.8 > pw * 0.1 ? pw * 0.1 : tfsize * 0.8;
          strokewidth = pw * 0.005;
        } else {
          mgap = ((ph - tfsize) / n) * 0.04;
          fontsize =
            tfsize * 0.8 > ((ph - tfsize) / n) * 0.1
              ? ((ph - tfsize) / n) * 0.1
              : tfsize * 0.8;
          strokewidth = ((ph - tfsize) / n) * 0.005;
        }

        w = pw - 2 * mgap;
        h = (ph - tfsize - mgap) / n - mgap;
        for (var i = 0; i < n; i++) {
          rx = p1.x + mgap;
          ry = p1.y + tfsize + (h + mgap) * i + mgap;
          tx = p1.x + w * 0.5 + mgap;
          if (Array.isArray(node.children[i].children)) {
            ty = p1.y + tfsize + (h + mgap) * i + fontsize + mgap;
          } else {
            ty = p1.y + tfsize + (h + mgap) * i + h * 0.5 + mgap;
          }

          g = graph
            .append("g")
            .attr("class", "node")
            .attr("id", `g_${node.children[i].guid}`);
          g.append("title").text(
            node.children[i].data.description || node.children[i].data.code
          );
          g.append("rect")
            .attr("x", rx)
            .attr("y", ry)
            .attr("width", w)
            .attr("height", h)
            .attr("stroke", "black")
            .attr("fill", color)
            .attr("stroke-width", strokewidth);
          g.append("text")
            .attr("x", tx)
            .attr("y", ty)
            .text(
              node.children[i].data.code
                ? node.children[i].data.code
                : node.children[i].data.key_name
            )
            .attr("style", "text-anchor:middle")
            .attr("font-size", fontsize);
          if (Array.isArray(node.children[i].children)) {
            this.setChildren(
              node.children[i],
              { x: rx, y: ry },
              w,
              h,
              fontsize,
              level + 1,
              rootGuid
            );
          }
        }
      }
    },
    translateAndScale(_this, guid, divWidth, divHeight) {
      let currentGraphSvg = d3.select("#graph_" + guid).select("svg");
      let graph0 = currentGraphSvg.select("#graph0");
      let points = graph0
        .select("polygon")
        .attr("points")
        .split(" ");
      let scale;
      let ph = parseInt(points[0].split(",")[1] - points[1].split(",")[1]);
      let pw = parseInt(points[2].split(",")[0] - points[1].split(",")[0]);
      if (divWidth / pw > divHeight / ph) {
        scale = divHeight / ph - 0.0005;
      } else {
        scale = divWidth / pw - 0.0005;
      }
      scale = scale.toFixed(3);
      let translateX = (divWidth - pw * scale) / 2;
      let translateY = divHeight;
      graph0
        .attr(
          "transform",
          "translate(" +
            translateX +
            ", " +
            translateY +
            ") scale(" +
            scale +
            ")"
        )
        .on("click", function() {
          let _graph = d3.select(this);
          let currentGraphId = _this.currentGraph;

          if (currentGraphId !== "") {
            let isExit = d3
              .select("#graphBig")
              .select("svg")
              .select("#graph0");
            isExit.remove();
            let currentGraph = d3
              .select("#graph_" + currentGraphId)
              .select("#graph0");
            currentGraph.select("polygon").attr("fill", "#ffffff");
            _this.setCurrentGraph("");
          }
          if (currentGraphId === "" || currentGraphId !== guid) {
            let graphBig;
            graphBig = d3.select("#graphBig");
            graphBig
              .on("dblclick.zoom", null)
              .on("wheel.zoom", null)
              .on("mousewheel.zoom", null);

            _this.graphBig = graphBig
              .graphviz()
              .scale(1)
              .width(window.innerWidth * 0.96)
              .height(window.innerHeight * 1.2)
              .zoom(true);

            let found;
            _this.graphData.forEach(idc => {
              if (idc.guid === guid) {
                found = idc;
              }
            });

            let nodesString = _this.genDOT(found);
            _this.graphBig.renderDot(nodesString);
            let gap = 12;
            let fsize = 16;
            let children = found.children || [];
            let svg = d3.select("#graphBig").select("svg");
            let height = svg.attr("height");
            let width = svg.attr("width");
            svg.attr("viewBox", "0 0 " + width + " " + height);

            children.forEach(zone => {
              d3.select("#graphBig")
                .select(`#g_${zone.guid}`)
                .select("polygon")
                .attr("fill", colors[0]);
              if (Array.isArray(zone.children)) {
                let points = d3
                  .select("#g_" + zone.guid)
                  .select("polygon")
                  .attr("points")
                  .split(" ");
                let p = {
                  x: parseInt(points[1].split(",")[0]),
                  y: parseInt(points[1].split(",")[1])
                };
                let pw = parseInt(
                  points[0].split(",")[0] - points[1].split(",")[0]
                );
                let ph = parseInt(
                  points[2].split(",")[1] - points[1].split(",")[1]
                );
                _this.setChildren(zone, p, pw, ph, fsize, 1);
              }
            });

            _graph.select("polygon").attr("fill", "cadetblue");
            _this.setCurrentGraph(name);
          }
        });
    },
    setCurrentGraph(name) {
      this.currentGraph = name;
    }
  },
  mounted() {
    this.$nextTick(() => {
      this.initEvent();
      this.callback();
    });
  }
};
</script>

<style lang="scss" scoped>
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
.physical-graph {
  position: relative;
  min-height: 300px;
}
</style>
