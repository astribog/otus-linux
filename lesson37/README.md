# 1) Установить FreeIPA

## Run Vagrantfile - it makes all base work on clients and ipa server

## Install FreeIPA server
Установим модуль DL1: yum install -y @idm:DL1
Установим FreeIPA-сервер: yum install -y ipa-server
Запустим скрипт установки: ipa-server-install


## Check Kerberos on ipa server
```
[root@ipa ~]# kinit admin
Password for admin@OTUS.LAN: 
[root@ipa ~]# klist
Ticket cache: KCM:0
Default principal: admin@OTUS.LAN

Valid starting     Expires            Service principal
06/14/23 16:58:06  06/15/23 16:58:01  krbtgt/OTUS.LAN@OTUS.LAN
```

## Add user "otus-user" on "ipa" server
```
[root@ipa ~]# ipa user-add otus-user --first=Otus --last=User --password
Password: 
Enter Password again to verify: 
----------------------
Added user "otus-user"
----------------------
  User login: otus-user
  First name: Otus
  Last name: User
  Full name: Otus User
  Display name: Otus User
  Initials: OU
  Home directory: /home/otus-user
  GECOS: Otus User
  Login shell: /bin/sh
  Principal name: otus-user@OTUS.LAN
  Principal alias: otus-user@OTUS.LAN
  User password expiration: 20230614140048Z
  Email address: otus-user@otus.lan
  UID: 681200003
  GID: 681200003
  Password: True
  Member of groups: ipausers
  Kerberos keys available: True
```
# 2) Написать Ansible-playbook для конфигурации клиента

## Run ansible playbook with tag "ipa" for clients configuration
```
user@ubuntu:~/otus-linux/otus-linux/lesson37$ sudo ansible-playbook playbook.yml -t ipa
```

## Check if Kerberos works on client1
```
[vagrant@client1 ~]$ sudo -i
[root@client1 ~]# kinit otus-user
Password for otus-user@OTUS.LAN: 
Password expired.  You must change it now.
Enter new password: 
Enter it again: 
Password change rejected: Password is too short

Password not changed..  Please try again.

Enter new password: 
Enter it again: 
Password change rejected: Password is too short

Password not changed..  Please try again.

Enter new password: 
Enter it again: 
```