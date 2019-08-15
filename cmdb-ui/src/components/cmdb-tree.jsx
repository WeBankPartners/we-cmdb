import React from "react";
import { withStyles } from "@material-ui/core/styles";
import { Checkbox } from "@material-ui/core";

const styles = theme => ({});

function CMDBTree(props) {
  const { sourceData } = props;
  const level = props.level || 1;

  const handliCheckboxClick = node => {
    if (level > 1) {
      props.handleChangeToRoot(node);
    } else {
      const result = findCheckboxChange(sourceData, node).data;
      props.handleDataChange(result);
    }
  };

  const findCheckboxChange = (data, node) => {
    let found = false;
    const result = data.map(_ => {
      if (_.treeId === node.treeId) {
        found = true;
        _.checked = !_.checked;
        if (_.children) {
          childrenCheckboxChange(_.children, _.checked);
        }
      } else {
        if (_.children) {
          const children = findCheckboxChange(_.children, node);
          _.children = children.data;
          if (children.found) {
            found = true;
            if (node.checked) {
              let checked = true;
              _.children.forEach(item => {
                if (!item.checked) {
                  checked = false;
                }
              });
              _.checked = checked;
            } else {
              _.checked = false;
            }
          }
        }
      }
      return _;
    });
    return { data: result, found };
  };

  const childrenCheckboxChange = (data, checked) => {
    data.forEach(_ => {
      _.checked = checked;
      if (_.children) {
        childrenCheckboxChange(_.children, _.checked);
      }
    });
  };

  return (
    <div style={{ paddingLeft: level > 1 ? 35 : 0 }}>
      {sourceData.map(_ => (
        <div key={_.treeId}>
          <Checkbox
            checked={_.checked}
            onClick={() => handliCheckboxClick(_)}
            color="primary"
          />
          <span>{_.title}</span>
          {_.children && _.children.length && (
            <CMDBTree
              sourceData={_.children}
              handleChangeToRoot={handliCheckboxClick}
              level={level + 1}
            />
          )}
        </div>
      ))}
    </div>
  );
}

export default withStyles(styles)(CMDBTree);
