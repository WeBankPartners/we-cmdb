import Vue from 'vue'
import { pluginI18n } from '../const/plugin-i18n'
export const components = {
  number: {
    component: 'Input',
    type: 'number'
  },
  datetime: {
    component: 'DatePicker',
    type: 'datetimerange'
  },
  text: {
    component: 'Input',
    type: 'text'
  },
  select: {
    component: 'WeCMDBSelect',
    options: []
  },
  ref: {
    component: 'WeCMDBRefSelect',
    highlightRow: true
  },
  extRef: {
    component: 'WeCMDBRefSelect',
    highlightRow: true
  },
  multiSelect: {
    component: 'WeCMDBSelect',
    options: []
  },
  multiRef: {
    component: 'WeCMDBRefSelect'
  },
  textArea: {
    component: 'Input',
    type: 'text'
  },
  float: {
    component: 'Input',
    type: 'text'
  },
  password: {
    component: 'WeCMDBCIPassword'
  }
}

export const newOuterActions = [
  {
    label: window.vm ? pluginI18n('new') : pluginI18n('new'),
    operation: window.vm ? pluginI18n('new') : pluginI18n('new'),
    props: {
      type: 'success',
      icon: 'md-add',
      disabled: false,
      loading: false
    },
    actionType: 'add',
    operation_en: 'add'
  },
  {
    label: window.vm ? pluginI18n('copyToNew') : pluginI18n('copyToNew'),
    operation: window.vm ? pluginI18n('copyToNew') : pluginI18n('copyToNew'),
    props: {
      type: 'success',
      icon: 'md-add',
      disabled: true,
      loading: false
    },
    actionType: 'copy',
    operation_en: 'copy'
  },
  {
    label: window.vm ? pluginI18n('edit') : pluginI18n('edit'),
    operation: window.vm ? pluginI18n('edit') : pluginI18n('edit'),
    props: {
      type: 'info',
      icon: 'ios-build',
      disabled: true,
      loading: false
    },
    actionType: 'edit',
    operation_en: 'edit'
  },
  {
    label: window.vm ? pluginI18n('delete') : pluginI18n('delete'),
    operation: window.vm ? pluginI18n('delete') : pluginI18n('delete'),
    props: {
      type: 'error',
      icon: 'ios-trash-outline',
      disabled: true,
      loading: false
    },
    actionType: 'delete',
    operation_en: 'delete'
  },
  {
    label: window.vm ? pluginI18n('export') : pluginI18n('export'),
    operation: window.vm ? pluginI18n('export') : pluginI18n('export'),
    props: {
      type: 'primary',
      icon: 'ios-download-outline',
      loading: false
    },
    actionType: 'export',
    operation_en: 'export'
  }
]
export const outerActions = [
  {
    label: window.vm ? pluginI18n('new') : pluginI18n('new'),
    props: {
      type: 'success',
      icon: 'md-add',
      disabled: false,
      loading: false
    },
    actionType: 'add'
  },
  {
    label: window.vm ? pluginI18n('save') : pluginI18n('save'),
    props: {
      type: 'info',
      icon: 'md-checkmark',
      disabled: true,
      loading: false
    },
    actionType: 'save'
  },
  {
    label: window.vm ? pluginI18n('copyToNew') : pluginI18n('copyToNew'),
    props: {
      type: 'success',
      icon: 'md-add',
      disabled: true,
      loading: false
    },
    actionType: 'copy'
  },
  {
    label: window.vm ? pluginI18n('edit') : pluginI18n('edit'),
    props: {
      type: 'info',
      icon: 'ios-build',
      disabled: true,
      loading: false
    },
    actionType: 'edit'
  },
  {
    label: window.vm ? pluginI18n('delete') : pluginI18n('delete'),
    props: {
      type: 'error',
      icon: 'ios-trash-outline',
      disabled: true,
      loading: false
    },
    actionType: 'delete'
  },
  {
    label: window.vm ? pluginI18n('cancel') : pluginI18n('cancel'),
    props: {
      type: 'warning',
      icon: 'md-undo',
      // disabled: true
      loading: false
    },
    actionType: 'cancel'
  },
  {
    label: window.vm ? pluginI18n('export') : pluginI18n('export'),
    props: {
      type: 'primary',
      icon: 'ios-download-outline',
      loading: false
    },
    actionType: 'export'
  }
  // {
  //   label: window.vm ? pluginI18n('column_filter') : pluginI18n('column_filter'),
  //   props: {
  //     type: 'primary',
  //     icon: 'ios-funnel',
  //     shape: 'circle',
  //     disabled: false,
  //     loading: false
  //   },
  //   actionType: 'filterColumns'
  // }
]
export const newExportOuterActions = [
  {
    label: window.vm ? pluginI18n('export') : pluginI18n('export'),
    props: {
      type: 'primary',
      icon: 'ios-download-outline'
    },
    actionType: 'export'
  }
]
export const exportOuterActions = [
  {
    label: window.vm ? pluginI18n('export') : pluginI18n('export'),
    props: {
      type: 'primary',
      icon: 'ios-download-outline'
    },
    actionType: 'export'
  },
  {
    label: window.vm ? pluginI18n('column_filter') : pluginI18n('column_filter'),
    props: {
      type: 'primary',
      icon: 'ios-funnel',
      shape: 'circle',
      disabled: false
    },
    actionType: 'filterColumns'
  }
]
export const innerActions = [
  {
    label: window.vm ? pluginI18n('cancel') : pluginI18n('cancel'),
    props: {
      type: 'warning',
      size: 'small'
    },
    actionType: 'innerCancel',
    visible: {
      key: 'isRowEditable',
      value: true
    }
  }
]
export const pagination = {
  pageSize: 10,
  currentPage: 1,
  total: 0
}
