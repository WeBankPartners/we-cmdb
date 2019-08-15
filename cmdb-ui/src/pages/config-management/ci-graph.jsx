import React, { useEffect, useState, useRef } from "react";
import { withStyles, createStyles } from "@material-ui/core/styles";
import { Popover, Button, Tabs, Tab } from "@material-ui/core";
import vis from "vis";
import CheckboxList from "../../components/checkbox-list";
import {
  fetchCiReferBy,
  fetchCiReferTo,
  fetchCiTypeAttrs
} from "../../apis/endpoints";

// import 'd3-graphviz';

const styles = createStyles({
  root: {
    width: "100%",
    height: 600,
    margin: "0 auto"
  }
});

function deduplicate(data) {
  const ret = [];
  data.forEach(d => {
    let found = ret.find(_ => d.label === _.label);
    if (!found) ret.push(d);
  });

  return ret;
}

// function createNode(item) {
// 	return { id: item.label, label: item.label, shape: 'box', group: item.index }
// }

function createNode(item) {
  return {
    id: `${item.label || item.name}`,
    label: `${item.label || item.name}`,
    shape: "box"
  };
}

function createNodes(nodes) {
  let t = [];

  Object.keys(nodes).forEach(id => {
    t.push(createNode(nodes[id].node));
    if (nodes[id].from) {
      nodes[id].from.forEach(_ => {
        if (_ && !nodes[_.ciTypeId]) {
          t.push(createNode(_));
        }
      });
    }
    if (nodes[id].to) {
      nodes[id].to.forEach(_ => {
        if (_ && !nodes[_.ciTypeId]) {
          t.push(createNode(_));
        }
      });
    }
  });

  return t;
}

function createEdges(nodes) {
  const nodeKeys = Object.keys(nodes);
  let t = [];
  nodeKeys.forEach(key => {
    const froms = nodes[key].from;
    if (froms && Array.isArray(froms)) {
      t = t.concat(
        froms.map(_ => {
          return {
            from: nodes[key].node.label,
            to: _.label,
            arrows: {
              to: true
            },
            physics: false
          };
        })
      );
    }
    const tos = nodes[key].to;
    if (tos && Array.isArray(tos)) {
      t = t.concat(
        tos.map(_ => {
          return {
            from: nodes[key].node.label,
            to: _.label,
            arrows: {
              to: {
                enabled: true,
                type: "circle"
              }
            },
            physics: false
          };
        })
      );
    }
  });

  return t;
}

function deleteRemovedNode(host, targets) {
  targets.forEach(target => {
    delete host[target.label];
  });
}

function findRemovedNode(pre, cur, cb) {
  const ret = [];
  if (Array.isArray(pre) && Array.isArray(cur)) {
    pre.forEach(item => {
      if (!cur.find(c => c.label === item.label)) {
        ret.push(item);
      }
    });
  }

  return ret;
}

const visOptions = {
  interaction: {
    hover: true
  },
  edges: {
    smooth: {
      type: "cubicBezier",
      forceDirection: "horizontal",
      roundness: 1
    }
  },
  layout: {
    hierarchical: {
      direction: "LR"
    }
  }
  // physics: false
};

let indexMap = {};

function calIndex(label) {
  const splitedIndex = label.split("-");
  if (splitedIndex[0] === label) {
    indexMap[1] = 1;
    return 1;
  } else {
    if (!isNaN(Number(splitedIndex[0])) && !isNaN(Number(splitedIndex[1]))) {
      indexMap[splitedIndex[0]] = splitedIndex[1];
      return Number(splitedIndex[0]);
    }
  }
}
function generateCiRelation(cis) {
  if (!cis) return {};
  indexMap = {};
  const ret = {};

  function helper(root) {
    if (!root) return;
    const label = root.name;
    ret[label] = {
      from: [],
      to: [],
      node: {
        label,
        ciTypeId: root.ciTypeId,
        index: calIndex(root.name)
      }
    };

    if (!root.children) return;

    root.children.map(child => {
      const node = {
        attrId: child.parentRs.attrId,
        label: child.name,
        ciTypeId: child.ciTypeId,
        index: calIndex(child.name)
      };

      if (child.parentRs.isReferedFromParent) {
        ret[label].to.push(node);
      } else {
        ret[label].from.push(node);
      }

      helper(child);

      return null;
    });
  }

  helper(cis);

  return ret;
}

