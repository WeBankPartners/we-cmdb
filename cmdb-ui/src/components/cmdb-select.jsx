import React from "react";
import PropTypes from "prop-types";
import { Input, Popover } from "@material-ui/core";
import CheckboxList from "./checkbox-list";

export default class CMDBSelect extends React.Component {
  state = {
    anchorEl: null,
    inputVal: "",
    checkeds: []
  };

  static propTypes = {
    options: PropTypes.array,
    onChange: PropTypes.func.isRequired,
    value: PropTypes.array,
    optLabels: PropTypes.array.isRequired, // 1th is option key label, 2th is option value label
    onFetch: PropTypes.func
  };

  handleClick = event => {
    this.setState({
      anchorEl: event.currentTarget
    });
  };

  handleInputchange = event => {
    this.setState({
      inputVal: event.target.value
    });
  };

  handleCheckboxListChange = values => {
    this.setState({
      inputVal: values.map(_ => _[this.props.optLabels[1]]).join(","),
      checkeds: values
    });

    this.props.onChange && this.props.onChange(values);
  };

  handleClose = () => {
    this.setState({
      anchorEl: null
    });
  };

  componentDidMount = () => {
    const { options, optLabels, data } = this.props;
    if (!data) return;
    const found = options.find(_ => _[optLabels[0]] === data);
    if (found) {
      this.setState({ inputVal: found[optLabels[1]], checkeds: [found] });
    }
  };

  render() {
    const { options, optLabels, multiple } = this.props;
    const { anchorEl, inputVal } = this.state;
    const open = Boolean(anchorEl);

    return (
      <>
        <Input
          aria-owns={open ? "simple-popper" : undefined}
          aria-haspopup="true"
          value={inputVal}
          onClick={this.handleClick}
          onChange={this.handleInputchange}
        />
        <Popover
          id="simple-popper"
          open={open}
          anchorEl={anchorEl}
          onClose={this.handleClose}
          anchorOrigin={{
            vertical: "bottom",
            horizontal: "left"
          }}
          transformOrigin={{
            vertical: "top",
            horizontal: "left"
          }}
        >
          <CheckboxList
            multiple={multiple}
            options={options}
            optLabels={optLabels}
            onChange={this.handleCheckboxListChange}
            onFetch={this.props.onFetch}
            value={this.state.checkeds}
          />
        </Popover>
      </>
    );
  }
}
