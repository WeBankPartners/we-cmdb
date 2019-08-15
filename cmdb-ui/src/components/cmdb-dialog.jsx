import React from "react";
import { withStyles } from "@material-ui/core/styles";
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import MuiDialogTitle from "@material-ui/core/DialogTitle";
import MuiDialogContent from "@material-ui/core/DialogContent";
import MuiDialogActions from "@material-ui/core/DialogActions";
import IconButton from "@material-ui/core/IconButton";
import CloseIcon from "@material-ui/icons/Close";
import Typography from "@material-ui/core/Typography";
import PropTypes from "prop-types";

const DialogTitle = withStyles(theme => ({
  root: {
    borderBottom: `1px solid ${theme.palette.divider}`,
    margin: 0,
    padding: theme.spacing.unit * 2
  },
  closeButton: {
    position: "absolute",
    right: theme.spacing.unit,
    top: theme.spacing.unit,
    color: theme.palette.grey[500]
  }
}))(props => {
  const { children, classes, onClose } = props;
  return (
    <MuiDialogTitle disableTypography className={classes.root}>
      <Typography variant="h6">{children}</Typography>
      {onClose ? (
        <IconButton
          aria-label="Close"
          className={classes.closeButton}
          onClick={onClose}
        >
          <CloseIcon />
        </IconButton>
      ) : null}
    </MuiDialogTitle>
  );
});

const DialogContent = withStyles(theme => ({
  root: {
    margin: 0,
    padding: theme.spacing.unit * 2
  }
}))(MuiDialogContent);

const DialogActions = withStyles(theme => ({
  root: {
    borderTop: `1px solid ${theme.palette.divider}`,
    margin: 0,
    padding: theme.spacing.unit
  }
}))(MuiDialogActions);

class CMDBDialog extends React.Component {
  static defaultProps = {
    cancelText: "取消",
    okText: "确定",
    maxWidth: "md"
  };

  static propTypes = {
    visible: PropTypes.bool.isRequired,
    title: PropTypes.string.isRequired,
    cancelText: PropTypes.string,
    okText: PropTypes.string,
    onCancel: PropTypes.func.isRequired,
    onOk: PropTypes.func
  };

  render() {
    const {
      title,
      children,
      cancelText,
      okText,
      visible,
      onOk,
      ...rest
    } = this.props;
    return (
      <Dialog
        onClose={this.props.onCancel}
        aria-labelledby="dialog-title"
        open={visible}
        {...rest}
      >
        <DialogTitle id="dialog-title" onClose={this.handleClose}>
          {title}
        </DialogTitle>
        <DialogContent>{children}</DialogContent>
        <DialogActions>
          <Button onClick={this.props.onCancel} color="primary">
            {cancelText}
          </Button>
          {this.props.onOk && (
            <Button
              onClick={this.props.onOk}
              color="primary"
              variant="contained"
            >
              {okText}
            </Button>
          )}
        </DialogActions>
      </Dialog>
    );
  }
}

export default CMDBDialog;
