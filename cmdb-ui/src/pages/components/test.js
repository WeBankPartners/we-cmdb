export const SearchFilters = [
  {
    title: "Name",
    key: "name",
    component: "Input",
    type: "text",
    placeholder: "Name"
  },
  {
    title: "Date",
    key: "date",
    component: "DatePicker",
    type: "datetimerange",
    placeholder: "Date"
  },
  {
    title: "Parent Header",
    align: "center",
    children: [
      {
        title: "Age",
        key: "age",
        component: "WeCMDBSelect",
        type: "text",
        placeholder: "Age",
        options: [
          {
            value: "London",
            label: "London"
          },
          {
            value: "Sydney",
            label: "Sydney"
          },

          {
            value: "Paris",
            label: "Paris"
          }
        ]
      },
      {
        title: "Address",
        key: "address",
        component: "Input",
        type: "textarea",
        placeholder: "Address",
        autosize: { minRows: 1, maxRows: 3 }
      }
    ]
  },
  {
    title: "Phone",
    key: "phone",
    component: "WeCMDBSelect",
    placeholder: "Phone",
    options: [
      {
        value: "London",
        label: "London"
      },
      {
        value: "Sydney",
        label: "Sydney"
      },

      {
        value: "Paris",
        label: "Paris"
      }
    ]
  },
  {
    title: "Email",
    key: "email",
    component: "WeCMDBRefSelect",
    placeholder: "Email",
    isGroup: true,
    options: [
      {
        value: "London",
        label: "London",
        children: [
          {
            value: "London",
            label: "London"
          },
          {
            value: "Sydney",
            label: "Sydney"
          },
          {
            value: "Paris",
            label: "Paris"
          }
        ]
      },
      {
        value: "Sydney",
        label: "Sydney",
        children: [
          {
            value: "XXX",
            label: "XXX"
          },
          {
            value: "ssss",
            label: "ssss"
          },
          {
            value: "ccFF",
            label: "ccFF"
          }
        ]
      },
      {
        value: "Paris",
        label: "Paris",
        children: [
          {
            value: "CCC",
            label: "CCC"
          },
          {
            value: "eee",
            label: "eee"
          }
        ]
      }
    ]
  }
];

export const outerActions = [
  {
    label: "Add",
    props: {
      type: "success",
      icon: "md-add",
      disabled: false
    },
    actionType: "add"
  },
  {
    label: "save",
    props: {
      type: "info",
      icon: "md-checkmark",
      disabled: true
    },
    actionType: "save"
  },
  {
    label: "edit",
    props: {
      type: "info",
      icon: "ios-build",
      disabled: true
    },
    actionType: "edit"
  },
  {
    label: "delete",
    props: {
      type: "warning",
      icon: "ios-trash-outline",
      disabled: true
    },
    actionType: "delete"
  },
  {
    label: "export",
    props: {
      type: "primary",
      icon: "ios-download-outline"
    },
    actionType: "export"
  }
];
export const innerActions = [
  {
    label: "query",
    props: {
      type: "primary",
      size: "small"
    },
    actionType: "query",
    visible: {
      key: "name",
      value: "Joe"
    }
  },
  {
    label: "approve",
    props: {
      type: "success",
      size: "small"
    },
    actionType: "approve",
    visible: {
      key: "name",
      value: "Snow"
    }
  }
];
