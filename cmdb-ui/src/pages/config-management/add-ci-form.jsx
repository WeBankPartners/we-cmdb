import React from "react";
import PropTypes from "prop-types";
import { withStyles } from "@material-ui/core/styles";
import { Paper, Grid, MenuItem, TextField, Button } from "@material-ui/core";
import {
  fetchZoomLevels,
  fetchCatalogMap,
  fetchCiTypeLayerMap,
  updateCiType
} from "../../apis/endpoints";
import CMDBMessage from "../../components/cmdb-message";
import { connect } from "react-redux";

const styles = theme => {
  return {
    paper: {
      paddingTop: 10
    },
    form: {
      padding: "0 20px 20px 20px",
      textAlign: "left"
    },
    textField: {
      width: "80%"
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

export const ciFormConfig = {
  name: "",
  description: "",
  tableName: "",
  catalogId: 0,
  layerId: 0,
  zoomLevelId: "",
  imageFileId: 0,
  ciTypeId: 0
};

class CiForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      layerMap: [],
      zoomLevelMap: [],
      catalogMap: [],
      form: props.base
    };
  }

  handleChange = prop => event => {
    event.persist();
    this.props.onFieldChange({ [prop]: event.target.value });
  };

  componentDidMount = async () => {
    const catalogMap = await fetchCatalogMap();
    const zoomLevelMap = await fetchZoomLevels();
    const layerMap = await fetchCiTypeLayerMap();

    if (!(zoomLevelMap instanceof Error)) {
      this.setState({ zoomLevelMap });
    }
    if (!(catalogMap instanceof Error)) {
      this.setState({ catalogMap });
    }
    if (!(layerMap instanceof Error)) {
      this.setState({ layerMap });
    }
  };

  save = async () => {
    const { mode, values } = this.props;
    if (mode === "edit") {
      const res = await updateCiType(values);
      if (res === "Success") {
        CMDBMessage({
          message: `更新${values.name} CI 成功`
        });
      }
    } else {
      this.props.onSubmit();
    }
  };

  render() {
    const { classes, mode, values } = this.props;
    const { catalogMap, layerMap, zoomLevelMap } = this.state;
    const isEdit = mode === "edit";

    return (
      <div>
        <Paper elevation={1} className={classes.paper}>
          {isEdit && <p className={classes.title}>{values.name} CI</p>}
          <form action="" className={classes.form}>
            <Grid container>
              <Grid item xs={3}>
                <TextField
                  label="中文名"
                  value={values.name}
                  onChange={this.handleChange("name")}
                  margin="normal"
                  className={classes.textField}
                />
              </Grid>
              <Grid item xs={3}>
                <TextField
                  label="描述"
                  value={values.description}
                  onChange={this.handleChange("description")}
                  SelectProps={{
                    MenuProps: {
                      className: classes.input
                    }
                  }}
                  margin="normal"
                  className={classes.textField}
                >
                  {[{ key: 1, value: 2 }, { key: 3, value: 4 }].map(option => (
                    <MenuItem key={option.value} value={option.value}>
                      {option.value}
                    </MenuItem>
                  ))}
                </TextField>
              </Grid>
              <Grid item xs={3}>
                <TextField
                  disabled={isEdit}
                  label="英文名"
                  value={values.tableName}
                  onChange={this.handleChange("tableName")}
                  SelectProps={{
                    MenuProps: {
                      className: classes.input
                    }
                  }}
                  margin="normal"
                  className={classes.textField}
                />
              </Grid>
              <Grid item xs={3}>
                <TextField
                  select
                  label="目录"
                  value={values.catalogId}
                  onChange={this.handleChange("catalogId")}
                  SelectProps={{
                    MenuProps: {
                      className: classes.input
                    }
                  }}
                  margin="normal"
                  className={classes.textField}
                >
                  {catalogMap.map(option => (
                    <MenuItem key={option.codeId} value={option.codeId}>
                      {option.code}
                    </MenuItem>
                  ))}
                </TextField>
              </Grid>
              <Grid item xs={3}>
                <TextField
                  select
                  label="层"
                  value={values.layerId}
                  onChange={this.handleChange("layerId")}
                  margin="normal"
                  className={classes.textField}
                >
                  {layerMap.map(option => (
                    <MenuItem key={option.codeId} value={option.codeId}>
                      {option.code}
                    </MenuItem>
                  ))}
                </TextField>
              </Grid>
              <Grid item xs={3}>
                <TextField
                  select
                  label="Z轴"
                  value={values.zoomLevelId}
                  onChange={this.handleChange("zoomLevelId")}
                  margin="normal"
                  className={classes.textField}
                >
                  {zoomLevelMap.map(option => (
                    <MenuItem key={option.codeId} value={option.codeId}>
                      {option.code}
                    </MenuItem>
                  ))}
                </TextField>
              </Grid>
              <Grid item xs={3}>
                <TextField
                  select
                  label="图标"
                  value={values.imageFileId}
                  onChange={this.handleChange("imageFileId")}
                  margin="normal"
                  className={classes.textField}
                >
                  {[{ key: 1, value: 2 }, { key: 3, value: 4 }].map(option => (
                    <MenuItem key={option.value} value={option.value}>
                      {option.value}
                    </MenuItem>
                  ))}
                </TextField>
              </Grid>
              {isEdit && (
                <Grid item xs={12} className={classes.save}>
                  <Button
                    variant="contained"
                    color="primary"
                    onClick={this.save}
                  >
                    保存
                  </Button>
                </Grid>
              )}
            </Grid>
          </form>
        </Paper>
      </div>
    );
  }
}

CiForm.defaultProps = {
  mode: "edit",
  base: {},
  values: ciFormConfig
};
CiForm.propTypes = {
  mode: PropTypes.string,
  base: PropTypes.object.isRequired,
  values: PropTypes.object.isRequired,
  onFieldChange: PropTypes.func.isRequired
};

const StyledCiForm = withStyles(styles)(CiForm);

const mapState = state => {
  return {
    activedCI: state.configManagement.activedCI
  };
};

const mapDispatch = dispatch => {
  return {};
};

export default connect(
  mapState,
  mapDispatch
)(StyledCiForm);
