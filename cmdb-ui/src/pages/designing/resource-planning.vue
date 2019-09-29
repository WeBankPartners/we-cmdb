<template>
  <div>
    <Row class="graph-select-row">
      <div class="graph-select-col">
        <Select multiple v-model="selectedIdcs" placeholder="请选择IDC">
          <Option v-for="item in allIdcs" :value="item.guid" :key="item.guid">{{
            item.name
          }}</Option>
        </Select>
      </div>
      <Button @click="onIdcDataChange" type="primary">查询</Button>
    </Row>
    <Row class="graph-tabs">
      <Spin fix v-if="spinShow">
        <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
        <div>加载中...</div>
      </Spin>
      <Tabs
        v-if="idcData.length"
        type="card"
        :value="currentTab"
        :closable="false"
        @on-click="handleTabClick"
      >
        <TabPane label="资源规划图" name="resource-design">
          <Alert show-icon closable v-if="isDataChanged">
            Data has beed changed, click Reload button to reload graph.
            <Button slot="desc" @click="reloadHandler">Reload</Button>
          </Alert>

          <div class="graph-list">
            <div
              v-for="item in idcData"
              class="graph-container"
              :id="`graph_${item.guid}`"
              :key="item.guid"
            >
              <span>{{ item.data.name }}</span>
            </div>
          </div>
          <div class="graph-container-big" id="graphBig"></div>
        </TabPane>
        <TabPane
          v-for="ci in tabList"
          :key="ci.id"
          :name="ci.id"
          :label="ci.name"
        >
          <WeTable
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
          ></WeTable>
        </TabPane>
      </Tabs>
    </Row>
  </div>
</template>

<script>
import * as d3 from "d3-selection";
import * as d3Graphviz from "d3-graphviz";
import {
  getAllIdcData,
  getIdcImplementTreeByGuid,
  queryCiData,
  getCiTypeAttributes,
  deleteCiDatas,
  createCiDatas,
  updateCiDatas,
  getEnumCodesByCategoryId,
  getRefCiTypeFrom,
  getCiTypes,
  getAllZoneLinkGroupByIdc,
  operateCiState
} from "@/api/server";
import {
  outerActions,
  innerActions,
  pagination,
  components
} from "@/const/actions.js";
import { formatData } from "../util/format.js";
import { getExtraInnerActions } from "../util/state-operations.js";

const colors = [
  "#c8d6f0",
  "#cde4fd",
  "#acc1e8",
  "#516282",
  "#243047",
  "#0f1624"
];

