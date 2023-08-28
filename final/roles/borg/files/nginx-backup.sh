#!/bin/sh

borg create -C zstd --stats borg@192.168.56.160:/var/backup/::nginx-$(date +"%Y_%m_%d_%I_%M_%p") /var/www/bets/ >> /var/log/borg.log 2>&1
# Очистка старых бэкапов
borg prune --keep-hourly 10 --keep-daily 90 --keep-monthly 12 --keep-yearly 1 borg@192.168.56.150:/var/backup/
