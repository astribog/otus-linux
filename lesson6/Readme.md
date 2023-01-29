## NFS server configuration
```
[root@nfss ~]# yum install nfs-utils

[root@nfss ~]# systemctl enable firewalld --now
Created symlink from /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service to /usr/lib/systemd/system/firewalld.service.
Created symlink from /etc/systemd/system/multi-user.target.wants/firewalld.service to /usr/lib/systemd/system/firewalld.service.
[root@nfss ~]# systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2023-01-29 08:18:43 UTC; 18s ago
     Docs: man:firewalld(1)
 Main PID: 3599 (firewalld)
   CGroup: /system.slice/firewalld.service
           └─3599 /usr/bin/python2 -Es /usr/sbin/firewalld --nofork --nopid

Jan 29 08:18:42 nfss systemd[1]: Starting firewalld - dynamic firewall daemon...
Jan 29 08:18:43 nfss systemd[1]: Started firewalld - dynamic firewall daemon.
Jan 29 08:18:44 nfss firewalld[3599]: WARNING: AllowZoneDrifting is enabled. This is considered an insecure configuration option. It will be removed in a future release. Please consider disabling it now.
[root@nfss ~]# firewall-cmd --add-service="nfs3" \
> --add-service="rpc-bind" \
> --add-service="mountd" \
> --permanent
success

[root@nfss ~]# firewall-cmd --reload
success

[root@nfss ~]# systemctl enable nfs --now
Created symlink from /etc/systemd/system/multi-user.target.wants/nfs-server.service to /usr/lib/systemd/system/nfs-server.service.
```
<details>
<summary>[root@nfss ~]# ss -tnplu</summary>
<p> 

```
Netid  State      Recv-Q Send-Q                                                         Local Address:Port                                                                        Peer Address:Port              
udp    UNCONN     0      0                                                                  127.0.0.1:959                                                                                    *:*                   users:(("rpc.statd",pid=3751,fd=5))
udp    UNCONN     0      0                                                                          *:2049                                                                                   *:*                  
udp    UNCONN     0      0                                                                          *:41795                                                                                  *:*                   users:(("rpc.statd",pid=3751,fd=8))
udp    UNCONN     0      0                                                                  127.0.0.1:323                                                                                    *:*                   users:(("chronyd",pid=343,fd=5))
udp    UNCONN     0      0                                                                          *:68                                                                                     *:*                   users:(("dhclient",pid=2606,fd=6))
udp    UNCONN     0      0                                                                          *:20048                                                                                  *:*                   users:(("rpc.mountd",pid=3759,fd=7))
udp    UNCONN     0      0                                                                          *:111                                                                                    *:*                   users:(("rpcbind",pid=347,fd=6))
udp    UNCONN     0      0                                                                          *:36465                                                                                  *:*                  
udp    UNCONN     0      0                                                                          *:925                                                                                    *:*                   users:(("rpcbind",pid=347,fd=7))
udp    UNCONN     0      0                                                                       [::]:54262                                                                               [::]:*                  
udp    UNCONN     0      0                                                                       [::]:2049                                                                                [::]:*                  
udp    UNCONN     0      0                                                                      [::1]:323                                                                                 [::]:*                   users:(("chronyd",pid=343,fd=6))
udp    UNCONN     0      0                                                                       [::]:20048                                                                               [::]:*                   users:(("rpc.mountd",pid=3759,fd=9))
udp    UNCONN     0      0                                                                       [::]:56932                                                                               [::]:*                   users:(("rpc.statd",pid=3751,fd=10))
udp    UNCONN     0      0                                                                       [::]:111                                                                                 [::]:*                   users:(("rpcbind",pid=347,fd=9))
udp    UNCONN     0      0                                                                       [::]:925                                                                                 [::]:*                   users:(("rpcbind",pid=347,fd=10))
tcp    LISTEN     0      100                                                                127.0.0.1:25                                                                                     *:*                   users:(("master",pid=700,fd=13))
tcp    LISTEN     0      64                                                                         *:33886                                                                                  *:*                  
tcp    LISTEN     0      64                                                                         *:2049                                                                                   *:*                  
tcp    LISTEN     0      128                                                                        *:111                                                                                    *:*                   users:(("rpcbind",pid=347,fd=8))
tcp    LISTEN     0      128                                                                        *:20048                                                                                  *:*                   users:(("rpc.mountd",pid=3759,fd=8))
tcp    LISTEN     0      128                                                                        *:59282                                                                                  *:*                   users:(("rpc.statd",pid=3751,fd=9))
tcp    LISTEN     0      128                                                                        *:22                                                                                     *:*                   users:(("sshd",pid=615,fd=3))
tcp    LISTEN     0      100                                                                    [::1]:25                                                                                  [::]:*                   users:(("master",pid=700,fd=14))
tcp    LISTEN     0      128                                                                     [::]:44413                                                                               [::]:*                   users:(("rpc.statd",pid=3751,fd=11))
tcp    LISTEN     0      64                                                                      [::]:2049                                                                                [::]:*                  
tcp    LISTEN     0      128                                                                     [::]:111                                                                                 [::]:*                   users:(("rpcbind",pid=347,fd=11))
tcp    LISTEN     0      128                                                                     [::]:20048                                                                               [::]:*                   users:(("rpc.mountd",pid=3759,fd=10))
tcp    LISTEN     0      64                                                                      [::]:34833                                                                               [::]:*                  
tcp    LISTEN     0      128                                                                     [::]:22                                                                                  [::]:*                   users:(("sshd",pid=615,fd=4))
```
</p>
</details>

