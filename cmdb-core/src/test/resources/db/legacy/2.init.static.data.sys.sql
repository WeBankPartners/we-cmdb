INSERT INTO `adm_tenement` VALUES (1,'微众银行','前海微众银行','wb');
INSERT INTO `adm_user` (`id_adm_user`, `name`, `code`, `description`, `id_adm_tenement`, `action_flag`) VALUES
	('1', 'umadmin', 'umadmin', 'umadmin', 1, 0);
INSERT INTO `adm_sequence`(id_adm_sequence,seq_name,current_val,increment_val,length_limitation,left_zero_padding) 
VALUES 
(1,'wb_system',2,1,10,'Y'),
(2,'wb_sub_system',12,1,10,'Y'),
(3,'wb_state_create',20,1,10,'Y');

