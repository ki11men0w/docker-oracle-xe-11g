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
fi
