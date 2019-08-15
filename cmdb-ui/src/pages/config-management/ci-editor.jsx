import React from "react";
import { withStyles, createStyles } from "@material-ui/core/styles";
import { ciFormConfig } from "./add-ci-form";
import { Paper, Grid, MenuItem, TextField } from "@material-ui/core";
import { connect } from "react-redux";
import CMDBDialog from "../../components/cmdb-dialog";
import {
  fetchZoomLevels,
  fetchCatalogMap,
  fetchCiTypeLayerMap
} from "../../apis/endpoints";

const styles = createStyles({
  root: {
    "& div[class^='MuiPaper-root']": {
      boxShadow: "none"
    }
  },
  textField: {
    width: "80%"
  },
  form: {
    padding: "0 20px 20px 20px"
  }
});

export const ciEditorConfig = {
  name: "",
  description: "",
  tableName: "",
  catalogId: 0,
  layerId: 5,
  zoomLevelId: "1",
  imageFileId: 0,
  ciTypeId: 0
};

class CiEditor extends React.Component {
  state = {
    form: ciFormConfig,
    open: false,
    layerMap: [],
    zoomLevelMap: [],
    catalogMap: []
  };

  handleChange = prop => event => {
    event.persist();
    this.props.onFieldChange({ [prop]: event.target.value });
  };

  componentDidMount = async () => {
    const catalogMap = await fetchCatalogMap();
    const zoomLevelMap = await fetchZoomLevels();
    const layerMap = await fetchCiTypeLayerMap();

    if (!(catalogMap instanceof Error)) {
      this.setState({ catalogMap });
    }
    if (!(zoomLevelMap instanceof Error)) {
      this.setState({ zoomLevelMap });
    }
    if (!(layerMap instanceof Error)) {
      this.setState({ layerMap });
    }
  };

  render() {
    const { classes, open, values, mode } = this.props;
    const { form, catalogMap, layerMap, zoomLevelMap } = this.state;
    const title = mode === "edit" ? "编辑CI" : "新增CI";
    return (
      <CMDBDialog
        visible={open}
        onCancel={this.props.onCancel}
        onOk={this.props.onOk}
        className={classes.root}
        title={title}
      >
        <Paper elevation={1} className={classes.paper}>
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
                  disabled={mode === "edit"}
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
            </Grid>
          </form>
        </Paper>
      </CMDBDialog>
    );
  }
}

const mapState = state => {
  return {
    selectedCatalog: state.configManagement.selectedCatalog
  };
};

const mapDispatch = dispatch => {
  return {
    ...dispatch.configManagement
  };
};

export default connect(
  mapState,
  mapDispatch
)(withStyles(styles)(CiEditor));
