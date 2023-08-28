#!/bin/sh
xtrabackup --backup --target-dir=/var/backups/mysql-full-$(date +"%Y_%m_%d_%I_%M_%p") --no-server-version-check
borg create -C zstd --stats borg@192.168.56.160:/var/backup/::mysql-$(date +"%Y_%m_%d_%I_%M_%p") /var/backups
