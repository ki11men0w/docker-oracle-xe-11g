#!/bin/bash
LISTENERS_ORA=/u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora

cp "${LISTENERS_ORA}.tmpl" "$LISTENERS_ORA" && 
sed -i "s/%hostname%/$HOSTNAME/g" "${LISTENERS_ORA}" && 
sed -i "s/%port%/1521/g" "${LISTENERS_ORA}" && 


if [ -f /.need_oracle_configure ]
then
    printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure &&
    rm /.need_oracle_configure &&
    service oracle-xe restart
else
    service oracle-xe start
fi &&

# First time run db initialization scripts
if [ -f /.need_oracle_initialize ]; then
    if [ -d /dbinit/dbinit.d ]; then
        echo Oracle data initialization... &&
        run-parts --exit-on-error /dbinit/dbinit.d &&
        echo Oracle data initialization. Done.
    fi &&
    rm /.need_oracle_initialize
fi
