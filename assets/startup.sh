#!/bin/bash
LISTENERS_ORA=/u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora

cp "${LISTENERS_ORA}.tmpl" "$LISTENERS_ORA" && 
sed -i "s/%hostname%/$HOSTNAME/g" "${LISTENERS_ORA}" && 
sed -i "s/%port%/1521/g" "${LISTENERS_ORA}" && 


if [ -f /.need_oracle_configure ]
then
    printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure &&
    rm /.need_oracle_configure
else
    service oracle-xe start
fi &&

# First time run db initialization scripts
if [ -f /.need_oracle_initialize ]; then
    if [ -d /dbinit/dbinit.d ]; then
        # Make all files in the directory executable. It will facilitate the addition of scripts when working on MS Windows.
        chmod +x /dbinit/dbinit.d/* &&
        echo Oracle data initialization... &&
        # Use _login_ shell to initialize Oracle environment variables
        /bin/bash -lc run-parts --exit-on-error /dbinit/dbinit.d &&
        echo Oracle data initialization. Done.
    fi &&
    rm /.need_oracle_initialize
fi
