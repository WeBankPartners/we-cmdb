ALTER TABLE adm_log
ADD COLUMN request_url varchar(500),
ADD COLUMN client_host varchar(20);