import React from "react";
import PropTypes from "prop-types";
import { withStyles } from "@material-ui/core/styles";
import { FormControl, Grid, TextField, InputLabel } from "@material-ui/core";
import CMDBSelect from "./cmdb-select";
import CMDBTimePicker from "./cmdb-timePicker";

const styles = theme => ({});

function QueryHeader(props) {
  const { columns, classes, data, keys, isQuery } = props;

  const handleInputChange = key => event => {
    if (Array.isArray(event)) {
      props.onChange(key, event.map(_ => _.id), "in");
    } else {
      props.onChange(key, event.target.value, "contains");
    }
  };

  const handlePickerChange = (key, value, operator) => {
    props.onChange(key, value, operator);
  };

  const renderInputComponent = _ => {
    switch (_.inputType) {
      case "select":
        const value = data[_[keys[1]]] ? data[_[keys[1]]].value : null;
        return (
          <FormControl
            margin="normal"
            disabled={_.isEditable === false && !isQuery}
          >
            <InputLabel htmlFor="select">{_[keys[0]]}</InputLabel>
            <CMDBSelect
              id="select"
              data={value}
              options={_.vals || []}
              optLabels={["id", "code"]}
              onChange={handleInputChange(_[keys[1]])}
            />
          </FormControl>
        );
      case "date":
        return <CMDBTimePicker label={_.name} onChange={handlePickerChange} />;
      case "datetime":
        return (
          <TextField
            disabled={_.isEditable === false && !isQuery}
            type="date"
            label={_[keys[0]]}
            onChange={handleInputChange(_[keys[1]])}
            margin="normal"
            className={classes.textField}
            InputLabelProps={{
              shrink: true
            }}
          />
        );
      default:
        return (
          <TextField
            disabled={_.isEditable === false && !isQuery}
            label={_[keys[0]]}
            value={
              data[_[keys[1]]]
                ? data[_[keys[1]]].value
                  ? data[_[keys[1]]].value
                  : ""
                : ""
            }
            onChange={handleInputChange(_[keys[1]])}
            margin="normal"
            className={classes.textField}
          />
        );
    }
  };

  return (
    <Grid container>
      {columns.map((_, index) => {
        return (
          !_.isHidden && (
            <Grid item xl={3} md={3} key={index}>
              {renderInputComponent(_)}
            </Grid>
          )
        );
      })}
    </Grid>
  );
}

QueryHeader.propTypes = {
  columns: PropTypes.array.isRequired,
  data: PropTypes.object.isRequired,
  keys: PropTypes.array.isRequired // 1th is option value label, 2th is option key label
};

export default withStyles(styles)(QueryHeader);
