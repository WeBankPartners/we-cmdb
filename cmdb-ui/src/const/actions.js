export const components = {
  number: {
    component: "Input",
    type: "number"
  },
  date: {
    component: "DatePicker",
    type: "datetimerange"
  },
  text: {
    component: "Input",
    type: "text"
  },
  select: {
    component: "WeSelect",
    options: []
  },
  ref: {
    component: "refSelect",
    highlightRow: true
  },
  multiSelect: {
    component: "WeSelect",
    options: []
  },
  multiRef: {
    component: "refSelect"
  },
  textArea: {
    component: "Input",
    type: "text"
  }
};
export const outerActions = [
  {
    label: "新增",
    props: {
      type: "success",
      icon: "md-add",
      disabled: false
    },
    actionType: "add"
  },
  {
    label: "保存",
    props: {
      type: "info",
      icon: "md-checkmark",
      disabled: true
    },
    actionType: "save"
  },
  {
    label: "编辑",
    props: {
      type: "info",
      icon: "ios-build",
      disabled: true
    },
    actionType: "edit"
  },
  {
    label: "删除",
    props: {
      type: "error",
      icon: "ios-trash-outline",
      disabled: true
    },
    actionType: "delete"
  },
  {
    label: "取消",
    props: {
      type: "warning",
      icon: "md-undo"
      // disabled: true
    },
    actionType: "cancel"
  },
  {
    label: "导出",
    props: {
      type: "primary",
      icon: "ios-download-outline"
    },
    actionType: "export"
  }
];
export const innerActions = [
  {
    label: "取消",
    props: {
      type: "warning",
      size: "small"
    },
    actionType: "innerCancel",
    visible: {
      key: "isRowEditable",
      value: true
    }
  }
];
export const pagination = {
  pageSize: 10,
  currentPage: 1,
  total: 0
};
