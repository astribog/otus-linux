## Building nginx rpm with ssl
```
[root@localhost ~]# wget https://nginx.org/packages/centos/8/SRPMS/nginx-1.20.2-1.el8.ngx.src.rpm

[root@localhost ~]# rpm -i nginx-1.*

[root@localhost ~]# wget https://github.com/openssl/openssl/archive/refs/heads/OpenSSL_1_1_1-stable.zip

[root@localhost ~]# unzip OpenSSL_1_1_1-stable.zip -d ~/

[root@localhost ~]# yum-builddep rpmbuild/SPECS/nginx.spec

[root@localhost ~]# vi rpmbuild/SPECS/nginx.spec
# --with-openssl=/root/openssl-OpenSSL_1_1_1-stable

[root@localhost ~]# rpmbuild -bb rpmbuild/SPECS/nginx.spec

[root@localhost ~]# ll rpmbuild/RPMS/x86_64/
total 3912
-rw-r--r--. 1 root root 2039948 фев  1 12:12 nginx-1.20.2-1.el7.ngx.x86_64.rpm
-rw-r--r--. 1 root root 1960904 фев  1 12:12 nginx-debuginfo-1.20.2-1.el7.ngx.x86_64.rpm

[root@localhost ~]# yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el7.ngx.x86_64.rpm

[root@localhost ~]# systemctl start nginx

[root@localhost ~]# systemctl status nginx
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Ср 2023-02-01 12:15:51 UTC; 10s ago
     Docs: http://nginx.org/en/docs/
  Process: 9692 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
 Main PID: 9693 (nginx)
   CGroup: /system.slice/nginx.service
           ├─9693 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
           ├─9694 nginx: worker process
           ├─9695 nginx: worker process
           ├─9696 nginx: worker process
           └─9697 nginx: worker process

фев 01 12:15:51 localhost.localdomain systemd[1]: Starting nginx - high performance web server...
фев 01 12:15:51 localhost.localdomain systemd[1]: Started nginx - high performance web server.
```

## Creating own repo

```
[root@localhost ~]# cp rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo

[root@localhost ~]# wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.0.28/binary/redhat/8/x86_64/percona-orchestrator-3.2.6-2.el8.x86_64.rpm -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-2.el8.x86_64.rpm

[root@localhost ~]# createrepo /usr/share/nginx/html/repo/
Spawning worker 0 with 1 pkgs
Spawning worker 1 with 1 pkgs
Spawning worker 2 with 0 pkgs
Spawning worker 3 with 0 pkgs
Workers Finished
Saving Primary metadata
Saving file lists metadata
Saving other metadata
Generating sqlite DBs
Sqlite DBs complete

[root@localhost ~]# vi /etc/nginx/conf.d/default.conf
# autoindex on;

[root@localhost ~]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

[root@localhost ~]# nginx -s reload

[root@localhost ~]# curl -a http://localhost/repo/
<html>
<head><title>Index of /repo/</title></head>
<body>
<h1>Index of /repo/</h1><hr><pre><a href="../">../</a>
<a href="repodata/">repodata/</a>                                          01-Feb-2023 12:23                   -
<a href="nginx-1.20.2-1.el7.ngx.x86_64.rpm">nginx-1.20.2-1.el7.ngx.x86_64.rpm</a>                  01-Feb-2023 12:18             2039948
<a href="percona-orchestrator-3.2.6-2.el8.x86_64.rpm">percona-orchestrator-3.2.6-2.el8.x86_64.rpm</a>        16-Feb-2022 15:57             5222976
</pre><hr></body>
</html>

[root@localhost ~]# cat >> /etc/yum.repos.d/otus.repo << EOF
> [otus]
> name=otus-linux
> baseurl=http://localhost/repo
> gpgcheck=0
> enabled=1
> EOF

[root@localhost ~]# yum repolist enabled | grep otus
otus                                otus-linux                                 2

[root@localhost ~]# yum list | grep otus
percona-orchestrator.x86_64                 2:3.2.6-2.el8              otus     
