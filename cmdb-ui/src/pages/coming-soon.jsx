import React from "react";
import { withStyles } from "@material-ui/core/styles";

const styles = theme => ({
  root: {
    width: "100%",
    textAlign: "center",
    fontSize: 120
  }
});

function ComingSoon(props) {
  const { classes } = props;
  return <h1 className={classes.root}>Coming Soon</h1>;
}

export default withStyles(styles)(ComingSoon);
