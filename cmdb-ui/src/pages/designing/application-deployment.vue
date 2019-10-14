<template>
  <div>
    <Row class="artifact-management">
      <Col span="6">
        <span style="margin-right: 10px">系统设计</span>
        <Select
          filterable
          @on-change="onSystemDesignSelect"
          v-model="systemDesignVersion"
          label-in-name
          style="width: 70%;"
        >
          <Option
            v-for="item in systemDesigns"
            :value="item.guid"
            :key="item.guid"
            >{{ item.name }}</Option
          >
        </Select>
      </Col>
      <Col span="6" offset="1">
        <span style="margin-right: 10px">环境类型</span>
        <Select
          @on-change="onEnvSelect"
          v-model="env"
          label-in-name
          style="width: 70%;"
        >
          <Option v-for="env in envs" :value="env.code || ''" :key="env.code">
            {{ env.value }}
          </Option>
        </Select>
      </Col>
      <Col span="3" offset="1">
        <Button type="info" @click="querySysTree">查询</Button>
      </Col>
    </Row>
    <hr style="margin: 10px 0" />
    <Tabs
      type="card"
      :value="currentTab"
      :closable="false"
      @on-click="handleTabClick"
    >
      <TabPane label="应用逻辑图" name="logic-graph" :index="1">
        <Alert show-icon closable v-if="isDataChanged">
          Data has beed changed, click Reload button to reload graph.
          <Button slot="desc" @click="reloadHandler">Reload</Button>
        </Alert>

        <div class="graph-container" id="graph">
          <Spin size="large" fix v-if="spinShow">
            <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
            <div>加载中...</div>
          </Spin>
        </div>
      </TabPane>
      <TabPane label="应用树状逻辑图" name="logic-tree-graph" :index="2">
        <Alert show-icon closable v-if="isDataChanged">
          Data has beed changed, click Reload button to reload graph.
          <Button slot="desc" @click="reloadHandler">Reload</Button>
        </Alert>

        <div class="graph-container" id="graphTree">
          <Spin size="large" fix v-if="treeSpinShow">
            <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
            <div>加载中...</div>
          </Spin>
        </div>
      </TabPane>
      <TabPane label="物理部署图" name="physicalGraph" :index="3">
        <div id="physicalGraph">
          <PhysicalGraph
            v-if="physicalGraphData.length"
            :graphData="physicalGraphData"
            :links="physicalGraphLinks"
            :callback="graphCallback"
          ></PhysicalGraph>
          <Spin size="large" fix v-if="physicalSpin">
            <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
            <div>加载中...</div>
          </Spin>
        </div>
      </TabPane>
      <TabPane
        v-for="(ci, index) in tabList"
        :key="ci.id"
        :name="ci.id"
        :label="ci.name"
        v-if="isShowTabs"
        :index="index + 5"
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
  </div>
</template>

<script>
import * as d3 from "d3-selection";
import * as d3Graphviz from "d3-graphviz";

