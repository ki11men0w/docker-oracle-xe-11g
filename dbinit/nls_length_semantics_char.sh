#!/bin/bash

echo Set NLS_LENGTH_SEMANTICS=CHAR... &&
su -l -c "sqlplus system/oracle @/dbinit/nls_length_semantics_char/nls_length_semantics_char.sql" oracle &&
echo Set NLS_LENGTH_SEMANTICS=CHAR. Done.
