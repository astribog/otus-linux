
inetRouter
(192.168.255.1/30)
	|
(192.168.255.2/30)
centralRouter (192.168.225.9/30)-----------(192.168.255.10/30)inetRouter2(192.168.56.13/24)------vagrant host
(192.168.0.1/28)		 	   	
	|
(192.168.0.2/28)
(centralServer)	

```
(На centralRouter сама не включается маршрутизация, но почему-то включается после:
[vagrant@centralRouter ~]$ cat /proc/sys/net/ipv4/ip_forward
1
[vagrant@centralRouter ~]$ sudo reboot
)
```
## реализовать knocking port
### centralRouter может попасть на ssh inetrRouter через knock скрипт

Для проверки использовать:

```
[vagrant@centralRouter ~]$ ssh vagrant@192.168.255.1 -i inetRouter-private_key 

[vagrant@centralRouter ~]$ sudo hping3 192.168.255.1 --udp -c 1 -p 12345
[vagrant@centralRouter ~]$ sudo hping3 192.168.255.1 --udp -c 1 -p 23456
[vagrant@centralRouter ~]$ sudo hping3 192.168.255.1 --udp -c 1 -p 34567

[vagrant@centralRouter ~]$ ssh vagrant@192.168.255.1 -i inetRouter-private_key 
```

## добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост.
### запустить nginx на centralServer.
### пробросить 80й порт на inetRouter2 8080.
### дефолт в инет оставить через inetRouter.


Для проверки использовать:

```
user@ubuntu:~/otus-linux/otus-linux/lesson29$ curl 192.168.56.13:8080
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Welcome to CentOS</title>
  <style rel="stylesheet" type="text/css"> 
```

	