```
[root@nfss ~]# mkdir -p /srv/share/upload
[root@nfss ~]# chown -R nfsnobody:nfsnobody /srv/share
[root@nfss ~]# chmod 0777 /srv/share/upload

[root@nfss ~]# cat << EOF > /etc/exports
> /srv/share 192.168.50.11/32(rw,sync,root_squash)
> EOF

[root@nfss ~]# exportfs -s
/srv/share  192.168.50.11/32(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)
```
## NFS client configuration
```
[root@nfsc ~]# yum install nfs-utils

[root@nfsc ~]# systemctl enable firewalld --now
Created symlink from /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service to /usr/lib/systemd/system/firewalld.service.
Created symlink from /etc/systemd/system/multi-user.target.wants/firewalld.service to /usr/lib/systemd/system/firewalld.service.

[root@nfsc ~]# systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2023-01-29 08:31:10 UTC; 11s ago
     Docs: man:firewalld(1)
 Main PID: 3598 (firewalld)
   CGroup: /system.slice/firewalld.service
           └─3598 /usr/bin/python2 -Es /usr/sbin/firewalld --nofork --nopid

Jan 29 08:31:09 nfsc systemd[1]: Starting firewalld - dynamic firewall daemon...
Jan 29 08:31:10 nfsc systemd[1]: Started firewalld - dynamic firewall daemon.
Jan 29 08:31:10 nfsc firewalld[3598]: WARNING: AllowZoneDrifting is enabled. This is considered an insecure configuration option. It will be removed in a future release. Please consider disabling it now.

[root@nfsc ~]# firewall-cmd --add-service="nfs3" \
> --add-service="rpc-bind" \
> --add-service="mountd" \
> --permanent
success

[root@nfsc ~]# firewall-cmd --reload
success

[root@nfsc ~]# echo "192.168.50.10:/srv/share/ /mnt nfs nfsvers=3,proto=udp 0 0" >> /etc/fstab

[root@nfsc mnt]# mount -a

[root@nfsc mnt]# mount | grep mnt
192.168.50.10:/srv/share/ on /mnt type nfs (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,proto=udp,timeo=11,retrans=3,sec=sys,mountaddr=192.168.50.10,mountvers=3,mountport=20048,mountproto=udp,local_lock=none,addr=192.168.50.10)
```
## NFS work test
```
[vagrant@nfss ~]$ touch /srv/share/upload/test_file

[vagrant@nfss ~]$ ls /srv/share/upload
test_file

[root@nfsc mnt]# ls /mnt/upload/
test_file

root@nfsc mnt]# reboot
Connection to 127.0.0.1 closed by remote host.

user@ubuntu:~/otus-linux/otus-linux/lesson6$ vagrant ssh nfsc
Last login: Sun Jan 29 08:28:15 2023 from 10.0.2.2

[vagrant@nfsc ~]$ ls /mnt/upload/
test_file

[vagrant@nfss ~]$ sudo reboot
Connection to 127.0.0.1 closed by remote host.

user@ubuntu:~/otus-linux/otus-linux/lesson6$ vagrant ssh nfss
Last login: Sun Jan 29 09:05:55 2023 from 10.0.2.2

[vagrant@nfss ~]$ ls /srv/share/upload/
test_file

[vagrant@nfss ~]$ systemctl status nfs
● nfs-server.service - NFS server and services
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; vendor preset: disabled)
  Drop-In: /run/systemd/generator/nfs-server.service.d
           └─order-with-mounts.conf
   Active: active (exited) since Sun 2023-01-29 09:16:10 UTC; 2min 31s ago
  Process: 815 ExecStartPost=/bin/sh -c if systemctl -q is-active gssproxy; then systemctl reload gssproxy ; fi (code=exited, status=0/SUCCESS)
  Process: 789 ExecStart=/usr/sbin/rpc.nfsd $RPCNFSDARGS (code=exited, status=0/SUCCESS)
  Process: 784 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
 Main PID: 789 (code=exited, status=0/SUCCESS)
   CGroup: /system.slice/nfs-server.service

[vagrant@nfss ~]$ systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2023-01-29 09:16:03 UTC; 2min 49s ago
     Docs: man:firewalld(1)
 Main PID: 406 (firewalld)
   CGroup: /system.slice/firewalld.service
           └─406 /usr/bin/python2 -Es /usr/sbin/firewalld --nofork --nopid

[vagrant@nfss ~]$ sudo exportfs -s
/srv/share  192.168.50.11/32(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)

[vagrant@nfss ~]$ showmount -a 192.168.50.10
All mount points on 192.168.50.10:
192.168.50.11:/srv/share

[vagrant@nfsc ~]$ touch /mnt/upload/final_test

[vagrant@nfss ~]$ ls /srv/share/upload/
final_test  test_file