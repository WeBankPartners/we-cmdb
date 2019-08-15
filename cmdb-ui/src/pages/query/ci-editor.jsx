import React from "react";
import PropTypes from "prop-types";
import CMDBDialog from "../../components/cmdb-dialog";
import QueryHeader from "../../components/query-header";

function CiEditor(props) {
  const { columns, visible, title } = props;

  return (
    <CMDBDialog
      visible={visible}
      onCancel={props.onCancel}
      onOk={props.onOk}
      title={title}
    >
      <QueryHeader
        data={props.values}
        keys={["name", "propertyName"]}
        columns={columns}
        onChange={props.onChange}
      />
    </CMDBDialog>
  );
}

CiEditor.propTypes = {
  columns: PropTypes.array.isRequired,
  visible: PropTypes.bool.isRequired,
  onCancel: PropTypes.func.isRequired,
  onOk: PropTypes.func.isRequired
};

export default CiEditor;
