import React from "react";
import PropTypes from "prop-types";
import { withStyles } from "@material-ui/core/styles";
import {
  Grid,
  MenuItem,
  TextField,
  FormControl,
  InputLabel
} from "@material-ui/core";
import CMDBDialog from "../../components/cmdb-dialog";
import CMDBSelect from "../../components/cmdb-select";
import { connect } from "react-redux";
import { fetchAllCiTypes, fetchAllCategories } from "../../apis/endpoints";

const styles = theme => {
  return {
    form: {
      padding: "0 20px 20px 20px",
      textAlign: "left",
      width: 700
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

export const attributeEditorConfig = {
  name: "",
  description: "",
  propertyName: "",
  propertyType: "varchar",
  inputType: "text",
  searchSeqNo: 0,
  displaySeqNo: 0,
  isNullable: 0,
  isUnique: 0,
  isDefunct: 0,
  isSystem: 0,
  isDisplayable: 0,
  length: 0,
  referenceId: 0
};

const boolOpts = [{ value: 1, label: "是" }, { value: 0, label: "否" }];

const showTypeOpts = [
  { value: true, label: "展示" },
  { value: false, label: "不展示" }
];

export const inputTypeOpts = [
  { label: "文字", value: "text" },
  { label: "数字", value: "number" },
  { label: "日期", value: "date" },
  { label: "文本域", value: "textArea" },
  { label: "下拉", value: "select" },
  { label: "多选下拉", value: "multiSelect" },
  { label: "引用", value: "ref" },
  { label: "多选引用", value: "multiRef" }
];

export const propertyTypeMap = {
  text: "varchar",
  number: "int",
  date: "datetime",
  textArea: "varchar",
  select: "int",
  multiSelect: "varchar",
  ref: "varchar",
  multiRef: "varchar"
};

class AttributeEditor extends React.Component {
  static propTypes = {
    values: PropTypes.object.isRequired,
    onCancel: PropTypes.func.isRequired,
    visible: PropTypes.bool.isRequired,
    onFieldChange: PropTypes.func.isRequired
  };

  state = {
    dynamicSelect: []
  };

  optLabels = [];

  handleChange = prop => event => {
    if (Array.isArray(event)) {
      this.props.onFieldChange({ [prop]: event.toString() });
    } else {
      event.persist();
      this.props.onFieldChange({ [prop]: event.target.value });
    }

    if (prop === "inputType") {
      if (event.target.value === "select") {
        fetchAllCategories().then(data => {
          this.setState({ dynamicSelect: data });
        });
        this.optLabels = ["catId", "catName"];
      }
      if (event.target.value === "ref") {
        fetchAllCiTypes().then(data => {
          this.setState({ dynamicSelect: data });
        });
        this.optLabels = ["ciTypeId", "name"];
      }
    }
  };

  async componentDidMount() {
    if (this.props.values.inputType === "ref") {
      fetchAllCiTypes().then(data => {
        this.setState({ dynamicSelect: data });
      });
      this.optLabels = ["ciTypeId", "name"];
    } else if (this.props.values.inputType === "select") {
      fetchAllCategories().then(data => {
        this.setState({ dynamicSelect: data });
      });
      this.optLabels = ["catId", "catName"];
    }
  }

  render() {
    const { classes, values, visible, mode } = this.props;
    const isEdit = mode === "edit";
    const title = isEdit ? "编辑 CI Type 属性" : "新增 CI Type 属性";

    return (
      <CMDBDialog
        visible={visible}
        onCancel={this.props.onCancel}
        onOk={this.props.onOk}
        title={title}
      >
        <form className={classes.form}>
          <Grid container>
            <Grid item xs={4}>
              <Grid container direction="column">
                <Grid item xs={12}>
                  <TextField
                    label="中文名"
                    value={values.name}
                    onChange={this.handleChange("name")}
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
                    disabled={isEdit}
                    label="真实列名"
                    value={values.propertyName}
                    onChange={this.handleChange("propertyName")}
                    margin="normal"
                    className={classes.textField}
                  />
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    disabled
                    label="真实类型"
                    value={values.propertyType}
                    onChange={this.handleChange("propertyType")}
                    margin="normal"
                    className={classes.textField}
                  />
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    label="长度"
                    value={values.length}
                    onChange={this.handleChange("length")}
                    margin="normal"
                    className={classes.textField}
                  />
                </Grid>
              </Grid>
            </Grid>

            <Grid item xs={4}>
              <Grid container direction="column">
                <Grid item xs={12}>
                  <TextField
                    select
                    label="输入类型"
                    value={values.inputType || ""}
                    onChange={this.handleChange("inputType")}
                    margin="normal"
                    className={classes.textField}
                  >
                    {inputTypeOpts.map(option => (
                      <MenuItem key={option.value} value={option.value}>
                        {option.label}
                      </MenuItem>
                    ))}
                  </TextField>
                </Grid>
                {values.inputType === "select" && (
                  <Grid item xs={12}>
                    <FormControl margin="normal">
                      <InputLabel htmlFor="select">枚举值</InputLabel>
                      <CMDBSelect
                        id="select"
                        options={this.state.dynamicSelect}
                        optLabels={this.optLabels}
                        onChange={this.handleChange("referenceId")}
                      />
                    </FormControl>
                  </Grid>
                )}
                {/* <Grid item xs={12}>
                  <TextField
                    type="number"
                    label="搜索条件序号"
                    value={values.searchSeqNo}
                    onChange={this.handleChange("searchSeqNo")}
                    margin="normal"
                    className={classes.textField}
                  />
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    type="number"
                    label="展示排序"
                    value={values.displaySeqNo}
                    onChange={this.handleChange("displaySeqNo")}
                    margin="normal"
                    className={classes.textField}
                  />
                </Grid> */}
              </Grid>
            </Grid>

            <Grid item xs={4}>
              <Grid container direction="column">
                <Grid item xs={12}>
                  <TextField
                    select
                    label="是否为空"
                    value={
                      values.isNullable === void 0 ? "" : values.isNullable
                    }
                    onChange={this.handleChange("isNullable")}
                    margin="normal"
                    className={classes.textField}
                  >
                    {boolOpts.map(option => (
                      <MenuItem key={option.value} value={option.value}>
                        {option.label}
                      </MenuItem>
                    ))}
                  </TextField>
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    select
                    label="是否唯一"
                    value={values.isUnique === void 0 ? "" : values.isUnique}
                    onChange={this.handleChange("isUnique")}
                    margin="normal"
                    className={classes.textField}
                  >
                    {boolOpts.map(option => (
                      <MenuItem key={option.value} value={option.value}>
                        {option.label}
                      </MenuItem>
                    ))}
                  </TextField>
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    select
                    label="是否丢弃"
                    value={values.isDefunct === void 0 ? "" : values.isDefunct}
                    onChange={this.handleChange("isDefunct")}
                    margin="normal"
                    className={classes.textField}
                  >
                    {boolOpts.map(option => (
                      <MenuItem key={option.value} value={option.value}>
                        {option.label}
                      </MenuItem>
                    ))}
                  </TextField>
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    select
                    label="是否系统"
                    value={values.isSystem === void 0 ? "" : values.isSystem}
                    onChange={this.handleChange("isSystem")}
                    margin="normal"
                    className={classes.textField}
                  >
                    {boolOpts.map(option => (
                      <MenuItem key={option.value} value={option.value}>
                        {option.label}
                      </MenuItem>
                    ))}
                  </TextField>
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    select
                    label="是否展示"
                    value={
                      values.isDisplayType === void 0
                        ? ""
                        : values.isDisplayType
                    }
                    onChange={this.handleChange("isDisplayType")}
                    margin="normal"
                    className={classes.textField}
                  >
                    {showTypeOpts.map(option => (
                      <MenuItem key={option.value} value={option.value}>
                        {option.label}
                      </MenuItem>
                    ))}
                  </TextField>
                </Grid>
              </Grid>
            </Grid>
          </Grid>
        </form>
      </CMDBDialog>
    );
  }
}

const StyledCiForm = withStyles(styles)(AttributeEditor);

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
