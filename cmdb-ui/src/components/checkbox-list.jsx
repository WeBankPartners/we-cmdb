import React from "react";
import PropTypes from "prop-types";
import { withStyles } from "@material-ui/core/styles";
import { debounce } from "lodash";
import {
  Input,
  FormGroup,
  FormControlLabel,
  Checkbox,
  FormControl
} from "@material-ui/core";

const styles = theme => ({
  form: {
    minWidth: 200,
    width: "auto",
    padding: "10px 20px"
  },
  options: {
    display: "flex",
    flexDirection: "column",
    flexWrap: "nowrap",
    maxHeight: 350,
    overflowY: "auto"
  },
  item: {
    flexShrink: 0
  }
});

class CheckboxList extends React.Component {
  state = {
    optValues: {},
    indeterminate: false,
    isAllSeleced: false,
    filteredOpts: [],
    search: ""
  };

  static propTypes = {
    classes: PropTypes.object.isRequired,
    options: PropTypes.array,
    onChange: PropTypes.func.isRequired,
    multiple: PropTypes.bool,
    optLabels: PropTypes.array.isRequired, // 1th is option key label, 2th is option value label
    onFetch: PropTypes.func
  };

  static defaultProps = {
    multiple: false
  };

  static getDerivedStateFromProps = (nextProp, preState) => {
    if ("value" in nextProp) {
      const { value } = nextProp;
      let isAllSeleced = false;
      let indeterminate = false;
      if (nextProp.options && nextProp.options.length > 0) {
        if (
          value.length === nextProp.options.length ||
          (preState.filteredOpts.length > 0 &&
            value.length === preState.filteredOpts.length)
        ) {
          isAllSeleced = true;
          indeterminate = false;
        } else if (value.length > 0) {
          indeterminate = true;
        }
      }
      let obj = {};
      value.forEach(_ => {
        obj[_[nextProp.optLabels[0]]] = _;
      });
      return { optValues: obj, isAllSeleced, indeterminate };
    } else {
      return {};
    }
  };

  selectedKeys = [];

  handleSearch = debounce(async e => {
    const { optLabels } = this.props;
    const search = e.target.value;
    if (!this.props.onFetch) {
      if (search) {
        const filteredOpts = this.props.options.filter(
          _ => _[optLabels[1]].toLowerCase().indexOf(search.toLowerCase()) > -1
        );
        this.setState({ search, filteredOpts });
      } else {
        this.setState({ search });
      }
    } else {
      const res = await this.props.onFetch(search.trim());
      if (!(res instanceof Error)) {
        this.setState({ filteredOpts: res });
      }
    }
  }, 500);

  _handleSearch = e => {
    e.persist();
    this.handleSearch(e);
  };

  handleCheckboxChange = key => event => {
    const { multiple } = this.props;
    const checked = event.target.checked;
    if (multiple) {
      if (checked) {
        this.selectedKeys.push(key);
      } else {
        // eslint-disable-next-line
        let index = this.selectedKeys.findIndex(_ => _ == key);
        this.selectedKeys.splice(index, 1);
      }
    } else {
      if (checked) {
        this.selectedKeys = [key];
      } else {
        this.selectedKeys = [];
      }
    }

    let newValue = this.calSelectedOpts();

    this.props.onChange && this.props.onChange(newValue);
  };

  handleSelectAll = e => {
    if (e.target.checked) {
      const { filteredOpts } = this.state;
      (filteredOpts.length ? filteredOpts : this.props.options).reduce(
        (pre, cur) => {
          pre.push(cur[this.props.optLabels[0]]);
          return pre;
        },
        this.selectedKeys
      );
    } else {
      this.selectedKeys = [];
    }

    const newValue = this.calSelectedOpts();
    this.props.onChange && this.props.onChange(newValue);
  };

  calSelectedOpts = () => {
    const t = [];
    const { options, optLabels } = this.props;
    this.selectedKeys.forEach(key => {
      const found = (this.props.onFetch
        ? this.state.filteredOpts
        : options
      ).find(node => node[optLabels[0]] === key);
      t.push(found);
    });

    return t;
  };

  isChecked = item => {
    const { selectedKeys } = this;
    if (!selectedKeys.length) return false;
    // eslint-disable-next-line
    const found = selectedKeys.find(key => key == item);
    if (found) return true;
    return false;
  };

  getSelKeysFromOptValues = () => {
    this.selectedKeys = Object.keys(this.state.optValues).map(
      key => this.state.optValues[key][this.props.optLabels[0]]
    );
  };

  componentDidMount = async () => {
    if (this.props.onFetch) {
      const res = await this.props.onFetch("");
      if (!(res instanceof Error)) {
        this.setState({ filteredOpts: res });
      }
    }
  };

  render() {
    this.getSelKeysFromOptValues();
    const { classes, options, optLabels, multiple } = this.props;
    const { filteredOpts } = this.state;

    return (
      <FormGroup className={classes.form}>
        <FormControl>
          <Input
            inputRef={v => (this.inputRef = v)}
            onChange={this._handleSearch}
          />
        </FormControl>
        {multiple && (
          <FormControlLabel
            control={
              <Checkbox
                checked={this.state.isAllSeleced}
                color="primary"
                indeterminate={this.state.indeterminate}
                onChange={this.handleSelectAll}
              />
            }
            label="所有"
          />
        )}
        <FormGroup className={classes.options}>
          {(filteredOpts.length ? filteredOpts : options || []).map(_ => {
            const checked = this.isChecked(_[optLabels[0]]);
            return (
              <FormControlLabel
                className={classes.item}
                key={_[optLabels[0]]}
                control={
                  <Checkbox
                    checked={checked}
                    onChange={this.handleCheckboxChange(_[optLabels[0]])}
                    color="primary"
                  />
                }
                label={_[optLabels[1]]}
              />
            );
          })}
        </FormGroup>
      </FormGroup>
    );
  }
}

export default withStyles(styles)(CheckboxList);
