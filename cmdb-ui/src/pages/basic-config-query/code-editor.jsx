import React from "react";
import PropTypes from "prop-types";
import { withStyles } from "@material-ui/core/styles";
import { Grid, TextField } from "@material-ui/core";
import CMDBDialog from "../../components/cmdb-dialog";

const styles = theme => {
  return {
    form: {
      padding: "0 20px 20px 20px",
      textAlign: "left",
      width: 500
    },
    textField: {
      width: "100%"
    },
    title: {
      paddingLeft: 20,
      color: theme.palette.text.primary,
      fontSize: 22,
      textAlign: "left",
      margin: 0
    },
    save: {
      textAlign: "right",
      marginTop: 10
    }
  };
};

class AttributeEditor extends React.Component {
  static defaultProps = {
    mode: "edit"
  };

  static propTypes = {
    values: PropTypes.object.isRequired,
    onCancel: PropTypes.func.isRequired,
    visible: PropTypes.bool.isRequired,
    onFieldChange: PropTypes.func.isRequired
  };

  handleChange = prop => event => {
    event.persist();
    this.props.onFieldChange({ [prop]: event.target.value });
  };

  render() {
    const { classes, values, visible, mode } = this.props;
    const title = mode === "edit" ? "编辑编码" : "新增编码";

    return (
      <CMDBDialog
        visible={visible}
        onCancel={this.props.onCancel}
        onOk={this.props.onOk}
        title={title}
      >
        <form className={classes.form}>
          <Grid container direction="column">
            <Grid item xs={12}>
              <TextField
                label="编码"
                value={values.code || ""}
                onChange={this.handleChange("code")}
                margin="normal"
                className={classes.textField}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                label="值"
                value={values.value || ""}
                onChange={this.handleChange("value")}
                margin="normal"
                className={classes.textField}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                label="描述"
                value={values.codeDescription || ""}
                onChange={this.handleChange("codeDescription")}
                margin="normal"
                className={classes.textField}
              />
            </Grid>
          </Grid>
        </form>
      </CMDBDialog>
    );
  }
}

export default withStyles(styles)(AttributeEditor);
