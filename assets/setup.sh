#!/bin/bash

# avoid dpkg frontend dialog / frontend warnings 
export DEBIAN_FRONTEND=noninteractive

cat /assets/oracle-xe_11.2.0-1.0_amd64.deba* > /assets/oracle-xe_11.2.0-1.0_amd64.deb

touch /.in_build_stage && sync &&

# Install OpenSSH
apt-get install -y openssh-server &&
mkdir /var/run/sshd &&
echo 'root:admin' | chpasswd &&
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd &&
echo "export VISIBLE=now" >> /etc/profile &&

# Prepare to install Oracle
apt-get install -y libaio1 net-tools bc &&
ln -s /usr/bin/awk /bin/awk &&
mkdir /var/lock/subsys &&
mv /assets/chkconfig /sbin/chkconfig &&
chmod 755 /sbin/chkconfig &&

# Install Oracle
dpkg --install /assets/oracle-xe_11.2.0-1.0_amd64.deb &&

# Backup listener.ora as template
cp /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora.tmpl &&

mv /assets/init.ora /u01/app/oracle/product/11.2.0/xe/config/scripts &&
mv /assets/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts &&

echo 'export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe' >> /etc/profile.d/oracle.sh &&
echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/profile.d/oracle.sh &&
echo 'export ORACLE_SID=XE' >> /etc/profile.d/oracle.sh &&
echo '. /etc/profile.d/oracle.sh' >> /etc/bash.bashrc &&

if [ "${configure_on_build:-yes}" = "no" ] || [ "${configure_on_build:-true}" = "false" ]
then
    touch /.need_oracle_configure
else
    printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure &&
    # Run first time run db initialization scripts on build stage to speed up the first container run
    if [ -d /dbinit/dbinit.d ]; then
        # Make all files in the directory executable. It will facilitate the addition of scripts when working on MS Windows.
        if [ "$(ls /dbinit/dbinit.d)" ]; then
            chmod +x /dbinit/dbinit.d/*
        fi &&
        echo Oracle data initialization... &&
        # Use _login_ shell to initialize Oracle environment variables
        /bin/bash -lc "run-parts --exit-on-error /dbinit/dbinit.d" &&
        # Delete every script that has been launched
        rm -rf /dbinit/dbinit.d/* &&
        echo Oracle data initialization. Done.
    fi
fi &&

touch /.need_oracle_initialize &&

# Install startup script for container
mv /assets/startup.sh /usr/sbin/startup.sh &&
chmod +x /usr/sbin/startup.sh &&

# Remove installation files
rm -r /assets/ &&
rm /.in_build_stage


exit $?
