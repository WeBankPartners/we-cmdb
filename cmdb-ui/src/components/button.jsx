import React from "react";
import classNames from "classnames";
import { withStyles } from "@material-ui/core/styles";
import Button from "@material-ui/core/Button";

const styles = {
  default: {
    background: "#fff"
  }
};

function CMDBButton(props) {
  const { color = "default", children, className, classes, ...other } = props;

  return (
    <Button className={classNames(classes[color], className)} {...other}>
      {children}
    </Button>
  );
}

export default withStyles(styles)(CMDBButton);