import {
  getDeployCiData,
  getDeployDesignTabs,
  getCiTypeAttributes,
  deleteCiDatas,
  createCiDatas,
  updateCiDatas,
  getSystemDesigns,
  getEnumCodesByCategoryId,
  previewDeployGraph,
  getAllDeployTreesFromDesignCi,
  startProcessInstancesWithCiDataInbatch,
  getAllCITypes,
  operateCiState,
  getApplicationDeploymentDesignDataTree,
  getAllZoneLinkGroupByIdc,
  getAllNonSystemEnumCodes,
  queryEnumCategories,
  queryEnumCodes
} from "@/api/server.js";
import {
  outerActions,
  innerActions,
  pagination,
  components
} from "@/const/actions.js";
import { formatData } from "../util/format.js";
const endEvent = require("../images/endEvent.png");
const errEndEvent = require("../images/errEndEvent.png");
const eventBasedGateway = require("../images/eventBasedGateway.png");
const exclusiveGateway = require("../images/exclusiveGateway.png");
const intermediateCatchEvent = require("../images/intermediateCatchEvent.png");
const startEvent = require("../images/startEvent.png");
const serviceTask = require("../images/serviceTask.png");
import { getExtraInnerActions } from "../util/state-operations.js";
import PhysicalGraph from "./physical-graph";
const stateColorMap = new Map([
  ["new", "#47cb89"],
  ["created", "#47cb89"],
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
      isShowTabs: false,
      systemDesigns: [],
      systemDesignVersion: "",
      envs: [],
      env: "",
      currentTab: "logic-graph",
      deployTree: [],
      selectedDeployItems: [],
      graphSource: [],
      graphs: {},
      tabList: [],
      payload: {
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true
      },
      spinShow: false,
      graph: {},
      systemData: [],
      physicalGraphData: [],
      physicalGraphLinks: [],
      serviceCiTypeId: "",
      invokeCiTypeId: "",
      instanceCiTypeId: "",
      isDataChanged: false,
      physicalSpin: false,
      graphTree: {},
      layerData: [],
      systemTreeData: [],
      rankNodes: {},
      treeLayerEnumName: "deploy_tree_layer",
      treeSpinShow: true
    };
  },
  computed: {
    tableRef() {
      return "table" + this.currentTab;
    },
    needCheckout() {
      return this.$route.name === "ciDataEnquiry" ? false : true;
    },
    envCodeId() {
      return this.envs.find(_ => _.code === this.env).codeId || "";
    }
  },
  methods: {
    initADGraph(filters = {}) {
      this.spinShow = true;
      const initEvent = () => {
        let graph = d3.select("#graph");

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
      this.renderADGraph(this.systemData);
      this.spinShow = false;
    },
    renderADGraph(data) {
      let nodesString = this.genADDOT(data);
      this.graph.graphviz.renderDot(nodesString);
      let svg = d3.select("#graph").select("svg");
      let width = svg.attr("width");
      let height = svg.attr("height");
      svg.attr("viewBox", "0 0 " + width + " " + height);
    },
    genADDOT(data) {
      let sysChildren = data || [];
      let sysIvks = [];
      let width = 16;
      let height = 12;
      const found = this.systemDesigns.find(
        sys => this.systemDesignVersion === sys.guid
      );
      if (!found) return "digraph G {}";
      let sysLabel = (found && found.code) || "SYS";
      let graphMap = new Map();
      let dots = [
        "digraph G{",
        "rankdir=LR nodesep=0.5;",
        'size = "' + width + "," + height + '";',
        "subgraph cluster_" +
          found.guid +
          '{ label="' +
          sysLabel +
          '";tooltip="' +
          found.description +
          '";'
      ];
      sysChildren.forEach(subsys => {
        let label;
        if (
          subsys.data.code &&
          subsys.data.code !== null &&
          subsys.data.code !== ""
        ) {
          label = subsys.data.code;
        } else {
          label = subsys.data.key_name;
        }
        dots.push("subgraph cluster_" + subsys.guid + "{");
        dots.push(`label="${label}";tooltip="${subsys.data.description}";`);
        if (Array.isArray(subsys.children)) {
          subsys.children.forEach(unit => {
            let unitLabel;
            if (
              unit.data.code &&
              unit.data.code !== null &&
              unit.data.code !== ""
            ) {
              unitLabel = unit.data.code;
            } else {
              unitLabel = unit.data.key_name;
            }
            let color = "grey";
            if (unit.data.state && stateColorMap.has(unit.data.state.code)) {
              color = stateColorMap.get(unit.data.state.code);
            }
            dots.push("subgraph cluster_" + unit.guid + "{");
            dots.push(
              `label="${unitLabel}"; style=filled; color="${color}";tooltip="${
                unit.data.description
              }"`
            );
            dots.push(`"${unit.guid}"[shape="none",`);
            dots.push(
              `label=<<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">\n<TR><TD COLSPAN="2"> ${unitLabel} </TD></TR>`
            );
            graphMap.set(unit.guid, unitLabel);
            if (Array.isArray(unit.children)) {
              unit.children.forEach(child => {
                if (child.ciTypeId === this.instanceCiTypeId) {
                  let hostIp = "";
                  if (child.data.host && child.data.host.key_name) {
                    hostIp = child.data.host.key_name;
                  }
                  dots.push(
                    `<TR><TD> ${hostIp} </TD><TD>${child.data.port}</TD></TR>`
                  );
                }
              });
            }
            dots.push(unit.data.key_name + "</TABLE>>]");
            if (Array.isArray(unit.children)) {
              unit.children.forEach(service => {
                if (service.ciTypeId === this.invokeCiTypeId) {
                  sysIvks.push(service);
                }
                if (service.ciTypeId === this.serviceCiTypeId) {
                  let serviceLabel;
                  if (
                    service.data.code &&
                    service.data.code !== null &&
                    service.data.code !== ""
                  ) {
                    serviceLabel = service.data.code;
                  } else {
                    serviceLabel = service.data.key_name;
                  }
                  let domain = "";
                  if (service.data.dns_domain) {
                    domain =
                      service.data.dns_name + service.data.dns_domain.value;
                  } else {
                    domain = service.data.dns_name;
                  }
                  let ip = service.data.ip ? service.data.ip : "";
                  dots.push(
                    `"${
                      service.guid
                    }" [shape="record", label="{{ ${serviceLabel}|{ ${domain} | ${
                      service.data.service_port
                    } }| ${ip} }}", tooltip="${service.data.description}"];`
                  );
                  graphMap.set(service.guid, serviceLabel);
                  dots.push(
                    `"${service.guid}" ->"${unit.guid}" [arrowhead="t"];`
                  );
                }
              });
            }
            dots.push("} ");
          });
        }
        dots.push("} ");
      });
      dots.push("} ");

      sysIvks.forEach(invoke => {
        let color = "grey";
        if (invoke.data.state && stateColorMap.has(invoke.data.state.code)) {
          color = stateColorMap.get(invoke.data.state.code);
        }

        dots.push(
          `"${invoke.data.unit.guid}"->"${invoke.data.service.guid}"[id="${
            invoke.guid
          }",color="${color}"];`
        );
        if (!graphMap.has(invoke.data.unit.guid)) {
          dots.push(
            `"${invoke.data.unit.guid}"[label="${invoke.data.unit.key_name}"`
          );
        }
        if (!graphMap.has(invoke.data.service.guid)) {
          dots.push(
            `"${invoke.data.service.guid}"[label="${
              invoke.data.service.key_name
            }"];`
          );
        }
      });
      dots.push("}");
      return dots.join("");
    },
    async reloadHandler() {
      this.querySysTree();
      this.isDataChanged = false;
    },

    onSystemDesignSelect(key) {
      this.systemDesignVersion = key;
      this.isShowTabs = false;
      this.deployTree = [];
      this.systemData = [];
      this.systemTreeData = [];
      this.initADGraph();
      this.initTreeGraph();
    },
    onEnvSelect(key) {
      this.env = key;
      this.isShowTabs = false;
      this.deployTree = [];
      this.systemData = [];
      this.systemTreeData = [];
      this.initADGraph();
      this.initTreeGraph();
    },
    async getSystemDesigns() {
      let { status, data, message } = await getSystemDesigns();
      if (status === "OK") {
        this.systemDesigns = data.contents.map(_ => _.data);
      }
    },
    async getAllEnvs() {
      const payload = {
        filters: [{ name: "cat.catName", operator: "eq", value: "env" }],
        paging: false
      };
      const { status, data, message } = await getAllNonSystemEnumCodes(payload);

      if (status === "OK") {
        this.envs = data.contents;
      }
    },
    onTreeCheck(all, current) {
      this.selectedDeployItems = all;
    },
    async querySysTree() {
      if (!this.systemDesignVersion || !this.env) {
        this.$Notice.warning({
          title: "Warning",
          desc: "请先选择系统设计和环境类型"
        });
        return;
      }
      this.spinShow = true;
      this.treeSpinShow = true;
      if (this.currentTab) {
        this.queryCiData();
      }
      let { status, message, data } = await getAllCITypes();
      if (status === "OK") {
        data.forEach(ci => {
          if (ci.tableName === "service") {
            this.serviceCiTypeId = ci.ciTypeId;
          }
          if (ci.tableName === "invoke") {
            this.invokeCiTypeId = ci.ciTypeId;
          }
          if (ci.tableName === "running_instance") {
            this.instanceCiTypeId = ci.ciTypeId;
          }
        });
      }
      this.physicalSpin = true;
      this.getAllDeployTreesFromDesignCi();
      this.getPhysicalGraphData();
    },
    async getAllDeployTreesFromDesignCi() {
      const { status, message, data } = await getAllDeployTreesFromDesignCi(
        this.systemDesignVersion,
        this.env
      );
      if (status === "OK") {
        this.isShowTabs = true;
        this.deployTree = this.formatTree(data);
        this.systemData = data;
        this.initADGraph();
        const found = this.systemDesigns.find(
          sys => this.systemDesignVersion === sys.guid
        );
        if (found) {
          let systemTreeData = {
            guid: this.systemDesignVersion,
            children: data,
            data: {
              code: found.code
            }
          };
          this.systemTreeData = [];
          this.systemTreeData.push(systemTreeData);
          this.initTreeGraph();
        }
      }
    },
    async getPhysicalGraphData() {
      this.physicalGraphData = [];
      const promiseArray = [
        getApplicationDeploymentDesignDataTree(
          this.systemDesignVersion,
          this.envCodeId
        ),
        getAllZoneLinkGroupByIdc()
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
    async executeDeploy() {
      let payload = {
        attach: {
          attachItems: [
            {
              filterName: "systemDesignVersion",
              filterValue: this.systemDesignVersion
            },
            {
              filterName: "env",
              filterValue: this.env
            }
          ]
        },
        requests: this.selectedDeployItems.map(_ => {
          return {
            ciDataId: _.guid,
            ciTypeId: _.ciTypeId,
            processDefinitionKey: _.data.orchestration.codeId
          };
        })
      };
      const {
        status,
        data,
        message
      } = await startProcessInstancesWithCiDataInbatch(payload);
      if (status === "OK") {
        this.$Notice.success({
          title: "开始执行",
          desc: message
        });
      }
    },
    async previewDeploy() {
      let payload = this.selectedDeployItems.map(_ => {
        return {
          ciGuid: _.guid,
          ciTypeId: _.ciTypeId,
          definitionKey: _.data.orchestration.codeId
        };
      });
      const { status, data, message } = await previewDeployGraph(payload);
      if (status === "OK") {
        this.graphSource = data;
        data.forEach((_, index) => {
          this.$set(this.graphs, _.defintiionKey + "_" + index, {});
        });
        this.$nextTick(() => {
          this.initGraph();
        });
      }
    },
    loadImage(index, nodesString) {
      (nodesString.match(/image=[^,]*(img\/\d*|png)/g) || [])
        .filter((value, index, self) => {
          return self.indexOf(value) === index;
        })
        .map(keyvaluepaire => keyvaluepaire.substr(7))
        .forEach(image => {
          this.graphs[index].graphviz.addImage(image, "48px", "48px");
        });
    },
    genDOT(raw) {
      const shapes = {
        startEvent,
        errEndEvent,
        eventBasedGateway,
        intermediateCatchEvent,
        exclusiveGateway,
        endEvent,
        serviceTask
      };
      var dots = [
        "digraph  {",
        'bgcolor="transparent";',
        'Node [fontname=Arial,shape="none",width="0.8", height="0.8", color="#273c75" ,fontsize=10];',
        'Edge [fontname=Arial, minlen="1", color="#000", fontsize=10];'
      ];
      let drawConnection = (from, to) => {
        return `"${from.id}" -> "${to.id}"[edgetooltip="${to.name}"];`;
      };
      let addNodeAttr = node => {
        const color = "#273c75";
        let path = `${shapes[node.nodeTypeName] || shapes.startEvent}`;
        return `"${node.id}" [image="${path}" label="${
          node.name
        }" labelloc="b", fontcolor="${color}"];`;
      };
      const nodeMap = new Map();
      raw.forEach(node => {
        dots.push(addNodeAttr(node));
        if (node.toNodeIds.length) {
          node.toNodeIds.forEach(toId => {
            let found = raw.find(_ => toId === _.id);
            if (found) {
              const dot = drawConnection(node, found);
              if (!nodeMap.has(dot)) {
                dots.push(dot);
                nodeMap.set(dot, true);
              }
            }
          });
        }

        if (node.fromNodeIds.length) {
          node.fromNodeIds.forEach(fromId => {
            let found = raw.find(_ => fromId === _.id);
            if (found) {
              const dot = drawConnection(found, node);
              if (!nodeMap.has(dot)) {
                dots.push(dot);
                nodeMap.set(dot, true);
              }
            }
          });
        }
      });

      dots.push("}");
      return dots.join("");
    },
    renderGraph(data, index) {
      let nodesString = this.genDOT(data.flowNodes || []);
      this.loadImage(data.defintiionKey + "_" + index, nodesString);
      this.graphs[data.defintiionKey + "_" + index].graphviz.renderDot(
        nodesString
      );
    },
    initGraph() {
      const initEvent = () => {
        this.graphSource.forEach((item, index) => {
          let graph;
          graph = d3.select("#graph_" + item.defintiionKey + "_" + index);
          graph.on("dblclick.zoom", null);
          this.graphs[
            item.defintiionKey + "_" + index
          ].graphviz = graph.graphviz().zoom(false);
        });
      };

      initEvent();
      this.graphSource.forEach((_, index) => {
        this.renderGraph(_, index);
      });
    },
    initTreeGraph(filters = {}) {
      this.treeSpinShow = true;
      let graph;
      const initEvent = () => {
        graph = d3.select("#graphTree");
        graph
          .on("dblclick.zoom", null)
          .on("wheel.zoom", null)
          .on("mousewheel.zoom", null);
        this.graphTree.graphviz = graph
          .graphviz()
          .scale(1.2)
          .width(window.innerWidth * 0.96)
          .height(window.innerHeight * 0.8)
          .zoom(true);
      };

      initEvent();
      this.renderTreeGraph(this.systemTreeData);
      this.treeSpinShow = false;
    },
    renderTreeGraph(data) {
      let nodesString = this.genTreeDOT(data);
      this.graphTree.graphviz.renderDot(nodesString);
      let svg = d3.select("#graphTree").select("svg");
      let width = svg.attr("width");
      let height = svg.attr("height");
      svg.attr("viewBox", "0 0 " + width + " " + height);
    },
    genTreeDOT(data) {
      if (data.length === 0) {
        return "digraph G {}";
      }
      const width = 16;
      const height = 12;
      let dots = [
        "digraph G{",
        "rankdir=TB nodesep=0.5;",
        `size="${width},${height}";`,
        ...this.genlayerDot(this.layerData),
        "Node [fontname=Arial, fontsize=12];",
        'Edge [fontname=Arial, minlen="2",fontsize=10, arrowhead = "t"];',
        ...this.genChildrenDot(data || [], 1),
        ...this.genRankNodeDot(),
        "}"
      ];
      return dots.join(" ");
    },
    genlayerDot(data) {
      let layerDot = [];
      layerDot.push("{");
      layerDot.push("node [shape=plaintext, fontsize=16];");
      data.forEach((element, index) => {
        if (index === data.length - 1) {
          layerDot.push(`${element.value}`);
        } else {
          layerDot.push(`${element.value} -> `);
        }
        this.rankNodes[index + 1] = [];
        this.rankNodes[index + 1].push(element.value);
      });
      layerDot.push(" [style=invis]");
      layerDot.push("}");
      return layerDot;
    },
    genChildrenDot(data, level) {
      let dots = [];
      data.forEach(_ => {
        dots = dots.concat([
          `"${_.guid}"`,
          `[id="n_${_.guid}";`,
          `label="${_.data.code || _.data.key_name}";`,
          "shape=ellipse;",
          `style="filled";color="${colors[level]}";`,
          `tooltip="${_.data.description || "-"}"];`
        ]);
        this.rankNodes[level].push(`"${_.guid}"`);
        if (_.children instanceof Array && _.children.length) {
          dots = dots.concat(this.genChildrenDot(_.children, level + 1));
          _.children.forEach(c => {
            dots = dots.concat([`"${_.guid}" -> "${c.guid}";`]);
          });
        }
      });
      return dots;
    },
    genRankNodeDot() {
      let dot = [];
      Object.keys(this.rankNodes).forEach(key => {
        dot = dot.concat([`{rank=same;`, this.rankNodes[key].join(";"), `;}`]);
      });
      return dot;
    },
    async queryTreeLayerData() {
      let request = {
        filters: [
          {
            name: "catName",
            operator: "eq",
            value: this.treeLayerEnumName
          }
        ]
      };
      const { status, message, data } = await queryEnumCategories(request);
      if (status === "OK") {
        let catId = data.contents[0].catId;
        const response = await queryEnumCodes(0, catId, {});
        if (response.status === "OK") {
          this.layerData = response.data.contents;
        }
      }
    },
    handleTabClick(name) {
      this.payload.filters = [];
      this.currentTab = name;
      if (
        this.currentTab !== "logic-graph" &&
        this.currentTab !== "deploy-detail" &&
        this.currentTab !== "physicalGraph" &&
        this.currentTab !== "logic-tree-graph"
      ) {
        this.getCurrentData();
      }
    },
    getCurrentData() {
      this.queryCiAttrs(this.currentTab);
      this.queryCiData();
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
      this.getCurrentData();
    },
    handleSubmit(data) {
      this.payload.filters = data;
      this.getCurrentData();
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
            this.getCurrentData();
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
          this.getCurrentData();
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
          this.getCurrentData();
        }
      }
    },
    async exportHandler() {
      let found = this.tabList.find(i => i.code === this.currentTab);
      let requst = {
        codeId: found.codeId,
        envCode: this.env,
        systemDesignGuid: this.systemDesignVersion
      };

      let exportPayload = {
        ...this.payload,
        paging: false
      };
      const { status, message, data } = await getDeployCiData(
        requst,
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
      this.getCurrentData();
    },
    pageSizeChange(size) {
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.pagination.pageSize = size;
        }
      });
      this.getCurrentData();
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

    async queryCiData() {
      if (this.env === "" || this.systemDesignVersion === "") {
        this.$Notice.warning({
          title: "Warning",
          desc: "请先选择系统设计和环境类型"
        });
        return;
      }
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
      if (!found) return;
      let requst = {
        codeId: found.codeId,
        envCode: this.env,
        systemDesignGuid: this.systemDesignVersion
      };

      const { status, message, data } = await getDeployCiData(
        requst,
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
    async getDeployDesignTabs() {
      const { status, message, data } = await getDeployDesignTabs();
      if (status === "OK") {
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
      }
    }
  },
  created() {
    this.getSystemDesigns();
    this.getAllEnvs();
    this.getDeployDesignTabs();
    this.queryTreeLayerData();
  }
};
</script>

<style lang="scss" scoped>
#physicalGraph {
  position: relative;
  min-height: 300px;
}
#graphTree {
  position: relative;
  min-height: calc(50% + 300px);
}
</style>
