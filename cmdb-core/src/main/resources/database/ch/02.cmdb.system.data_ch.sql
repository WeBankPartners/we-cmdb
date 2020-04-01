SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Records of adm_basekey_cat
-- ----------------------------
INSERT INTO `adm_basekey_cat` VALUES ('1', 'ci_layer', '层级', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('2', 'ci_catalog', '目录', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('3', 'ci_zoom_level', 'Zoom', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('4', 'ci_attr_type', '属性类型', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('5', 'ci_attr_enum_type', '枚举类型', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('6', 'ci_attr_ref_type', '引用类型', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('7', 'ci_state_design', '设计类CI状态', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('8', 'ci_state_create', '可创建类CI状态', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('9', 'ci_state_start_stop', '可起停类CI状态', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('10', 'state_transition_operation', '状态迁移操作', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('11', 'state_transition_action', '状态迁移动作', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('12', 'tab_of_planning_design', '规划设计CI标签', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('13', 'tab_query_of_planning_design', '规划设计标签查询', null, '1', '12');
INSERT INTO `adm_basekey_cat` VALUES ('14', 'tab_of_resourse_planning', '资源规划CI标签', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('15', 'tab_query_of_resourse_planning', '资源规划标签查询', null, '1', '14');
INSERT INTO `adm_basekey_cat` VALUES ('16', 'tab_of_architecture_design', '架构设计CI标签', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('17', 'tab_query_of_architecture_design', '架构设计标签查询', null, '1', '16');
INSERT INTO `adm_basekey_cat` VALUES ('18', 'tab_of_deploy_design', '部署设计CI标签', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('19', 'tab_query_of_deploy_design', '部署设计标签查询', null, '1', '18');
INSERT INTO `adm_basekey_cat` VALUES ('20', 'view_config_params', '视图初始化参数', null, '1', null);
INSERT INTO `adm_basekey_cat` VALUES ('21', 'view_ci_type_id', '视图相关CI的ID', null, '1', null);

-- ----------------------------
-- Records of adm_basekey_cat_type
-- ----------------------------
INSERT INTO `adm_basekey_cat_type` VALUES ('1', 'sys', null, null, '1');
INSERT INTO `adm_basekey_cat_type` VALUES ('2', 'common', null, null, '2');
INSERT INTO `adm_basekey_cat_type` VALUES ('3', 'manage_role', '管理角色', '1', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('4', 'unit_type', '单元类型', '2', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('5', 'deploy_environment', '部署环境', '3', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('6', 'legal_person', '法人', '4', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('7', 'application_domain', '应用域', '5', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('8', 'cloud_vendor', '公有云厂家', '6', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('9', 'cluster_type', '集群类型', '7', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('10', 'cluster_node_type', '集群节点类型', '8', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('11', 'resource_instance_type', '资源实例类型', '9', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('12', 'resource_instance_spec', '资源实例规格', '10', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('13', 'resource_instance_system', '资源实例系统', '11', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('14', 'data_center_design', '数据中心设计', '12', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('15', 'network_segment_design', '网段设计', '13', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('16', 'network_zone_design', '网络区域设计', '14', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('17', 'default_security_policy_d', '默认安全策略设计', '15', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('18', 'network_zone_link_design', '网络区域连接设计', '16', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('20', 'business_zone_design', '业务区域设计', '18', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('21', 'resource_set_design', '资源集合设计', '19', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('22', 'resource_set_route_design', '资源集合路由设计', '20', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('23', 'resource_set_invoke_desig', '资源集合调用设计', '21', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('24', 'data_center', '数据中心', '22', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('25', 'network_segment', '网段', '23', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('26', 'network_zone', '网络区域', '24', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('27', 'default_security_policy', '默认安全策略', '25', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('28', 'network_zone_link', '网络区域连接', '26', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('30', 'business_zone', '业务区域', '28', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('31', 'resource_set', '资源集合', '29', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('32', 'resource_set_route', '资源集合路由', '30', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('33', 'ip_address', 'IP地址', '31', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('34', 'host_resource_instance', '主机资源实例', '32', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('35', 'rdb_resource_instance', '数据库资源实例', '33', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('36', 'cache_resource_instance', '缓存资源实例', '34', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('37', 'lb_resource_instance', '负载均衡资源实例', '35', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('38', 'block_storage', '块存储', '36', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('39', 'app_system_design', '应用系统设计', '37', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('40', 'subsys_design', '子系统设计', '38', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('41', 'unit_design', '单元设计', '39', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('42', 'invoke_design', '调用设计', '40', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('43', 'service_design', '服务设计', '41', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('44', 'service_invoke_design', '服务调用设计', '42', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('45', 'service_invoke_seq_design', '服务调用时序设计', '43', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('46', 'diff_configuration', '差异化变量', '44', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('47', 'deploy_package', '部署物料包', '45', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('48', 'app_system', '应用系统', '46', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('49', 'subsys', '子系统', '47', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('50', 'unit', '单元', '48', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('51', 'invoke', '调用', '49', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('52', 'app_instance', '应用实例', '50', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('53', 'rdb_instance', '数据库实例', '51', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('54', 'cache_instance', '缓存实例', '52', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('55', 'lb_instance', '负载均衡实例', '53', '3');
INSERT INTO `adm_basekey_cat_type` VALUES ('56', '节点类型', null, '54', '3');


-- ----------------------------
-- Records of adm_basekey_code
-- ----------------------------
INSERT INTO `adm_basekey_code` VALUES ('1', '1', 'app_architecture_layer', '应用架构层', null, '应用架构层', '1', 'active');
INSERT INTO `adm_basekey_code` VALUES ('2', '1', 'app_develop_layer', '应用开发层', null, '应用开发层', '2', 'active');
INSERT INTO `adm_basekey_code` VALUES ('3', '1', 'app_deploy_layer', '应用部署层', null, '应用部署层', '3', 'active');
INSERT INTO `adm_basekey_code` VALUES ('4', '1', 'res_instance_layer', '资源实例层', null, '资源实例层', '4', 'active');
INSERT INTO `adm_basekey_code` VALUES ('5', '1', 'res_planning_layer', '资源规划层', null, '资源规划层', '5', 'active');
INSERT INTO `adm_basekey_code` VALUES ('6', '1', 'res_architecture_layer', '资源架构层', null, '资源架构层', '6', 'active');
INSERT INTO `adm_basekey_code` VALUES ('7', '2', 'app_architecture_layer', '应用架构层', null, '应用架构层', '1', 'active');
INSERT INTO `adm_basekey_code` VALUES ('8', '2', 'app_develop_layer', '应用开发层', null, '应用开发层', '2', 'active');
INSERT INTO `adm_basekey_code` VALUES ('9', '2', 'app_deploy_layer', '应用部署层', null, '应用部署层', '3', 'active');
INSERT INTO `adm_basekey_code` VALUES ('10', '2', 'res_instance_layer', '资源实例层', null, '资源实例层', '4', 'active');
INSERT INTO `adm_basekey_code` VALUES ('11', '2', 'res_planning_layer', '资源规划层', null, '资源规划层', '5', 'active');
INSERT INTO `adm_basekey_code` VALUES ('12', '2', 'res_architecture_layer', '资源架构层', null, '资源架构层', '6', 'active');
INSERT INTO `adm_basekey_code` VALUES ('13', '3', '1', '常规图层', null, '常规图层', '1', 'active');
INSERT INTO `adm_basekey_code` VALUES ('14', '3', '2', '网络图层', null, '网络图层', '2', 'active');
INSERT INTO `adm_basekey_code` VALUES ('15', '3', '3', '基础图层', null, '基础图层', '3', 'active');
INSERT INTO `adm_basekey_code` VALUES ('16', '4', 'text', '文本', null, '文本', '1', 'active');
INSERT INTO `adm_basekey_code` VALUES ('17', '4', 'area', '文本域', null, '文本域', '2', 'active');
INSERT INTO `adm_basekey_code` VALUES ('18', '4', 'number', '整型数字', null, '整型数字', '3', 'active');
INSERT INTO `adm_basekey_code` VALUES ('19', '4', 'regular_text', '正则校验文本', null, '正则校验文本', '4', 'inactive');
INSERT INTO `adm_basekey_code` VALUES ('20', '4', 'datetime', '时间', null, '时间', '5', 'active');
INSERT INTO `adm_basekey_code` VALUES ('21', '4', 'select', '下拉选择', null, '下拉选择', '6', 'active');
INSERT INTO `adm_basekey_code` VALUES ('22', '4', 'multi_enum', '多选下拉选择', null, '多选下拉选择', '7', 'active');
INSERT INTO `adm_basekey_code` VALUES ('23', '4', 'ref', '引用', null, '引用', '8', 'active');
INSERT INTO `adm_basekey_code` VALUES ('24', '4', 'multi_ref', '多选引用', null, '多选引用', '9', 'active');
INSERT INTO `adm_basekey_code` VALUES ('25', '4', 'password', '密码', null, '密码', '10', 'active');
INSERT INTO `adm_basekey_code` VALUES ('26', '4', '预留3', '预留3', null, '预留3', '11', 'inactive');
INSERT INTO `adm_basekey_code` VALUES ('27', '5', 'common', '公共枚举', null, '公共枚举', '1', 'active');
INSERT INTO `adm_basekey_code` VALUES ('28', '5', 'private', '私有枚举', null, '私有枚举', '2', 'active');
INSERT INTO `adm_basekey_code` VALUES ('29', '6', 'belong', '属于', null, '属于', '1', 'active');
INSERT INTO `adm_basekey_code` VALUES ('30', '6', 'use', '使用', null, '使用', '2', 'active');
INSERT INTO `adm_basekey_code` VALUES ('31', '6', 'depend', '依赖', null, '依赖', '3', 'active');
INSERT INTO `adm_basekey_code` VALUES ('32', '6', 'relation', '关联', null, '关联', '4', 'active');
INSERT INTO `adm_basekey_code` VALUES ('33', '6', 'realize', '实现', null, '实现', '5', 'active');
INSERT INTO `adm_basekey_code` VALUES ('34', '7', 'new', '新增', null, null, '1', 'active');
INSERT INTO `adm_basekey_code` VALUES ('35', '7', 'update', '更新', null, null, '2', 'active');
INSERT INTO `adm_basekey_code` VALUES ('36', '7', 'deleted', '删除', null, null, '3', 'active');
INSERT INTO `adm_basekey_code` VALUES ('37', '8', 'created', '创建', null, null, '6', 'active');
INSERT INTO `adm_basekey_code` VALUES ('38', '8', 'changed', '变更', null, null, '7', 'active');
INSERT INTO `adm_basekey_code` VALUES ('39', '8', 'destroyed', '销毁', null, null, '8', 'active');
INSERT INTO `adm_basekey_code` VALUES ('40', '9', 'created', '创建', null, null, '1', 'active');
INSERT INTO `adm_basekey_code` VALUES ('41', '9', 'startup', '启动', null, null, '2', 'active');
INSERT INTO `adm_basekey_code` VALUES ('42', '9', 'changed', '变更', null, null, '3', 'active');
INSERT INTO `adm_basekey_code` VALUES ('43', '9', 'stoped', '停止', null, null, '4', 'active');
INSERT INTO `adm_basekey_code` VALUES ('44', '9', 'destroyed', '销毁', null, null, '5', 'active');
INSERT INTO `adm_basekey_code` VALUES ('45', '10', 'insert', '添加', null, null, '1', 'active');
INSERT INTO `adm_basekey_code` VALUES ('46', '10', 'update', '更新', null, null, '2', 'active');
INSERT INTO `adm_basekey_code` VALUES ('47', '10', 'discard', '放弃', null, null, '3', 'active');
INSERT INTO `adm_basekey_code` VALUES ('48', '10', 'delete', '删除', null, null, '4', 'active');
INSERT INTO `adm_basekey_code` VALUES ('49', '10', 'confirm', '确认', null, null, '5', 'active');
INSERT INTO `adm_basekey_code` VALUES ('50', '10', 'startup', '启动', null, null, '6', 'active');
INSERT INTO `adm_basekey_code` VALUES ('51', '10', 'stop', '停止', null, null, '7', 'active');
INSERT INTO `adm_basekey_code` VALUES ('52', '11', 'insert', '插入', null, null, '1', 'active');
INSERT INTO `adm_basekey_code` VALUES ('53', '11', 'insert-update', '插入-更新', null, null, '2', 'active');
INSERT INTO `adm_basekey_code` VALUES ('54', '11', 'delete', '删除', null, null, '3', 'active');
INSERT INTO `adm_basekey_code` VALUES ('55', '11', 'update-delete', '更新-删除', null, null, '4', 'active');
INSERT INTO `adm_basekey_code` VALUES ('56', '11', 'update', '更新', null, null, '5', 'active');
INSERT INTO `adm_basekey_code` VALUES ('57', '11', 'confirm', '确认', null, null, '6', 'active');
INSERT INTO `adm_basekey_code` VALUES ('58', '20', 'idcPlanningLinkFrom', 'network_zone_design_1', null, null, '1', 'active');
INSERT INTO `adm_basekey_code` VALUES ('59', '20', 'idcPlanningLinkTo', 'network_zone_design_2', null, null, '2', 'active');
INSERT INTO `adm_basekey_code` VALUES ('60', '20', 'idcPlanningLayer', 'network_zone_layer', null, null, '3', 'active');
INSERT INTO `adm_basekey_code` VALUES ('61', '20', 'idcPlanningNetworkSegmentDesign', 'network_segment_design', null, null, '4', 'active');
INSERT INTO `adm_basekey_code` VALUES ('62', '20', 'resourcePlaningRegionalDataCenter', 'regional_data_center', null, null, '5', 'active');
INSERT INTO `adm_basekey_code` VALUES ('63', '20', 'resourcePlaningNetworkSegmentDesign', 'network_segment', null, null, '6', 'active');
INSERT INTO `adm_basekey_code` VALUES ('64', '20', 'resourcePlaningDataCenter', 'data_center', null, null, '7', 'active');
INSERT INTO `adm_basekey_code` VALUES ('65', '20', 'resourcePlaningVpcNetworkZone', 'vpc_network_zone', null, null, '8', 'active');
INSERT INTO `adm_basekey_code` VALUES ('66', '20', 'resourcePlaningLinkFrom', 'network_zone_1', null, null, '9', 'active');
INSERT INTO `adm_basekey_code` VALUES ('67', '20', 'resourcePlaningLinkTo', 'network_zone_2', null, null, '10', 'active');
INSERT INTO `adm_basekey_code` VALUES ('68', '20', 'appArchitectureDesignServiceDesign', 'service_design', null, null, '11', 'active');
INSERT INTO `adm_basekey_code` VALUES ('69', '20', 'appArchitectureDesignServiceType', 'service_type', null, null, '12', 'active');
INSERT INTO `adm_basekey_code` VALUES ('70', '20', 'appArchitectureDesignServiceInvokeDesignSequence', 'service_invoke_design_sequence', null, null, '13', 'active');
INSERT INTO `adm_basekey_code` VALUES ('71', '20', 'appArchitectureDesignInvokeDiagramLinkFrom', 'invoke_unit_design', null, null, '14', 'active');
INSERT INTO `adm_basekey_code` VALUES ('72', '20', 'appArchitectureDesignInvokeDiagramLinkTo', 'invoked_unit_design', null, null, '15', 'active');
INSERT INTO `adm_basekey_code` VALUES ('73', '20', 'appDeploymentDesignResourceInstance', 'resource_instance', null, null, '16', 'active');
INSERT INTO `adm_basekey_code` VALUES ('74', '20', 'appDeploymentDesignInvokeUnit', 'invoke_unit', null, null, '17', 'active');
INSERT INTO `adm_basekey_code` VALUES ('75', '20', 'appDeploymentDesignInvokedUnit', 'invoked_unit', null, null, '18', 'active');
INSERT INTO `adm_basekey_code` VALUES ('77', '20', 'appArchitectureDesignSyetemDesign', 'app_system_design', null, null, '19', 'active');
INSERT INTO `adm_basekey_code` VALUES ('78', '20', 'appArchitectureDesignInvokeDesign', 'invoke_design', null, null, '20', 'active');
INSERT INTO `adm_basekey_code` VALUES ('79', '20', 'appArchitectureDesignUnitDesignId', '39', null, null, '21', 'active');
INSERT INTO `adm_basekey_code` VALUES ('80', '20', 'appArchitectureDesignInvokeDesignId', '40', null, null, '22', 'active');
INSERT INTO `adm_basekey_code` VALUES ('81', '20', 'appArchitectureDesignServiceInvokeDesignId', '42', null, null, '23', 'active');
INSERT INTO `adm_basekey_code` VALUES ('83', '20', 'appArchitectureDesignInvokeSequenceId', '43', null, null, '24', 'active');
INSERT INTO `adm_basekey_code` VALUES ('89', '19', 'guid_of_deploy_detail', '[{\"ciTypeId\": 47},{ \"ciTypeId\": 38, \"parentRs\": { \"attrId\": 870, \"isReferedFromParent\": 1}},{ \"ciTypeId\": 37,\"parentRs\": { \"attrId\": 709,\"isReferedFromParent\": 1}}]', null, null, '8', 'active');
INSERT INTO `adm_basekey_code` VALUES ('90', '21', 'ciTypeIdOfSystemDesign', '37', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('91', '21', 'ciTypeIdOfSubsystemDesign', '38', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('92', '21', 'ciTypeIdOfUnitDesign', '39', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('93', '21', 'ciTypeIdOfUnit', '48', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('94', '21', 'ciTypeIdOfSubsys', '47', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('95', '21', 'ciTypeIdOfSystem', '46', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('96', '21', 'ciTypeIdOfHost', '32', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('97', '21', 'ciTypeIdOfInstance', '50', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('98', '21', 'ciTypeIdOfIdc', '22', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('99', '21', 'ciTypeIdOfZone', '24', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('100', '21', 'ciTypeIdOfZoneLink', '26', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('101', '21', 'ciTypeIdOfIdcDesign', '12', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('102', '21', 'ciTypeIdOfZoneDesign', '14', null, null, null, 'active');
INSERT INTO `adm_basekey_code` VALUES ('103', '21', 'ciTypeIdOfZoneLinkDesign', '16', null, null, null, 'active');

-- ----------------------------
-- Records of adm_ci_type
-- ----------------------------
INSERT INTO `adm_ci_type` VALUES ('1', '管理角色', '1', '管理角色', null, 'manage_role', 'created', '7', null, '1', '1', '15', null);
INSERT INTO `adm_ci_type` VALUES ('2', '单元类型', '1', '单元类型', null, 'unit_type', 'created', '7', null, '2', '1', '15', null);
INSERT INTO `adm_ci_type` VALUES ('3', '部署环境', '1', '部署环境', null, 'deploy_environment', 'created', '9', null, '1', '3', '15', null);
INSERT INTO `adm_ci_type` VALUES ('4', '法人', '1', '法人', null, 'legal_person', 'created', '9', null, '2', '3', '15', null);
INSERT INTO `adm_ci_type` VALUES ('5', '应用域', '1', '应用域', null, 'application_domain', 'created', '12', null, '1', '6', '15', null);
INSERT INTO `adm_ci_type` VALUES ('6', '云厂商', '1', '公有云厂家', null, 'cloud_vendor', 'created', '11', null, '1', '5', '15', null);
INSERT INTO `adm_ci_type` VALUES ('7', '集群类型', '1', '集群类型', null, 'cluster_type', 'created', '11', null, '2', '5', '15', null);
INSERT INTO `adm_ci_type` VALUES ('8', '集群节点类型', '1', '集群节点类型', null, 'cluster_node_type', 'created', '10', null, '1', '4', '15', null);
INSERT INTO `adm_ci_type` VALUES ('9', '资源实例类型', '1', '资源实例类型', null, 'resource_instance_type', 'created', '10', null, '2', '4', '15', null);
INSERT INTO `adm_ci_type` VALUES ('10', '资源实例规格', '1', '资源实例规格', null, 'resource_instance_spec', 'created', '10', null, '3', '4', '15', null);
INSERT INTO `adm_ci_type` VALUES ('11', '资源实例系统', '1', '资源实例系统', null, 'resource_instance_system', 'created', '10', null, '4', '4', '15', null);
INSERT INTO `adm_ci_type` VALUES ('12', '数据中心设计', '22', '数据中心设计', null, 'data_center_design', 'created', '12', null, '2', '6', '13', null);
INSERT INTO `adm_ci_type` VALUES ('13', '网段设计', '21', '网段设计', null, 'network_segment_design', 'created', '12', null, '3', '6', '14', null);
INSERT INTO `adm_ci_type` VALUES ('14', '网络区域设计', '23', '网络区域设计', null, 'network_zone_design', 'created', '12', null, '4', '6', '13', null);
INSERT INTO `adm_ci_type` VALUES ('15', '默认安全策略设计', '15', '默认安全策略设计', null, 'default_security_policy_design', 'created', '12', null, '5', '6', '14', null);
INSERT INTO `adm_ci_type` VALUES ('16', '网络区域连接设计', '24', '网络区域连接设计', null, 'network_zone_link_design', 'created', '12', null, '6', '6', '14', null);
INSERT INTO `adm_ci_type` VALUES ('18', '业务区域设计', '25', '业务区域设计', null, 'business_zone_design', 'created', '12', null, '8', '6', '13', null);
INSERT INTO `adm_ci_type` VALUES ('19', '资源集合设计', '26', '资源集合设计', null, 'resource_set_design', 'created', '12', null, '9', '6', '13', null);
INSERT INTO `adm_ci_type` VALUES ('20', '路由设计', '29', '路由设计', null, 'route_design', 'created', '12', null, '10', '6', '14', null);
INSERT INTO `adm_ci_type` VALUES ('21', '资源集合调用设计', '15', '资源集合调用设计', null, 'resource_set_invoke_design', 'created', '12', null, '11', '6', '13', null);
INSERT INTO `adm_ci_type` VALUES ('22', '数据中心', '16', '数据中心', null, 'data_center', 'created', '11', null, '3', '5', '13', null);
INSERT INTO `adm_ci_type` VALUES ('23', '网段', '21', '网段', null, 'network_segment', 'created', '11', null, '4', '5', '14', null);
INSERT INTO `adm_ci_type` VALUES ('24', '网络区域', '17', '网络区域', null, 'network_zone', 'created', '11', null, '5', '5', '13', null);
INSERT INTO `adm_ci_type` VALUES ('25', '默认安全策略', '15', '默认安全策略', null, 'default_security_policy', 'created', '11', null, '6', '5', '14', null);
INSERT INTO `adm_ci_type` VALUES ('26', '网络区域连接', '18', '网络区域连接', null, 'network_zone_link', 'created', '11', null, '7', '5', '14', null);
INSERT INTO `adm_ci_type` VALUES ('28', '业务区域', '19', '业务区域', null, 'business_zone', 'created', '11', null, '9', '5', '13', null);
INSERT INTO `adm_ci_type` VALUES ('29', '资源集合', '20', '资源集合', null, 'resource_set', 'created', '11', null, '10', '5', '13', null);
INSERT INTO `adm_ci_type` VALUES ('30', '路由', '28', '路由', null, 'route', 'created', '11', null, '11', '5', '14', null);
INSERT INTO `adm_ci_type` VALUES ('31', 'IP地址', '14', 'IP地址', null, 'ip_address', 'created', '10', null, '5', '4', '14', null);
INSERT INTO `adm_ci_type` VALUES ('32', '主机资源实例', '12', '主机资源实例', null, 'host_resource_instance', 'created', '10', null, '6', '4', '13', null);
INSERT INTO `adm_ci_type` VALUES ('33', '数据库资源实例', '12', '数据库资源实例', null, 'rdb_resource_instance', 'created', '10', null, '7', '4', '13', null);
INSERT INTO `adm_ci_type` VALUES ('34', '缓存资源实例', '12', '缓存资源实例', null, 'cache_resource_instance', 'created', '10', null, '8', '4', '13', null);
INSERT INTO `adm_ci_type` VALUES ('35', '负载均衡资源实例', '12', '负载均衡资源实例', null, 'lb_resource_instance', 'created', '10', null, '9', '4', '13', null);
INSERT INTO `adm_ci_type` VALUES ('36', '块存储', '13', '块存储', null, 'block_storage', 'created', '10', null, '10', '4', '13', null);
INSERT INTO `adm_ci_type` VALUES ('37', '应用系统设计', '1', '应用系统设计', null, 'app_system_design', 'created', '7', null, '3', '1', '13', null);
INSERT INTO `adm_ci_type` VALUES ('38', '子系统设计', '2', '子系统设计', null, 'subsys_design', 'created', '7', null, '4', '1', '13', null);
INSERT INTO `adm_ci_type` VALUES ('39', '单元设计', '3', '单元设计', null, 'unit_design', 'created', '7', null, '5', '1', '13', null);
INSERT INTO `adm_ci_type` VALUES ('40', '调用设计', '5', '调用设计', null, 'invoke_design', 'created', '7', null, '6', '1', '13', null);
INSERT INTO `adm_ci_type` VALUES ('41', '服务设计', '4', '服务设计', null, 'service_design', 'created', '7', null, '7', '1', '13', null);
INSERT INTO `adm_ci_type` VALUES ('42', '服务调用设计', '9', '服务调用设计', null, 'service_invoke_design', 'created', '7', null, '8', '1', '13', null);
INSERT INTO `adm_ci_type` VALUES ('43', '服务调用时序设计', '6', '服务调用时序设计', null, 'service_invoke_seq_design', 'created', '7', null, '9', '1', '13', null);
INSERT INTO `adm_ci_type` VALUES ('44', '差异化配置', '11', '差异化变量', null, 'diff_configuration', 'created', '8', null, '2', '2', '13', null);
INSERT INTO `adm_ci_type` VALUES ('45', '部署物料包', '27', '部署物料包', null, 'deploy_package', 'created', '8', null, '1', '2', '13', null);
INSERT INTO `adm_ci_type` VALUES ('46', '应用系统', '1', '应用系统', null, 'app_system', 'created', '9', null, '3', '3', '13', null);
INSERT INTO `adm_ci_type` VALUES ('47', '子系统', '7', '子系统', null, 'subsys', 'created', '9', null, '4', '3', '13', null);
INSERT INTO `adm_ci_type` VALUES ('48', '单元', '8', '单元', null, 'unit', 'created', '9', null, '5', '3', '13', null);
INSERT INTO `adm_ci_type` VALUES ('49', '调用', '10', '调用', null, 'invoke', 'created', '9', null, '6', '3', '13', null);
INSERT INTO `adm_ci_type` VALUES ('50', '应用实例', '15', '应用实例', null, 'app_instance', 'created', '9', null, '7', '3', '13', null);
INSERT INTO `adm_ci_type` VALUES ('51', '数据库实例', '15', '数据库实例', null, 'rdb_instance', 'created', '9', null, '8', '3', '13', null);
INSERT INTO `adm_ci_type` VALUES ('52', '缓存实例', '15', '缓存实例', null, 'cache_instance', 'created', '9', null, '9', '3', '13', null);
INSERT INTO `adm_ci_type` VALUES ('53', '负载均衡实例', '15', '负载均衡实例', null, 'lb_instance', 'created', '9', null, '10', '3', '13', null);
INSERT INTO `adm_ci_type` VALUES ('54', '节点类型', '1', '业务区域和资源集合的类型', null, 'node_type', 'created', null, null, '1', '5', '15', null);

-- ----------------------------
-- Records of adm_ci_type_attr_base
-- ----------------------------
INSERT INTO `adm_ci_type_attr_base` VALUES ('1', '1', '全局唯一ID', '全局唯一ID', 'text', 'guid', 'varchar', '15', null, null, null, null, '0', '0', '0', '0', '1', '0', '0', '0', null, 'notCreated', '1', '0', '0', null, null, '0');
INSERT INTO `adm_ci_type_attr_base` VALUES ('2', '1', '前全局唯一ID', '前一版本数据的guid', 'text', 'p_guid', 'varchar', '15', null, null, null, null, '0', '0', '0', '1', '0', '0', '0', '0', null, 'notCreated', '1', '0', '0', null, null, '1');
INSERT INTO `adm_ci_type_attr_base` VALUES ('3', '1', '根全局唯一ID', '原始数据guid', 'text', 'r_guid', 'varchar', '15', null, null, null, null, '0', '0', '0', '0', '0', '0', '0', '0', null, 'notCreated', '1', '0', '0', null, null, '0');
INSERT INTO `adm_ci_type_attr_base` VALUES ('4', '1', '更新用户', '更新用户', 'text', 'updated_by', 'varchar', '50', null, null, null, null, '0', '0', '0', '0', '0', '1', '0', '0', null, 'notCreated', '1', '0', '0', null, null, '1');
INSERT INTO `adm_ci_type_attr_base` VALUES ('5', '1', '更新日期', '更新日期', 'date', 'updated_date', 'datetime', '1', null, null, null, null, '0', '0', '0', '0', '0', '1', '0', '0', null, 'notCreated', '1', '0', '0', null, null, '1');
INSERT INTO `adm_ci_type_attr_base` VALUES ('6', '1', '创建用户', '创建用户', 'text', 'created_by', 'varchar', '50', null, null, null, null, '0', '0', '0', '0', '0', '1', '0', '0', null, 'notCreated', '1', '0', '0', null, null, '0');
INSERT INTO `adm_ci_type_attr_base` VALUES ('7', '1', '创建日期', '创建日期', 'date', 'created_date', 'datetime', '1', null, null, null, null, '0', '0', '0', '0', '0', '1', '0', '0', null, 'notCreated', '1', '0', '0', null, null, '0');
INSERT INTO `adm_ci_type_attr_base` VALUES ('8', '1', '状态', '状态', 'select', 'state', 'int', '15', null, null, null, null, '0', '0', '0', '0', '0', '0', '0', '0', null, 'notCreated', '1', '0', '0', null, null, '0');
INSERT INTO `adm_ci_type_attr_base` VALUES ('9', '1', '唯一名称', '唯一名称', 'text', 'key_name', 'varchar', '1000', null, null, null, null, '1', '1', '1', '0', '1', '0', '0', '0', null, 'notCreated', '1', '0', '1', null, null, '0');
INSERT INTO `adm_ci_type_attr_base` VALUES ('10', '1', '状态编码', '状态编码', 'text', 'state_code', 'varchar', '50', null, null, null, null, '2', '1', '2', '0', '0', '0', '0', '0', null, 'notCreated', '1', '0', '1', null, null, '0');
INSERT INTO `adm_ci_type_attr_base` VALUES ('11', '1', '确认日期', '确认日期', 'text', 'fixed_date', 'varchar', '19', null, null, null, null, '3', '1', '3', '1', '0', '0', '0', '0', null, 'notCreated', '1', '0', '0', null, null, '0');
INSERT INTO `adm_ci_type_attr_base` VALUES ('12', '1', '编码', '编码', 'text', 'code', 'varchar', '1000', null, null, null, null, '4', '1', '4', '0', '0', '0', '1', '0', null, 'notCreated', '1', '0', '0', null, null, '0');

-- ----------------------------
-- Records of adm_ci_type_attr_group
-- ----------------------------

-- ----------------------------
-- Records of adm_files
-- ----------------------------

-- ----------------------------
-- Records of adm_integrate_template
-- ----------------------------
INSERT INTO `adm_integrate_template` VALUES ('2', '26', 'test', 'test');

-- ----------------------------
-- Records of adm_integrate_template_alias
-- ----------------------------
INSERT INTO `adm_integrate_template_alias` VALUES ('1', '26', '2', '网络区域连接');
INSERT INTO `adm_integrate_template_alias` VALUES ('2', '24', '2', '2-1-网络区域2-关联');
INSERT INTO `adm_integrate_template_alias` VALUES ('3', '28', '2', '3-1-业务区域-网络区域');
INSERT INTO `adm_integrate_template_alias` VALUES ('4', '29', '2', '4-1-资源集合-业务区域');

-- ----------------------------
-- Table structure for adm_integrate_template_alias_attr
-- ----------------------------
-- ----------------------------
-- Records of adm_integrate_template_alias_attr
-- ----------------------------
INSERT INTO `adm_integrate_template_alias_attr` VALUES ('1', '1', '422', '1', '1', '编码', null, 'networkZoneLink$code', '1', null, null);
INSERT INTO `adm_integrate_template_alias_attr` VALUES ('2', '2', '382', '1', '1', '编码', null, 'networkZoneLink-networkZone$code', '1', null, null);
INSERT INTO `adm_integrate_template_alias_attr` VALUES ('3', '3', '461', '1', '1', '编码', null, 'networkZoneLink-networkZone-businessZone$code', '1', null, null);
INSERT INTO `adm_integrate_template_alias_attr` VALUES ('4', '4', '480', '1', '1', '编码', null, 'networkZoneLink-networkZone-businessZone-resourceSet$code', '1', null, null);


-- ----------------------------
-- Records of adm_integrate_template_relation
-- ----------------------------
INSERT INTO `adm_integrate_template_relation` VALUES ('1', '2', '424', '1', '1');
INSERT INTO `adm_integrate_template_relation` VALUES ('2', '3', '463', '2', '0');
INSERT INTO `adm_integrate_template_relation` VALUES ('3', '4', '481', '3', '0');

-- ----------------------------
-- Records of adm_menu
-- ----------------------------
INSERT INTO `adm_menu` VALUES ('1', 'DATA_QUERY', '数据查询', null, '1', null, null, null, '0');
INSERT INTO `adm_menu` VALUES ('2', 'DATA_MANAGEMENT', '数据管理', null, '2', null, null, null, '0');
INSERT INTO `adm_menu` VALUES ('4', 'VIEW_MANAGEMENT', '视图管理', null, '4', null, null, null, '0');
INSERT INTO `adm_menu` VALUES ('5', 'ADMIN', '系统', null, '5', null, null, null, '0');
INSERT INTO `adm_menu` VALUES ('6', 'DESIGNING_CI_DATA_ENQUIRY', 'CI数据查询', null, '6', null, '1', null, '0');
INSERT INTO `adm_menu` VALUES ('7', 'DESIGNING_CI_INTEGRATED_QUERY_EXECUTION', 'CI数据综合查询', null, '7', null, '1', null, '0');
INSERT INTO `adm_menu` VALUES ('8', 'CMDB_DESIGNING_ENUM_ENQUIRY', '枚举数据查询', null, '8', null, '1', null, '0');
INSERT INTO `adm_menu` VALUES ('9', 'DESIGNING_CI_DATA_MANAGEMENT', 'CI数据管理', null, '9', null, '2', null, '0');
INSERT INTO `adm_menu` VALUES ('10', 'DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT', 'CI综合查询管理', null, '10', null, '2', null, '0');
INSERT INTO `adm_menu` VALUES ('11', 'CMDB_DESIGNING_ENUM_MANAGEMENT', '枚举数据管理', null, '11', null, '2', null, '0');
INSERT INTO `adm_menu` VALUES ('16', 'IDC_PLANNING_DESIGN', 'IDC规划设计', null, '16', null, '4', null, '0');
INSERT INTO `adm_menu` VALUES ('17', 'IDC_RESOURCE_PLANNING', 'IDC资源规划', null, '17', null, '4', null, '0');
INSERT INTO `adm_menu` VALUES ('18', 'APPLICATION_ARCHITECTURE_DESIGN', '应用架构设计', null, '18', null, '4', null, '0');
INSERT INTO `adm_menu` VALUES ('19', 'APPLICATION_DEPLOYMENT_DESIGN', '应用部署设计', null, '19', null, '4', null, '0');
INSERT INTO `adm_menu` VALUES ('20', 'ADMIN_CMDB_MODEL_MANAGEMENT', 'CMDB模型管理', null, '20', null, '5', null, '0');
INSERT INTO `adm_menu` VALUES ('21', 'ADMIN_PERMISSION_MANAGEMENT', '系统权限管理', null, '21', null, '5', null, '0');
INSERT INTO `adm_menu` VALUES ('22', 'CMDB_ADMIN_BASE_DATA_MANAGEMENT', '基础数据管理', null, '22', null, '5', null, '0');
INSERT INTO `adm_menu` VALUES ('23', 'ADMIN_QUERY_LOG', '日志查询', null, '23', null, '5', null, '0');
INSERT INTO `adm_menu` VALUES ('24', 'ADMIN_USER_PASSWORD_MANAGEMENT', '用户密码管理', null, '24', null, '5', null, '0');

-- ----------------------------
-- Records of adm_role
-- ----------------------------
INSERT INTO `adm_role` VALUES ('1', 'SUPER_ADMIN', '超级管理员', null, null, 'ADMIN', '1');
INSERT INTO `adm_role` VALUES ('2', 'CMDB_ADMIN', 'CMDB管理员', null, null, 'ADMIN', '0');
INSERT INTO `adm_role` VALUES ('3', 'admin', null, null, null, null, null);
INSERT INTO `adm_role` VALUES ('11', 'STG_OPS', null, null, null, null, null);

-- ----------------------------
-- Records of adm_role_ci_type
-- ----------------------------
INSERT INTO `adm_role_ci_type` VALUES ('1', '1', '1', '管理角色', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('2', '1', '2', '单元类型', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('3', '1', '3', '部署环境', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('4', '1', '4', '法人', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('5', '1', '5', '应用域', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('6', '1', '6', '云厂商', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('7', '1', '7', '集群类型', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('8', '1', '8', '集群节点类型', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('9', '1', '9', '资源实例类型', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('10', '1', '10', '资源实例规格', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('11', '1', '11', '资源实例系统', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('12', '1', '12', '数据中心设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('13', '1', '13', '网段设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('14', '1', '14', '网络区域设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('15', '1', '15', '默认安全策略设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('16', '1', '16', '网络区域连接设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('18', '1', '18', '业务区域设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('19', '1', '19', '资源集合设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('20', '1', '20', '资源集合路由设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('21', '1', '21', '资源集合调用设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('22', '1', '22', '数据中心', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('23', '1', '23', '网段', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('24', '1', '24', '网络区域', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('25', '1', '25', '默认安全策略', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('26', '1', '26', '网络区域连接', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('28', '1', '28', '业务区域', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('29', '1', '29', '资源集合', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('30', '1', '30', '资源集合路由', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('31', '1', '31', 'IP地址', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('32', '1', '32', '主机资源实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('33', '1', '33', '数据库资源实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('34', '1', '34', '缓存资源实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('35', '1', '35', '负载均衡资源实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('36', '1', '36', '块存储', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('37', '1', '37', '应用系统设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('38', '1', '38', '子系统设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('39', '1', '39', '单元设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('40', '1', '40', '调用设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('41', '1', '41', '服务设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('42', '1', '42', '服务调用设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('43', '1', '43', '服务调用时序设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('44', '1', '44', '差异化配置', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('45', '1', '45', '部署物料包', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('46', '1', '46', '应用系统', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('47', '1', '47', '子系统', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('48', '1', '48', '单元', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('49', '1', '49', '调用', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('50', '1', '50', '应用实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('51', '1', '51', '数据库实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('52', '1', '52', '缓存实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('53', '1', '53', '负载均衡实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('54', '1', '54', '节点类型', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('55', '3', '1', '管理角色', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('56', '3', '2', '单元类型', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('57', '3', '3', '部署环境', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('58', '3', '4', '法人', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('59', '3', '5', '应用域', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('60', '3', '6', '云厂商', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('61', '3', '7', '集群类型', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('62', '3', '8', '集群节点类型', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('63', '3', '9', '资源实例类型', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('64', '3', '10', '资源实例规格', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('65', '3', '11', '资源实例系统', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('66', '3', '12', '数据中心设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('67', '3', '13', '网段设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('68', '3', '14', '网络区域设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('69', '3', '15', '默认安全策略设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('70', '3', '16', '网络区域连接设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('71', '3', '18', '业务区域设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('72', '3', '19', '资源集合设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('73', '3', '20', '路由设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('74', '3', '21', '资源集合调用设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('75', '3', '22', '数据中心', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('76', '3', '23', '网段', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('77', '3', '24', '网络区域', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('78', '3', '25', '默认安全策略', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('79', '3', '26', '网络区域连接', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('80', '3', '28', '业务区域', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('81', '3', '29', '资源集合', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('82', '3', '30', '路由', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('83', '3', '31', 'IP地址', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('84', '3', '32', '主机资源实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('85', '3', '33', '数据库资源实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('86', '3', '34', '缓存资源实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('87', '3', '35', '负载均衡资源实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('88', '3', '36', '块存储', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('89', '3', '37', '应用系统设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('90', '3', '38', '子系统设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('91', '3', '39', '单元设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('92', '3', '40', '调用设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('93', '3', '41', '服务设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('94', '3', '42', '服务调用设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('95', '3', '43', '服务调用时序设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('96', '3', '44', '差异化配置', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('97', '3', '45', '部署物料包', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('98', '3', '46', '应用系统', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('99', '3', '47', '子系统', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('100', '3', '48', '单元', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('101', '3', '49', '调用', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('102', '3', '50', '应用实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('103', '3', '51', '数据库实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('104', '3', '52', '缓存实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('105', '3', '53', '负载均衡实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('106', '3', '54', '节点类型', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('471', '11', '1', '管理角色', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('472', '11', '2', '单元类型', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('473', '11', '3', '部署环境', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('474', '11', '4', '法人', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('475', '11', '5', '应用域', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('476', '11', '6', '云厂商', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('477', '11', '7', '集群类型', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('478', '11', '8', '集群节点类型', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('479', '11', '9', '资源实例类型', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('480', '11', '10', '资源实例规格', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('481', '11', '11', '资源实例系统', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('482', '11', '12', '数据中心设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('483', '11', '13', '网段设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('484', '11', '14', '网络区域设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('485', '11', '15', '默认安全策略设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('486', '11', '16', '网络区域连接设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('487', '11', '18', '业务区域设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('488', '11', '19', '资源集合设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('489', '11', '20', '路由设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('490', '11', '21', '资源集合调用设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('491', '11', '22', '数据中心', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('492', '11', '23', '网段', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('493', '11', '24', '网络区域', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('494', '11', '25', '默认安全策略', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('495', '11', '26', '网络区域连接', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('496', '11', '28', '业务区域', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('497', '11', '29', '资源集合', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('498', '11', '30', '路由', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('499', '11', '31', 'IP地址', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('500', '11', '32', '主机资源实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('501', '11', '33', '数据库资源实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('502', '11', '34', '缓存资源实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('503', '11', '35', '负载均衡资源实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('504', '11', '36', '块存储', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('505', '11', '37', '应用系统设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('506', '11', '38', '子系统设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('507', '11', '39', '单元设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('508', '11', '40', '调用设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('509', '11', '41', '服务设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('510', '11', '42', '服务调用设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('511', '11', '43', '服务调用时序设计', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('512', '11', '44', '差异化配置', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('513', '11', '45', '部署物料包', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('514', '11', '46', '应用系统', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('515', '11', '47', '子系统', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('516', '11', '48', '单元', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('517', '11', '49', '调用', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('518', '11', '50', '应用实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('519', '11', '51', '数据库实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('520', '11', '52', '缓存实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('521', '11', '53', '负载均衡实例', 'N', 'N', 'N', 'N', 'N', 'N');
INSERT INTO `adm_role_ci_type` VALUES ('522', '11', '54', '节点类型', 'N', 'N', 'N', 'N', 'N', 'N');

-- ----------------------------
-- Records of adm_role_ci_type_ctrl_attr
-- ----------------------------
INSERT INTO `adm_role_ci_type_ctrl_attr` VALUES ('1', '37', 'N', 'N', 'N', 'Y', 'N', 'N');

-- ----------------------------
-- Records of adm_role_ci_type_ctrl_attr_condition
-- ----------------------------
INSERT INTO `adm_role_ci_type_ctrl_attr_condition` VALUES ('1', '1', '693', '应用域', '0005_0000000005', null);

-- ----------------------------
-- Records of adm_role_menu
-- ----------------------------
INSERT INTO `adm_role_menu` VALUES ('1', '1', '1', '0');
INSERT INTO `adm_role_menu` VALUES ('2', '1', '2', '0');
INSERT INTO `adm_role_menu` VALUES ('5', '1', '5', '1');
INSERT INTO `adm_role_menu` VALUES ('6', '1', '6', '0');
INSERT INTO `adm_role_menu` VALUES ('7', '1', '7', '0');
INSERT INTO `adm_role_menu` VALUES ('8', '1', '8', '0');
INSERT INTO `adm_role_menu` VALUES ('9', '1', '9', '0');
INSERT INTO `adm_role_menu` VALUES ('10', '1', '10', '0');
INSERT INTO `adm_role_menu` VALUES ('11', '1', '11', '0');
INSERT INTO `adm_role_menu` VALUES ('16', '1', '16', '0');
INSERT INTO `adm_role_menu` VALUES ('17', '1', '17', '0');
INSERT INTO `adm_role_menu` VALUES ('18', '1', '18', '0');
INSERT INTO `adm_role_menu` VALUES ('19', '1', '19', '0');
INSERT INTO `adm_role_menu` VALUES ('20', '1', '20', '0');
INSERT INTO `adm_role_menu` VALUES ('21', '1', '21', '1');
INSERT INTO `adm_role_menu` VALUES ('22', '1', '22', '0');
INSERT INTO `adm_role_menu` VALUES ('23', '1', '23', '0');
INSERT INTO `adm_role_menu` VALUES ('24', '1', '24', '0');

-- ----------------------------
-- Records of adm_role_user
-- ----------------------------
INSERT INTO `adm_role_user` VALUES ('1', '1', '1', '1');


-- ----------------------------
-- Records of adm_sequence
-- ----------------------------
INSERT INTO `adm_sequence` VALUES ('2', 'manage_role', '1', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('4', 'data_center_design', '9', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('9', 'network_segment_design', '18', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('10', 'network_zone_design', '5', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('11', 'application_domain', '5', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('12', 'business_zone_design', '3', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('13', 'unit_type', '6', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('14', 'resource_set_design', '9', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('16', 'resource_set_invoke_design', '10', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('18', 'network_zone_link_design', '3', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('20', 'default_security_policy_design', '10', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('22', 'network_zone_route_design', '3', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('23', 'resource_set_route_design', '1', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('24', 'cloud_vendor', '2', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('25', 'deploy_environment', '4', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('26', 'data_center', '3', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('27', 'network_segment', '24', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('28', 'network_zone', '7', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('29', 'business_zone', '6', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('30', 'cluster_type', '5', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('31', 'cluster_node_type', '4', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('33', 'resource_set', '18', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('35', 'ip_address', '18', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('36', 'resource_instance_type', '10', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('37', 'resource_instance_system', '4', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('38', 'resource_instance_spec', '4', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('41', 'host_resource_instance', '4', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('43', 'node_type', '2', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('45', 'rdb_resource_instance', '1', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('47', 'lb_resource_instance', '1', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('48', 'app_system_design', '2', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('49', 'subsys_design', '2', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('50', 'unit_design', '5', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('52', 'invoke_design', '3', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('53', 'service_design', '1', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('54', 'service_invoke_design', '1', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('55', 'legal_person', '1', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('56', 'app_system', '1', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('57', 'subsys', '2', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('65', 'unit', '4', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('70', 'app_instance', '2', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('71', 'network_zone_link', '3', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('72', 'route_design', '6', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('74', 'route', '6', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('75', 'default_security_policy', '11', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('78', 'rdb_instance', '1', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('79', 'lb_instance', '1', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('82', 'invoke', '3', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('83', 'deploy_package', '2', '1', '8', 'N');
INSERT INTO `adm_sequence` VALUES ('84', 'diff_configuration', '9', '1', '8', 'N');

-- ----------------------------
-- Records of adm_state_transition
-- ----------------------------
INSERT INTO `adm_state_transition` VALUES ('1', '37', '0', null, null, '48', '54', 'active');
INSERT INTO `adm_state_transition` VALUES ('2', null, null, '37', '0', '45', '52', 'active');
INSERT INTO `adm_state_transition` VALUES ('3', '37', '0', '37', '0', '46', '56', 'active');
INSERT INTO `adm_state_transition` VALUES ('4', '37', '0', '37', '1', '49', '57', 'active');
INSERT INTO `adm_state_transition` VALUES ('5', '37', '1', '38', '0', '46', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('6', '38', '0', '37', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('7', '37', '1', '39', '0', '48', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('8', '39', '0', '37', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('9', '38', '0', '38', '0', '46', '56', 'active');
INSERT INTO `adm_state_transition` VALUES ('10', '38', '0', '38', '1', '49', '57', 'active');
INSERT INTO `adm_state_transition` VALUES ('11', '38', '1', '38', '0', '46', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('12', '38', '0', '38', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('13', '38', '1', '39', '0', '48', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('14', '39', '0', '38', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('15', '39', '0', '39', '1', '49', '57', 'active');
INSERT INTO `adm_state_transition` VALUES ('16', '40', '0', null, null, '48', '54', 'active');
INSERT INTO `adm_state_transition` VALUES ('17', null, null, '40', '0', '45', '52', 'active');
INSERT INTO `adm_state_transition` VALUES ('18', '40', '0', '40', '0', '46', '56', 'active');
INSERT INTO `adm_state_transition` VALUES ('19', '40', '0', '40', '1', '49', '57', 'active');
INSERT INTO `adm_state_transition` VALUES ('20', '40', '1', '41', '0', '50', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('21', '41', '0', '40', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('22', '41', '0', '41', '1', '49', '57', 'active');
INSERT INTO `adm_state_transition` VALUES ('23', '40', '1', '43', '0', '51', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('24', '43', '0', '40', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('25', '43', '0', '43', '1', '49', '57', 'active');
INSERT INTO `adm_state_transition` VALUES ('26', '41', '1', '43', '0', '51', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('27', '43', '0', '41', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('28', '43', '1', '41', '0', '50', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('29', '41', '0', '43', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('30', '41', '1', '42', '0', '46', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('31', '42', '0', '41', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('32', '43', '1', '42', '0', '46', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('33', '42', '0', '43', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('34', '42', '0', '42', '0', '46', '56', 'active');
INSERT INTO `adm_state_transition` VALUES ('35', '42', '0', '42', '1', '49', '57', 'active');
INSERT INTO `adm_state_transition` VALUES ('36', '42', '1', '43', '0', '51', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('37', '43', '0', '42', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('38', '42', '1', '41', '0', '50', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('39', '41', '0', '42', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('40', '43', '1', '44', '0', '48', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('41', '44', '0', '43', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('42', '44', '0', '44', '1', '49', '57', 'active');
INSERT INTO `adm_state_transition` VALUES ('43', '34', '0', null, null, '48', '54', 'active');
INSERT INTO `adm_state_transition` VALUES ('44', null, null, '34', '0', '45', '52', 'active');
INSERT INTO `adm_state_transition` VALUES ('45', '34', '0', '34', '0', '46', '56', 'active');
INSERT INTO `adm_state_transition` VALUES ('46', '34', '0', '34', '1', '49', '57', 'active');
INSERT INTO `adm_state_transition` VALUES ('47', '34', '1', '35', '0', '46', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('48', '35', '0', '34', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('49', '34', '1', '36', '0', '48', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('50', '36', '0', '34', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('51', '35', '0', '35', '0', '46', '56', 'active');
INSERT INTO `adm_state_transition` VALUES ('52', '35', '0', '35', '1', '49', '57', 'active');
INSERT INTO `adm_state_transition` VALUES ('53', '35', '1', '35', '0', '46', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('54', '35', '0', '35', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('55', '35', '1', '36', '0', '48', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('56', '36', '0', '35', '1', '47', '55', 'active');
INSERT INTO `adm_state_transition` VALUES ('57', '36', '0', '36', '1', '49', '57', 'active');
INSERT INTO `adm_state_transition` VALUES ('58', '40', '1', '42', '0', '46', '53', 'active');
INSERT INTO `adm_state_transition` VALUES ('59', '42', '0', '40', '1', '47', '55', 'active');

-- ----------------------------
-- Records of adm_tenement
-- ----------------------------

-- ----------------------------
-- Records of adm_user
-- ----------------------------
INSERT INTO `adm_user` VALUES ('1', 'admin', 'admin', '$2a$10$Gh3WDwZ8kFpxbmo/h.oywuN.LuYwgrlx53ZeG.mz7P4eKgct7IYZm', 'admin', null, '0', '1');
SET FOREIGN_KEY_CHECKS=1;
