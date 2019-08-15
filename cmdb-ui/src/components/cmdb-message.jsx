import React from "react";
import ReactDOM from "react-dom";
import CMDBSnackbar from "./cmdb-snackbar";

export default props => {
  const div = document.createElement("div");
  document.body.appendChild(div);
  const { variant = "success", message, ...rest } = props;
  ReactDOM.render(
    <CMDBSnackbar variant={variant} message={message} {...rest} />,
    div
  );
};
