Linux core homework

[vagrant@kernel-update ~]$ uname -r
4.18.0-277.el8.x86_64
[vagrant@kernel-update ~]$ yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm 
Failed to set locale, defaulting to C.UTF-8
Error: This command has to be run with superuser privileges (under the root user on most systems).
[vagrant@kernel-update ~]$ sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm 
Failed to set locale, defaulting to C.UTF-8
Last metadata expiration check: 1:12:40 ago on Wed Jan 11 15:57:47 2023.
elrepo-release-8.el8.elrepo.noarch.rpm           12 kB/s |  13 kB     00:01    
Dependencies resolved.
================================================================================
 Package             Arch        Version                Repository         Size
================================================================================
Installing:
 elrepo-release      noarch      8.3-1.el8.elrepo       @commandline       13 k

Transaction Summary
================================================================================
Install  1 Package

Total size: 13 k
Installed size: 5.0 k
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                        1/1 
  Installing       : elrepo-release-8.3-1.el8.elrepo.noarch                 1/1 
  Verifying        : elrepo-release-8.3-1.el8.elrepo.noarch                 1/1 

Installed:
  elrepo-release-8.3-1.el8.elrepo.noarch                                        

Complete!
[vagrant@kernel-update ~]$ sudo yum --enablerepo elrepo-kernel install kernel-ml -y
Failed to set locale, defaulting to C.UTF-8
ELRepo.org Community Enterprise Linux Repositor 232 kB/s | 239 kB     00:01    
ELRepo.org Community Enterprise Linux Kernel Re 1.1 MB/s | 2.1 MB     00:01    
Dependencies resolved.
================================================================================
 Package              Arch      Version                  Repository        Size
================================================================================
Installing:
 kernel-ml            x86_64    6.1.4-1.el8.elrepo       elrepo-kernel     98 k
Installing dependencies:
 kernel-ml-core       x86_64    6.1.4-1.el8.elrepo       elrepo-kernel     34 M
 kernel-ml-modules    x86_64    6.1.4-1.el8.elrepo       elrepo-kernel     30 M

Transaction Summary
================================================================================
Install  3 Packages

Total download size: 64 M
Installed size: 100 M
Downloading Packages:
(1/3): kernel-ml-6.1.4-1.el8.elrepo.x86_64.rpm  279 kB/s |  98 kB     00:00    
(2/3): kernel-ml-core-6.1.4-1.el8.elrepo.x86_64 6.5 MB/s |  34 MB     00:05    
(3/3): kernel-ml-modules-6.1.4-1.el8.elrepo.x86 3.8 MB/s |  30 MB     00:07    
--------------------------------------------------------------------------------
Total                                           7.9 MB/s |  64 MB     00:08     
warning: /var/cache/dnf/elrepo-kernel-e80375c2d5802dd1/packages/kernel-ml-6.1.4-1.el8.elrepo.x86_64.rpm: Header V4 DSA/SHA256 Signature, key ID baadae52: NOKEY
ELRepo.org Community Enterprise Linux Kernel Re 1.2 MB/s | 1.7 kB     00:00    
Importing GPG key 0xBAADAE52:
 Userid     : "elrepo.org (RPM Signing Key for elrepo.org) <secure@elrepo.org>"
 Fingerprint: 96C0 104F 6315 4731 1E0B B1AE 309B C305 BAAD AE52
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org
Key imported successfully
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                        1/1 
  Installing       : kernel-ml-core-6.1.4-1.el8.elrepo.x86_64               1/3 
  Running scriptlet: kernel-ml-core-6.1.4-1.el8.elrepo.x86_64               1/3 
  Installing       : kernel-ml-modules-6.1.4-1.el8.elrepo.x86_64            2/3 
  Running scriptlet: kernel-ml-modules-6.1.4-1.el8.elrepo.x86_64            2/3 
  Installing       : kernel-ml-6.1.4-1.el8.elrepo.x86_64                    3/3 
  Running scriptlet: kernel-ml-core-6.1.4-1.el8.elrepo.x86_64               3/3 
  Running scriptlet: kernel-ml-6.1.4-1.el8.elrepo.x86_64                    3/3 
  Verifying        : kernel-ml-6.1.4-1.el8.elrepo.x86_64                    1/3 
  Verifying        : kernel-ml-core-6.1.4-1.el8.elrepo.x86_64               2/3 
  Verifying        : kernel-ml-modules-6.1.4-1.el8.elrepo.x86_64            3/3 

Installed:
  kernel-ml-6.1.4-1.el8.elrepo.x86_64                                           
  kernel-ml-core-6.1.4-1.el8.elrepo.x86_64                                      
  kernel-ml-modules-6.1.4-1.el8.elrepo.x86_64                                   

Complete!
[vagrant@kernel-update ~]$ sudo reboot
Connection to 127.0.0.1 closed by remote host.
user@ubuntu:~$ vagrant ssh
Last login: Wed Jan 11 17:09:06 2023 from 10.0.2.2
[vagrant@kernel-update ~]$ uname -r
6.1.4-1.el8.elrepo.x86_64
