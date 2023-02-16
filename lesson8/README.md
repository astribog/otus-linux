## Changing root password 1

```
boot menu - `e`
put "rd.break" at the end of line, starting with "linux16"
`ctrl-x`
switch_root:/# mount -o remount,rw /sysroot
switch_root:/# chroot /sysroot
sh-4.2# passwd root
sh-4.2# touch /.autorelabel
sh-4.2# exit
switch_root:/# reboot
```

## Changing root password 2

```
boot menu - `e`
replace "ro" with "rw init=/sysroot/bin/sh" at the line, starting with "linux16
`ctrl-x`
:/# chroot /sysroot
:/# passwd
:/# touch /.autorelabel
:/# exit
:/# reboot
```

## Renaming Root Volume Group

```
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
```

## Adding module to initrd

```
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
```
