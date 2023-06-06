## завести в зоне dns.lab имена:

  ### web1 - смотрит на клиент1
  ### web2 - смотрит на клиент2

## завести еще одну зону newdns.lab
  ### завести в ней запись
  ### www - смотрит на обоих клиентов


# TESTING:

### web1 сервер в зоне dns.lab резолвится:

```
[vagrant@client ~]$ dig @192.168.50.11 web1.dns.lab

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el7_9.13 <<>> @192.168.50.11 web1.dns.lab
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 47044
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;web1.dns.lab.                  IN      A

;; ANSWER SECTION:
web1.dns.lab.           3600    IN      A       192.168.50.15

;; AUTHORITY SECTION:
dns.lab.                3600    IN      NS      ns02.dns.lab.
dns.lab.                3600    IN      NS      ns01.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.           3600    IN      A       192.168.50.10
ns02.dns.lab.           3600    IN      A       192.168.50.11

;; Query time: 3 msec
;; SERVER: 192.168.50.11#53(192.168.50.11)
;; WHEN: Tue Jun 06 13:17:04 UTC 2023
;; MSG SIZE  rcvd: 127
```

## Оба www сервера в зоне newdns.lab резолвятся:

```
[vagrant@client ~]$ dig @192.168.50.11 www.newdns.lab

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el7_9.13 <<>> @192.168.50.11 www.newdns.lab
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 32823
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 2, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.newdns.lab.                        IN      A

;; ANSWER SECTION:
www.newdns.lab.         3600    IN      A       192.168.50.16
www.newdns.lab.         3600    IN      A       192.168.50.15

;; AUTHORITY SECTION:
newdns.lab.             3600    IN      NS      ns01.dns.lab.
newdns.lab.             3600    IN      NS      ns02.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.           3600    IN      A       192.168.50.10
ns02.dns.lab.           3600    IN      A       192.168.50.11

;; Query time: 9 msec
;; SERVER: 192.168.50.11#53(192.168.50.11)
;; WHEN: Tue Jun 06 13:13:59 UTC 2023
;; MSG SIZE  rcvd: 149
```
## настроить split-dns
### клиент1 - видит обе зоны, но в зоне dns.lab только web1

```
[vagrant@client ~]$ ping www.newdns.lab -c 1
PING www.newdns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from client (192.168.50.15): icmp_seq=1 ttl=64 time=0.015 ms

--- www.newdns.lab ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.015/0.015/0.015/0.000 ms

[vagrant@client ~]$ ping web1.dns.lab -c 1
PING web1.dns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from client (192.168.50.15): icmp_seq=1 ttl=64 time=0.020 ms

--- web1.dns.lab ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.020/0.020/0.020/0.000 ms

[vagrant@client ~]$ ping web2.dns.lab -c 1
ping: web2.dns.lab: Name or service not known
```

## настроить split-dns
### клиент2 видит только dns.lab

```
[vagrant@client2 ~]$ ping www.newdns.lab -c 1
ping: www.newdns.lab: Name or service not known

[vagrant@client2 ~]$ ping web1.dns.lab -c 1
PING web1.dns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=1 ttl=64 time=1.14 ms

--- web1.dns.lab ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 1.148/1.148/1.148/0.000 ms

[vagrant@client2 ~]$ ping web2.dns.lab -c 1
PING web2.dns.lab (192.168.50.16) 56(84) bytes of data.
64 bytes from client2 (192.168.50.16): icmp_seq=1 ttl=64 time=0.053 ms

--- web2.dns.lab ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.053/0.053/0.053/0.000 ms
```