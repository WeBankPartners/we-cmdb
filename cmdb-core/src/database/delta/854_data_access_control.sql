CREATE TABLE IF NOT EXISTS `adm_role_ci_type_ctrl_attr_expression` (
  `id_adm_role_ci_type_ctrl_attr_expression` int(11) NOT NULL AUTO_INCREMENT,
  `id_adm_role_ci_type_ctrl_attr_condition` int(11) DEFAULT NULL,
  `expression` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_adm_role_ci_type_ctrl_attr_expression`),
  KEY `id_adm_role_ci_type_attr_condition` (`id_adm_role_ci_type_ctrl_attr_condition`),
  CONSTRAINT `id_adm_role_ci_type_attr_condition` FOREIGN KEY (`id_adm_role_ci_type_ctrl_attr_condition`) REFERENCES `adm_role_ci_type_ctrl_attr_condition` (`id_adm_role_ci_type_ctrl_attr_condition`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_role_ci_type_ctrl_attr_select` (
  `id_adm_role_ci_type_ctrl_attr_select` int(11) NOT NULL AUTO_INCREMENT,
  `id_adm_role_ci_type_ctrl_attr_condition` int(11) NOT NULL,
  `id_adm_basekey` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_adm_role_ci_type_ctrl_attr_select`),
  KEY `id_adm_role_ci_type_ctrl_attr_condition` (`id_adm_role_ci_type_ctrl_attr_condition`),
  KEY `id_adm_basekey_code` (`id_adm_basekey`),
  CONSTRAINT `id_adm_basekey_code` FOREIGN KEY (`id_adm_basekey`) REFERENCES `adm_basekey_code` (`id_adm_basekey`),
  CONSTRAINT `id_adm_role_ci_type_ctrl_attr_condition` FOREIGN KEY (`id_adm_role_ci_type_ctrl_attr_condition`) REFERENCES `adm_role_ci_type_ctrl_attr_condition` (`id_adm_role_ci_type_ctrl_attr_condition`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
