<template>
  <Row>
    <Row>
      <Col span="12">
        <Row>
          <span style="margin-right: 10px">系统设计</span>
          <Select
            filterable
            @on-change="onSystemDesignSelect"
            label-in-name
            style="width: 35%;"
          >
            <Option
              v-for="item in systemDesigns"
              :value="item.guid"
              :key="item.guid"
              >{{ item.name }}</Option
            >
          </Select>
          <Button style="margin: 0 10px;" @click="onArchChange"
            >架构变更</Button
          >
          <Button @click="querySysTree">去定版</Button>
          <Modal v-model="fixVersionTreeModal" width="500px" title="去定版">
            <div style="max-height: 600px; overflow: auto;">
              <Tree :data="deployTree"></Tree>
            </div>
            <div slot="footer">
              <Button @click="cancelFixVersion">取消定版</Button>
              <Button type="info" @click="onArchFixVersion">确定定版</Button>
            </div>
          </Modal>
        </Row>
      </Col>
    </Row>
    <Card style="margin-top: 20px">
      <div>
        <Tabs
          type="card"
          :value="currentTab"
          :closable="false"
          @on-click="handleTabClick"
        >
          <TabPane label="应用逻辑图" name="architecture-design">
            <Alert show-icon closable v-if="isDataChanged">
              Data has beed changed, click Reload button to reload graph.
              <Button slot="desc" @click="reloadHandler">Reload</Button>
            </Alert>
            <Spin size="large" fix v-if="spinShow">
              <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
              <div>加载中...</div>
            </Spin>
            <div v-else-if="!systemDesignData.length" class="no-data">
              暂无数据
            </div>
            <Row>
              <Col span="18">
                <div style="padding-right: 20px">
                  <div class="graph-container" id="graph"></div>
                </div>
              </Col>
              <Col
                span="6"
                offset="0"
                class="func-wrapper"
                v-if="isShowInvokeSequence"
              >
                <Collapse>
                  <Panel name="invokeDesignSequence">
                    <b>调用时序设计</b>
                    <Form
                      slot="content"
                      ref="invokeSequenceForm"
                      :model="invokeSequenceForm"
                      label-position="left"
                      :label-width="110"
                    >
                      <Form-item label="调用时序设计">
                        <Row>
                          <Select
                            placeholder="请选择"
                            v-model="invokeSequenceForm.selectedInvokeSequence"
                            style="width:calc(100% - 80px)"
                          >
                            <Option
                              v-for="item in invokeSequenceForm.invokeSequenceData"
                              :key="item.data.guid"
                              :value="item.data.guid"
                              >{{ item.data.code }}</Option
                            >
                          </Select>
                          <Button
                            style="float:right;width:70px;"
                            @click="onSearchInvokeSquence"
                            >确定</Button
                          >
                        </Row>
                      </Form-item>
                      <Form-item
                        label="调用时序设计序列"
                        v-if="invokeSequenceForm.isShowInvokeSequenceDetial"
                      >
                        <span style="margin-right: 10px">{{
                          invokeSequenceForm.spliceInvokeSequenceList
                        }}</span>
                      </Form-item>
                      <Form-Item
                        label="当前调用"
                        v-if="invokeSequenceForm.isShowInvokeSequenceDetial"
                      >
                        <Row>
                          <span style="margin-right: 10px">{{
                            invokeSequenceForm.currentInvokeSequenceTag
                          }}</span>
                          <span
                            class="header-buttons-container margin-right"
                            style="float:right"
                          >
                            <Tooltip content="上一步" placement="top-start">
                              <Button
                                size="small"
                                @click="backInvokeSequence"
                                icon="md-arrow-round-back"
                              ></Button>
                            </Tooltip>
                            <span
                              >{{ invokeSequenceForm.currentNum }}/{{
                                invokeSequenceForm.totalNum
                              }}</span
                            >
                            <Tooltip content="下一步" placement="top-start">
                              <Button
                                size="small"
                                @click="nextInvokeSequence"
                                icon="md-arrow-round-forward"
                              ></Button>
                            </Tooltip>
                          </span>
                        </Row>
                      </Form-Item>
                      <Form-Item
                        v-if="invokeSequenceForm.isShowInvokeSequenceDetial"
                      >
                        <Button
                          style="margin-right: calc(50% + 35px);width=70px;float: right"
                          @click="closeInvokeSquence"
                          >返回</Button
                        >
                      </Form-Item>
                    </Form>
                  </Panel>
                </Collapse>
              </Col>
            </Row>
          </TabPane>

          <TabPane label="物理部署图" name="physicalGraph">
            <div id="physicalGraph">
              <PhysicalGraph
                v-if="physicalGraphData.length"
                :graphData="physicalGraphData"
                :links="physicalGraphLinks"
                :callback="graphCallback"
              ></PhysicalGraph>
              <div v-else class="no-data">暂无数据</div>
              <Spin size="large" fix v-if="physicalSpin">
                <Icon
                  type="ios-loading"
                  size="44"
                  class="spin-icon-load"
                ></Icon>
                <div>加载中...</div>
              </Spin>
            </div>
          </TabPane>
          <TabPane
            v-if="!!systemDesignVersion"
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
              @handleSubmit="handleSubmit"
              @sortHandler="sortHandler"
              @getSelectedRows="onSelectedRowsChange"
              @pageChange="pageChange"
              @pageSizeChange="pageSizeChange"
              tableHeight="650"
              :ref="'table' + ci.id"
            ></WeTable>
          </TabPane>
        </Tabs>
      </div>
    </Card>
  </Row>
