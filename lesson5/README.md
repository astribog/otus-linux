## Task 1. Create ZFS pools and play with compression.

```
vagrant@zfs ~]$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   40G  0 disk 
`-sda1   8:1    0   40G  0 part /
sdb      8:16   0  512M  0 disk 
sdc      8:32   0  512M  0 disk 
sdd      8:48   0  512M  0 disk 
sde      8:64   0  512M  0 disk 
sdf      8:80   0  512M  0 disk 
sdg      8:96   0  512M  0 disk 
sdh      8:112  0  512M  0 disk 
sdi      8:128  0  512M  0 disk

[vagrant@zfs ~]$ sudo zpool create otus1 mirror /dev/sdb /dev/sdc
[vagrant@zfs ~]$ sudo zpool create otus2 mirror /dev/sdd /dev/sde
[vagrant@zfs ~]$ sudo zpool create otus3 mirror /dev/sdf /dev/sdg
[vagrant@zfs ~]$ sudo zpool create otus4 mirror /dev/sdh /dev/sdi

[vagrant@zfs ~]$ zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
otus1   480M   100K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus2   480M   100K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus3   480M   100K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus4   480M   100K   480M        -         -     0%     0%  1.00x    ONLINE  -

[vagrant@zfs ~]$ sudo zfs set compression=lzjb otus1
[vagrant@zfs ~]$ sudo zfs set compression=lz4 otus2
[vagrant@zfs ~]$ sudo zfs set compression=gzip-9 otus3
[vagrant@zfs ~]$ sudo zfs set compression=zle otus4
[vagrant@zfs ~]$ sudo -i

[root@zfs ~]# for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done

[root@zfs ~]#  ls -l /otus*
/otus1:
total 22039
-rw-r--r--. 1 root root 40894017 Jan  2 09:19 pg2600.converter.log

/otus2:
total 17984
-rw-r--r--. 1 root root 40894017 Jan  2 09:19 pg2600.converter.log

/otus3:
total 10955
-rw-r--r--. 1 root root 40894017 Jan  2 09:19 pg2600.converter.log

/otus4:
total 39965
-rw-r--r--. 1 root root 40894017 Jan  2 09:19 pg2600.converter.log

[root@zfs ~]# zfs list
NAME    USED  AVAIL     REFER  MOUNTPOINT
otus1  21.7M   330M     21.5M  /otus1
otus2  17.8M   334M     17.6M  /otus2
otus3  10.9M   341M     10.7M  /otus3
otus4  39.2M   313M     39.1M  /otus4

[root@zfs ~]# zfs get all | grep compressratio | grep -v ref
otus1  compressratio         1.81x                  -
otus2  compressratio         2.21x                  -
otus3  compressratio         3.63x                  -
otus4  compressratio         1.00x                  -
```
## Task 2. Import ZFS pool and find pool parameters.

```
[root@zfs ~]# wget -O archive.tar.gz https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg

[root@zfs ~]# tar -xzvf archive.tar.gz
zpoolexport/
zpoolexport/filea
zpoolexport/fileb

[root@zfs ~]# zpool import -d zpoolexport/
   pool: otus
     id: 6554193320433390805
  state: ONLINE
status: Some supported features are not enabled on the pool.
 action: The pool can be imported using its name or numeric identifier, though
	some features will not be available without an explicit 'zpool upgrade'.
 config:

	otus                         ONLINE
	  mirror-0                   ONLINE
	    /root/zpoolexport/filea  ONLINE
	    /root/zpoolexport/fileb  ONLINE

root@zfs ~]# zpool import -d zpoolexport/ otus

[root@zfs ~]# zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
otus    480M  2.18M   478M        -         -     0%     0%  1.00x    ONLINE  -
otus1   480M  21.7M   458M        -         -     3%     4%  1.00x    ONLINE  -
otus2   480M  17.8M   462M        -         -     3%     3%  1.00x    ONLINE  -
otus3   480M  10.9M   469M        -         -     2%     2%  1.00x    ONLINE  -
otus4   480M  39.2M   441M        -         -     4%     8%  1.00x    ONLINE  -

[root@zfs ~]# zpool status
  pool: otus
 state: ONLINE
status: Some supported features are not enabled on the pool. The pool can
	still be used, but some features are unavailable.
action: Enable all features using 'zpool upgrade'. Once this is done,
	the pool may no longer be accessible by software that does not support
	the features. See zpool-features(5) for details.
config:

	NAME                         STATE     READ WRITE CKSUM
	otus                         ONLINE       0     0     0
	  mirror-0                   ONLINE       0     0     0
	    /root/zpoolexport/filea  ONLINE       0     0     0
	    /root/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors

  pool: otus1
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	otus1       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0

errors: No known data errors

  pool: otus2
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	otus2       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdd     ONLINE       0     0     0
	    sde     ONLINE       0     0     0

errors: No known data errors

  pool: otus3
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	otus3       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdf     ONLINE       0     0     0
	    sdg     ONLINE       0     0     0

errors: No known data errors

  pool: otus4
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	otus4       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdh     ONLINE       0     0     0
	    sdi     ONLINE       0     0     0

errors: No known data errors

[root@zfs ~]# zfs get available otus
NAME  PROPERTY   VALUE  SOURCE
otus  available  350M   -

[root@zfs ~]# zfs get type otus
NAME  PROPERTY  VALUE       SOURCE
otus  type      filesystem  -

[root@zfs ~]# zfs get recordsize otus
NAME  PROPERTY    VALUE    SOURCE
otus  recordsize  128K     local

[root@zfs ~]# zfs get compression otus
NAME  PROPERTY     VALUE           SOURCE
otus  compression  zle             local

[root@zfs ~]# zfs get checksum otus
NAME  PROPERTY  VALUE      SOURCE
otus  checksum  sha256     local
```
## Task 3. Restore ZFS snapshot and find secret message.

```
[root@zfs ~]# wget -O otus_task3.file https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG

[root@zfs ~]# zfs receive otus/test@today < otus_task3.file

[root@zfs ~]# ls /otus/
hometask2  test

[root@zfs ~]# find /otus/ -name "secret_message"
/otus/test/task1/file_mess/secret_message

[root@zfs ~]# cat /otus/test/task1/file_mess/secret_message
https://github.com/sindresorhus/awesome
```

