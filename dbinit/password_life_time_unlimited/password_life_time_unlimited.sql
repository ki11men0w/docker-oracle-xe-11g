-- Disable password expiration
alter profile default limit password_life_time unlimited;
alter user system identified by oracle;
alter user sys identified by oracle;

exit;
