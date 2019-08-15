import React from "react";
import PropTypes from "prop-types";
import { withStyles } from "@material-ui/core/styles";
import { TextField } from "@material-ui/core";

const styles = theme => ({
  root: {
    display: "flex",
    alignItems: "center"
  },
  span: {
    marginTop: "20px"
  }
});

class CMDBTimePicker extends React.Component {
  state = {
    date: ["", ""]
  };

  handleInputChange = (dateIndex, event) => {
    const time = dateIndex === 0 ? " 00:00:00" : " 23:59:59";
    const date = [...this.state.date];
    date[dateIndex] = event.target.value ? event.target.value + time : "";
    this.setState({ date });
    this.props.onChange(this.props.label, date, "range");
  };

  render() {
    const { classes, label } = this.props;

    return (
      <div className={classes.root}>
        <TextField
          type="date"
          label={label}
          onChange={event => this.handleInputChange(0, event)}
          margin="normal"
          className={classes.textField}
          InputLabelProps={{
            shrink: true
          }}
        />
        <span className={classes.span}>-</span>
        <TextField
          type="date"
          label=" "
          onChange={event => this.handleInputChange(1, event)}
          margin="normal"
          className={classes.textField}
          InputLabelProps={{
            shrink: true
          }}
        />
      </div>
    );
  }
}

CMDBTimePicker.propTypes = {
  classes: PropTypes.object.isRequired,
  label: PropTypes.string.isRequired,
  onChange: PropTypes.func.isRequired
};

export default withStyles(styles)(CMDBTimePicker);
