#!/bin/bash

# SELinux Access Denial Practical
# Student Name:shalini M
# Register Number:1U24IT104

echo "===== SELinux Status ====="
sestatus
getenforce

echo "===== Creating Web Directory ====="
mkdir -p /webcontent
echo "===== Creating HTML File ====="
echo "<h1>SELinux Access Denial test</h1>" /webcontent/index.html

echo "===== Setting Linux Permissions ====="
chmod -R 755 /webcontent

echo "===== Checking Initial Context ====="
ls -Z /webcontent/index.html

echo "===== Assigning Wrong SELinux Context ====="
chcon -t user_home_t /webcontent/index.html
echo "===== Checking Wrong Context ====="
ls -Z /webcontent/index.html

echo "===== Checking AVC Denials ====="
grep "denied" /var/log/audit/audit.log | tail -n 5 || ausearch -m avc -ts recent
echo "===== Correcting SELinux Context ====="
semanage fcontext -a -t httpd_sys_content_t "/webcontent(/.*)?"
restorecon -Rv /webcontent

echo "===== Checking Correct Context ====="
ls -Z /webcontent/index.html

echo "===== Practical Completed ====="
