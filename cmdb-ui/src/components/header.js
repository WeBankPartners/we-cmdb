import React from "react";
import PropTypes from "prop-types";
import { createStyles, withStyles } from "@material-ui/core/styles";
import {
  AppBar,
  Toolbar,
  IconButton,
  MenuItem,
  Menu as MuiMenu
} from "@material-ui/core";
import AccountCircle from "@material-ui/icons/AccountCircle";
import { menus } from "../constants/menus";
import Menu from "./menu";
import { username } from "../apis/base";
import { retrieveMenus, retrieveRoleMenus } from "../apis/endpoints";

const styles = createStyles({
  root: {
    position: "fixed",
    flexGrow: 1,
    backgroundColor: "#2196f3"
  },
  grow: {
    flexGrow: 1
  },
  menuButton: {
    marginLeft: -12,
    marginRight: 20
  },
  auth: {
    marginLeft: "auto"
  },
  menu: {
    background: "transparent",
    boxShadow: "none",
    "& > ul > li": {
      color: "#fff"
    }
  }
});

class MenuAppBar extends React.Component {
  state = {
    auth: true,
    anchorEl: null,
    menusTree: [],
    menusObj: {}
  };

  handleChange = event => {
    this.setState({ auth: false });
  };

  handleMenu = event => {
    this.setState({ anchorEl: event.currentTarget });
  };

  handleClose = () => {
    this.setState({ anchorEl: null });
  };

  componentDidMount = async () => {
    const menusList = await retrieveMenus();
    if (!menusList || !(menusList.contents instanceof Array)) return;
    const rolesData = await retrieveRoleMenus({
      filters: [
        {
          name: "role.roleUsers.user.username",
          operator: "eq",
          value: "umadmin"
        }
      ],
      refResources: ["role", "role.roleUsers", "role.roleUsers.user"]
    });
    if (rolesData && rolesData.contents instanceof Array) {
      let tree = [];
      let menusObj = {};
      let userMenusObj = {};
      const formatMenusTree = nodes =>
        nodes
          .filter(_ => menus[_.name])
          .map(_ => {
            let obj = {
              path: menus[_.name].path || "",
              name: menus[_.name].name,
              menuId: _.menuId
            };
            if (menusObj[_.menuId]) {
              obj.children = formatMenusTree(menusObj[_.menuId]);
            }
            return obj;
          });
      const initTree = nodes =>
        nodes.filter(_ => {
          if (_.children) {
            _.children = initTree(_.children);
            let isShow = false;
            _.children.forEach(child => {
              if (userMenusObj[child.menuId]) {
                isShow = true;
              }
            });
            return isShow;
          } else {
            return userMenusObj[_.menuId];
          }
        });
      menusList.contents.forEach(_ => {
        if (_.parentIdAdmMenu) {
          if (!menusObj[_.parentIdAdmMenu]) {
            menusObj[_.parentIdAdmMenu] = [];
          }
          menusObj[_.parentIdAdmMenu].push(_);
        } else {
          tree.push(_);
        }
      });
      rolesData.contents.forEach(_ => {
        userMenusObj[_.menuId] = _;
      });
      const newTree = formatMenusTree(tree);
      const treeData = initTree(newTree);
      this.setState({ menusTree: treeData });
    }
  };

  render() {
    const { classes } = this.props;
    const { auth, anchorEl, menusTree } = this.state;
    const open = Boolean(anchorEl);
    return (
      <AppBar position="static" className={classes.root}>
        <Toolbar>
          <Menu
            className={classes.menu}
            data={menusTree}
            labels={{ parent: "name", child: "name", childrenKey: "children" }}
          />
          {auth && (
            <div className={classes.auth}>
              <IconButton
                aria-owns={open ? "menu-appbar" : undefined}
                aria-haspopup="true"
                onClick={this.handleMenu}
                color="inherit"
              >
                <AccountCircle /> {username}
              </IconButton>
              <MuiMenu
                id="menu-appbar"
                anchorEl={anchorEl}
                anchorOrigin={{
                  vertical: "top",
                  horizontal: "right"
                }}
                transformOrigin={{
                  vertical: "top",
                  horizontal: "right"
                }}
                open={open}
                onClose={this.handleClose}
              >
                <MenuItem onClick={this.handleClose}>操作指南</MenuItem>
                <MenuItem onClick={this.handleClose}>接口文档</MenuItem>
                <MenuItem>
                  {" "}
                  <a
                    href="/cmdb/logout"
                    style={{ color: "inherit", textDecoration: "none" }}
                  >
                    注销
                  </a>
                </MenuItem>
              </MuiMenu>
            </div>
          )}
        </Toolbar>
      </AppBar>
    );
  }
}

MenuAppBar.propTypes = {
  classes: PropTypes.object.isRequired
};

export default withStyles(styles)(MenuAppBar);
