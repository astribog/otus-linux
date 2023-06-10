




# Backup test
```
[root@client ~]# ls /etc/ | grep hosts
hosts
hosts.allow
hosts.deny

[root@client ~]# rm -f /etc/hosts

[root@client ~]# ls /etc/ | grep hosts
hosts.allow
hosts.deny

[root@client ~]# cd /

[root@client /]# borg extract borg@192.168.56.150:/var/backup::etc-2023-06-10_14:35:41 etc/hosts

[root@client /]# ls -a /etc/ | grep hosts
hosts
hosts.allow
hosts.deny
```