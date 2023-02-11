## watchlog
```
[root@localhost ~]# vi /etc/sysconfig/watchlog
[root@localhost ~]# vi /var/log/watchlog.log
[root@localhost ~]# vi /opt/watchlog.sh
[root@localhost ~]# chmod +x /opt/watchlog.sh 
[root@localhost ~]# vi /etc/systemd/system/watchlog.service
[root@localhost ~]# vi /etc/systemd/system/watchlog.timer
[root@localhost ~]# systemctl start watchlog.timer 
[root@localhost ~]# tail -f /var/log/messages
Feb 10 10:30:38 localhost systemd: Started My watchlog service.
Feb 10 10:31:38 localhost systemd: Starting My watchlog service...
Feb 10 10:31:38 localhost root: Fri Feb 10 10:31:38 UTC 2023: I found word, Master!
Feb 10 10:31:38 localhost systemd: Started My watchlog service.
Feb 10 10:31:53 localhost systemd: Created slice User Slice of vagrant.
Feb 10 10:31:53 localhost systemd-logind: New session 7 of user vagrant.
Feb 10 10:31:53 localhost systemd: Started Session 7 of user vagrant.
Feb 10 10:32:09 localhost systemd: Starting My watchlog service...
Feb 10 10:32:09 localhost root: Fri Feb 10 10:32:09 UTC 2023: I found word, Master!
Feb 10 10:32:09 localhost systemd: Started My watchlog service.
```
## spawn-fcgi
```
[root@localhost ~]# yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y
[root@localhost ~]# vi /etc/sysconfig/spawn-fcgi
[root@localhost ~]# vi /etc/systemd/system/spawn-fcgi.service
[root@localhost ~]# systemctl start spawn-fcgi
[root@localhost ~]# systemctl status spawn-fcgi
● spawn-fcgi.service - Spawn-fcgi startup service by Otus
   Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; vendor preset: disabled)
   Active: active (running) since Fri 2023-02-10 11:01:59 UTC; 8s ago
 Main PID: 22542 (php-cgi)
   CGroup: /system.slice/spawn-fcgi.service
           ├─22542 /usr/bin/php-cgi
           ├─22543 /usr/bin/php-cgi
           ├─22544 /usr/bin/php-cgi
           ├─22545 /usr/bin/php-cgi
           ├─22546 /usr/bin/php-cgi
           ├─22547 /usr/bin/php-cgi
           ├─22548 /usr/bin/php-cgi
           ├─22549 /usr/bin/php-cgi
           ├─22550 /usr/bin/php-cgi
           ├─22551 /usr/bin/php-cgi
           ├─22552 /usr/bin/php-cgi
           ├─22553 /usr/bin/php-cgi
           ├─22554 /usr/bin/php-cgi
           ├─22555 /usr/bin/php-cgi
           ├─22556 /usr/bin/php-cgi
           ├─22557 /usr/bin/php-cgi
           ├─22558 /usr/bin/php-cgi
           ├─22559 /usr/bin/php-cgi
           ├─22560 /usr/bin/php-cgi
           ├─22561 /usr/bin/php-cgi
           ├─22562 /usr/bin/php-cgi
           ├─22563 /usr/bin/php-cgi
           ├─22564 /usr/bin/php-cgi
           ├─22565 /usr/bin/php-cgi
           ├─22566 /usr/bin/php-cgi
           ├─22567 /usr/bin/php-cgi
           ├─22568 /usr/bin/php-cgi
           ├─22569 /usr/bin/php-cgi
           ├─22570 /usr/bin/php-cgi
           ├─22571 /usr/bin/php-cgi
           ├─22572 /usr/bin/php-cgi
           ├─22573 /usr/bin/php-cgi
           └─22574 /usr/bin/php-cgi

Feb 10 11:01:59 localhost.localdomain systemd[1]: Started Spawn-fcgi startup service by Otus.
```
## apache httpd
```
[root@localhost ~]# vi /usr/lib/systemd/system/httpd.service
[root@localhost ~]# vi /etc/sysconfig/httpd-first
[root@localhost ~]# vi /etc/sysconfig/httpd-second
[root@localhost ~]# cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/first.conf
[root@localhost ~]# cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/second.conf 
[root@localhost ~]# vi /etc/httpd/conf/second.conf
[root@localhost ~]# cd /usr/lib/systemd/system
[root@localhost system]# ls -d http*
httpd.service
[root@localhost system]# cp httpd.service httpd@.service 
[root@localhost system]# systemctl start httpd@first
[root@localhost system]# systemctl  start httpd@second
[root@localhost system]# ss -tnulp | grep httpd
tcp    LISTEN     0      128    [::]:8080               [::]:*                   users:(("httpd",pid=22995,fd=4),("httpd",pid=22994,fd=4),("httpd",pid=22993,fd=4),("httpd",pid=22992,fd=4),("httpd",pid=22991,fd=4),("httpd",pid=22990,fd=4),("httpd",pid=22989,fd=4))
tcp    LISTEN     0      128    [::]:80                 [::]:*                   users:(("httpd",pid=22981,fd=4),("httpd",pid=22980,fd=4),("httpd",pid=22979,fd=4),("httpd",pid=22978,fd=4),("httpd",pid=22977,fd=4),("httpd",pid=22976,fd=4),("httpd",pid=22975,fd=4))
