import Vue from "vue";
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
    component: "WeCMDBSelect",
    options: []
  },
  ref: {
    component: "WeCMDBRefSelect",
    highlightRow: true
  },
  multiSelect: {
    component: "WeCMDBSelect",
    options: []
  },
  multiRef: {
    component: "WeCMDBRefSelect"
  },
  textArea: {
    component: "Input",
    type: "text"
  }
};
export const outerActions = [
  {
    label: Vue.t("new"),
    props: {
      type: "success",
      icon: "md-add",
      disabled: false
    },
    actionType: "add"
  },
  {
    label: Vue.t("save"),
    props: {
      type: "info",
      icon: "md-checkmark",
      disabled: true
    },
    actionType: "save"
  },
  {
    label: Vue.t("edit"),
    props: {
      type: "info",
      icon: "ios-build",
      disabled: true
    },
    actionType: "edit"
  },
  {
    label: Vue.t("delete"),
    props: {
      type: "error",
      icon: "ios-trash-outline",
      disabled: true
    },
    actionType: "delete"
  },
  {
    label: Vue.t("cancel"),
    props: {
      type: "warning",
      icon: "md-undo"
      // disabled: true
    },
    actionType: "cancel"
  },
  {
    label: Vue.t("export"),
    props: {
      type: "primary",
      icon: "ios-download-outline"
    },
    actionType: "export"
  },
  {
    label: Vue.t("column_filter"),
    props: {
      type: "primary",
      icon: "ios-funnel",
      shape: "circle",
      disabled: false
    },
    actionType: "filterColumns"
  }
];
export const innerActions = [
  {
    label: Vue.t("cancel"),
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
