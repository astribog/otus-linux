[root@localhost ~]# vgs
  VG     #PV #LV #SN Attr   VSize   VFree
  centos   1   2   0 wz--n- <31.00g 4.00m
[root@localhost ~]# vgrename centos otus
  Volume group "centos" successfully renamed to "otus"
[root@localhost ~]# vi /etc/fstab
[root@localhost ~]# vi /etc/default/grub 
[root@localhost ~]# vi /etc/grub2.cfg 
[root@localhost ~]# mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
[root@localhost ~]# reboot
[root@localhost ~]# vgs
  VG   #PV #LV #SN Attr   VSize   VFree
  otus   1   2   0 wz--n- <31.00g 4.00m
[user@localhost ~]$ sudo mkdir /usr/lib/dracut/modules.d/01test
[user@localhost ~]$ cd /usr/lib/dracut/modules.d/01test
[user@localhost 01test]$ sudo vi module-setup.sh
[user@localhost 01test]$ sudo vi test.sh
[user@localhost 01test]$ sudo chmod +x module-setup.sh 
[user@localhost 01test]$ sudo chmod +x test.sh
[user@localhost 01test]$ sudo -i
[sudo] password for user: 
[root@localhost ~]# mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
[root@localhost ~]# lsinitrd -m /boot/initramfs-$(uname -r).img | grep test
test
