#!/bin/bash

echo Set NLS_LENGTH_SEMANTICS=CHAR... &&
sqlplus system/oracle @/dbinit/nls_length_semantics_char/nls_length_semantics_char.sql &&
echo Set NLS_LENGTH_SEMANTICS=CHAR. Done. &&
# This setting take effect only after oracle restart
if [ -f /.need_oracle_configure ]; then
    # Do not restart on build stage
    service oracle-xe restart
fi