</template>

<script>
import * as d3 from "d3-selection";
import * as d3Graphviz from "d3-graphviz";
import {
  getCiTypeAttributes,
  deleteCiDatas,
  createCiDatas,
  updateCiDatas,
  getEnumCodesByCategoryId,
  getCiTypes,
  getSystemDesigns,
  updateCIRecord,
  getAllDesignTreeFromSystemDesign,
  saveAllDesignTreeFromSystemDesign,
  getArchitectureDesignTabs,
  getArchitectureCiDatas,
  getAllCITypes,
  operateCiState,
  getApplicationFrameworkDesignDataTree,
  getAllZoneLinkDesignGroupByIdcDesign
} from "@/api/server";
import {
  outerActions,
  innerActions,
  pagination,
  components
} from "@/const/actions.js";
import { formatData } from "../util/format.js";
import { getExtraInnerActions } from "../util/state-operations.js";
import PhysicalGraph from "./physical-graph";

const stateColorMap = new Map([
  ["new", "#19be6b"],
  ["created", "#19be6b"],
  ["update", "#2d8cf0"],
  ["change", "#2d8cf0"],
  ["destroyed", "#ed4014"],
  ["delete", "#ed4014"]
]);
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
  components: {
    PhysicalGraph
  },
  data() {
    return {
      tabList: [],
      systemDesigns: [],
      systemDesignVersion: "",
      deployTree: [],
      fixVersionTreeModal: false,
      payload: {
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true
      },
      systemDesignCiTypeId: "",
      invokeDesignCiTypeId: "",
      graph: {},
      systemDesignData: [],
      physicalGraphData: [],
      physicalGraphLinks: [],
      physicalGraphNodes: {},
      physicalGraphLineNodes: {
        serviceDesign: {},
        unitDesign: {}
      },
      currentTab: "architecture-design",
      spinShow: false,
      isDataChanged: false,
      physicalSpin: false,
      invokeLines: [],
      isShowInvokeSequence: false,
      invokeSequenceCode: "6",
      invokeSequenceForm: {
        isShowInvokeSequenceDetial: false,
        invokeSequenceData: [],
        spliceInvokeSequenceList: "",
        totalNum: 0,
        currentNum: 0,
        currentInvokeSequenceTag: "",
        currentInvokeSequence: [],
        selectedInvokeSequence: ""
      }
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
    closeInvokeSquence() {
      this.invokeSequenceForm.totalNum = 0;
      this.invokeSequenceForm.currentNum = 0;
      this.invokeSequenceForm.selectedInvokeSequence = "";
      this.invokeSequenceForm.currentInvokeSequenceTag = "";
      this.invokeSequenceForm.currentInvokeSequence = [];
      this.invokeSequenceForm.isShowInvokeSequenceDetial = false;
      this.invokeSequenceForm.spliceInvokeSequenceList = "";
      this.initGraph();
    },
    backInvokeSequence() {
      if (this.invokeSequenceForm.currentNum > 1) {
        let invokeDesignSequenceList = this.invokeSequenceForm
          .currentInvokeSequence;
        this.invokeSequenceForm.currentNum =
          this.invokeSequenceForm.currentNum - 1;
        this.invokeSequenceForm.currentInvokeSequenceTag =
          invokeDesignSequenceList[
            this.invokeSequenceForm.currentNum - 1
          ].key_name;
        this.reColorInvokeSequence();
      }
    },
    nextInvokeSequence() {
      if (
        this.invokeSequenceForm.currentNum < this.invokeSequenceForm.totalNum
      ) {
        let invokeDesignSequenceList = this.invokeSequenceForm
          .currentInvokeSequence;
        this.invokeSequenceForm.currentNum =
          this.invokeSequenceForm.currentNum + 1;
        this.invokeSequenceForm.currentInvokeSequenceTag =
          invokeDesignSequenceList[
            this.invokeSequenceForm.currentNum - 1
          ].key_name;
        this.reColorInvokeSequence();
      }
    },
    async getAllInvokeSequenceData() {
      this.invokeSequenceForm.invokeSequenceData = [];
      let found = this.tabList.find(i => i.code === this.invokeSequenceCode);
      const { status, message, data } = await getArchitectureCiDatas(
        found.codeId,
        this.systemDesignVersion,
        {}
      );
      if (status === "OK") {
        this.invokeSequenceForm.invokeSequenceData = data.contents;
      }
    },
    onSearchInvokeSquence() {
      this.invokeSequenceForm.isShowInvokeSequenceDetial = true;
      const found = this.invokeSequenceForm.invokeSequenceData.find(
        i => i.data.guid === this.invokeSequenceForm.selectedInvokeSequence
      );
      if (found) {
        this.invokeSequenceForm.currentInvokeSequence =
          found.data.invoke_design_sequence;
        this.handleInvokeSquence(true);
      }
    },
    handleInvokeSquence() {
      let invokeDesignSequenceList = this.invokeSequenceForm
        .currentInvokeSequence;
      let spliceInvokeSequenceList = [];
      invokeDesignSequenceList.forEach(_ => {
        spliceInvokeSequenceList.push(_.key_name);
      });
      this.invokeSequenceForm.spliceInvokeSequenceList = spliceInvokeSequenceList.join(
        " -> "
      );
      if (invokeDesignSequenceList.length > 0) {
        this.invokeSequenceForm.totalNum = invokeDesignSequenceList.length;
        this.invokeSequenceForm.currentNum = 1;
        this.invokeSequenceForm.currentInvokeSequenceTag =
          invokeDesignSequenceList[0].key_name;
      }
      this.reColorInvokeSequence();
    },
    reColorInvokeSequence() {
      this.initGraph();
      this.shadeAll();

      this.invokeSequenceForm.currentInvokeSequence.forEach(_ => {
        this.reColorCurrentInvokeSequenceNode(
          _.service_design,
          "ellipse",
          "green"
        );
        this.reColorCurrentInvokeSequenceNode(
          _.unit_design,
          "polygon",
          "green"
        );
        this.reColorCurrentInvokeSequenceLine(_, "green");
      });

      let index = this.invokeSequenceForm.currentNum;
      let current = this.invokeSequenceForm.currentInvokeSequence[index - 1];
      this.reColorCurrentInvokeSequenceLine(current, "red");
    },
    async onArchFixVersion() {
      if (this.systemDesignVersion === "") return;
      const { status, message, data } = await saveAllDesignTreeFromSystemDesign(
        this.systemDesignVersion
      );
      if (status === "OK") {
        this.queryCiData();
        this.$Notice.success({
          title: "Success",
          desc: message
        });
        this.fixVersionTreeModal = false;
      }
    },
    cancelFixVersion() {
      this.fixVersionTreeModal = false;
    },
    async reloadHandler() {
      this.onArchChange();
      this.isDataChanged = false;
    },
    async onArchChange() {
      let { status, message, data } = await getAllCITypes();
      if (status === "OK") {
        data.forEach(ci => {
          if (ci.tableName === "system_design") {
            this.systemDesignCiTypeId = ci.ciTypeId + "";
          }
          if (ci.tableName === "invoke_design") {
            this.invokeDesignCiTypeId = ci.ciTypeId;
          }
        });
      }

      if (this.systemDesignVersion === "") return;
      this.spinShow = true;
      this.physicalSpin = true;
      this.getAllDesignTreeFromSystemDesign();
      this.getPhysicalGraphData();
    },
    async getAllDesignTreeFromSystemDesign() {
      const { status, message, data } = await getAllDesignTreeFromSystemDesign(
        this.systemDesignVersion
      );
      if (status === "OK") {
        this.getAllInvokeSequenceData();
        this.systemDesignData = data ? data : [];
        this.initGraph();
      }

      let response = await updateCIRecord(this.systemDesignCiTypeId, {
        guid: this.systemDesignVersion
      });
    },
    async getPhysicalGraphData() {
      this.physicalGraphData = [];
      const promiseArray = [
        getApplicationFrameworkDesignDataTree(this.systemDesignVersion),
        getAllZoneLinkDesignGroupByIdcDesign()
      ];
      const [graphData, links] = await Promise.all(promiseArray);
      if (graphData.status === "OK") {
        if (graphData.data.length) {
          this.physicalGraphData = graphData.data;
        } else {
          this.physicalGraphData = [];
          this.physicalSpin = false;
        }
      }
      if (links.status === "OK") {
        this.physicalGraphLinks = links.data || [];
      }
    },
    graphCallback() {
      this.physicalSpin = false;
    },
    async querySysTree() {
      if (this.systemDesignVersion === "") return;
      this.spinShow = true;
      const { status, message, data } = await getAllDesignTreeFromSystemDesign(
        this.systemDesignVersion
      );
      if (status === "OK") {
        this.spinShow = false;
        this.systemDesignData = data ? data : [];
        this.deployTree = this.formatTree(this.systemDesignData);
        this.fixVersionTreeModal = true;
      }
    },
    formatTree(data) {
      return data.map(_ => {
        if (_.children && _.children.length > 0) {
          return {
            ..._,

            title: _.data.key_name,
            id: _.guid,
            expand: true,
            disableCheckbox: !_.data.orchestration,
            children: this.formatTree(_.children)
          };
        } else {
          return {
            ..._,
            title: _.data.key_name,
            id: _.guid,
            expand: true,
            disableCheckbox: !_.data.orchestration
          };
        }
      });
    },
    initGraph() {
      this.isShowInvokeSequence = true;
      this.spinShow = true;
      let graph;

      const initEvent = () => {
        graph = d3.select("#graph");

        graph
          .on("dblclick.zoom", null)
          .on("wheel.zoom", null)
          .on("mousewheel.zoom", null);
        this.graph.graphviz = graph
          .graphviz()
          .scale(1.2)
          .width(window.innerWidth * 0.96)
          .height(window.innerHeight * 0.8)
          .zoom(true);
      };

      initEvent();
      this.renderGraph(this.systemDesignData);
      this.spinShow = false;
    },
    genDOT(sysData) {
      this.physicalGraphNodes = {};
      this.physicalGraphLineNodes = {
        serviceDesign: {},
        unitDesign: {}
      };
      this.invokeLines = [];
      const width = 16;
      const height = 12;
      let dots = [
        "digraph G{",
        "rankdir=LR nodesep=0.5;",
        "Node [fontname=Arial, fontsize=12];",
        'Edge [fontname=Arial, minlen="2",fontsize=10];',
        `size="${width},${height}";`,
        `subgraph cluster_${sysData[0].guid} {`,
        `style="filled";color="${colors[0]}";`,
        `tooltip="${sysData[0].data.description}";`,
        `label="${sysData[0].data.name}";`,
        this.genChildrenDot(sysData[0].children || [], 1),
        "}",
        ...this.invokeLines,
        this.renderOtherNodes(),
        "}"
      ];

      console.log(
        dots
          .join("")
          .replace(/;/g, ";\n")
          .replace(/]/g, "]\n")
      );

      return dots.join("");
    },
    genChildrenDot(data, level) {
      const width = 12;
      const height = 9;
      let dots = [];
      if (data.length) {
        data.forEach(_ => {
          if (_.children instanceof Array && _.children.length) {
            dots = dots.concat([
              `subgraph cluster_${_.guid}{`,
              `id="g_${_.guid}";`,
              `style="filled";color="${colors[level]}";`,
              `label="${_.data.code || _.data.key_name}";`,
              `tooltip="${_.data.description || _.data.name}"`,
              _.ciTypeId === 3
                ? this.genServiceInvokeLine(_)
                : this.genChildrenDot(_.children, level + 1),
              "}"
            ]);
          } else {
            this.physicalGraphNodes[_.guid] = _;
            dots = dots.concat([
              `"${_.guid}"`,
              `[id="n_${_.guid}";`,
              `label="${_.data.code || _.data.key_name}";`,
              "shape=box;",
              `style="filled";color="${colors[level]}";`,
              `tooltip="${_.data.description || _.data.name}"];`
            ]);
          }
        });
      } else {
        dots.push(
          `g[label=" ",color="${colors[0]}";width="${width}";height="${height -
            3}"]`
        );
      }
      return dots.join("");
    },
    genServiceInvokeLine(unitNode) {
      const unitLabel = unitNode.data.code || unitNode.data.key_name;
      let serviceData = [];
      let InvokeLine = [];
      unitNode.children.forEach(_ => {
        if (_.ciTypeId === 4) {
          serviceData.push(_);
        } else if (_.ciTypeId === 5) {
          InvokeLine.push(_);
        }
      });
      if (InvokeLine.length) {
        InvokeLine.forEach(line => {
          let color = "grey";
          if (line.data.state && stateColorMap.has(line.data.state.code)) {
            color = stateColorMap.get(line.data.state.code);
          }
          this.invokeLines.push(
            `gn_${line.data.unit_design.guid} -> gn_${line.data.service_design.guid} [id="gl_${line.guid}",color="${color}",taillabel="${line.data.type.value}", labeldistance=3];`
          );
          this.physicalGraphLineNodes.serviceDesign[
            line.data.service_design.guid
          ] = line.data.service_design;
          this.physicalGraphLineNodes.unitDesign[line.data.unit_design.guid] =
            line.data.unit_design;
        });
      }
      return [
        this.renderNode(unitNode, "doubleoctagon"),
        ...this.renderServiceNode(serviceData, unitNode)
      ].join("");
    },
    renderNode(node, nodeType) {
      this.physicalGraphNodes[node.guid] = node;
      return `"gn_${node.guid}" [label="${node.data.code}", id="gn_${
        node.guid
      }", shape=${nodeType ||
        "ellipse"},style="filled", color="${stateColorMap.get(
        node.data.state.code
      )}", tooltip="${node.data.description || node.data.name}"]`;
    },
    renderServiceNode(serviceData, unitNode) {
      let result = [];
      if (serviceData.length) {
        serviceData.forEach(_ => {
          result = result.concat([
            this.renderNode(_),
            `"gn_${_.guid}" -> "gn_${unitNode.guid}" [arrowhead = "t"]`
          ]);
        });
      }
      return result;
    },
    renderOtherNodes() {
      let result = "";
      Object.keys(this.physicalGraphLineNodes.serviceDesign).forEach(
        serviceGuid => {
          if (!this.physicalGraphNodes[serviceGuid]) {
            const node = this.physicalGraphLineNodes.serviceDesign[serviceGuid];
            result += `"gn_${node.guid}" [label="${node.code}",id="gn_${
              node.guid
            }",shape="ellipse",tooltip="${node.description || node.name}"]`;
          }
        }
      );
      Object.keys(this.physicalGraphLineNodes.unitDesign).forEach(unitGuid => {
        if (!this.physicalGraphNodes[unitGuid]) {
          const node = this.physicalGraphLineNodes.unitDesign[unitGuid];
          result += `"gn_${node.guid}" [label="${node.code}",id="gn_${
            node.guid
          }",shape="doubleoctagon",tooltip="${node.description || node.name}"]`;
        }
      });
      return result;
    },
    renderGraph(data) {
      let nodesString = this.genDOT(data);
      this.graph.graphviz.renderDot(nodesString);
      let svg = d3.select("#graph").select("svg");
      let width = svg.attr("width");
      let height = svg.attr("height");
      svg.attr("viewBox", "0 0 " + width + " " + height);
    },
    shadeAll() {
      d3.selectAll("g path")
        .attr("stroke", "#7f8fa6")
        .attr("stroke-opacity", ".2");
      d3.selectAll("g polygon")
        .attr("stroke", "#7f8fa6")
        .attr("stroke-opacity", ".2")
        .attr("fill", "#7f8fa6")
        .attr("fill-opacity", ".2");
      d3.selectAll("g ellipse")
        .attr("stroke", "#7f8fa6")
        .attr("stroke-opacity", ".2")
        .attr("fill", "#7f8fa6")
        .attr("fill-opacity", ".2");
      d3.selectAll("text").attr("fill", "#000");
    },
    reColorCurrentInvokeSequenceLine(invokeSequence, color) {
      //line
      let edge = d3
        .select("#" + `gl_${invokeSequence.guid}`)
        .attr("stroke", color)
        .attr("stroke-opacity", "1");
      edge
        .select("path")
        .attr("stroke", color)
        .attr("stroke-opacity", "1");
      edge
        .select("polygon")
        .attr("fill", color)
        .attr("stroke", color)
        .attr("stroke-opacity", "1");
    },
    reColorCurrentInvokeSequenceNode(nodeId, nodeType, color) {
      //node
      let node = d3.select("#" + `gn_${nodeId}`);
      node
        .selectAll(nodeType)
        .attr("fill", color)
        .attr("stroke", color)
        .attr("stroke-opacity", "1");
    },
    handleTabClick(name) {
      this.payload.filters = [];
      this.currentTab = name;
      if (name !== "architecture-design" && name !== "physicalGraph") {
        this.getCurrentData();
      }
    },
    onSelectedRowsChange(rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        let isUpdateableAry = [];
        let isDeleteableAry = [];

        rows.forEach((r, index) => {
          isUpdateableAry.push(!!r.nextOperations.find(op => op === "update"));
          isDeleteableAry.push(!!r.nextOperations.find(op => op === "delete"));
        });
        let isValueTrue = val => {
          return val === true;
        };

        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.outerActions.forEach(_ => {
              switch (_.actionType) {
                case "add":
                  _.props.disabled = _.actionType === "add";
                  break;
                case "edit":
                  _.props.disabled = !isUpdateableAry.every(isValueTrue);
                  break;
                case "delete":
                  _.props.disabled = !isDeleteableAry.every(isValueTrue);
                  break;
                default:
                  break;
              }
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
    sortHandler(data) {
      if (data.order === "normal") {
        delete this.payload.sorting;
      } else {
        this.payload.sorting = {
          asc: data.order === "asc",
          field: data.key
        };
      }
      this.queryCiData();
    },
    handleSubmit(data) {
      this.payload.filters = data;
      this.queryCiData();
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
          let found = this.tabList.find(i => i.id === this.currentTab);
          const payload = {
            id: found && found.code,
            deleteData: deleteData.map(_ => _.guid)
          };
          const { status, message, data } = await deleteCiDatas(payload);
          if (status === "OK") {
            this.$Notice.success({
              title: "Delete data Success",
              desc: message
            });
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
            this.isDataChanged = true;
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
        let found = this.tabList.find(i => i.id === this.currentTab);
        let payload = {
          id: found && found.code,
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
        let found = this.tabList.find(i => i.id === this.currentTab);

        let payload = {
          id: found && found.code,
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
      let exportPayload = {
        ...this.payload,
        paging: false
      };
      const { status, message, data } = await getArchitectureCiDatas(
        this.currentTab,
        this.systemDesignVersion,
        exportPayload
      );
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

      let found = this.tabList.find(i => i.code === this.currentTab);
      const { status, message, data } = await getArchitectureCiDatas(
        found.codeId,
        this.systemDesignVersion,
        this.payload
      );
      if (status === "OK") {
        this.tabList.forEach(ci => {
          if (ci.id === this.currentTab) {
            ci.tableData = data
              ? data.contents.map(_ => {
                  return {
                    ..._.data,
                    nextOperations: _.meta.nextOperations || []
                  };
                })
              : [];
            ci.pagination.total = data ? data.pageInfo.totalRows : 0;
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
            const com =
              _.propertyName === "invoke_design_sequence"
                ? { component: "sequenceDiagram" }
                : { ...components[_.inputType] };
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
              ...com
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
    async getArchitectureDesignTabs() {
      const { data, status, message } = await getArchitectureDesignTabs();
      let allInnerActions = await getExtraInnerActions();
      if (status === "OK") {
        this.tabList = data.map(_ => {
          return {
            ..._,
            name: _.value,
            id: _.code,
            tableData: [],
            tableColumns: [],
            outerActions: JSON.parse(JSON.stringify(outerActions)),
            innerActions: JSON.parse(
              JSON.stringify(innerActions.concat(allInnerActions))
            ),
            pagination: JSON.parse(JSON.stringify(pagination)),
            ascOptions: {}
          };
        });
      }
    },
    onSystemDesignSelect(key) {
      this.systemDesignVersion = key;
      if (
        this.currentTab !== "architecture-design" &&
        this.currentTab !== "physicalGraph"
      ) {
        this.getCurrentData();
      }
    },
    async getSystemDesigns() {
      let { status, data, message } = await getSystemDesigns();
      if (status === "OK") {
        this.systemDesigns = data.contents.map(_ => _.data);
      }
    }
  },
  created() {
    this.getArchitectureDesignTabs();
    this.getSystemDesigns();
  }
};
</script>

<style scoped>
.ivu-card-head p {
  height: 30px;
  line-height: 30px;
}
.filter-title {
  margin-right: 10px;
}
#physicalGraph {
  position: relative;
  min-height: 300px;
}
.no-data {
  text-align: center;
}
</style>