function CiGraph(props) {
  const [isSwitcherOpen, setIsSwitcherOpen] = useState(false);
  const [pos, setPosition] = useState({ left: 0, top: 0 });
  const [tabValue, setTabValue] = useState(0);
  const [isRefPanelOpen, setIsRefPanelOpen] = useState(false);
  const [isAttrPanelOpen, setIsAttrPanelOpen] = useState(false);
  const [referBys, setReferBys] = useState([]);
  const [referTos, setReferTos] = useState([]);
  const [refsOfNode, setRefsOfNode] = useState({ tos: [], bys: [] });
  const [ciTypeAttrs, setCiTypeAttrs] = useState([]);
  const [selectedAttrs, setSelectedAttrs] = useState([]);

  const savedNetWork = useRef();
  const savedClickedNode = useRef();
  const savedRenderedNodes = useRef();
  const savedSelectedRefs = useRef({ tos: [], bys: [] });

  const toShowRefPanel = async () => {
    setIsRefPanelOpen(true);
    setIsSwitcherOpen(false);

    const referBys = await fetchCiReferBy(
      savedClickedNode.current.node.ciTypeId
    );
    const referTos = await fetchCiReferTo(
      savedClickedNode.current.node.ciTypeId
    );
    if (!(referBys instanceof Error)) {
      // TODO: transform
      setReferBys(referBys);
    }

    if (!(referTos instanceof Error)) {
      // TODO: transform
      setReferTos(referTos);
    }
  };

  const toShowAttrPanel = async () => {
    const data = await fetchCiTypeAttrs(savedClickedNode.current.node.ciTypeId);
    if (!(data instanceof Error)) {
      setCiTypeAttrs(data);
      setSelectedAttrs(savedClickedNode.current.node.attrs || []);
    }
    setIsAttrPanelOpen(true);
    setIsSwitcherOpen(false);
  };

  const handleReferByChange = node => {
    savedSelectedRefs.current.bys = node;
    setRefsOfNode({ bys: node, tos: refsOfNode.tos });
  };

  const handleReferToChange = node => {
    savedSelectedRefs.current.tos = node;
    setRefsOfNode({ tos: node, bys: refsOfNode.bys });
  };

  const destroy = function() {
    if (savedNetWork.current !== null) {
      savedNetWork.current.destroy();
      savedNetWork.current = null;
    }
  };

  const handleRefPanelClose = () => {
    const nodes = [];
    const selectedNode = savedClickedNode.current;
    const parentIndex = selectedNode.node.index;
    const selectedNodeLabel = selectedNode.node.label;
    const childIndexBase = Number(String(parentIndex || 1).split("-")[0]) + 1;
    if (savedSelectedRefs.current.bys.length) {
      savedSelectedRefs.current.bys.forEach(by => {
        const found = referBys
          .map(_ => {
            let currentIndex;
            if (indexMap[childIndexBase]) {
              currentIndex = `${childIndexBase}-${Number(
                indexMap[childIndexBase]
              ) + 1}`;
            } else {
              currentIndex = `${childIndexBase}-1`;
            }

            // 如果已经存在froms中 则不重复计算
            const existNode = savedClickedNode.current.from.find(
              // eslint-disable-next-line
              _ => _.ciTypeId == by.ciTypeId
            );
            if (existNode) {
              return existNode;
            }
            // eslint-disable-next-line
            if (_.ciTypeId == by.ciTypeId) {
              indexMap[childIndexBase] =
                Number(indexMap[childIndexBase] || 0) + 1;
              const label = `${currentIndex}-${_.name}-${_.refName}`;
              const node = {
                ..._,
                label,
                index: currentIndex
              };
              savedRenderedNodes.current[label] = {
                node,
                from: [],
                to: []
              };

              return node;
            }

            return null;
          })
          .filter(_ => _)[0];

        found && nodes.push(found);
      });

      const removed = findRemovedNode(selectedNode.from, nodes);
      if (removed.length) {
        deleteRemovedNode(savedRenderedNodes.current, removed);
      }

      savedRenderedNodes.current[selectedNodeLabel] = {
        to: selectedNode.to,
        node: selectedNode.node,
        from: [...nodes]
      };
    } else if (savedSelectedRefs.current.bys.length === 0) {
      deleteRemovedNode(
        savedRenderedNodes.current,
        savedRenderedNodes.current[selectedNodeLabel].from
      );

      savedRenderedNodes.current[selectedNodeLabel].from = [];
    }

    nodes.length = 0;

    if (savedSelectedRefs.current.tos.length) {
      savedSelectedRefs.current.tos.forEach(to => {
        const found = referTos
          .map(_ => {
            let currentIndex;
            if (indexMap[childIndexBase]) {
              currentIndex = `${childIndexBase}-${Number(
                indexMap[childIndexBase]
              ) + 1}`;
            } else {
              currentIndex = `${childIndexBase}-1`;
            }

            //如果已经存在froms中 则不重复计算
            const existNode = savedClickedNode.current.to.find(
              _ => _.ciTypeId === to.ciTypeId
            );
            if (existNode) {
              return existNode;
            }
            // eslint-disable-next-line
            if (_.ciTypeId == to.ciTypeId) {
              indexMap[childIndexBase] =
                Number(indexMap[childIndexBase] || 0) + 1;
              const label = `${currentIndex}-${_.name}-${_.refName}`;
              const node = {
                ..._,
                label,
                index: currentIndex
              };
              savedRenderedNodes.current[label] = {
                node,
                from: [],
                to: []
              };
              return node;
            }

            return null;
          })
          .filter(_ => _)[0];

        found && nodes.push(found);
      });

      const removed = findRemovedNode(selectedNode.to, nodes);
      if (removed.length) {
        deleteRemovedNode(savedRenderedNodes.current, removed);
      }

      savedRenderedNodes.current[selectedNodeLabel] = {
        to: [...nodes],
        node: selectedNode.node,
        from: savedRenderedNodes.current[selectedNodeLabel].from
      };
    } else if (savedSelectedRefs.current.tos.length === 0) {
      deleteRemovedNode(
        savedRenderedNodes.current,
        savedRenderedNodes.current[selectedNodeLabel].to
      );

      savedRenderedNodes.current[selectedNodeLabel].to = [];
    }

    destroy();

    // create a network
    var container = document.getElementById("mynetwork");
    var data = {
      nodes: deduplicate(createNodes(savedRenderedNodes.current)),
      edges: createEdges(savedRenderedNodes.current)
    };

    const network = new vis.Network(container, data, visOptions);
    savedNetWork.current = network;

    props.onChange && props.onChange(savedRenderedNodes.current);

    setIsRefPanelOpen(false);
    savedSelectedRefs.current.bys = [];
    savedSelectedRefs.current.tos = [];
  };

  const handleciTypeAttrChange = values => {
    setSelectedAttrs(values);
    savedClickedNode.current.node.attrs = values;
  };

  const toCloseAttrPanel = () => {
    setIsAttrPanelOpen(false);
    props.onChange && props.onChange(savedRenderedNodes.current);
  };

  // calculate ci relationship and render
  useEffect(() => {
    savedRenderedNodes.current = generateCiRelation(props.data);
    let container = document.getElementById("mynetwork");
    let data = {
      nodes: deduplicate(createNodes(savedRenderedNodes.current)),
      edges: createEdges(savedRenderedNodes.current)
    };

    const network = new vis.Network(container, data, visOptions);
    savedNetWork.current = network;
  }, [props.data]);

  // bind event
  useEffect(() => {
    const handler = e => {
      if (e.nodes.length === 0) return;
      savedClickedNode.current = savedRenderedNodes.current[e.nodes[0]];
      if (!savedClickedNode.current) {
        // 从from和to中寻找当前点击node label === e.nodes[0]
        const keys = Object.keys(savedRenderedNodes.current);
        for (let i = 0; i < keys.length; i++) {
          const key = keys[i];
          const { from, to } = savedRenderedNodes.current[key];
          for (let j = 0; j < from.length; j++) {
            const node = from[j];
            if (node.label === e.nodes[0]) {
              savedClickedNode.current = {
                node,
                from: [],
                to: []
              };
              break;
            }
          }

          if (savedClickedNode.current) break;

          for (let k = 0; k < to.length; k++) {
            const node = to[k];
            if (node.label === e.nodes[0]) {
              savedClickedNode.current = {
                node,
                from: [],
                to: []
              };
              break;
            }
          }

          if (savedClickedNode.current) break;
        }
      }

      savedSelectedRefs.current.bys = savedClickedNode.current.from;
      savedSelectedRefs.current.tos = savedClickedNode.current.to;
      setRefsOfNode({
        tos: savedClickedNode.current.to,
        bys: savedClickedNode.current.from
      });

      // 收集当前node的引用和被引用
      setPosition({ left: e.event.center.x, top: e.event.center.y });
      setIsSwitcherOpen(true);
    };
    savedNetWork.current.on("click", handler);

    return () => {
      savedNetWork.current.off("click", handler);
    };
  });

  const { classes } = props;

  return (
    <>
      <div id="mynetwork" className={classes.root} />
      <Popover
        open={isSwitcherOpen}
        onClose={() => setIsSwitcherOpen(false)}
        anchorReference="anchorPosition"
        anchorPosition={pos}
        anchorOrigin={{
          vertical: "top",
          horizontal: "left"
        }}
        transformOrigin={{
          vertical: "top",
          horizontal: "left"
        }}
      >
        <div>
          <Button onClick={toShowRefPanel}>引用</Button>
          <Button onClick={toShowAttrPanel}>属性</Button>
        </div>
      </Popover>
      <Popover
        open={isRefPanelOpen}
        onClose={handleRefPanelClose}
        anchorReference="anchorPosition"
        anchorPosition={pos}
        anchorOrigin={{
          vertical: "top",
          horizontal: "left"
        }}
        transformOrigin={{
          vertical: "top",
          horizontal: "left"
        }}
      >
        <Tabs
          value={tabValue}
          indicatorColor="primary"
          textColor="primary"
          onChange={(e, value) => setTabValue(value)}
        >
          <Tab label="被引用" />
          <Tab label="引用" />
        </Tabs>
        {tabValue === 0 && (
          <CheckboxList
            multiple
            options={referBys}
            optLabels={["ciTypeId", "name"]}
            onChange={handleReferByChange}
            value={refsOfNode.bys}
          />
        )}
        {tabValue === 1 && (
          <CheckboxList
            multiple
            options={referTos}
            optLabels={["ciTypeId", "name"]}
            onChange={handleReferToChange}
            value={refsOfNode.tos}
          />
        )}
      </Popover>
      <Popover
        open={isAttrPanelOpen}
        onClose={toCloseAttrPanel}
        anchorReference="anchorPosition"
        anchorPosition={pos}
        anchorOrigin={{
          vertical: "top",
          horizontal: "left"
        }}
        transformOrigin={{
          vertical: "top",
          horizontal: "left"
        }}
      >
        <CheckboxList
          multiple
          options={ciTypeAttrs}
          optLabels={["ciTypeAttrId", "name"]}
          onChange={handleciTypeAttrChange}
          value={selectedAttrs}
        />
      </Popover>
    </>
  );
}

CiGraph.defaultProps = {
  data: {}
};

export default withStyles(styles)(CiGraph);
