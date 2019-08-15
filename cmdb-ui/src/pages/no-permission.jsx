import React from "react";
import { withStyles } from "@material-ui/core/styles";

const styles = theme => ({
  root: {
    width: "100%",
    textAlign: "center"
  }
});

function NoPermission(props) {
  const { classes } = props;
  return <h1 className={classes.root}>您没有权限</h1>;
}

export default withStyles(styles)(NoPermission);
