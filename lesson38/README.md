Настроить стенд Vagrant с двумя виртуальными машинами: backup_server и client.
Настроить удаленный бекап каталога /etc c сервера client при помощи borgbackup. Резервные копии должны соответствовать следующим критериям:
- директория для резервных копий /var/backup. Это должна быть отдельная точка монтирования. В данном случае для демонстрации размер не принципиален, достаточно будет и 2GB;
- имя бекапа должно содержать информацию о времени снятия бекапа;
- глубина бекапа должна быть год, хранить можно по последней копии на конец месяца, кроме последних трех. Последние три месяца должны содержать копии на каждый день. Т.е. должна быть правильно настроена политика удаления старых бэкапов;
- резервная копия снимается каждые 5 минут. Такой частый запуск в целях демонстрации;
- написан скрипт для снятия резервных копий. Скрипт запускается из соответствующей Cron джобы, либо systemd timer-а - на ваше усмотрение;
- настроено логирование процесса бекапа. 

Запустите стенд на 30 минут.
Убедитесь что резервные копии снимаются.
Остановите бекап, удалите (или переместите) /etc/hosts и восстановите из бекапа.

# Run Vagrantfile and all must be working :) 

# Steps are described in playbook.yml

# Borg logs are in /var/log/borg.log (see borg.log file)

# Backup test
```
[root@client ~]# ls /etc/ | grep hosts
hosts
hosts.allow
hosts.deny

[root@client ~]# rm -f /etc/hosts

[root@client ~]# ls /etc/ | grep hosts
hosts.allow
hosts.deny

[root@client ~]# cd /

[root@client /]# borg extract borg@192.168.56.150:/var/backup::etc-2023-06-10_14:35:41 etc/hosts

[root@client /]# ls -a /etc/ | grep hosts
hosts
hosts.allow
hosts.deny
```