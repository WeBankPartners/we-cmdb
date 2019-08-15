import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  FormGroup,
  FormControlLabel,
  Checkbox,
  Popover
} from "@material-ui/core";

const styles = theme => ({
  popoverContent: {
    padding: 20
  }
});

function ColumnFilters(props) {
  const { anchorEl, classes } = props;
  const open = Boolean(anchorEl);

  return (
    <Popover
      id="simple-popper"
      open={open}
      anchorEl={anchorEl}
      onClose={props.onClose}
      anchorOrigin={{
        vertical: "bottom",
        horizontal: "center"
      }}
      transformOrigin={{
        vertical: "top",
        horizontal: "center"
      }}
    >
      <div className={classes.popoverContent}>
        <div>
          <FormGroup row>
            <FormControlLabel
              control={
                <Checkbox
                  indeterminate
                  checked={true}
                  // onChange={this.handleChange('checkedA')}
                  value="checkedA"
                />
              }
              label="全选"
            />
          </FormGroup>
        </div>
        <div>
          <FormGroup>
            {props.columns.map(c => {
              return (
                <FormControlLabel
                  key={c.title}
                  control={
                    <Checkbox
                      checked={c.selected}
                      onChange={() => props.onChange(c)}
                      value="checkedA"
                    />
                  }
                  label={c.title}
                />
              );
            })}
          </FormGroup>
        </div>
      </div>
    </Popover>
  );
}

export default withStyles(styles)(ColumnFilters);
