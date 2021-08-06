export const MENUS = [
  {
    code: 'data_query',
    cnName: '数据查询',
    enName: 'Data Query',
    seqNo: 1,
    parent: '',
    isActive: 'yes'
  },
  {
    code: 'data_mgmt',
    cnName: '数据管理',
    enName: 'Data MGMT',
    seqNo: 2,
    parent: '',
    isActive: 'yes'
  },
  {
    code: 'configuration',
    cnName: '配置管理',
    enName: 'Configuration',
    seqNo: 3,
    parent: '',
    isActive: 'yes'
  },
  {
    code: 'system',
    cnName: '系统',
    enName: 'system',
    seqNo: 4,
    parent: '',
    isActive: 'yes',
    link: ''
  },
  {
    code: 'data_mgmt_ci',
    cnName: '数据管理(CI)',
    enName: 'CI Data MGMT',
    seqNo: 1,
    parent: 'data_mgmt',
    isActive: 'yes',
    link: '/wecmdb/designing/ci-data-management'
  },
  {
    code: 'data_mgmt_view',
    cnName: '数据管理(视图)',
    enName: 'View Data MGMT',
    seqNo: 2,
    parent: 'data_mgmt',
    isActive: 'yes',
    link: '/wecmdb/designing/data-mgmt-view'
  },
  {
    code: 'data_query_ci',
    cnName: '数据查询(CI)',
    enName: 'CI Data Query',
    seqNo: 1,
    parent: 'data_query',
    isActive: 'yes',
    link: '/wecmdb/designing/ci-data-enquiry'
  },
  {
    code: 'data_query_report',
    cnName: '数据查询(报表)',
    enName: 'Report Data Query',
    seqNo: 2,
    parent: 'data_query',
    isActive: 'yes',
    link: '/wecmdb/designing/ci-integrated-query-execution'
  },
  {
    code: 'data_query_view',
    cnName: '数据查询(视图)',
    seqNo: 3,
    parent: 'data_query',
    isActive: 'yes',
    link: '/wecmdb/designing/data-query-view'
  },
  {
    code: 'model_configuration',
    cnName: '模型配置',
    enName: 'Model Configuration',
    seqNo: 1,
    parent: 'configuration',
    isActive: 'yes',
    link: '/wecmdb/admin/cmdb-model-management'
  },
  {
    code: 'report_configuration',
    cnName: '报表配置',
    enName: 'Report Configuration',
    seqNo: 2,
    parent: 'configuration',
    isActive: 'yes',
    link: '/wecmdb/designing/ci-integrated-query-management'
  },
  {
    code: 'state_machine_configuration',
    cnName: '状态机配置',
    enName: 'State Machine Configuration',
    seqNo: 3,
    parent: 'configuration',
    isActive: 'yes',
    link: '/wecmdb/designing/state-machine'
  },
  {
    code: 'ci_template_configuration',
    cnName: 'CI模板配置',
    enName: 'CI Template Configuration',
    seqNo: 3,
    parent: 'configuration',
    isActive: 'yes',
    link: '/wecmdb/designing/ci-template-configuration'
  },
  {
    code: 'graph_config',
    cnName: '视图配置',
    enName: 'Graph Configuration',
    seqNo: 4,
    parent: 'configuration',
    isActive: 'yes',
    link: '/wecmdb/designing/graph-config'
  },
  {
    code: 'system_authority',
    cnName: '授权',
    enName: 'Authority',
    seqNo: 2,
    parent: 'system',
    isActive: 'yes',
    link: '/wecmdb/admin/permission-management'
  },
  {
    code: 'system_basekey',
    cnName: '基础数据',
    enName: 'Basekey',
    seqNo: 1,
    parent: 'system',
    isActive: 'yes',
    link: '/wecmdb/admin/base-data-management'
  },
  {
    code: 'system_operation_log',
    cnName: '操作日志',
    enName: 'Operation Log',
    seqNo: 3,
    parent: 'system',
    isActive: 'yes',
    link: '/wecmdb/admin/log-enquiry'
  }
]
