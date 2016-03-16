#!/bin/bash
LISTENERS_ORA=/u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora

cp "${LISTENERS_ORA}.tmpl" "$LISTENERS_ORA" && 
sed -i "s/%hostname%/$HOSTNAME/g" "${LISTENERS_ORA}" && 
sed -i "s/%port%/1521/g" "${LISTENERS_ORA}" && 

service oracle-xe start &&

# First time run db initialization scripts
if [ -f /.need_oracle_initialize ]; then
    if [ -d /dbinit/dbinit.d ]; then
        # Make all files in the directory executable. It will facilitate the addition of scripts when working on MS Windows.
        chmod +x /dbinit/dbinit.d/* &&
        echo Oracle data initialization... &&
        run-parts --exit-on-error /dbinit/dbinit.d &&
        echo Oracle data initialization. Done.
    fi &&
    rm /.need_oracle_initialize
fi
