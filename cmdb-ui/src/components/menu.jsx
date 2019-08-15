import React from "react";
import PropTypes from "prop-types";
import { HashRouter as Router } from "react-router-dom";
import { Link } from "react-router-dom";
import {
  ClickAwayListener,
  Grow,
  Paper,
  Popper,
  MenuItem,
  MenuList
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";

const styles = theme => ({
  popper: {
    marginRight: theme.spacing.unit * 2,
    zIndex: "10"
  },
  menuItem: {
    overflow: "initial"
  },
  icon: {
    display: "flex",
    position: "absolute",
    right: 0,
    top: 0
  },
  text: {
    width: "100%",
    position: "relative"
  },
  link: {
    color: "rgba(0, 0, 0, 0.87)",
    "text-decoration": "none"
  }
});

const dirMap = {
  horizontal: "horizontal",
  vertical: "vertical"
};
const placementMap = {
  vertical: "right-start",
  horizontal: "bottom"
};
class MenuListComposition extends React.Component {
  state = {
    open: false,
    currentItem: {},
    currentChildItem: {}
  };

  handleToggle = (e, menuItem) => {
    this.anchorEl = e.currentTarget;
    this.setState(state => ({ open: !state.open, currentItem: menuItem }));
    this.props.onMenuClick && this.props.onMenuClick(menuItem);
  };

  handleClose = item => event => {
    if (this.anchorEl.contains(event.target)) {
      return;
    }
    this.props.onItemClick && this.props.onItemClick(item);
    this.anchorEl = null;
    this.setState({ open: false, currentChildItem: item });
  };

  render() {
    const {
      classes,
      dir,
      data,
      labels,
      className,
      menuClasses,
      menuActions
    } = this.props;
    const { open, currentItem, currentChildItem } = this.state;

    return (
      <div className={className}>
        <MenuList
          style={{
            display: dir === dirMap.horizontal ? "flex" : "block",
            height: "100%",
            overflow: "auto",
            boxSizing: "border-box",
            padding: 0
          }}
        >
          {data.map(_ => {
            return (
              <MenuItem
                selected={currentItem === _}
                key={_[labels.parent]}
                className={classes.menuItem}
                classes={menuClasses}
                onClick={e => this.handleToggle(e, _)}
              >
                <div className={classes.text}>
                  {_[labels.parent]}
                  <div className={classes.icon}>
                    {menuActions &&
                      menuActions.map(action => (
                        <action.comp
                          key={action.comp}
                          onClick={() => action.handler(_)}
                        />
                      ))}
                  </div>
                </div>
              </MenuItem>
            );
          })}
        </MenuList>
        <Popper
          open={open}
          anchorEl={this.anchorEl}
          transition
          //   disablePortal
          placement={placementMap[dir]}
          className={classes.popper}
        >
          {({ TransitionProps, placement }) => (
            <Grow
              {...TransitionProps}
              id="menu-list-grow"
              style={{
                transformOrigin:
                  placement === "bottom" ? "center top" : "center bottom"
              }}
            >
              <Paper>
                <ClickAwayListener onClickAway={this.handleClose()}>
                  <Router>
                    <MenuList>
                      {currentItem[labels.childrenKey] &&
                        currentItem[labels.childrenKey].map((child, index) => {
                          return (
                            <MenuItem
                              selected={currentChildItem === child}
                              onClick={this.handleClose(child)}
                              key={index + child[labels.child]}
                            >
                              {child.path ? (
                                <Link className={classes.link} to={child.path}>
                                  {child[labels.child]}
                                </Link>
                              ) : (
                                child[labels.child]
                              )}
                            </MenuItem>
                          );
                        })}
                    </MenuList>
                  </Router>
                </ClickAwayListener>
              </Paper>
            </Grow>
          )}
        </Popper>
      </div>
    );
  }
}

MenuListComposition.defaultProps = {
  placement: placementMap.horizontal,
  dir: dirMap.horizontal,
  labels: {
    parent: "value",
    child: "name",
    childrenKey: "ciTypes"
  }
};
MenuListComposition.propTypes = {
  classes: PropTypes.object.isRequired,
  menuClasses: PropTypes.object,
  placement: PropTypes.string,
  dir: PropTypes.oneOf([dirMap.horizontal, dirMap.vertical]),
  data: PropTypes.array.isRequired,
  labels: PropTypes.object,
  onItemClick: PropTypes.func,
  onMenuClick: PropTypes.func,
  menuActions: PropTypes.array
};

export default withStyles(styles)(MenuListComposition);
