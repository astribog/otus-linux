## Reducing /root volume
<details>
<summary>[root@lvm ~]# lsblk -f</summary>

```
NAME         FSTYPE      LABEL UUID                                   MOUNTPOINT
sda                                                                   
├─sda1                                                                
├─sda2       xfs               570897ca-e759-4c81-90cf-389da6eee4cc   /boot
└─sda3       LVM2_member       vrrtbx-g480-HcJI-5wLn-4aOf-Olld-rC03AY 
  ├─VolGroup00-LogVol00
             xfs               b60e9498-0baa-4d9f-90aa-069048217fee   /
  └─VolGroup00-LogVol01
             swap              c39c5bed-f37c-4263-bee8-aeb6a6659d7b   [SWAP]
sdb                                                                   
sdc                                                                   
sdd                                                                   
sde
```
</details>                                                             
<details>
<summary>[root@lvm ~]# df -h</summary>

```
Filesystem                       Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup00-LogVol00   38G  843M   37G   3% /
devtmpfs                         109M     0  109M   0% /dev
tmpfs                            118M     0  118M   0% /dev/shm
tmpfs                            118M  4.5M  114M   4% /run
tmpfs                            118M     0  118M   0% /sys/fs/cgroup
/dev/sda2                       1014M   63M  952M   7% /boot
tmpfs                             24M     0   24M   0% /run/user/1000
```
</details>

```
[root@lvm ~]# yum install xfsdump
Complete!
```
```
[root@lvm ~]# pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.

[root@lvm ~]# vgcreate vg_root /dev/sdb
  Volume group "vg_root" successfully created

[root@lvm ~]# lvcreate -n lv_root -l +100%FREE /dev/vg_root
  Logical volume "lv_root" created.
   
[root@lvm ~]# mkfs.xfs /dev/vg_root/lv_root 

[root@lvm ~]# mount /dev/vg_root/lv_root /mnt
```
```
[root@lvm ~]# xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt
xfsrestore: Restore Status: SUCCESS
```
```
[root@lvm ~]# for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
[root@lvm ~]# chroot /mnt/
[root@lvm /]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-862.2.3.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img
done
```
```
[root@lvm /]# cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g;
> s/.img//g"` --force; done
...
*** Creating image file ***
*** Creating image file done ***
*** Creating initramfs image file '/boot/initramfs-3.10.0-862.2.3.el7.x86_64.img' done ***

[root@lvm boot]# yum install nano

[root@lvm boot]# nano /boot/grub2/grub.cfg
#Change rd.lvm.lv=VolGroup00/LogVol00 with rd.lvm.lv=vg_root/lv_root

[root@lvm boot]# exit
exit

[root@lvm ~]# reboot
Connection to 127.0.0.1 closed by remote host.

user@ubuntu:~/otus-linux/otus-linux$ vagrant ssh
Last login: Mon Jan 16 14:24:52 2023 from 10.0.2.2
```

<details>
<summary>[root@lvm ~]# lsblk</summary>

```
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                       8:0    0   40G  0 disk 
├─sda1                    8:1    0    1M  0 part 
├─sda2                    8:2    0    1G  0 part /boot
└─sda3                    8:3    0   39G  0 part 
  ├─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]
  └─VolGroup00-LogVol00 253:2    0 37.5G  0 lvm  
sdb                       8:16   0   10G  0 disk 
└─vg_root-lv_root       253:0    0   10G  0 lvm  /
sdc                       8:32   0    2G  0 disk 
sdd                       8:48   0    1G  0 disk 
sde                       8:64   0    1G  0 disk 
```
</details>

```
[vagrant@lvm ~]$ sudo -i
[root@lvm ~]# lvremove /dev/VolGroup00/LogVol00
Do you really want to remove active logical volume VolGroup00/LogVol00? [y/n]: y
  Logical volume "LogVol00" successfully removed
```
```
[root@lvm ~]#  lvcreate -n VolGroup00/LogVol00 -L 8G /dev/VolGroup00
WARNING: xfs signature detected on /dev/VolGroup00/LogVol00 at offset 0. Wipe it? [y/n]: y
  Wiping xfs signature on /dev/VolGroup00/LogVol00.
  Logical volume "LogVol00" created.
```
[root@lvm ~]# mkfs.xfs /dev/VolGroup00/LogVol00
[root@lvm ~]#  mount /dev/VolGroup00/LogVol00 /mnt
```
[root@lvm ~]# xfsdump -J - /dev/vg_root/lv_root | xfsrestore -J - /mnt
...
xfsrestore: Restore Status: SUCCESS
```
```
root@lvm ~]# for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done

[root@lvm ~]# chroot /mnt/

[root@lvm /]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-862.2.3.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img
done

[root@lvm /]# cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g;
> s/.img//g"` --force; done
...
*** Creating image file ***
*** Creating image file done ***
*** Creating initramfs image file '/boot/initramfs-3.10.0-862.2.3.el7.x86_64.img' done ***
```
## Moving /var catalog
```
[root@lvm boot]# pvcreate /dev/sdc /dev/sdd
  Physical volume "/dev/sdc" successfully created.
  Physical volume "/dev/sdd" successfully created.
