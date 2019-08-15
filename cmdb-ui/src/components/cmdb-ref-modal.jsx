import React from "react";
import CMDBDialog from "./cmdb-dialog";
import QueryHeader from "./query-header";

function CMDBRefModal(props) {
  return (
    <CMDBDialog
      visible={props.visible}
      // visible={visible}
      // onCancel={this.props.onCancel}
      // onOk={this.props.onOk}
      title={"test"}
    >
      开发中
    </CMDBDialog>
  );
}

export default CMDBRefModal;
