#!/bin/bash
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

password_file='/etc/rsyncd.scrt'
user='rsync_d1'
ip='192.168.56.140'
source='data1'
destination='/var/www/bets/'

rsync -a --delete-after --password-file=$password_file $user@$ip::$source $destination