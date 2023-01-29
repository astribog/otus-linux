yum -y install nfs-utils
systemctl enable firewalld --now
echo "192.168.50.10:/srv/share/ /mnt nfs nfsvers=3,proto=udp 0 0" >> /etc/fstab