export default {
  data() {
    return {
      allIdcs: [],
      selectedIdcs: [],
      tabList: [],
      payload: {
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true,
        sorting: {}
      },
      graph: new Map(),
      layerId: 4,
      graphBig: "",
      idcData: [],
      zoneLinkData: new Map(),
      currentTab: "resource-design",
      clickedTab: [],
      currentGraph: "",
      spinShow: false,
      isDataChanged: false
    };
  },
  computed: {
    tableRef() {
      return "table" + this.currentTab;
    },
    needCheckout() {
      return this.$route.name === "ciDataEnquiry" ? false : true;
    }
  },
  methods: {
    async getAllIdcData() {
      const { data, message, status } = await getAllIdcData();
      if (status === "OK") {
        this.allIdcs = data.map(_ => _.data);
      }
    },
    async reloadHandler() {
      this.onIdcDataChange();
      this.isDataChanged = false;
    },

    async onIdcDataChange() {
      if (this.selectedIdcs.length) {
        this.spinShow = true;
        const { data, message, status } = await getIdcImplementTreeByGuid(
          this.selectedIdcs
        );
        if (status === "OK") {
          this.idcData = data;
          this.zoneLinkData = new Map();
          this.getZoneLink();
        }
      } else {
        this.idcData = [];
      }
    },
    initGraph(filters = {}) {
      this.idcData.forEach(item => {
        let graph = d3.select("#graph_" + item.guid);
        graph.on("dblclick.zoom", null);
        let graphZoom = graph.graphviz().zoom(false);
        if (this.graph.has(item.guid)) {
          this.graph[item.guid] = graphZoom;
        } else {
          this.graph.set(item.guid, graphZoom);
        }
        this.renderGraph(item);
        this.spinShow = false;
      });
    },
    genDOT(idcData, linkData) {
      let children = idcData.children || [];
      let links = linkData || [];
      let fsize = 16;
      let width = 16;
      let height = 12;
      let dots = [
        "digraph G {",
        "rankdir=TB nodesep=0.5;",
        'node [shape="box", fontsize=' + fsize + ', labelloc="t", penwidth=2];',
        'size = "' + width + "," + height + '";'
      ];
      let layers = new Map();
      children.forEach(zone => {
        if (layers.has(zone.data.zone_layer.value)) {
          layers.get(zone.data.zone_layer.value).push(zone);
        } else {
          let layer = [];
          layer.push(zone);
          layers.set(zone.data.zone_layer.value, layer);
        }
      });
      layers.forEach(layer => {
        dots.push('{rank = "same";');
        let n = layers.size;
        let lg = (height - 3) / n;
        let ll = (width - 0.5 * layer.length) / layer.length;
        layer.forEach(zone => {
          let label;
          if (
            zone.data.code &&
            zone.data.code !== null &&
            zone.data.code !== ""
          ) {
            label = zone.data.code;
          } else {
            label = zone.data.key_name;
          }
          dots.push(
            `g_${zone.guid}` +
              '[id="g_' +
              zone.guid +
              '", label="' +
              label +
              '", width=' +
              ll +
              ",height=" +
              lg +
              "];"
          );
        });
        dots.push("}");
      });
      links.forEach(link => {
        dots.push(link.azone + "->" + link.bzone + '[arrowhead="none"];');
      });
      dots.push("}");
      return dots.join("");
    },
    renderGraph(idcData) {
      let nodesString = this.genDOT(
        idcData,
        this.zoneLinkData.get(idcData.guid)
      );
      this.graph.get(idcData.guid).renderDot(nodesString);
      let gap = 12;
      let fsize = 16;
      let divWidth = 160,
        divHeight = 95;
      let children = idcData.children || [];
      let svg = d3.select("#graph_" + idcData.guid).select("svg");
      svg.attr("width", divWidth).attr("height", divHeight);
      svg.attr("viewBox", "0 0 " + divWidth + " " + divHeight);
      let g = svg.append("g").lower();

      children.forEach(zone => {
        d3.select(`#g_${zone.guid}`)
          .select("polygon")
          .attr("fill", colors[0]);
        if (Array.isArray(zone.children)) {
          let points = d3
            .select(`#g_${zone.guid}`)
            .select("polygon")
            .attr("points")
            .split(" ");
          let p = {
            x: parseInt(points[1].split(",")[0]),
            y: parseInt(points[1].split(",")[1])
          };
          let pw = parseInt(points[0].split(",")[0] - points[1].split(",")[0]);
          let ph = parseInt(points[2].split(",")[1] - points[1].split(",")[1]);
          this.setChildren(zone, p, pw, ph, fsize, 1, idcData.guid);
        }
      });

      let _this = this;
      this.translateAndScale(_this, idcData.guid, divWidth, divHeight);
    },
    translateAndScale(_this, name, divWidth, divHeight) {
      let currentGraphSvg = d3.select("#graph_" + name).select("svg");
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
          if (currentGraphId === "" || currentGraphId !== name) {
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
            _this.idcData.forEach(idc => {
              if (idc.data.guid === name) {
                found = idc;
              }
            });

            let nodesString = _this.genDOT(found, _this.zoneLinkData.get(name));
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
                  .select(`#g_${zone.guid}`)
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
                _this.setChildren(zone, p, pw, ph, fsize, 1, "graphBig");
              }
            });

            _graph.select("polygon").attr("fill", "cadetblue");
            _this.setCurrentGraph(name);
          }
        });
    },
    setChildren(node, p1, pw, ph, tfsize, deep, idcName) {
      let graph;
      if (idcName === "graphBig") {
        graph = d3.select("#graphBig").select("#g_" + node.guid);
      } else {
        graph = d3.select("#graph_" + idcName).select("#g_" + node.guid);
      }
      let n = node.children.length;
      let w, h, mgap, fontsize, strokewidth;
      let rx, ry, tx, ty, g;
      let color = colors[deep];
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
              deep + 1,
              idcName
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
              deep + 1,
              idcName
            );
          }
        }
      }
    },
    handleTabClick(name) {
      this.payload.filters = [];
      this.currentTab = name;
      if (this.currentTab != "resource-design") {
        const found = this.clickedTab.find(_ => _ === name);
        if (!found) {
          this.getCurrentData();
          this.clickedTab.push(this.currentTab);
        }
      }
    },
    setCurrentGraph(name) {
      this.currentGraph = name;
    },
    onSelectedRowsChange(rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              _.props.disabled = _.actionType === "add";
            });
          }
        });
      } else {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              _.props.disabled = !(
                _.actionType === "add" ||
                _.actionType === "export" ||
                _.actionType === "cancel"
              );
            });
          }
        });
      }
    },
    actionFun(type, data) {
      switch (type) {
        case "export":
          this.exportHandler();
          break;
        case "add":
          this.addHandler();
          break;
        case "edit":
          this.editHandler();
          break;
        case "save":
          this.saveHandler(data);
          break;
        case "delete":
          this.deleteHandler(data);
          break;
        case "cancel":
          this.cancelHandler();
          break;
        case "innerCancel":
          this.$refs[this.tableRef][0].rowCancelHandler(data.weTableRowId);
          break;
        default:
          this.defaultHandler(type, data);
          break;
      }
    },
    async defaultHandler(type, row) {
      const { data, status, message } = await operateCiState(
        this.currentTab,
        row.guid,
        type
      );
      if (status === "OK") {
        this.$Notice.success({
          title: type,
          desc: message
        });
        this.queryCiData();
      }
    },
    sortHandler(data) {
      this.payload.sorting = {
        asc: data.order === "asc",
        field: data.key
      };
      this.queryCiData();
    },

    handleSubmit(data) {
      this.payload.filters = data;
      this.queryCiData();
    },

    addHandler() {
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          let emptyRowData = {};
          ci.tableColumns.forEach(_ => {
            if (_.inputType === "multiSelect" || _.inputType === "multiRef") {
              emptyRowData[_.inputKey] = [];
            } else {
              emptyRowData[_.inputKey] = "";
            }
          });
          emptyRowData["isRowEditable"] = true;
          emptyRowData["isNewAddedRow"] = true;
          emptyRowData["weTableRowId"] = 1;
          emptyRowData["nextOperations"] = [];

          ci.tableData.unshift(emptyRowData);
          this.$nextTick(() => {
            this.$refs[this.tableRef][0].pushNewAddedRowToSelections();
            this.$refs[this.tableRef][0].setCheckoutStatus(true);
          });
          ci.outerActions.forEach(_ => {
            _.props.disabled = _.actionType === "add";
          });
        }
      });
    },
    cancelHandler() {
      this.$refs[this.tableRef][0].setAllRowsUneditable();
      this.$refs[this.tableRef][0].setCheckoutStatus();
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.outerActions.forEach(_ => {
            _.props.disabled = !(
              _.actionType === "add" ||
              _.actionType === "export" ||
              _.actionType === "cancel"
            );
          });
        }
      });
    },
    deleteHandler(deleteData) {
      this.$Modal.confirm({
        title: "确认删除？",
        "z-index": 1000000,
        onOk: async () => {
          const payload = {
            id: this.currentTab,
            deleteData: deleteData.map(_ => _.guid)
          };
          const { status, message, data } = await deleteCiDatas(payload);
          if (status === "OK") {
            this.$Notice.success({
              title: "Delete data Success",
              desc: message
            });
            this.isDataChanged = true;
            this.tabList.forEach(ci => {
              if (ci.id === this.currentTab) {
                ci.outerActions.forEach(_ => {
                  _.props.disabled =
                    _.actionType === "save" ||
                    _.actionType === "edit" ||
                    _.actionType === "delete";
                });
              }
            });
            this.queryCiData();
          }
        },
        onCancel: () => {}
      });
      document.querySelector(".ivu-modal-mask").click();
    },
    editHandler() {
      this.$refs[this.tableRef][0].swapRowEditable(true);
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.outerActions.forEach(_ => {
            if (_.actionType === "save") {
              _.props.disabled = false;
            }
          });
        }
      });
      this.$nextTick(() => {
        this.$refs[this.tableRef][0].setCheckoutStatus(true);
      });
    },
    deleteAttr() {
      let attrs = [];
      const found = this.tabList.find(_ => _.id === this.currentTab);
      found.tableColumns.forEach(i => {
        if (i.isAuto) {
          attrs.push(i.propertyName);
        }
      });
      return attrs;
    },
    async saveHandler(data) {
      let setBtnsStatus = () => {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              _.props.disabled = !(
                _.actionType === "add" || _.actionType === "export"
              );
            });
          }
        });
        this.$refs[this.tableRef][0].setAllRowsUneditable();
        this.$nextTick(() => {
          /* to get iview original data to set _ischecked flag */
          let objData = this.$refs[this.tableRef][0].$refs.table.$refs.tbody
            .objData;
          for (let obj in objData) {
            objData[obj]._isChecked = false;
            objData[obj]._isDisabled = false;
          }
        });
      };

      let d = JSON.parse(JSON.stringify(data));
      let addAry = d.filter(_ => _.isNewAddedRow);
      let editAry = d.filter(_ => !_.isNewAddedRow);
      if (addAry.length > 0) {
        const deleteAttrs = this.deleteAttr();
        addAry.forEach(_ => {
          deleteAttrs.forEach(attr => {
            delete _[attr];
          });
          delete _.isRowEditable;
          delete _.weTableForm;
          delete _.weTableRowId;
          delete _.isNewAddedRow;
          delete _.nextOperations;
        });
        let payload = {
          id: this.currentTab,
          createData: addAry
        };
        const { status, message, data } = await createCiDatas(payload);
        if (status === "OK") {
          this.$Notice.success({
            title: "Add data Success",
            desc: message
          });
          this.isDataChanged = true;
          setBtnsStatus();
          this.queryCiData();
        }
      }
      if (editAry.length > 0) {
        editAry.forEach(_ => {
          delete _.isRowEditable;
          delete _.weTableForm;
          delete _.weTableRowId;
          delete _.isNewAddedRow;
          delete _.nextOperations;
        });
        let payload = {
          id: this.currentTab,
          updateData: editAry
        };
        const { status, message, data } = await updateCiDatas(payload);
        if (status === "OK") {
          this.$Notice.success({
            title: "Update data Success",
            desc: message
          });
          this.isDataChanged = true;
          setBtnsStatus();
          this.queryCiData();
        }
      }
    },
    async exportHandler() {
      const { status, message, data } = await queryCiData({
        id: this.currentTab,
        queryObject: {}
      });
      if (status === "OK") {
        this.$refs[this.tableRef][0].export({
          filename: "Ci Data",
          data: formatData(data.contents.map(_ => _.data))
        });
      }
    },
    pageChange(current) {
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.pagination.currentPage = current;
        }
      });
      this.queryCiData();
    },
    pageSizeChange(size) {
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.pagination.pageSize = size;
        }
      });
      this.queryCiData();
    },
    async queryCiData() {
      this.payload.pageable.pageSize = 10;
      this.payload.pageable.startIndex = 0;
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          this.payload.pageable.pageSize = ci.pagination.pageSize;
          this.payload.pageable.startIndex =
            (ci.pagination.currentPage - 1) * ci.pagination.pageSize;
        }
      });
      const query = {
        id: this.currentTab,
        queryObject: this.payload
      };
      const { status, message, data } = await queryCiData(query);
      if (status === "OK") {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.tableData = data.contents.map(_ => {
              return {
                ..._.data,
                ..._.meta
              };
            });
            ci.pagination.total = data.pageInfo.totalRows;
          }
        });
      }
    },
    async queryCiAttrs(id) {
      const { status, message, data } = await getCiTypeAttributes(id);
      let columns = [];
      const disabledCol = [
        "created_date",
        "updated_date",
        "created_by",
        "updated_by",
        "key_name",
        "guid"
      ];
      if (status === "OK") {
        let columns = [];
        data.forEach(_ => {
          const disEditor = disabledCol.find(i => i === _.propertyName);
          let renderKey = _.propertyName;
          if (_.status !== "decommissioned" && _.status !== "notCreated") {
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
              component: "Input",
              ciType: { id: _.referenceId, name: _.name },
              type: "text",
              ...components[_.inputType]
            });
          }
        });
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.tableColumns = this.getSelectOptions(columns);
          }
        });
      }
    },
    getSelectOptions(columns) {
      columns.forEach(async _ => {
        if (_.inputType === "select") {
          const { status, message, data } = await getEnumCodesByCategoryId(
            0,
            _.referenceId
          );
          _["options"] = data
            .filter(j => j.status === "active")
            .map(i => {
              return {
                label: i.value,
                value: i.codeId
              };
            });
        }
      });
      return columns;
    },
    getCurrentData() {
      this.queryCiAttrs(this.currentTab);
      this.queryCiData();
    },
    async getZoneLink() {
      const { status, message, data } = await getAllZoneLinkGroupByIdc();
      if (status === "OK") {
        data.forEach(idc => {
          let idcGuid = idc.idcGuid;
          const found = this.idcData.find(idcItem => idcItem.guid === idcGuid);
          idc.linkList &&
            idc.linkList.forEach(link => {
              let zoneLink = {};
              if (
                link.data.zone1.idc === idcGuid &&
                link.data.zone2.idc === idcGuid
              ) {
                zoneLink["azone"] = `g_${link.data.zone1.guid}`;
                zoneLink["bzone"] = `g_${link.data.zone2.guid}`;
                if (found) {
                  if (this.zoneLinkData.has(found.data.guid)) {
                    this.zoneLinkData.get(found.data.guid).push(zoneLink);
                  } else {
                    let linkArray = [zoneLink];
                    this.zoneLinkData.set(found.data.guid, linkArray);
                  }
                }
              }
            });
        });
      }
      this.$nextTick(() => {
        this.initGraph();
      });
    },
    async getAllCiTypeByLayer(layerId) {
      if (layerId < 0) {
        return;
      }
      let filter = {
        key: "group-by",
        value: "layer"
      };
      const { status, message, data } = await getCiTypes(filter);
      if (status === "OK") {
        let allInnerActions = await getExtraInnerActions();
        data.forEach(item => {
          if (item.codeId === layerId) {
            this.tabList = item.ciTypes.map(_ => {
              if (_.status === "created" || _.status === "dirty") {
                return {
                  ..._,
                  name: _.name,
                  id: _.ciTypeId + "",
                  tableData: [],
                  tableColumns: [],
                  outerActions: JSON.parse(JSON.stringify(outerActions)),
                  innerActions: JSON.parse(
                    JSON.stringify(innerActions.concat(allInnerActions))
                  ),
                  pagination: JSON.parse(JSON.stringify(pagination)),
                  ascOptions: {}
                };
              }
            });
          }
        });
      }
    }
  },
  created() {
    this.getAllIdcData();
    this.getAllCiTypeByLayer(this.layerId);
  }
};
</script>

<style lang="scss" scoped>
.graph-select-row {
  margin-bottom: 10px;
}
.graph-select-col {
  display: inline-block;
  margin-right: 10px;
  width: 400px;
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
