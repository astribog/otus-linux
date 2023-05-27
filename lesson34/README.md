```
1. Между двумя виртуалками поднять vpn в режимах:
- tun
- tap
Описать в чём разница, замерить скорость между виртуальными
машинами в туннелях, сделать вывод об отличающихся показателях
скорости.
```
# Use playbook1.yml
# See there task names - descriptions
# iperf tap
```
[vagrant@client ~]$ iperf3 -c 10.10.10.1 -t 40 -i 5
Connecting to host 10.10.10.1, port 5201
[  4] local 10.10.10.2 port 54788 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-5.01   sec  12.0 MBytes  20.2 Mbits/sec    0    473 KBytes       
[  4]   5.01-10.00  sec  12.0 MBytes  20.1 Mbits/sec    0    952 KBytes       
[  4]  10.00-15.00  sec  12.2 MBytes  20.5 Mbits/sec   45    934 KBytes       
[  4]  15.00-20.01  sec  11.2 MBytes  18.7 Mbits/sec    0   1.25 MBytes       
[  4]  20.01-25.01  sec  11.2 MBytes  18.7 Mbits/sec   11   1.04 MBytes       
[  4]  25.01-30.00  sec  12.3 MBytes  20.7 Mbits/sec    0   1.07 MBytes       
[  4]  30.00-35.00  sec  11.1 MBytes  18.7 Mbits/sec    0   1.18 MBytes       
[  4]  35.00-40.00  sec  11.2 MBytes  18.7 Mbits/sec   37   1.10 MBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-40.00  sec  93.2 MBytes  19.5 Mbits/sec   93             sender
[  4]   0.00-40.00  sec  92.1 MBytes  19.3 Mbits/sec                  receiver

iperf Done.
```

# iperf tun
```
[vagrant@client ~]$ iperf3 -c 10.10.10.1 -t 40 -i 5
Connecting to host 10.10.10.1, port 5201
[  4] local 10.10.10.2 port 54792 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-5.00   sec  11.8 MBytes  19.7 Mbits/sec    0    466 KBytes       
[  4]   5.00-10.01  sec  12.3 MBytes  20.6 Mbits/sec   15    592 KBytes       
[  4]  10.01-15.01  sec  13.1 MBytes  21.9 Mbits/sec   17    387 KBytes       
[  4]  15.01-20.00  sec  12.3 MBytes  20.6 Mbits/sec    0    427 KBytes       
[  4]  20.00-25.00  sec  13.0 MBytes  21.8 Mbits/sec    0    523 KBytes       
[  4]  25.00-30.00  sec  11.4 MBytes  19.1 Mbits/sec   17    596 KBytes       
[  4]  30.00-35.00  sec  12.4 MBytes  20.9 Mbits/sec    5    534 KBytes       
[  4]  35.00-40.00  sec  12.1 MBytes  20.4 Mbits/sec    0    555 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-40.00  sec  98.4 MBytes  20.6 Mbits/sec   54             sender
[  4]   0.00-40.00  sec  96.9 MBytes  20.3 Mbits/sec                  receiver

iperf Done.
```
# TUN is slightly faster, BUT:

TAP is basically at Ethernet level (layer 2) and acts like a switch where as TUN works at network level (layer 3) and routes packets on the VPN. TAP is bridging whereas TUN is routing.

From the OpenVPN Wiki:

TAP benefits:

behaves like a real network adapter (except it is a virtual network adapter)
can transport any network protocols (IPv4, IPv6, Netalk, IPX, etc, etc)
Works in layer 2, meaning Ethernet frames are passed over the VPN tunnel
Can be used in bridges
TAP drawbacks:

causes much more broadcast overhead on the VPN tunnel
adds the overhead of Ethernet headers on all packets transported over the VPN tunnel
scales poorly
TUN benefits:

A lower traffic overhead, transports only traffic which is destined for the VPN client
Transports only layer 3 IP packets
TUN drawbacks:

Broadcast traffic is not normally transported
Can only transport IPv4 (OpenVPN 2.3 adds IPv6)
Cannot be used in bridges

```
2. Поднять RAS на базе OpenVPN с клиентскими сертификатами
```

# Use playbook2.yml
# See there task names - descriptions

On `client` VM  use "sudo openvpn --config client.conf"

```
[vagrant@client ~]$ sudo openvpn --config client.conf                     192.168.56.
Sat May 27 15:03:04 2023 OpenVPN 2.4.12 x86_64-redhat-linux-gnu [Fedora EPEL patched] [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Mar 17 2022
Sat May 27 15:03:04 2023 library versions: OpenSSL 1.0.2k-fips  26 Jan 2017, LZO 2.06
Sat May 27 15:03:04 2023 TCP/UDP: Preserving recently used remote address: [AF_INET]192.168.56.10:1207
Sat May 27 15:03:04 2023 Socket Buffers: R=[212992->212992] S=[212992->212992]
Sat May 27 15:03:04 2023 UDP link local (bound): [AF_INET][undef]:1194
Sat May 27 15:03:04 2023 UDP link remote: [AF_INET]192.168.56.10:1207
Sat May 27 15:03:04 2023 TLS: Initial packet from [AF_INET]192.168.56.10:1207, sid=323f987c 350ceaab
Sat May 27 15:03:04 2023 VERIFY OK: depth=1, CN=rasvpn
Sat May 27 15:03:04 2023 VERIFY KU OK
Sat May 27 15:03:04 2023 Validating certificate extended key usage
Sat May 27 15:03:04 2023 ++ Certificate has EKU (str) TLS Web Server Authentication, expects TLS Web Server Authentication
Sat May 27 15:03:04 2023 VERIFY EKU OK
Sat May 27 15:03:04 2023 VERIFY OK: depth=0, CN=rasvpn
...
```