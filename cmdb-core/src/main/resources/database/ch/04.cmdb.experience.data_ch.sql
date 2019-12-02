SET FOREIGN_KEY_CHECKS=0;

INSERT INTO `adm_user` (`id_adm_user`, `name`, `code`, `encrypted_password`, `description`, `id_adm_tenement`, `action_flag`, `is_system`) VALUES
	(2, 'Jordan Zhang', 'jordan', '$2a$10$N7CQen.5UtFbEIPBYWhfgOnAg73h0YbLQjr2ivVuEeDATghfuZea.', 'CMDB Admin', NULL, NULL, NULL),
	(3, 'Monkey', 'monkey', '$2a$10$N7CQen.5UtFbEIPBYWhfgOnAg73h0YbLQjr2ivVuEeDATghfuZea.', 'CMDB Developer', NULL, NULL, NULL),
	(4, 'Chaney Liu', 'chaneyliu', '$2a$10$N7CQen.5UtFbEIPBYWhfgOnAg73h0YbLQjr2ivVuEeDATghfuZea.', 'CMDB Architect', NULL, NULL, NULL);

INSERT INTO `adm_role_user` (`id_adm_role_user`, `id_adm_role`, `id_adm_user`, `is_system`) VALUES
	(2, 2, 2, 0),
	(3, 9, 3, 0),
	(4, 6, 4, 0);

INSERT INTO `adm_role_menu` (`id_adm_role_menu`, `id_adm_role`, `id_adm_menu`, `is_system`) VALUES
	(25, 2, 20, 0),
	(26, 2, 21, 0),
	(27, 2, 22, 0),
	(28, 2, 23, 0),
	(29, 2, 24, 0),
	(30, 2, 9, 0),
	(31, 2, 10, 0),
	(32, 2, 11, 0),
	(33, 2, 16, 0),
	(34, 2, 17, 0),
	(35, 2, 18, 0),
	(36, 2, 19, 0),
	(37, 2, 6, 0),
	(38, 2, 7, 0),
	(39, 2, 8, 0),
	(44, 9, 6, 0),
	(45, 9, 7, 0),
	(46, 9, 8, 0),
	(47, 9, 9, 0),
	(48, 9, 10, 0),
	(49, 9, 11, 0),
	(50, 6, 16, 0),
	(51, 6, 17, 0),
	(52, 6, 18, 0),
	(53, 6, 19, 0),
	(54, 6, 6, 0),
	(55, 6, 7, 0),
	(56, 6, 8, 0),
	(57, 6, 9, 0),
	(58, 6, 10, 0),
	(59, 6, 11, 0),
	(61, 6, 22, 0),
	(62, 6, 20, 0),
	(63, 6, 23, 0);

SET FOREIGN_KEY_CHECKS=1;
