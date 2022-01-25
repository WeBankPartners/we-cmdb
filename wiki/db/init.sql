SET NAMES utf8 ;
SET FOREIGN_KEY_CHECKS=0;
CREATE TABLE `sys_basekey_cat` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name` varchar(255) NOT NULL COMMENT '显示名',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


LOCK TABLES `sys_basekey_cat` WRITE;
/*!40000 ALTER TABLE `sys_basekey_cat` DISABLE KEYS */;
INSERT INTO `sys_basekey_cat` (`id`, `name`, `description`) VALUES ('ci_group','ci_group',NULL);
INSERT INTO `sys_basekey_cat` (`id`, `name`, `description`) VALUES ('ci_layer','ci_layer',NULL);
INSERT INTO `sys_basekey_cat` (`id`, `name`, `description`) VALUES ('ref_type','ref_type',NULL);
/*!40000 ALTER TABLE `sys_basekey_cat` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_basekey_code` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `cat_id` varchar(32) NOT NULL COMMENT '所属配置组',
  `code` varchar(255) NOT NULL COMMENT '配置key',
  `value` varchar(255) DEFAULT NULL COMMENT '配置value',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `seq_no` int(11) DEFAULT '0' COMMENT '排序号',
  `status` varchar(20) DEFAULT 'active' COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `sys_basekey_code_cat_id` (`cat_id`),
  CONSTRAINT `sys_basekey_code_cat_id` FOREIGN KEY (`cat_id`) REFERENCES `sys_basekey_cat` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


