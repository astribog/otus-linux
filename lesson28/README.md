## Запретить всем пользователям, кроме группы admin, логин в выходные (суббота и воскресенье), без учета праздников

### Use pam_exec module

```
#add users "otus" & "otusadmin"
[vagrant@pam ~]$ sudo useradd otusadm && sudo useradd otus
[vagrant@pam ~]$ echo "Otus2022!" | sudo passwd --stdin otusadm && echo "Otus2022!" | sudo passwd --stdin otus

#add them with "root" & to "admin" group
[vagrant@pam ~]$ groupadd -f admin
[vagrant@pam ~]$ sudo usermod otusadm -a -G admin && sudo usermod root -a -G admin && sudo usermod vagrant -a -G admin

#make shell script (look "login.sh" file)
[vagrant@pam ~]$ sudo vi /usr/local/bin/login.sh
sudo chmod +x /usr/local/bin/login.sh

#use pam_exec module with our script (look "sshd" file)
vi /etc/pam.d/sshd