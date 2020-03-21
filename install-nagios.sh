#!/bin/bash
echo "Welcome to Nagios v4.4.5 Setup!"
nano /etc/selinux/config
yum update && yum upgrade
systemctl disable --now firewalld
sudo dnf install @php
sudo dnf install @perl @httpd wget unzip glibc automake glibc-common gettext autoconf php php-cli gcc gd gd-devel net-snmp openssl-devel unzip net-snmp postfix net-snmp-utils
sudo dnf groupinstall "Development Tools"
sudo systemctl enable --now httpd php-fpm
tar -xzf nagios-4.4.5.tar.gz
cd nagios-4.4.5/
./configure
make all
make install-groups-users
usermod -a -G nagios apache
make install
make install-daemoninit
make install-commandmode
make install-config
make install-webconf
make install-exfoliation
make install-classicui
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
sudo systemctl restart httpd
cd /usr/src
tar xzf nagios-plugins-2.2.1.tar.gz
nagios-plugins-2.2.1/
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make && make install
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
sudo systemctl enable --now nagios
systemctl status nagios

