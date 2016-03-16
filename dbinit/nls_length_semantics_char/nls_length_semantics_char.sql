-- In Oracle XE there is only UTF-8 database encoding supported
-- so use char length semantics for russian strings.
alter system set nls_length_semantics=CHAR scope=both;

exit;
