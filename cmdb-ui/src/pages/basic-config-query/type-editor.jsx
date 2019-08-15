import React from "react";
import PropTypes from "prop-types";
import { withStyles } from "@material-ui/core/styles";
import { Grid, MenuItem, TextField } from "@material-ui/core";
import CMDBDialog from "../../components/cmdb-dialog";
import { fetchBasicConfigCat, fetchAllCategories } from "../../apis/endpoints";
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

  state = {
    catTypes: [],
    categories: []
  };

  handleChange = prop => event => {
    event.persist();
    this.props.onFieldChange({ [prop]: event.target.value });
  };

  componentDidMount = async () => {
    const catTypes = await fetchBasicConfigCat();
    const categories = await fetchAllCategories();

    if (!(catTypes instanceof Error)) {
      this.setState({ catTypes });
    }
    if (!(categories instanceof Error)) {
      this.setState({ categories });
    }
  };

  render() {
    const { classes, values, visible, mode } = this.props;
    const { catTypes } = this.state;
    const title = mode === "edit" ? "编辑属性" : "新增属性";

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
                label="名称"
                value={values.catName || ""}
                onChange={this.handleChange("catName")}
                margin="normal"
                className={classes.textField}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                label="描述"
                value={values.description || ""}
                onChange={this.handleChange("description")}
                margin="normal"
                className={classes.textField}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                select
                label="类型"
                value={values.id || ""}
                onChange={this.handleChange("id")}
                margin="normal"
                className={classes.textField}
              >
                {catTypes.map(option => (
                  <MenuItem key={option.catTypeId} value={option.catTypeId}>
                    {option.catTypeName}
                  </MenuItem>
                ))}
              </TextField>
            </Grid>
            {/* <Grid item xs={12}>
              <TextField
                select
                label="类型"
                value={values.groupCodeId || ""}
                onChange={this.handleChange("groupCodeId")}
                margin="normal"
                className={classes.textField}
              >
                {categories.map(option => (
                  <MenuItem key={option.catId} value={option.catId}>
                    {option.catName}
                  </MenuItem>
                ))}
              </TextField>
            </Grid> */}
          </Grid>
        </form>
      </CMDBDialog>
    );
  }
}

export default withStyles(styles)(AttributeEditor);
