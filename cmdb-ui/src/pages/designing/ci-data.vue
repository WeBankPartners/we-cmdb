<template>
  <div>
    <Tabs
      type="card"
      :value="currentTab"
      closable
      @on-tab-remove="handleTabRemove"
      @on-click="handleTabClick"
    >
      <TabPane :closable="false" name="CMDB" label="CMDB模型">
        <div class="graph-container" id="graph"></div>
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
</template>
<script>
import * as d3 from "d3-selection";
import * as d3Graphviz from "d3-graphviz";
import { addEvent } from "../util/event.js";
import {
  getAllCITypesByLayerWithAttr,
  getAllLayers,
  queryCiData,
  getCiTypeAttributes,
  deleteCiDatas,
  createCiDatas,
  updateCiDatas,
  getEnumCodesByCategoryId,
  operateCiState
} from "@/api/server";
import { setHeaders } from "@/api/base.js";
import {
  outerActions,
  innerActions,
  pagination,
  components
} from "@/const/actions.js";
import { formatData } from "../util/format.js";
import { getExtraInnerActions } from "../util/state-operations.js";
const defaultCiTypePNG = require("@/assets/ci-type-default.png");
export default {
  data() {
    return {
      tabList: [],
      currentTab: "CMDB",
      payload: {
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true,
        sorting: {}
      },
      source: {},
      layers: [],
      graph: {},
      ciTypesName: {}
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
    handleTabRemove(name) {
      this.tabList.forEach((_, index) => {
        if (_.id === name) {
          this.tabList.splice(index, 1);
          this.payload.filters = [];
        }
      });
      this.currentTab = "CMDB";
    },
    handleTabClick(name) {
      this.payload.filters = [];
      this.currentTab = name;
    },
    async initGraph(filters = ["created", "dirty"]) {
      var origin;
      var edges = {};
      var levels = {};
      let graph;
      let graphviz;

      const initEvent = () => {
        graph = d3.select("#graph");
        graph
          .on("dblclick.zoom", null)
          .on("wheel.zoom", null)
          .on("mousewheel.zoom", null);

        this.graph.graphviz = graph
          .graphviz()
          .zoom(true)
          .scale(1.2)
          .width(window.innerWidth * 0.96)
          .height(window.innerHeight * 0.8)
          .attributer(function(d) {
            if (d.attributes.class === "edge") {
              var keys = d.key.split("->");
              var from = keys[0].trim();
              var to = keys[1].trim();
              d.attributes.from = from;
              d.attributes.to = to;
            }

            if (d.tag === "text") {
              var key = d.children[0].text;
              d3.select(this).attr("text-key", key);
            }
          });
      };

      let layerResponse = await getAllLayers();
      if (layerResponse.status === "OK") {
        let tempLayer = layerResponse.data
          .filter(i => i.status === "active")
          .map(_ => {
            return { name: _.value, layerId: _.codeId, ..._ };
          });
        this.layers = tempLayer.sort((a, b) => {
          return a.seqNo - b.seqNo;
        });
        let ciResponse = await getAllCITypesByLayerWithAttr(filters);
        if (ciResponse.status === "OK") {
          this.source = ciResponse.data;
          this.source.forEach(_ => {
            _.ciTypes &&
              _.ciTypes.forEach(async i => {
                this.ciTypesName[i.ciTypeId] = i.name;
                let imgFileSource =
                  i.imageFileId === 0 || i.imageFileId === undefined
                    ? defaultCiTypePNG.substring(0, defaultCiTypePNG.length - 4)
                    : `/cmdb/ui/v2/files/${i.imageFileId}`;
                this.$set(i, "form", {
                  ...i,
                  imgSource: imgFileSource,
                  imgUploadURL: `/cmdb/ui/v2/ci-types/${i.ciTypeId}/icon`
                });
                i.attributes &&
                  i.attributes.forEach(j => {
                    this.$set(j, "form", {
                      ...j,
                      isAccessControlled: j.isAccessControlled ? "yes" : "no",
                      isNullable: j.isNullable ? "yes" : "no",
                      isSystem: j.isSystem ? "yes" : "no"
                    });
                  });
              });
          });
          let uploadToken = document.cookie
            .split(";")
            .find(i => i.indexOf("XSRF-TOKEN") !== -1);
          setHeaders({
            "X-XSRF-TOKEN": uploadToken && uploadToken.split("=")[1]
          });
          initEvent();
          this.renderGraph(ciResponse.data);
        }
      }
    },
    genDOT(data) {
      let nodes = [];
      data.forEach(_ => {
        if (_.ciTypes) nodes = nodes.concat(_.ciTypes);
      });
      var dots = [
        "digraph  {",
        'bgcolor="transparent";',
        'Node [fontname=Arial,shape="ellipse", fixedsize="true", width="1.1", height="1.1", color="transparent" ,fontsize=11];',
        'Edge [fontname=Arial,minlen="1", color="#7f8fa6", fontsize=10];',
        'ranksep = 1.1; nodesep=.7; size = "11,8";rankdir=TB'
      ];
      let layerTag = `node [];`;

      // generate group
      let tempClusterObjForGraph = {};
      let tempClusterAryForGraph = [];
      this.layers.map((_, index) => {
        if (index !== this.layers.length - 1) {
          layerTag += '"' + _.name + '"' + "->";
        } else {
          layerTag += '"' + _.name + '"';
        }

        tempClusterObjForGraph[index] = [`{ rank=same; "${_.name}";`];
        nodes.forEach((node, nodeIndex) => {
          if (node.layerId === _.layerId) {
            tempClusterObjForGraph[index].push(
              `"${node.name}"[id="${node.ciTypeId}", image="${node.form.imgSource}.png", labelloc="b"]`
            );
          }
          if (nodeIndex === nodes.length - 1) {
            tempClusterObjForGraph[index].push("} ");
          }
        });
        if (nodes.length === 0) {
          tempClusterObjForGraph[index].push("} ");
        }
        tempClusterAryForGraph.push(tempClusterObjForGraph[index].join(""));
      });

      dots.push(tempClusterAryForGraph.join(""));
      dots.push("{" + layerTag + "[style=invis]}");

      //generate edges
      nodes.forEach(node => {
        node.attributes &&
          node.attributes.forEach(attr => {
            if (attr.inputType === "ref" || attr.inputType === "multiRef") {
              var target = nodes.find(_ => _.ciTypeId === attr.referenceId);
              if (target) {
                dots.push(this.genEdge(nodes, node, attr));
              }
            }
          });
      });
      dots.push("}");
      return dots.join("");
    },
    genEdge(nodes, from, to) {
      const target = nodes.find(_ => _.ciTypeId === to.referenceId);
      let labels = to.referenceName ? to.referenceName.trim() : "";
      return (
        '"' +
        from.name +
        '"->' +
        '"' +
        target.name.trim() +
        '"[label="' +
        labels +
        '"];'
      );
    },

    loadImage(nodesString) {
      (nodesString.match(/image=[^,]*(files\/\d*|png)/g) || [])
        .filter((value, index, self) => {
          return self.indexOf(value) === index;
        })
        .map(keyvaluepaire => keyvaluepaire.substr(7))
        .forEach(image => {
          this.graph.graphviz.addImage(image, "48px", "48px");
        });
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
      d3.selectAll(".edge text").attr("fill", "#7f8fa6");
    },
    colorNode(nodeName) {
      d3.selectAll('g[from="' + nodeName + '"] path')
        .attr("stroke", "red")
        .attr("stroke-opacity", "1");
      d3.selectAll('g[from="' + nodeName + '"] text').attr("fill", "red");
      d3.selectAll('g[from="' + nodeName + '"] polygon')
        .attr("stroke", "red")
        .attr("fill", "red")
        .attr("fill-opacity", "1")
        .attr("stroke-opacity", "1");
      d3.selectAll('g[to="' + nodeName + '"] path')
        .attr("stroke", "green")
        .attr("stroke-opacity", "1");
      d3.selectAll('g[to="' + nodeName + '"] text').attr("fill", "green");
      d3.selectAll('g[to="' + nodeName + '"] polygon')
        .attr("stroke", "green")
        .attr("fill", "green")
        .attr("fill-opacity", "1")
        .attr("stroke-opacity", "1");
    },
    renderGraph(data) {
      let nodesString = this.genDOT(data);
      this.loadImage(nodesString);
      this.graph.graphviz.renderDot(nodesString);
      this.shadeAll();
      addEvent(".node", "mouseover", async e => {
        e.preventDefault();
        e.stopPropagation();
        d3.selectAll("g").attr("cursor", "pointer");
        var g = e.currentTarget;
        var nodeName = g.children[0].innerHTML.trim();
        this.shadeAll();
        this.colorNode(nodeName);
      });

      addEvent("svg", "mouseover", e => {
        this.shadeAll();
        e.preventDefault();
        e.stopPropagation();
      });

      addEvent(".node", "click", async e => {
        e.preventDefault();
        e.stopPropagation();
        var g = e.currentTarget;
        var nodeName = g.children[0].innerHTML.trim();
        let isLayerSelected = this.layers.find(_ => _.name === nodeName);
        if (isLayerSelected) {
          return;
        }
        const found = this.tabList.find(_ => _.id === g.id);
        if (!found) {
          const ci = {
            name: nodeName,
            id: g.id,
            tableData: [],
            outerActions:
              this.$route.name === "ciDataEnquiry"
                ? null
                : JSON.parse(JSON.stringify(outerActions)),
            innerActions:
              this.$route.name === "ciDataEnquiry"
                ? null
                : JSON.parse(
                    JSON.stringify(
                      innerActions.concat(await getExtraInnerActions())
                    )
                  ),
            tableColumns: [],
            pagination: JSON.parse(JSON.stringify(pagination)),
            ascOptions: {}
          };
          const query = {
            id: g.id,
            queryObject: this.payload
          };
          this.tabList.push(ci);
          this.currentTab = g.id;
          this.queryCiAttrs(g.id);
          this.queryCiData(query);
        } else {
          this.currentTab = g.id;
        }
      });
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
      this.$refs[this.tableRef][0].setTableData(checkoutBoxdisable);
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
      this.payload.sorting = {
        asc: data.order === "asc",
        field: data.key
      };
      this.queryCiData();
    },
    handleSubmit(data) {
      this.payload.filters = data;
      this.tabList.forEach(ci => {
        if (ci.id === this.currentTab) {
          ci.pagination.currentPage = 1;
        }
      });
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
      this.queryCiData();
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
          filename: this.ciTypesName[this.currentTab],
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
                nextOperations: _.meta.nextOperations || []
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
              filterRule: !!_.filterRule,
              ciType: { id: _.referenceId, name: _.name },
              type: "text",
              isMultiple: _.inputType === "multiSelect",
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
        if (_.inputType === "select" || _.inputType === "multiSelect") {
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
    }
  },
  mounted() {
    this.initGraph();
  }
};
</script>
