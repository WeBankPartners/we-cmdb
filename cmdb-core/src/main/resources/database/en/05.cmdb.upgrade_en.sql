#@1.5.9.0-begin@
ALTER TABLE `adm_ci_type_attr` 
CHANGE COLUMN `auto_fill_rule` `auto_fill_rule` VARCHAR(3000) NULL DEFAULT NULL;
#@1.5.9.0-end@