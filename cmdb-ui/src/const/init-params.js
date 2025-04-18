export const ZOOM_LEVEL_CAT = 'ci_zoom_level'
export const CI_LAYER = 'ci_layer'
export const CI_GROUP = 'ci_group'
export const VIEW_CONFIG_PARAMS = 20
export const UNIT_DESIGN_ID = 'appArchitectureDesignUnitDesignId' // 单元设计的ciTypeId，也是两张图最小节点的ciTypeId
export const INVOKE_DESIGN_ID = 'appArchitectureDesignInvokeDesignId' // 调用设计的ciTypeId
export const SERVICE_INVOKE_DESIGN_ID = 'appArchitectureDesignServiceInvokeDesignId' // 服务调用设计的ciTypeId
export const SERVICE_DESIGN = 'appArchitectureDesignServiceDesign' // 服务设计ci的code
export const SERVICE_TYPE = 'appArchitectureDesignServiceType' // 服务类型
export const SERVICE_INVOKE_SEQ_DESIGN = 'appArchitectureDesignServiceInvokeDesignSequence' // 服务调用时序设计ci的code
export const INVOKE_SEQUENCE_ID = 'appArchitectureDesignInvokeSequenceId'
export const INVOKE_DIAGRAM_LINK_FROM = 'appArchitectureDesignInvokeDiagramLinkFrom'
export const INVOKE_DIAGRAM_LINK_TO = 'appArchitectureDesignInvokeDiagramLinkTo'
export const NETWORK_SEGMENT_DESIGN = 'idcPlanningNetworkSegmentDesign'
export const UNIT_ID = 'appDeploymentDesignUnitId'
export const BUSINESS_APP_INSTANCE_ID = 'appDeploymentDesignBusinessAppInstanceId'
export const INVOKE_ID = 'appDeploymentDesignInvokeId'
export const INVOKE_UNIT = 'appDeploymentDesignInvokeUnit'
export const INVOKED_UNIT = 'appDeploymentDesignInvokedUnit'
export const INVOKE_TYPE = 'appArchitectureDesignInvokeType'
export const IDC_PLANNING_LINK_ID = 'idcPlanningLinkId'
export const IDC_PLANNING_LINK_FROM = 'idcPlanningLinkFrom'
export const IDC_PLANNING_LINK_TO = 'idcPlanningLinkTo'
export const REGIONAL_DATA_CENTER = 'resourcePlaningRegionalDataCenter'
export const NETWORK_SEGMENT = 'resourcePlaningNetworkSegmentDesign'
export const LAYER = 'idcPlanningLayer'
export const RESOURCE_PLANNING_LINK_ID = 'resourcePlaningLinkId'
export const RESOURCE_PLANNING_LINK_FROM = 'resourcePlaningLinkFrom'
export const RESOURCE_PLANNING_LINK_TO = 'resourcePlaningLinkTo'
export const RESOURCE_PLANNING_ROUTER_CODE = 'resourcePlaningRouterCode'
export const DEFAULT_SECURITY_POLICY_CODE = 'defaultSecurityPolicyCode'
export const IDC_PLANNING_ROUTER_DESIGN_CODE = 'idcPlaningRouterDesignCode'
export const DEFAULT_SECURITY_POLICY_DESIGN_CODE = 'defaultSecurityPolicyDesignCode'

export const INPUT_TYPE_CONFIG = [
  {
    code: 'text',
    value: 'varchar',
    length: 255
  },
  {
    code: 'multiText',
    value: 'varchar',
    length: 1024
  },
  {
    code: 'multiInt',
    value: 'varchar',
    length: 255
  },
  {
    code: 'multiObject',
    value: 'text',
    length: 0
  },
  {
    code: 'longText',
    value: 'text',
    length: 0
  },
  {
    code: 'diffVariable',
    value: 'text',
    length: 0
  },
  {
    code: 'int',
    value: 'int',
    length: 64
  },
  {
    code: 'float',
    value: 'float',
    length: 64
  },
  {
    code: 'datetime',
    value: 'datetime',
    length: 0
  },
  {
    codeId: 'ref',
    code: 'ref',
    value: 'varchar',
    length: 64
  },
  {
    code: 'multiRef',
    value: 'table',
    length: 0
  },
  {
    codeId: 'extRef',
    code: 'extRef',
    value: 'varchar',
    length: 180
  },
  {
    codeId: 'select',
    code: 'select',
    value: 'varchar',
    length: 1024
  },
  {
    code: 'multiSelect',
    value: 'text',
    length: 64
  },
  {
    code: 'autofillRule',
    value: 'text',
    length: 0
  },
  {
    code: 'password',
    value: 'varchar(4096)',
    length: 64
  },
  {
    code: 'object',
    value: 'text',
    length: 0
  },
  {
    code: 'richText',
    value: 'text',
    length: 0
  }
]
