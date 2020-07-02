ALTER TABLE adm_ci_type_attr
ADD COLUMN `is_delete_validate` INT(1) NULL DEFAULT 1;

ALTER TABLE adm_ci_type_attr_base
ADD COLUMN `is_delete_validate` INT(1) NULL DEFAULT 1;
