#!/bin/bash

echo Set password life time unlimited... &&
su -l -c "sqlplus system/oracle @/dbinit/password_life_time_unlimited/password_life_time_unlimited.sql" oracle &&
echo Set password life time unlimited. Done.