LOCK TABLES `sys_basekey_code` WRITE;
/*!40000 ALTER TABLE `sys_basekey_code` DISABLE KEYS */;
INSERT INTO `sys_basekey_code` (`id`, `cat_id`, `code`, `value`, `description`, `seq_no`, `status`) VALUES ('ref_type__belong','ref_type','belong','属于',NULL,1,'active');
INSERT INTO `sys_basekey_code` (`id`, `cat_id`, `code`, `value`, `description`, `seq_no`, `status`) VALUES ('ref_type__depend','ref_type','depend','依赖',NULL,2,'active');
INSERT INTO `sys_basekey_code` (`id`, `cat_id`, `code`, `value`, `description`, `seq_no`, `status`) VALUES ('ref_type__realize','ref_type','realize','实现',NULL,3,'active');
INSERT INTO `sys_basekey_code` (`id`, `cat_id`, `code`, `value`, `description`, `seq_no`, `status`) VALUES ('ref_type__relation','ref_type','relation','关联',NULL,5,'active');
INSERT INTO `sys_basekey_code` (`id`, `cat_id`, `code`, `value`, `description`, `seq_no`, `status`) VALUES ('ref_type__use','ref_type','use','使用',NULL,4,'active');
/*!40000 ALTER TABLE `sys_basekey_code` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_ci_template` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `image_file` varchar(32) DEFAULT NULL COMMENT '图标',
  `state_machine` varchar(32) NOT NULL COMMENT '所属状态机',
  PRIMARY KEY (`id`),
  KEY `sys_ci_template_machine` (`state_machine`),
  KEY `sys_ci_template_image_idx` (`image_file`),
  CONSTRAINT `sys_ci_template_image` FOREIGN KEY (`image_file`) REFERENCES `sys_files` (`guid`),
  CONSTRAINT `sys_ci_template_machine` FOREIGN KEY (`state_machine`) REFERENCES `sys_state_machine` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `sys_ci_template` WRITE;
/*!40000 ALTER TABLE `sys_ci_template` DISABLE KEYS */;
INSERT INTO `sys_ci_template` (`id`, `description`, `image_file`, `state_machine`) VALUES ('create_destroy','创销类模版','60a46b5948a2b249','create_destroy');
INSERT INTO `sys_ci_template` (`id`, `description`, `image_file`, `state_machine`) VALUES ('design','设计类模版','60a46b5948a2b249','design');
INSERT INTO `sys_ci_template` (`id`, `description`, `image_file`, `state_machine`) VALUES ('start_stop','起停类模版','60a46b5948a2b249','start_stop');
/*!40000 ALTER TABLE `sys_ci_template` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_ci_template_attr` (
  `id` varchar(128) NOT NULL COMMENT 'ci_template.name',
  `ci_template` varchar(32) NOT NULL COMMENT '所属ci模板',
  `name` varchar(32) NOT NULL COMMENT '属性名',
  `display_name` varchar(128) NOT NULL COMMENT '显示名',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `status` varchar(32) DEFAULT 'notCreated' COMMENT '状态',
  `input_type` varchar(32) NOT NULL COMMENT '字段类型',
  `data_type` varchar(32) NOT NULL COMMENT '数据库数据类型',
  `data_length` int(11) DEFAULT '0',
  `text_validate` varchar(1024) DEFAULT NULL COMMENT '正则校验',
  `ref_ci_type` varchar(32) DEFAULT NULL COMMENT '关联ci',
  `ref_name` varchar(64) DEFAULT NULL COMMENT '关联显示名',
  `ref_type` varchar(32) DEFAULT NULL COMMENT '关联类型',
  `ref_filter` varchar(4096) DEFAULT NULL COMMENT '关联过滤规则',
  `ref_update_state_validate` varchar(2048) DEFAULT NULL COMMENT '关联状态映射',
  `ref_confirm_state_validate` varchar(2048) DEFAULT NULL COMMENT '确认状态映射',
  `select_list` varchar(32) DEFAULT NULL COMMENT '枚举列表',
  `ui_search_order` int(11) DEFAULT '0' COMMENT '搜索条件排序',
  `ui_form_order` int(11) DEFAULT '0' COMMENT '字段显示排序',
  `unique_constraint` varchar(16) DEFAULT 'no' COMMENT '唯一约束',
  `ui_nullable` varchar(16) DEFAULT 'no' COMMENT '前端允许为空',
  `nullable` varchar(16) DEFAULT 'no' COMMENT '允许为空',
  `editable` varchar(16) DEFAULT 'yes' COMMENT '是否可编辑',
  `display_by_default` varchar(16) DEFAULT 'yes' COMMENT '默认显示',
  `permission_usage` varchar(16) DEFAULT 'no' COMMENT '允许权限控制',
  `reset_on_edit` varchar(16) DEFAULT 'no' COMMENT '编辑重置',
  `source` varchar(16) NOT NULL DEFAULT 'custom' COMMENT 'template or custom',
  `customizable` varchar(16) NOT NULL DEFAULT 'yes' COMMENT '可以修改',
  `autofillable` varchar(16) DEFAULT 'no' COMMENT '是否自动填充',
  `autofill_rule` varchar(4096) DEFAULT NULL COMMENT '填充规则',
  `autofill_type` varchar(32) DEFAULT NULL COMMENT 'suggest or forced',
  `edit_group_control` varchar(32) DEFAULT 'no',
  `edit_group_value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sys_ci_template_attr_ci_template` (`ci_template`),
  KEY `sys_ci_template_attr_ref_ci_type` (`ref_ci_type`),
  KEY `sys_ci_template_attr_ref_type` (`ref_type`),
  CONSTRAINT `sys_ci_template_attr_ci_template` FOREIGN KEY (`ci_template`) REFERENCES `sys_ci_template` (`id`),
  CONSTRAINT `sys_ci_template_attr_ref_ci_type` FOREIGN KEY (`ref_ci_type`) REFERENCES `sys_ci_type` (`id`),
  CONSTRAINT `sys_ci_template_attr_ref_type` FOREIGN KEY (`ref_type`) REFERENCES `sys_basekey_code` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `sys_ci_template_attr` WRITE;
/*!40000 ALTER TABLE `sys_ci_template_attr` DISABLE KEYS */;
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('create_destroy__asset_id','create_destroy','asset_id','资产ID','资产ID','notCreated','text','varchar',1024,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,5,'yes','yes','yes','yes','yes','no','no','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('create_destroy__code','create_destroy','code','编码简称','编码简称','notCreated','text','varchar',64,'[0-9a-zA-Z]{2,10}',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,3,'no','no','no','yes','yes','no','no','template','yes','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('create_destroy__confirm.time','create_destroy','confirm_time','确认时间','确认时间','notCreated','datetime','datetime',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,4,'no','yes','yes','no','yes','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('create_destroy__create_time','create_destroy','create_time','创建时间','创建时间','notCreated','datetime','datetime',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'no','yes','no','no','no','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('create_destroy__create_user','create_destroy','create_user','创建人','创建人','notCreated','text','varchar',64,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'no','yes','no','no','no','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('create_destroy__guid','create_destroy','guid','全局唯一ID','全局唯一ID','notCreated','text','varchar',64,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'yes','yes','no','no','no','no','no','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('create_destroy__key_name','create_destroy','key_name','唯一名称','唯一名称','notCreated','text','varchar',1024,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'yes','yes','yes','no','yes','no','no','template','yes','yes',NULL,'force','no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('create_destroy__state','create_destroy','state','状态','状态','notCreated','text','varchar',64,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,2,'no','yes','yes','no','yes','no','no','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('create_destroy__update_time','create_destroy','update_time','修改时间','修改时间','notCreated','datetime','datetime',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'no','yes','no','no','no','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('create_destroy__update_user','create_destroy','update_user','修改人','修改人','notCreated','text','varchar',64,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'no','yes','no','no','no','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('design__code','design','code','编码简称','编码简称','notCreated','text','varchar',64,'[0-9a-zA-Z]{2,10}',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,3,'no','no','no','yes','yes','no','no','template','yes','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('design__confirm.time','design','confirm_time','确认时间','确认时间','notCreated','datetime','datetime',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,4,'no','yes','yes','no','yes','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('design__create_time','design','create_time','创建时间','创建时间','notCreated','datetime','datetime',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'no','yes','no','no','no','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('design__create_user','design','create_user','创建人','创建人','notCreated','text','varchar',64,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'no','yes','no','no','no','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('design__guid','design','guid','全局唯一ID','全局唯一ID','notCreated','text','varchar',64,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'yes','yes','no','no','no','no','no','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('design__key_name','design','key_name','唯一名称','唯一名称','notCreated','text','varchar',1024,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'yes','yes','yes','no','yes','no','no','template','yes','yes',NULL,'force','no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('design__state','design','state','状态','状态','notCreated','text','varchar',64,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,2,'no','yes','yes','no','yes','no','no','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('design__update_time','design','update_time','修改时间','修改时间','notCreated','datetime','datetime',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'no','yes','no','no','no','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('design__update_user','design','update_user','修改人','修改人','notCreated','text','varchar',64,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'no','yes','no','no','no','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('start_stop__asset_id','start_stop','asset_id','资产ID','资产ID','notCreated','text','varchar',1024,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,5,'yes','yes','yes','yes','yes','no','no','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('start_stop__code','start_stop','code','编码简称','编码简称','notCreated','text','varchar',64,'[0-9a-zA-Z]{2,10}',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,3,'no','no','no','yes','yes','no','no','template','yes','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('start_stop__confirm.time','start_stop','confirm_time','确认时间','确认时间','notCreated','datetime','datetime',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,4,'no','yes','yes','no','yes','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('start_stop__create_time','start_stop','create_time','创建时间','创建时间','notCreated','datetime','datetime',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'no','yes','no','no','no','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('start_stop__create_user','start_stop','create_user','创建人','创建人','notCreated','text','varchar',64,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'no','yes','no','no','no','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('start_stop__guid','start_stop','guid','全局唯一ID','全局唯一ID','notCreated','text','varchar',64,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'yes','yes','no','no','no','no','no','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('start_stop__key_name','start_stop','key_name','唯一名称','唯一名称','notCreated','text','varchar',1024,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'yes','yes','yes','no','yes','no','no','template','yes','yes',NULL,'force','no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('start_stop__state','start_stop','state','状态','状态','notCreated','text','varchar',64,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,2,'no','yes','yes','no','yes','no','no','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('start_stop__update_time','start_stop','update_time','修改时间','修改时间','notCreated','datetime','datetime',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'no','yes','no','no','no','no','yes','template','no','no',NULL,NULL,'no',NULL);
INSERT INTO `sys_ci_template_attr` (`id`, `ci_template`, `name`, `display_name`, `description`, `status`, `input_type`, `data_type`, `data_length`, `text_validate`, `ref_ci_type`, `ref_name`, `ref_type`, `ref_filter`, `ref_update_state_validate`, `ref_confirm_state_validate`, `select_list`, `ui_search_order`, `ui_form_order`, `unique_constraint`, `ui_nullable`, `nullable`, `editable`, `display_by_default`, `permission_usage`, `reset_on_edit`, `source`, `customizable`, `autofillable`, `autofill_rule`, `autofill_type`, `edit_group_control`, `edit_group_value`) VALUES ('start_stop__update_user','start_stop','update_user','修改人','修改人','notCreated','text','varchar',64,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'no','yes','no','no','no','no','yes','template','no','no',NULL,NULL,'no',NULL);
/*!40000 ALTER TABLE `sys_ci_template_attr` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_ci_type` (
  `id` varchar(32) NOT NULL COMMENT '名称主键',
  `display_name` varchar(32) NOT NULL COMMENT '显示名',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `status` varchar(20) DEFAULT 'notCreated' COMMENT '描述',
  `image_file` varchar(32) NOT NULL COMMENT '图标',
  `ci_group` varchar(32) NOT NULL COMMENT '所属图层',
  `ci_layer` varchar(32) NOT NULL COMMENT '图层层级',
  `ci_template` varchar(32) NOT NULL COMMENT '所属模版',
  `state_machine` varchar(32) NOT NULL COMMENT '关联状态机',
  `seq_no` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sys_ci_type_image` (`image_file`),
  KEY `sys_ci_type_group` (`ci_group`),
  KEY `sys_ci_type_layer` (`ci_layer`),
  KEY `sys_ci_type_template` (`ci_template`),
  KEY `sys_ci_type_machine` (`state_machine`),
  CONSTRAINT `sys_ci_type_group` FOREIGN KEY (`ci_group`) REFERENCES `sys_basekey_code` (`id`),
  CONSTRAINT `sys_ci_type_image` FOREIGN KEY (`image_file`) REFERENCES `sys_files` (`guid`),
  CONSTRAINT `sys_ci_type_layer` FOREIGN KEY (`ci_layer`) REFERENCES `sys_basekey_code` (`id`),
  CONSTRAINT `sys_ci_type_machine` FOREIGN KEY (`state_machine`) REFERENCES `sys_state_machine` (`id`),
  CONSTRAINT `sys_ci_type_template` FOREIGN KEY (`ci_template`) REFERENCES `sys_ci_template` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_ci_type_attr` (
  `id` varchar(128) NOT NULL COMMENT 'ci_type.name',
  `ci_type` varchar(32) NOT NULL COMMENT '所属ci',
  `name` varchar(32) NOT NULL COMMENT '属性名',
  `display_name` varchar(64) NOT NULL COMMENT '显示名',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `status` varchar(32) DEFAULT 'notCreated' COMMENT '状态',
  `input_type` varchar(32) NOT NULL COMMENT '字段类型',
  `data_type` varchar(32) NOT NULL,
  `data_length` int(11) DEFAULT '0',
  `text_validate` varchar(1024) DEFAULT NULL COMMENT '正则校验',
  `ref_ci_type` varchar(32) DEFAULT NULL COMMENT '关联ci',
  `ref_name` varchar(64) DEFAULT NULL COMMENT '关联显示名',
  `ref_type` varchar(32) DEFAULT NULL COMMENT '关联类型',
  `ref_filter` varchar(4096) DEFAULT NULL COMMENT '关联过滤规则',
  `ref_update_state_validate` varchar(2048) DEFAULT NULL COMMENT '关联状态映射',
  `ref_confirm_state_validate` varchar(2048) DEFAULT NULL,
  `select_list` varchar(32) DEFAULT NULL COMMENT '枚举列表',
  `ui_search_order` int(11) DEFAULT '0' COMMENT '搜索条件排序',
  `ui_form_order` int(11) DEFAULT '0' COMMENT '字段显示排序',
  `unique_constraint` varchar(16) DEFAULT 'no' COMMENT '唯一约束',
  `ui_nullable` varchar(16) DEFAULT 'no' COMMENT '前端允许为空',
  `nullable` varchar(16) DEFAULT 'no' COMMENT '允许为空',
  `editable` varchar(16) DEFAULT 'yes' COMMENT '是否可编辑',
  `display_by_default` varchar(16) DEFAULT 'yes' COMMENT '默认显示',
  `permission_usage` varchar(16) DEFAULT 'no' COMMENT '允许权限控制',
  `reset_on_edit` varchar(16) DEFAULT 'no' COMMENT '编辑重置',
  `source` varchar(16) NOT NULL DEFAULT 'custom' COMMENT 'template or custom',
  `customizable` varchar(16) NOT NULL DEFAULT 'yes' COMMENT '可以修改',
  `autofillable` varchar(16) DEFAULT 'no' COMMENT '是否自动填充',
  `autofill_rule` varchar(4096) DEFAULT NULL COMMENT '填充规则',
  `autofill_type` varchar(32) DEFAULT NULL COMMENT 'suggest or forced',
  `edit_group_control` varchar(32) DEFAULT 'no',
  `edit_group_value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sys_ci_type_attr_ref_ci_type` (`ref_ci_type`),
  KEY `sys_ci_type_attr_ref_type` (`ref_type`),
  KEY `sys_ci_attr_ci_type_idx` (`ci_type`),
  KEY `sys_ci_type_attr_select_list_idx` (`select_list`),
  CONSTRAINT `sys_ci_type_attr_ci_type` FOREIGN KEY (`ci_type`) REFERENCES `sys_ci_type` (`id`),
  CONSTRAINT `sys_ci_type_attr_ref_ci_type` FOREIGN KEY (`ref_ci_type`) REFERENCES `sys_ci_type` (`id`),
  CONSTRAINT `sys_ci_type_attr_ref_type` FOREIGN KEY (`ref_type`) REFERENCES `sys_basekey_code` (`id`),
  CONSTRAINT `sys_ci_type_attr_select_list` FOREIGN KEY (`select_list`) REFERENCES `sys_basekey_cat` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `sys_files` (
  `guid` varchar(32) NOT NULL COMMENT '随机主键',
  `type` varchar(32) DEFAULT NULL COMMENT '图片类型',
  `content` blob COMMENT '二进制图片',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `sys_files` WRITE;
/*!40000 ALTER TABLE `sys_files` DISABLE KEYS */;
INSERT INTO `sys_files` (`guid`, `type`, `content`, `update_time`) VALUES ('60a46b5948a2b249','png',0x89504E470D0A1A0A0000000D4948445200000080000000800806000000C33E61CB000000017352474200AECE1CE9000017AF494441547801ED3D09941445B291D5E71C301C720978012272082A9EC3A58820DE7F0101B9740514715957976306FD4F9941F0603D70451610105050BFA880A8283003A222A2A0B882222C8833F007988199AE3E2A37B2A59AAAACEA9EEAAEEEE9EAA1EBBD7E9519191119191195199995954DA0165D742D34F606609404703350684300EA5302A578DF0104DE75E5C062720D54D5A2269B6E0AEAA6765C9ED5F008B6E4714A213B428B0E0A041E74DD04EF46C039A38A52DE01D0E082670D2CC6277E8811CB1182980426BAFBC1D346F06B3B4ECA3B003EF933D009FE1EADA1041B0C72F585E5D1D2D536FC947600EF87708914806D144088C13047DC045A919BA03C06DA5A43128BE22CD37849823C3DE36337BF0E7FB70A76E8880D1C8AE97FEB087D961760AC0EFC8C02A56C0F403F03B7580547B0FBCF52598CC0521CDFEF0E8EF5A70AE866C8108FC116C4EDA4C205F832A33F5CC9C1CEA8AC3D555BEB13A12D6F7C667417C004A5F159FBD8D4CFF3214C8400AC51B617BDBF33F2203CBE12271E69BA1532BDA5700BF6565D3104CDC6FAF66320FA81AB1F7C170FFE6678A4AC0360F7DF44A7E1FB704C3FAC0307971DBEF204D425681027AC85FA082D5397C42FE75B0BDDC5125880755D207345A7037484020C605F7165C0A3A4179C90CB6AFA9EB231808D40854659141AA3726D1A3802BC229CCDC3834F7ECBC4295F5C03770502B05E697CA50C28EB581CC6B6B0E14C09AFC974CA3A80DD0D7B7945A1A2337D6B60280F67795C11BC8F8723FE41D21E30168CFF453F8466548297D1C811E32C2C6F2F7AA020FE1218E398B20E80DDE6EFF8047FC3371397815FC4276F800C673D02E62761FE411926DFD132AA984086C7E32E06201F1D8C0D2FD55F124CC065EC96D523C61F23651D20A80A02AFF02A4183D7C5F86079D52A3850B51A8AC4D57018F3D3F9279175FFB8183487A78F5B9E401F9E173ADC2E5C8A5E8075FB9565E82882C70FBD95B09A4AA7B403E04ADE3C54EAB76194D51C03ADDC704F21C217396F84AFC3D09A07536DCC61B3C3587C0F710F325FC757808EA18951789C44E453DA01F0490A503BDC81A3AC6EE41F4E61BB2B3BC39F761CD81FAE3C1E7074B0A33C1F0C082760CF340AE157F165D8431DE36135914F6907600ACAB811F6BE7270D6D8FDE245A8F3EAAFAFCAFBC0A3BBD7C2715FA387ABC78E1D039D73334F8D46BE0361F3F19EC397090ED8C4C36A229FF20EC094F44EE903A3C7FEF005997360069478CFD5D5DB9EAA4B60DADED761CA9E95703280FAA734AB5B8158A88B1C07A04061263FD687638B786B9C7D607BB8F244C271084DFDABDB34D143295B04FCE33A2FE37BB82073C7C1C9E78E9C8A0D3CFCB9D8FFD7A93FBCBD1D63026E8D805415E53BB37029D050EF21F3377AC720741AD69917091FE53BE6724307723D1C8C8497A8B294EF01BA1578472A8DCF14F56B557BF8AC6CD853B8CEBFC0DD1F3EE875E7AA9D4084155A25D28CEE85BE67B5F0F840F09DC4E32B4A1FDEEFA70E5D8668FCED44801EC9323E132AE51D8052493B9613E2DB9827CC566A3DB3A5E3CF98574DBF82E5127D6000A55CCFA0A48C3DCD82D4570F4C6F74FF8F5BE0BDC363E0C79397C33ECF45F0FDC9ABCBD0F0E35C4DE08A64BF0F48E921A0CF229A55B9DF5B8EE3B9CA9189206C28CA73F6E44DD76D9A77013ACC481E8EFDFF9C4D53DD717F35DCEB097A998F885BF9FA884D185D34C53997872723AF525C32043053A7679F3895373EE34704C7137A7C0F5DEA188B53461F5F46808C6ABDFA740CC197C79AF70BBEF11A5A42A4A6931DF335F0240152DA0170997D98466F84946F9C4C3ED5C011B0E72622E2144C47F9D4D96C9B4FB3AAA8C7231A18C62637F0F814E8FE1584047878B2F229EB003DA7D3D6F882A719AF3842C9FB3C4C99F734768DC7A85F54C2589A8274371B527878ACF901CFD10C3DF96C20AC8E956722E852D601FC017F2176FFEA1806A773B4AE634A24457D3D86F8700BC8CB1A1C0AF6CAFFF8FEA581C708385429DD8FD268E493321CCFC7C832216429EB0040A57E3A1A3950FC17B25F07AE026D9CE2F81B460A1E159065A834E0B23954B34AA7C13300A0D43F5807ED44F1DFC84F3AF0A48112B623E8FA02DAC40BDE26360CC9CCB64EB2D1C0C649AE1D329F1E059E7E01896A3E00A182B440C68974670B3FB80A380BDFD74F56E1E14251D6612FE371A70A1E43061BDD915F5DC27ABF64AC7ACEA44DC1E76B6A846D00BDD209CE927579A4C4087EB43871758001CBA9EDD04FE2381C871F1425B10D13C68FA3ABD90BF9FD3FF2384BE62349C254007CF3AFB8B016A9A4B3DBF0D26E519E6B4AEE34F1211C4654E33E72BDF5FA9768C3750F06EB54D4603CD9AD905E4B0362686552A69404813917F8BDDE71586FBE0CAFEE2E8208DD9E147753425F6A76A16BF68A81F10B224D3F9DB2F0B7CEA075D0F81FA3BD9FC74837687CB92C9EF7E0A20DA15D799E8408DB5994CFC323E571463643538E8B429EE3E2620D3C0A00A53ECDE6138C3B02C5936C4BA360A3420DEA1475CB74CC74AD2A3491899B031CF57967A3F17B9990C510E96F05FEBFE2F44AD373113B7DDA10030552515EC693180B68F616628F73E38D05B4990235BAA48E1EF06DC32F7179E780BC83BA8E4EA2B0D8717180EED37CD760177C77D85AE25840684067C58E788A26B9DE88A51A4A84273474B8B25809BE987A8160104969630D4F817CA081C50860BA663A8F915C45161707A034A09D92B16A083E5D841C35FBC3EE2FB85902C7D646C8EB02550B5835403FE16146F39BF21DCFE04AA06633069568AFDCE7E93946F9C87819A57EECFEB5D33F9AEDF8878C83EF082AA3D089A68762D3DFA0CE658626EE9AAE345A5EFD5EA0754F947B73512835A940F28BF35C056A60F4B9456B1FC9F21F7464162329917CD3B0FBD7CCAD314E361C50E94940505634F84BEA322A9072DF12847553C3ABC991C0003EEEC5EEBFBC48313DC500743A72613F43576E819807129DA642262497E97ECD43A45C058F3263BA073851E13D0F8DA27A9BC656DA2E3ECB39334A5982E8F3173DDA63CDD2811FEC78EB9263252B1B0406069EA918DC647A69D9FBD9D29C765DEEBBAFF964B8386B4B88353EFD478A1F23E1F60586F0222536E63967E3537984C79108BD36F7597A210F8F98A7A49DB69C7EAE851987305D329D2A2998CE99EE95B058D2A67B0081083901FCE64A79A17025AFB215B728AE650B277569E9DAB6ECB2BACF5CC8BA389954EE58328413E43CF7F7C07E039BCC82EF2A7261EE6FD361D7C92B631AFB65FEF21D63818938E59E27E7D99DADE4914A2F8B050C7D3F78CD744F1FF053A79247304DC8BF34B028004C97B94F7AD83A806A4862BA8F828D2EAAE91E00175342C60AD5808F65286D20B17CD10393FA3498FDF565753E6AAB347E24D24E758AE1A58BBAD1FC0B4674888467B4AC38CF391FB74768165BB0215DF1B56E7B237CEC128CD1E2117F51BEEB6D2D3C4A888E4E75751F255BD30E10657D1AF4FF5B387CDECD0D5F29CC142AB48EA4C15603B077203DEB2DEBB5E98DDEBB595A5D1A7D8E38E8040CCE38E7A52420F85E37C20D65E8CEE3E1D0B29B8759299F540778F3B5710FF5396BE928029229E35D5AE793D61F2FFD53CC3301D9206C2A89E63F28E7E5BB04F412B6B943CEEBDDD90C057DB0A1A60C0FA7D2C02C04301D03C4DA9645CB279ED3D3357796007E8DF103E0A0DBCAAFFBE1A0D8EA352075D7F905A810C0736523E1C0A84ED9EB7BE6D88FA8824E2643F7FA6FF5620E3568E4EC17629589D1D99D749CCF47DE550D45180BE0CE9E85581C76B81102DEF1B86EAF6E0BF626DE2CA7A5DEFEF1BA499A039CEDFFF7B2BA59659A1EE880D8C6F3F989DBFA0F1FFECCA79CB07B30BF64F1E229CD5A39376FEE92BDFE3C65391B023AD559CFA69DA61CE0B389EEF7F045D13EE4A7E28F43C3C56C8DBF680AD9A4AC574EA3F1B52F90281CFD6242625EE2C8F59ABD6B0C6096A111FAF9F3F35A76ADB3F66A1EF7A8BF71E073FF9D6D758C1F421D36ACF0D03583D69FBFF3C4D5BF8780A7123843C87E73E1687C5164EE0A08748C2616603313495C1081735BBE0C17B08A7998D5F24971807ACE438F38852A7577899A293E7E5BC1F08133F61B51D28F27BAF7C50F3C241EB7B9EBD7A13C2CDAFCE6C9EE8F3016603D8EEAC24EA675EED39EDE2A20667ACDF0DC8A374D6F6A17B41FAFF2B4C9CE27C5019A3AF6DEC2377CD7C9AB4A060E9FFB380F0F971F76EF8C6FBF2CBF69255FDE3AE39BD63C2C96BC449DF7EAF602227995E7E7F7C3681EC6369F6EC87327ECF3734D7D310292E200F5ED258D7879F7555DB88A8755973F1A68F9148F93633F6C5BB830AF390F8F36BFE931528481E08F3A74E7E54EF3A81C184707BD17337AB43AEC920B4A8A03D4B597B9F9668B42BD2F785875F9A123667EE9A36E6EDE8ECB395265C7EA688D9413E21AA9D70B10E9F49EC2EB9EA3CCD9EAF1FCF0FDC25B3CCC8AF9A4388003444DBD01104EC6A2209FE4D43A804DAA130B2F9EA6289F6DE1A2DFF170FC0CA5798FE9E20006F75579FFA29A32069109AD4B9C2FF27456CC6B0C5113421E0FB0331AD5979B9E34B4DCAAA49ABB744A934C5BB9A60DD49FF9BD12CF545A728DD0F6021239DBB66B76D587D0EBF23A6BEF3ADBA58E1771FA7F64D5647C0D9E0297467935217385BF61395F4F43E7819B795875F906BE92BFF2383EEAA243474DDFC5C363CDB3378DB826F035A3AF673F0C635B3C0A6F743C1FE6B7EFDC08DF817D5AD8EAD6960BDB7780251D5AC39F9BE7411DFB51EC106C1B62ADAFA6E992E200BFFBCEDFCC37B473F6860E0B163C6AF8DDFB0BABC7BBDA676F1ECFF3D953D9A514D7DF35C3028F174D5EB23987E5D65F4917B56F07FFD3F84568E8D02C414063E70118D4E4595874713B78E49CB15BA3E19F4CDCE43840A04568778CDC7817A9249765AD5BC956F46458A47BDB63BFBF7FAE7B57268FF31FF1C28F7998D9FCA79DC935FF7BC120C8B09DA89655B6FD18F43D6B5E211E4E35A85A640B2024C501EE19FEF406FC445AF318B5C9DA567FC3B2FEDB96D3019AB57EA5AEDE597CEF73D7E6BCAB599039EE6F2895DA5A3CA2C4359BF6AE81AEE891AF18754C561F763F02E22F103F84A8E31AB3F2464B9F14076042EE16AFD02EB722FCCA9C559D3BBEF3C331B64760CED6D10E6583962E9E70FBE6377BFD7253C379136CE0D3F4145F55F47BFBBE21859A77FA4A1ED1A6031466A13155722878B0BA8E28F2A1243A41060DC033218045139AE5CB9A9273F0B0E7DF5BBB64C0BAEEF556689E64B6A68FBFE9277FCB29E8F656874A3C0A2CD0C05992D5C0FE8FA0BC6810CDF553E5E565BF5D94697A1958C918FF8FE0523CD9EB5A258CA5D1F3B6E3A14EA3E4737DBC6BE14AC91F3C0FB89D1217C5ECEBF908DAB8FB58774F40D27A00A6A83E4356F4F9EE44F7FD4AA529D359B6E3C2F9193BB35B676ECF69603F14D6594BBDE77A777A7B771D73F9AB3E25BDD934EEB8D19B991C71B9A0AF6C7C56079E37F885CB097D31F8D4CC6E70A6A0C7C3AC6871A34FAA03B0687D7BAB8B5A7F51D16F47AC2DFAA5AA6379D1D1215D860E7DEA97587984A393F09FC7F832947919E90D9A6186DC00FBF105D23B3C3E06041A1E1A9C240292EA00ACDDECA9ED79D79A4E6BCBEE79B9CCD744BDBB348262D8127071F91D9BB61CEFD7E2EE7BA6FF100135E622ECEAEB6B8809ECD5C064804E190E579A656219DD0AF7B0DD6A4D0B77FBB0F9E3962C99945F9FEE9B77AE7B67EF56993BB251799A408F75F77B2A3B6D2F0DB41B3778F8CCAD8994139FF6523EDE2092E65F474222E098CFFF23096BC0E110820513967100A61BECC6D9F2697067CDEBF3275F6C2315DD5DF6AA36369032AAA4CC3DA23FEB9B11F7CEFC0C601FA2BDCF48127AE116901DFC92121A7988B80A9E73F5C732C5752A10BC5D010A26115F85C797273B6F2907502AE354B79E90AE5D594FC4B40356122F3CABEC89D0A04E748CF578E6EF44B71DFF6FC40E029EF77F33FE7B592196A9D62FF0E90F60C098784F8DD888C885967580C862D74CA9BB37FC82A77D2EC7DAD4AB7A141A206C2E1EF17EFAE441B4BEE612F068789D805183974440D283C024B6DD50D56E47F04F298F1842562211F8CDE5807C25C88AE9B40354631536BDB3DBE04EECCE2BAA410D1523EE511B85DBACFEF43381D30E10325BF884A32F14111B5C8DB382EFC2639D2A21F01546025738FB43426728D5CA6110211D03185414FE3BC9F7180C76F1AE86BB30081C8CB3831E38EC07771EA1631C47369FE193BFC4D90FDEC6BC5E4460B0A69A4533ED00780618E53E0E66AFC35017B5EF42C3B26DE84B4FFDD8AEFF3A78F02CAD91FFFDD3D16950F726D56C7A08C0A3D98E6965204DF1F00297165EBB2024172A6AC2F87FE892688E95D3D77D743A36ED00421DE75E3C62854D88141775E2A9218FB163E314C07432060D301D325D62B7EA5492339D33DD2B61B1A4E3D255E33E79763C5C6F5E0026240E869AAF7778BC743EBC06D040F8EF33DA53D17090FDA438DF7D43784A6325A66300560D2E864DC60321AF432F55F528BA821B932B8D754A03FAD12491EC4026C743492A83C5CA707DBE732B6E859E1F2B7D9A2E3A0D305D339D4747A58F1D170760AC9B66BA1EC22E7FB57E356968BC34C074CC741D3F7EF1E2847CD8116E3D0A7DA3244AC763A6731C59A75911B25D20E4C50D531CF8D7B3B8F5244E575C82403D597ACEA6D9421934F1BBB49F81E9E1D7242CE02553F004B091CA3AF13CB0D76C4E5AA88459216D175D92D4004AD68F23D5EF498F41E0B804817AF59E12382142EBD5170D0CFF3CEA1806A82A12014F0BDDF877D76E15F00CC8C42D06380374552B9B9876805A6956E38D4A3B80715DD54ACCB403D44AB31A6F54DA018CEBAA5662A61DA0569AD578A3D20E605C57B51233ED00B5D2ACC61B95B095403D11D8BBEDC3BBBDC12F68718F5D2B9F9FB66278B80A77001737D52B337A0CE2071B814BD5FD55EC0861C7D42D54C11298C16D65B8A04B5BB02A1C76F2337E4AFE334B376AE3DC15CFBF85633C235D095B09D4ABB4FC00E4F825FAC797328A5D02A8083DF49A85FDE1106AA748A004CAD57C9FEF74FB51470DB1DAB20456AD629D1E0254EA38F332690738F36CAE6A71DA0154EA38F332351A0384532FC6435F6199222A088759ABE06CAF5FD764B7C8120E606BE0BC2E51EFBB93ADE070F5B3FD12FE32D1F0E766E1F89885A78700B31A4C71FAB403A4B801CD8A9F7600B31A4C71FAB403A4B801CD8A9F7600B31A4C71FAB403A4B801CD8A9F7600B31A4C71FAB403A4B801CD8A9F7600B31A4C71FAB403A4B801CD8AAFBB21A4E734EFE501907291792BB671C16C25217A0A6EDCF6716F282F2708BC8AB5C4EDA46FB6B904DFB0EF2644282ECA736E93AB89E5DEADC07B29A5522E2AA14D9C75E1405D8CD6C844601EEAC2A381C70838B5D1E6671B08C57A5F14AB8C7BCB1C9A79B4D4FB4FDCA3333CC6FAAC47860A6D96E91ABFE26152158D70039EA319872AC517751D361A4696C2258BEA3776DEFFFE1852298BA57A1974ACD43B0F8D7F975C582BEED8E3FC5EE965ED1C194D7B90E69F68FC11D1D0581F970E471BB3A36606CBB2867A809ED37CB97E1A28920B6AD51D77DFE148765551BE13FF08B2FA0B3F1EBD0247912D389084F4533D55EA60D889ADDBFA7C473193381404FAA97473EA34214A498386E43681466481B8B5D4F8ACD94A5B87860074F58EA7B7269ED20E216B3088D8195157562C24F4128C02FB2845C3B67554E623A5F570F18CC08F70FBF2B791E8AC58867D580774E67E4AD998ADE57CC80170ECCF9181F25D20F0FAC67CD752399F2AF7DC27BDA3708391CA01F0F04E4DFBC2B587E1F20F03A5C21BC5539D0BC2D15815DEBD401C827F7DA37200A5AD434380551B90962BB11A483B4062F56B79EE6907B0BC89122B60DA0112AB5FCB734F3B80E54D945801D30E9058FD5A9E7BDA012C6FA2C40A987680C4EAD7F2DCD30E6079132556C0B4032456BF96E79E7600CB9B28B102A61D20B1FAB53CF7B40358DE44891530ED0089D5AFE5B9A71DC0F2264AAC80690748AC7E2DCF5DB12104B8FFFEC36D039436EEFD143DC7F2ADE00414FDDE46FCC973B8C123C0A185CDEAE1E2B6C24629A98B80D844A7A1215B9F760002BB71176C0F25322A7196C727CE52C252364DE027C3B2335C0AAAFFE4C3876106EA6286611E564664B63E758586004285B8FC0D99CCD8727749F8DAB04CD1E01A666A1D44A5AD430E20B4702CC48D8F7BAD2366FC24C12DE1BB9BB5752C31CA91E1321AA3F8A984C76CCC6C2DCB1C7280F5A38887806D2400A9B1634A65211279C71DB047F013B19178FEAED7683D0C97D1305AA334A98147CA988D99AD6579430EC0001BF31D1B9DC47929FE2FDD42FC3E2D7878B18C986A77F604633B16D89CAE2ED8AECDD1CACF68182DE391F2BD01DA92D994D996D958A98BFF0284307D0458B3E9820000000049454E44AE426082,'2021-05-18 01:35:21');
/*!40000 ALTER TABLE `sys_files` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_graph` (
  `id` varchar(32) NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `view` varchar(32) NOT NULL,
  `graph_type` varchar(32) NOT NULL,
  `node_groups` varchar(128) DEFAULT NULL COMMENT '图形分组数据,A->B->C',
  `graph_dir` varchar(45) DEFAULT NULL COMMENT '图形方向',
  PRIMARY KEY (`id`),
  KEY `sys_graph_view_idx` (`view`),
  CONSTRAINT `sys_graph_view` FOREIGN KEY (`view`) REFERENCES `sys_view` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `sys_graph_element` (
  `id` varchar(128) NOT NULL,
  `graph` varchar(32) NOT NULL,
  `parent_element` varchar(128) DEFAULT NULL,
  `report_object` varchar(64) NOT NULL,
  `show_table` varchar(32) DEFAULT 'false' COMMENT '是否显示表格数据',
  `display_expression` varchar(128) NOT NULL COMMENT '显示名的表达式',
  `node_group_name` varchar(32) DEFAULT NULL,
  `line_start_data` varchar(32) DEFAULT NULL,
  `line_end_data` varchar(32) DEFAULT NULL,
  `line_display_position` varchar(32) DEFAULT NULL,
  `graph_type` varchar(32) DEFAULT NULL,
  `graph_shape_data` varchar(32) DEFAULT NULL,
  `graph_shapes` varchar(128) DEFAULT NULL,
  `graph_config_data` varchar(32) DEFAULT NULL,
  `graph_configs` varchar(1024) DEFAULT NULL,
  `edit_ref_attr` varchar(64) DEFAULT NULL,
  `graph_filter_data` varchar(64) DEFAULT NULL,
  `graph_filter_values` varchar(128) DEFAULT NULL,
  `editable` varchar(32) DEFAULT NULL,
  `seq_no` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sys_view_node_view_idx` (`graph`),
  KEY `sys_view_node_parent_node_idx` (`parent_element`),
  KEY `sys_graph_node_edit_ref_attr_idx` (`edit_ref_attr`),
  CONSTRAINT `sys_graph_element_edit_ref_attr` FOREIGN KEY (`edit_ref_attr`) REFERENCES `sys_ci_type_attr` (`id`),
  CONSTRAINT `sys_graph_element_graph` FOREIGN KEY (`graph`) REFERENCES `sys_graph` (`id`),
  CONSTRAINT `sys_graph_element_parent_element` FOREIGN KEY (`parent_element`) REFERENCES `sys_graph_element` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `sys_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `log_cat` varchar(64) NOT NULL COMMENT '日志归类',
  `operator` varchar(20) NOT NULL COMMENT '操作用户',
  `operation` varchar(64) NOT NULL COMMENT '操作行为',
  `content` longtext COMMENT '具体内容',
  `request_url` varchar(512) DEFAULT NULL COMMENT '请求url',
  `client_host` varchar(20) DEFAULT NULL COMMENT '请求客户端IP',
  `created_date` varchar(32) NOT NULL COMMENT '日志时间',
  `data_ci_type` varchar(32) DEFAULT NULL COMMENT '数据所属ci',
  `data_guid` varchar(64) DEFAULT NULL COMMENT '数据guid',
  `data_key_name` varchar(32) DEFAULT NULL COMMENT '数据名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=656 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `sys_menu` (
  `id` varchar(32) NOT NULL COMMENT '名称主键',
  `display_name` varchar(64) DEFAULT NULL COMMENT '显示名',
  `url` varchar(255) DEFAULT NULL COMMENT '访问路径',
  `seq_no` int(11) DEFAULT '0' COMMENT '排序号',
  `parent` varchar(32) DEFAULT NULL COMMENT '父菜单',
  `is_active` varchar(8) DEFAULT 'yes' COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('configuration','配置管理',NULL,3,NULL,'yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('data_mgmt','数据管理',NULL,2,NULL,'yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('data_mgmt_ci','数据管理(CI)',NULL,1,'data_mgmt','yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('data_mgmt_view','数据管理(视图)',NULL,2,'data_mgmt','yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('data_query','数据查询',NULL,1,NULL,'yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('data_query_ci','数据查询(CI)',NULL,1,'data_query','yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('data_query_report','数据查询(报表)',NULL,2,'data_query','yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('data_query_view','数据查询(视图)',NULL,3,'data_query','yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('model_configuration','模型配置',NULL,1,'configuration','yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('report_configuration','报表配置',NULL,2,'configuration','yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('system','系统',NULL,4,NULL,'yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('system_authority','授权',NULL,2,'system','yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('system_basekey','基础数据',NULL,1,'system','yes');
INSERT INTO `sys_menu` (`id`, `display_name`, `url`, `seq_no`, `parent`, `is_active`) VALUES ('system_operation_log','操作日志',NULL,3,'system','yes');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_report` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name` varchar(32) NOT NULL,
  `ci_type` varchar(32) NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `create_user` varchar(32) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `update_user` varchar(32) DEFAULT NULL,
  `sql_cache` text,
  PRIMARY KEY (`id`),
  KEY `sys_report_ci_type_idx` (`ci_type`),
  CONSTRAINT `sys_report_ci_type` FOREIGN KEY (`ci_type`) REFERENCES `sys_ci_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `sys_report_object` (
  `id` varchar(64) NOT NULL,
  `report` varchar(32) NOT NULL,
  `parent_object` varchar(64) DEFAULT NULL,
  `parent_attr` varchar(128) DEFAULT NULL,
  `ci_type` varchar(32) NOT NULL,
  `my_attr` varchar(128) DEFAULT NULL,
  `data_name` varchar(64) DEFAULT NULL,
  `data_title_name` varchar(64) DEFAULT NULL,
  `seq_no` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sys_report_object_report_idx` (`report`),
  KEY `sys_report_object_parent_object_idx` (`parent_object`),
  KEY `sys_report_object_ci_type_idx` (`ci_type`),
  KEY `sys_report_object_my_attr_idx` (`my_attr`),
  KEY `sys_report_object_parent_attr_idx` (`parent_attr`),
  CONSTRAINT `sys_report_object_my_attr` FOREIGN KEY (`my_attr`) REFERENCES `sys_ci_type_attr` (`id`),
  CONSTRAINT `sys_report_object_parent_attr` FOREIGN KEY (`parent_attr`) REFERENCES `sys_ci_type_attr` (`id`),
  CONSTRAINT `sys_report_object_parent_object` FOREIGN KEY (`parent_object`) REFERENCES `sys_report_object` (`id`),
  CONSTRAINT `sys_report_object_report` FOREIGN KEY (`report`) REFERENCES `sys_report` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `sys_report_object_attr` (
  `id` varchar(128) NOT NULL,
  `report_object` varchar(64) NOT NULL,
  `ci_type_attr` varchar(128) NOT NULL,
  `data_name` varchar(64) NOT NULL,
  `data_title_name` varchar(64) NOT NULL,
  `querialbe` varchar(32) DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `sys_report_object_attr_report_object_idx` (`report_object`),
  KEY `sys_report_object_attr_ci_type_attr_idx` (`ci_type_attr`),
  CONSTRAINT `sys_report_object_attr_ci_type_attr` FOREIGN KEY (`ci_type_attr`) REFERENCES `sys_ci_type_attr` (`id`),
  CONSTRAINT `sys_report_object_attr_report_object` FOREIGN KEY (`report_object`) REFERENCES `sys_report_object` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_report_object_filter` (
  `id` varchar(128) NOT NULL,
  `filter_name` varchar(64) NOT NULL,
  `filter_ci_type` varchar(32) NOT NULL,
  `filter_rule` varchar(2096) NOT NULL,
  `sys_report_object` varchar(128) NOT NULL,
  `multiple` varchar(32) DEFAULT NULL,
  `filter_display_name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sys_report_object_filter_ci_type_idx` (`filter_ci_type`),
  KEY `sys_report_object_filter_report_object_idx` (`sys_report_object`),
  CONSTRAINT `sys_report_object_filter_ci_type` FOREIGN KEY (`filter_ci_type`) REFERENCES `sys_ci_type` (`id`),
  CONSTRAINT `sys_report_object_filter_report_object` FOREIGN KEY (`sys_report_object`) REFERENCES `sys_report_object` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_role` (
  `id` varchar(32) NOT NULL COMMENT '名称主键',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `role_type` varchar(32) DEFAULT NULL COMMENT '角色类型',
  `is_system` varchar(8) DEFAULT 'no' COMMENT '是否系统角色',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('APP_ARC','应用架构师',NULL,'no');
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('APP_DEV','应用开发人员',NULL,'no');
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('CMDB_ADMIN','CMDB管理员',NULL,'no');
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('COBFIG_USER','配置管理员',NULL,'yes');
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('EDIT_USER','编辑用户',NULL,'yes');
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('IFA_ARC','基础架构师',NULL,'no');
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('IFA_OPS','基础架构运维人员',NULL,'no');
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('MONITOR_ADMIN','监控管理员',NULL,'no');
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('PRD_OPS','生产运维',NULL,'no');
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('QUERY_USER','查询用户',NULL,'yes');
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('STG_OPS','测试运维',NULL,'no');
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('SUB_SYSTEM','后台系统',NULL,'yes');
INSERT INTO `sys_role` (`id`, `description`, `role_type`, `is_system`) VALUES ('SUPER_ADMIN','超级管理员',NULL,'yes');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_role_ci_type` (
  `guid` varchar(32) NOT NULL COMMENT '主键',
  `role_id` varchar(32) DEFAULT NULL COMMENT '角色guid',
  `ci_type` varchar(32) DEFAULT NULL COMMENT 'ci类型',
  `insert` varchar(4) DEFAULT 'N' COMMENT '创建权限',
  `delete` varchar(4) DEFAULT 'N' COMMENT '删除权限',
  `update` varchar(4) DEFAULT 'N' COMMENT '修改权限',
  `query` varchar(4) DEFAULT 'N' COMMENT '查询权限',
  `execute` varchar(4) DEFAULT 'N' COMMENT '授权权限',
  PRIMARY KEY (`guid`),
  KEY `sys_role_ci_type_ref_role` (`role_id`),
  KEY `sys_role_ci_type_ref_ci_type` (`ci_type`),
  CONSTRAINT `sys_role_ci_type_ref_ci_type` FOREIGN KEY (`ci_type`) REFERENCES `sys_ci_type` (`id`),
  CONSTRAINT `sys_role_ci_type_ref_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_role_ci_type_condition` (
  `guid` varchar(32) NOT NULL COMMENT '随机主键',
  `role_ci_type` varchar(32) DEFAULT NULL COMMENT '所属角色ci关联',
  `insert` varchar(4) DEFAULT 'N' COMMENT '创建权限',
  `delete` varchar(4) DEFAULT 'N' COMMENT '删除权限',
  `update` varchar(4) DEFAULT 'N' COMMENT '修改权限',
  `query` varchar(4) DEFAULT 'N' COMMENT '查询权限',
  `execute` varchar(4) DEFAULT 'N' COMMENT '授权权限',
  PRIMARY KEY (`guid`),
  KEY `sys_role_ci_type_attr_owner` (`role_ci_type`),
  CONSTRAINT `sys_role_ci_type_attr_owner` FOREIGN KEY (`role_ci_type`) REFERENCES `sys_role_ci_type` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_role_ci_type_condition_filter` (
  `guid` varchar(32) NOT NULL COMMENT '随机主键',
  `role_ci_type_condition` varchar(32) DEFAULT NULL COMMENT '所属ci属性关联',
  `ci_type_attr` varchar(64) DEFAULT NULL COMMENT 'ci属性(条件对象)',
  `ci_type_attr_name` varchar(64) DEFAULT NULL COMMENT 'ci属性显示名',
  `expression` varchar(500) DEFAULT NULL COMMENT '条件表达式',
  PRIMARY KEY (`guid`),
  KEY `sys_role_ci_type_cond_owner` (`role_ci_type_condition`),
  KEY `sys_role_ci_type_cond_attr_idx` (`ci_type_attr`),
  CONSTRAINT `sys_role_ci_type_cond_attr` FOREIGN KEY (`ci_type_attr`) REFERENCES `sys_ci_type_attr` (`id`),
  CONSTRAINT `sys_role_ci_type_cond_owner` FOREIGN KEY (`role_ci_type_condition`) REFERENCES `sys_role_ci_type_condition` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_role_ci_type_list` (
  `guid` varchar(32) NOT NULL,
  `role_ci_type` varchar(32) NOT NULL,
  `list` text,
  `insert` varchar(4) DEFAULT 'N',
  `delete` varchar(4) DEFAULT 'N',
  `update` varchar(4) DEFAULT 'N',
  `query` varchar(4) DEFAULT 'N',
  `execute` varchar(4) DEFAULT 'N',
  PRIMARY KEY (`guid`),
  KEY `sys_role_ci_type_list_role_ci_type_idx` (`role_ci_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_role_menu` (
  `id` varchar(128) NOT NULL COMMENT '主键',
  `role_guid` varchar(32) DEFAULT NULL COMMENT '角色guid',
  `menu_guid` varchar(32) DEFAULT NULL COMMENT '菜单guid',
  PRIMARY KEY (`id`),
  KEY `sys_role_menu_ref_role` (`role_guid`),
  KEY `sys_role_menu_ref_menu` (`menu_guid`),
  CONSTRAINT `sys_role_menu_ref_menu` FOREIGN KEY (`menu_guid`) REFERENCES `sys_menu` (`id`),
  CONSTRAINT `sys_role_menu_ref_role` FOREIGN KEY (`role_guid`) REFERENCES `sys_role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` (`id`, `role_guid`, `menu_guid`) VALUES ('SUPER_ADMIN__system','SUPER_ADMIN','system');
INSERT INTO `sys_role_menu` (`id`, `role_guid`, `menu_guid`) VALUES ('SUPER_ADMIN__system_authority','SUPER_ADMIN','system_authority');
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_role_report` (
  `id` varchar(128) NOT NULL,
  `role` varchar(32) NOT NULL,
  `report` varchar(32) NOT NULL,
  `permission` varchar(32) NOT NULL COMMENT 'USE,MGMT',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_role_user` (
  `id` varchar(128) NOT NULL COMMENT '主键',
  `role_id` varchar(32) DEFAULT NULL COMMENT '角色guid',
  `user_id` varchar(32) DEFAULT NULL COMMENT '用户guid',
  PRIMARY KEY (`id`),
  KEY `sys_role_user_ref_role` (`role_id`),
  KEY `sys_role_user_ref_user` (`user_id`),
  CONSTRAINT `sys_role_user_ref_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`),
  CONSTRAINT `sys_role_user_ref_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `sys_role_user` WRITE;
/*!40000 ALTER TABLE `sys_role_user` DISABLE KEYS */;
INSERT INTO `sys_role_user` (`id`, `role_id`, `user_id`) VALUES ('SUPER_ADMIN___super_admin','SUPER_ADMIN','super_admin');
/*!40000 ALTER TABLE `sys_role_user` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_role_view` (
  `id` varchar(128) NOT NULL,
  `role` varchar(32) NOT NULL,
  `view` varchar(32) NOT NULL,
  `permission` varchar(32) NOT NULL COMMENT 'USE,MGMT',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_state` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name` varchar(255) NOT NULL COMMENT '名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `state_machine` varchar(32) DEFAULT NULL COMMENT '外键关联状态机',
  `unique_path_trigger` varchar(8) DEFAULT 'no' COMMENT '唯一路径触发',
  `is_confirm` varchar(8) DEFAULT 'no' COMMENT '是否是确认状态',
  PRIMARY KEY (`id`),
  KEY `sys_state_machine` (`state_machine`),
  CONSTRAINT `sys_state_machine` FOREIGN KEY (`state_machine`) REFERENCES `sys_state_machine` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


LOCK TABLES `sys_state` WRITE;
/*!40000 ALTER TABLE `sys_state` DISABLE KEYS */;
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('create_destroy__changed_0','changed_0',NULL,'create_destroy','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('create_destroy__changed_1','changed_1',NULL,'create_destroy','no','yes');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('create_destroy__created_0','created_0',NULL,'create_destroy','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('create_destroy__created_1','created_1',NULL,'create_destroy','no','yes');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('create_destroy__destroyed_0','destroyed_0',NULL,'create_destroy','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('create_destroy__destroyed_1','destroyed_1',NULL,'create_destroy','yes','yes');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('create_destroy__null_0','null_0','初始空','create_destroy','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('create_destroy__null_1','null_1','终止空','create_destroy','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('design__added_0','added_0',NULL,'design','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('design__added_1','added_1',NULL,'design','no','yes');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('design__deleted_0','deleted_0',NULL,'design','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('design__deleted_1','deleted_1',NULL,'design','yes','yes');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('design__null_0','null_0','初始空','design','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('design__null_1','null_1','终止空','design','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('design__updated_0','updated_0',NULL,'design','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('design__updated_1','updated_1',NULL,'design','no','yes');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('start_stop__changed_0','changed_0',NULL,'start_stop','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('start_stop__changed_1','changed_1',NULL,'start_stop','no','yes');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('start_stop__created_0','created_0',NULL,'start_stop','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('start_stop__created_1','created_1',NULL,'start_stop','no','yes');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('start_stop__destroyed_0','destroyed_0',NULL,'start_stop','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('start_stop__destroyed_1','destroyed_1',NULL,'start_stop','yes','yes');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('start_stop__null_0','null_0','初始空','start_stop','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('start_stop__null_1','null_1','终止空','start_stop','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('start_stop__started_0','started_0',NULL,'start_stop','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('start_stop__started_1','started_1',NULL,'start_stop','no','yes');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('start_stop__stoped_0','stoped_0',NULL,'start_stop','no','no');
INSERT INTO `sys_state` (`id`, `name`, `description`, `state_machine`, `unique_path_trigger`, `is_confirm`) VALUES ('start_stop__stoped_1','stoped_1',NULL,'start_stop','no','yes');
/*!40000 ALTER TABLE `sys_state` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_state_machine` (
  `id` varchar(32) NOT NULL COMMENT '名称主键',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `start_state` varchar(32) DEFAULT NULL COMMENT '开始状态',
  `final_state` varchar(32) DEFAULT NULL COMMENT '终止状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


LOCK TABLES `sys_state_machine` WRITE;
/*!40000 ALTER TABLE `sys_state_machine` DISABLE KEYS */;
INSERT INTO `sys_state_machine` (`id`, `description`, `start_state`, `final_state`) VALUES ('create_destroy','创销类状态机','create_destroy__null_0','create_destroy__null_1');
INSERT INTO `sys_state_machine` (`id`, `description`, `start_state`, `final_state`) VALUES ('design','设计类状态机','design__null_0','design__null_1');
INSERT INTO `sys_state_machine` (`id`, `description`, `start_state`, `final_state`) VALUES ('start_stop','启停类状态机','start_stop__null_0','start__stop_null_1');
/*!40000 ALTER TABLE `sys_state_machine` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_state_transition` (
  `guid` varchar(64) NOT NULL COMMENT '唯一主键',
  `state_machine` varchar(32) DEFAULT NULL COMMENT '所属状态机',
  `current_state` varchar(32) DEFAULT NULL COMMENT '当前状态',
  `target_state` varchar(32) DEFAULT NULL COMMENT '目标状态',
  `operation` varchar(64) DEFAULT NULL COMMENT '前端操作',
  `operation_en` varchar(45) DEFAULT NULL,
  `permission` varchar(32) DEFAULT NULL,
  `action` varchar(64) DEFAULT NULL COMMENT '后端处理',
  `operation_form_type` varchar(32) DEFAULT 'edit' COMMENT '前端表单操作类型',
  `operation_multiple` varchar(32) DEFAULT 'yes',
  PRIMARY KEY (`guid`),
  KEY `sys_transition_machine` (`state_machine`),
  KEY `sys_transition_current` (`current_state`),
  KEY `sys_transition_target` (`target_state`),
  CONSTRAINT `sys_transition_current` FOREIGN KEY (`current_state`) REFERENCES `sys_state` (`id`),
  CONSTRAINT `sys_transition_machine` FOREIGN KEY (`state_machine`) REFERENCES `sys_state_machine` (`id`),
  CONSTRAINT `sys_transition_target` FOREIGN KEY (`target_state`) REFERENCES `sys_state` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `sys_state_transition` WRITE;
/*!40000 ALTER TABLE `sys_state_transition` DISABLE KEYS */;
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-029ebea8','design','design__null_0','design__added_0','添加','Add','insert','insert','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-04b5b578','design','design__added_0','design__null_0','删除','Delete','delete','delete','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-06081023','design','design__added_0','design__added_0','更新','Update','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-0cd93755','design','design__added_0','design__added_0','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-179d8572','design','design__added_0','design__added_1','确认','Confirm','update','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-19a80b6c','design','design__added_1','design__updated_0','更新','Update','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-1b946b07','design','design__updated_0','design__added_1','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-1da593d3','design','design__updated_0','design__updated_0','更新','Update','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-22704a96','design','design__updated_0','design__updated_1','确认','Confirm','update','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-2402c9ca','design','design__updated_0','design__updated_1','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-24aebc5f','design','design__updated_1','design__updated_0','更新','Update','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-2bb81d80','design','design__updated_0','design__updated_0','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-300d167b','design','design__added_1','design__deleted_0','删除','Delete','delete','update','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-33627426','design','design__deleted_0','design__added_1','回退','Rollback','delete','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-36aa4863','design','design__updated_1','design__deleted_0','删除','Delete','delete','update','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-381a7050','design','design__deleted_0','design__updated_1','回退','Rollback','delete','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-387b3304','design','design__deleted_0','design__deleted_1','确认','Confirm','delete','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-3c832526','design','design__deleted_1','design__null_1','删除','Delete','delete','delete','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-3c832ytj','design','design__added_1','design__added_1','确认','Confirm','insert','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-3c8jugv6','design','design__updated_1','design__updated_1','确认','Confirm','update','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-3e31b129','create_destroy','create_destroy__null_0','create_destroy__created_0','新增','Add','insert','insert','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-3f7ae442','create_destroy','create_destroy__created_0','create_destroy__null_0','删除','Delete','delete','delete','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-41db2c39','create_destroy','create_destroy__created_0','create_destroy__created_0','变更','Change','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-420e8bcd','create_destroy','create_destroy__created_0','create_destroy__created_0','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-441b1c06','create_destroy','create_destroy__created_0','create_destroy__created_1','确认','Confirm','update','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-4c07adc1','create_destroy','create_destroy__created_1','create_destroy__changed_0','变更','Change','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-52dc02cc','create_destroy','create_destroy__changed_0','create_destroy__created_1','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-5e297171','create_destroy','create_destroy__changed_0','create_destroy__changed_0','变更','Change','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-5e7732a3','create_destroy','create_destroy__changed_0','create_destroy__changed_1','确认','Confirm','update','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-5fe97859','create_destroy','create_destroy__changed_0','create_destroy__changed_1','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-6683f94c','create_destroy','create_destroy__changed_1','create_destroy__changed_0','变更','Change','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-6db35ef2','create_destroy','create_destroy__changed_0','create_destroy__changed_0','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-74b8c816','create_destroy','create_destroy__created_1','create_destroy__destroyed_0','销毁','Destroy','delete','update','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-767d331a','create_destroy','create_destroy__destroyed_0','create_destroy__created_1','回退','Rollback','delete','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-782009f0','create_destroy','create_destroy__changed_1','create_destroy__destroyed_0','销毁','Destroy','delete','update','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-7b5f63ff','create_destroy','create_destroy__destroyed_0','create_destroy__changed_1','回退','Rollback','delete','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-7d0813fa','create_destroy','create_destroy__destroyed_0','create_destroy__destroyed_1','确认','Confirm','delete','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-7d1e59d6','create_destroy','create_destroy__destroyed_1','create_destroy__null_1','删除','delete','delete','delete','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-7f423166','start_stop','start_stop__null_0','start_stop__created_0','新增','Add','insert','insert','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-86c4431e','start_stop','start_stop__created_0','start_stop__null_0','删除','Delete','insert','delete','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-86c4db3e','start_stop','start_stop__created_0','start_stop__created_0','变更','Change','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-8a0db99f','start_stop','start_stop__created_0','start_stop__created_0','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-8df7f247','start_stop','start_stop__created_0','start_stop__created_1','确认','Confirm','update','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-8eda60cd','start_stop','start_stop__created_1','start_stop__changed_0','变更','Change','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-9237efd8','start_stop','start_stop__changed_0','start_stop__created_1','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-92a5e691','start_stop','start_stop__changed_0','start_stop__changed_0','变更','Change','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-92c068b0','start_stop','start_stop__changed_0','start_stop__changed_1','确认','Confirm','update','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-942508b3','start_stop','start_stop__changed_0','start_stop__changed_1','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-94ccffe7','start_stop','start_stop__changed_1','start_stop__changed_0','变更','Change','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-980f9730','start_stop','start_stop__changed_0','start_stop__changed_0','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-984618c2','start_stop','start_stop__created_1','start_stop__started_0','启动','start','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-9a31e964','start_stop','start_stop__started_0','start_stop__created_1','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-9a6fc0e6','start_stop','start_stop__created_1','start_stop__stoped_0','停止','stop','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-9c9bd4d2','start_stop','start_stop__stoped_0','start_stop__created_1','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-9e23239a','start_stop','start_stop__changed_1','start_stop__started_0','启动','start','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-9ec54e2b','start_stop','start_stop__started_0','start_stop__changed_1','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-9f9c3743','start_stop','start_stop__changed_1','start_stop__stoped_0','停止','stop','update','update','editable_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-9fc08a90','start_stop','start_stop__stoped_0','start_stop__changed_1','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-a1ad3f70','start_stop','start_stop__started_0','start_stop__started_1','确认','Confirm','update','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-a1dd71c2','start_stop','start_stop__stoped_0','start_stop__stoped_1','确认','Confirm','update','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-a30d2917','start_stop','start_stop__started_0','start_stop__stoped_1','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-a374c7d8','start_stop','start_stop__stoped_0','start_stop__started_1','回退','Rollback','update','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-a3ccdb94','start_stop','start_stop__stoped_1','start_stop__destroyed_0','销毁','Destroy','delete','update','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-a474f20b','start_stop','start_stop__destroyed_0','start_stop__stoped_1','回退','Rollback','delete','update','select_form','no');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-a602802a','start_stop','start_stop__destroyed_0','start_stop__destroyed_1','确认','Confirm','delete','confirm','confirm_form','yes');
INSERT INTO `sys_state_transition` (`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) VALUES ('609a4bdf-adb84587','start_stop','start_stop__destroyed_1','start_stop__null_1','删除','delete','delete','delete','confirm_form','yes');
/*!40000 ALTER TABLE `sys_state_transition` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_user` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `display_name` varchar(64) DEFAULT NULL COMMENT '显示名',
  `encrypted_password` varchar(255) DEFAULT NULL COMMENT '加密密钥',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `is_system` varchar(8) DEFAULT 'no' COMMENT '是否系统用户',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` (`id`, `display_name`, `encrypted_password`, `description`, `is_system`) VALUES ('super_admin','超级管理员','0f7c4c2c7b619959be930b1cf0a18bd2',NULL,'yes');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `sys_view` (
  `id` varchar(32) NOT NULL,
  `name` varchar(64) NOT NULL,
  `report` varchar(32) NOT NULL,
  `editable` varchar(32) DEFAULT NULL,
  `suport_version` varchar(32) DEFAULT NULL,
  `multiple` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `create_user` varchar(32) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `update_user` varchar(32) DEFAULT NULL,
  `filter_attr` varchar(64) DEFAULT NULL,
  `filter_value` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sys_view_report_idx` (`report`),
  KEY `sys_view_filter_attr_idx` (`filter_attr`),
  CONSTRAINT `sys_view_filter_attr` FOREIGN KEY (`filter_attr`) REFERENCES `sys_ci_type_attr` (`id`),
  CONSTRAINT `sys_view_report` FOREIGN KEY (`report`) REFERENCES `sys_report` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_wecube_process` (
  `guid` varchar(32) NOT NULL COMMENT '随机主键',
  `ci_data_guid` varchar(64) DEFAULT NULL COMMENT '数据行id',
  `wecube_proc_instance_tmp` varchar(64) DEFAULT NULL COMMENT '临时流程号',
  `wecube_proc_instance` varchar(64) DEFAULT NULL COMMENT '实例流程号',
  `wecube_proc_define` varchar(64) DEFAULT NULL COMMENT '流程选择',
  `status` varchar(64) DEFAULT 'start' COMMENT '状态',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


SET FOREIGN_KEY_CHECKS=1;

#@v2.0.2.1-begin@;
insert into sys_state_transition(`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) value ('609a4bdf-420e8bde','create_destroy','create_destroy__created_0','create_destroy__created_0','执行','Execute','execute','execute','select_form','no');
insert into sys_state_transition(`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) value ('609a4bdf-5e297272','create_destroy','create_destroy__changed_0','create_destroy__changed_0','执行','Execute','execute','execute','select_form','no');
insert into sys_state_transition(`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) value ('609a4bdf-86c4db4e','start_stop','start_stop__created_0','start_stop__created_0','执行','Execute','execute','execute','select_form','no');
insert into sys_state_transition(`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) value ('609a4bdf-92a5e791','start_stop','start_stop__changed_0','start_stop__changed_0','执行','Execute','execute','execute','select_form','no');
insert into sys_state_transition(`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) value ('609a4bdf-9ec54e3b','start_stop','start_stop__started_0','start_stop__started_0','执行','Execute','execute','execute','select_form','no');
insert into sys_state_transition(`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) value ('609a4bdf-a374c8d8','start_stop','start_stop__stoped_0','start_stop__stoped_0','执行','Execute','execute','execute','select_form','no');
insert into sys_state_transition(`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) value ('611f56a80c232a5a','start_stop','start_stop__destroyed_0','start_stop__destroyed_0','执行','Execute','execute','execute','select_form','no');

insert into sys_state_transition(`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) value ('611f4650b3dc0bbc','start_stop','start_stop__started_1','start_stop__stoped_0','停止','stop','update','update','editable_form','yes');
insert into sys_state_transition(`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) value ('611f4699133f2da3','start_stop','start_stop__started_1','start_stop__changed_0','变更','Change','update','update','editable_form','yes');
insert into sys_state_transition(`guid`, `state_machine`, `current_state`, `target_state`, `operation`, `operation_en`, `permission`, `action`, `operation_form_type`, `operation_multiple`) value ('611f46f1ffcc11f5','start_stop','start_stop__changed_0','start_stop__started_1','回退','Rollback','update','update','select_form','no');
#@v2.0.2.1-end@;

#@v2.0.3-begin@;
alter table sys_log add column response longtext;
#@v2.0.3-end@;

#@v2.0.6.1-begin@;
alter table sys_graph_element add column order_data varchar(128) default '';
alter table sys_graph_element add column update_operation varchar(64) default '';
#@v2.0.6.1-end@;