[root@lvm boot]# vgcreate vg_var /dev/sdc /dev/sdd
  Volume group "vg_var" successfully created
[root@lvm boot]# lvcreate -L 950M -m1 -n lv_var vg_var
  Rounding up size to full physical extent 952.00 MiB
  Logical volume "lv_var" created.
[root@lvm boot]# mkfs.ext4 /dev/vg_var/lv_var
[root@lvm boot]# mount /dev/vg_var/lv_var /mnt
[root@lvm boot]# cp -aR /var/* /mnt/
[root@lvm boot]# mkdir /tmp/oldvar && mv /var/* /tmp/oldvar
[root@lvm boot]# umount /mnt
[root@lvm boot]# mount /dev/vg_var/lv_var /var
[root@lvm boot]# echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab
```
<details>
<summary>[root@lvm boot]# cat /etc/fstab</summary>

```
#
# /etc/fstab
# Created by anaconda on Sat May 12 18:50:26 2018
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/VolGroup00-LogVol00 /                       xfs     defaults        0 0
UUID=570897ca-e759-4c81-90cf-389da6eee4cc /boot                   xfs     defaults        0 0
/dev/mapper/VolGroup00-LogVol01 swap                    swap    defaults        0 0
#VAGRANT-BEGIN
# The contents below are automatically generated by Vagrant. Do not modify.
#VAGRANT-END
UUID="e9a8e249-df06-4a92-a1e4-b45d7ef368c5" /var ext4 defaults 0 0
```
</details>

```
[root@lvm boot]# 
[root@lvm boot]# exit
exit
[root@lvm ~]# reboot
PolicyKit daemon disconnected from the bus.
We are no longer a registered authentication agent.
Connection to 127.0.0.1 closed by remote host.

user@ubuntu:~/otus-linux/otus-linux$ vagrant ssh
Last login: Tue Jan 17 07:52:04 2023 from 10.0.2.2

[vagrant@lvm ~]$ sudo -i
[root@lvm ~]#  lvremove /dev/vg_root/lv_root
Do you really want to remove active logical volume vg_root/lv_root? [y/n]: y
  Logical volume "lv_root" successfully removed
[root@lvm ~]# vgremove /dev/vg_root
  Volume group "vg_root" successfully removed
[root@lvm ~]# pvremove /dev/sdb
  Labels on physical volume "/dev/sdb" successfully wiped.
[root@lvm ~]# 
```
## Making /home dedicated volume
```
[root@lvm ~]# lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
  Logical volume "LogVol_Home" created.
[root@lvm ~]# mkfs.xfs /dev/VolGroup00/LogVol_Home
[root@lvm ~]# mount /dev/VolGroup00/LogVol_Home /mnt/
[root@lvm ~]# cp -aR /home/* /mnt/ 
[root@lvm ~]# rm -rf /home/*
[root@lvm ~]# umount /mnt
[root@lvm ~]# mount /dev/VolGroup00/LogVol_Home /home/
[root@lvm ~]# echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab
```
<details>
<summary>[root@lvm ~]# cat /etc/fstab</summary>

```
# Created by anaconda on Sat May 12 18:50:26 2018
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/VolGroup00-LogVol00 /                       xfs     defaults        0 0
UUID=570897ca-e759-4c81-90cf-389da6eee4cc /boot                   xfs     defaults        0 0
/dev/mapper/VolGroup00-LogVol01 swap                    swap    defaults        0 0
#VAGRANT-BEGIN
# The contents below are automatically generated by Vagrant. Do not modify.
#VAGRANT-END
UUID="e9a8e249-df06-4a92-a1e4-b45d7ef368c5" /var ext4 defaults 0 0
UUID="8dfa49ba-03dc-46ed-9d46-9bf51acead5d" /home xfs defaults 0 0
```
</details>

## /home - snapshots
``` 
[root@lvm ~]# touch /home/file{1..20}
[root@lvm ~]# ls /home/
file1  file10  file11  file12  file13  file14  file15  file16  file17  file18  file19  file2  file20  file3  file4  file5  file6  file7  file8  file9  vagrant
[root@lvm ~]# lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home
  Rounding up size to full physical extent 128.00 MiB
  Logical volume "home_snap" created.
[root@lvm ~]# rm -f /home/file{11..20}
[root@lvm ~]# ls /home/
file1  file10  file2  file3  file4  file5  file6  file7  file8  file9  vagrant
[root@lvm ~]# umount /home
[root@lvm ~]# lvconvert --merge /dev/VolGroup00/home_snap
  Merging of volume VolGroup00/home_snap started.
  VolGroup00/LogVol_Home: Merged: 100.00%
[root@lvm ~]#  mount /home
[root@lvm ~]# ls /home/
file1  file10  file11  file12  file13  file14  file15  file16  file17  file18  file19  file2  file20  file3  file4  file5  file6  file7  file8  file9  vagrant
```