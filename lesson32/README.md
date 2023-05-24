```
                        [192.168.10.0/24]
                                |
                                |
                                |
                        (192.168.10.1)
        ({enp0s9}10.0.12.1)router1(10.0.10.1{enps08})
                    /                    \ ospf cost 1000 (step 1)
                   /                      \
                  /                        \ ospf cost 1000 (step 2)
            (10.0.12.2)                   (10.0.10.2{enps08})
            router3(10.0.11.1)---({enp0s9}10.0.11.2)router2         
            (192.168.30.1)                       (192.168.20.1)     
                    |                                   |
                    |                                   |  
                    |                                   |
            [192.168.30.0/24]                   [192.168.20.0/24]       
```
### Поднять три виртуалки.
### Pоднять OSPF между машинами на базе Quagga.
Описание шагов в playbook и в шаблонах frr. 
### Изобразить ассиметричный роутинг.
Отключаем запрет ассиметричного роутинга (playbook.yml)
Меняем стоимость интерфейса enp0s8 на router1 в шаблоне (frr.connf.router1.j2)
```
router1# sh ip route ospf
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

O   10.0.10.0/30 [110/300] via 10.0.12.2, enp0s9, weight 1, 00:00:16
O>* 10.0.11.0/30 [110/200] via 10.0.12.2, enp0s9, weight 1, 00:00:16
O   10.0.12.0/30 [110/100] is directly connected, enp0s9, weight 1, 2d23h08m
O   192.168.10.0/24 [110/100] is directly connected, enp0s10, weight 1, 2d23h08m
O>* 192.168.20.0/24 [110/300] via 10.0.12.2, enp0s9, weight 1, 00:00:16
O>* 192.168.30.0/24 [110/200] via 10.0.12.2, enp0s9, weight 1, 2d23h07m
```
```
router2# sh ip route ospf
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

O   10.0.10.0/30 [110/100] is directly connected, enp0s8, weight 1, 2d23h12m
O   10.0.11.0/30 [110/100] is directly connected, enp0s9, weight 1, 2d23h12m
O>* 10.0.12.0/30 [110/200] via 10.0.10.1, enp0s8, weight 1, 2d23h12m
  *                        via 10.0.11.1, enp0s9, weight 1, 2d23h12m
O>* 192.168.10.0/24 [110/200] via 10.0.10.1, enp0s8, weight 1, 2d23h12m
O   192.168.20.0/24 [110/100] is directly connected, enp0s10, weight 1, 2d23h12m
O>* 192.168.30.0/24 [110/200] via 10.0.11.1, enp0s9, weight 1, 2d23h12m
```
Видно, что маршрут c router1 на сеть 192.168.0.20 идет через router3, а c router2 на сеть 192.168.10.0 идет напрямую через router1.

### Cделать один из линков "дорогим", но что бы при этом роутинг был симметричным.
Увеличим стоимость маршрута router2-router1:

```
router2# conf t
router2(config)# int enp0s8
router2(config-if)# ip ospf cost 1000
```
```
router2# sh ip route ospf
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

O   10.0.10.0/30 [110/1000] is directly connected, enp0s8, weight 1, 00:00:15
O   10.0.11.0/30 [110/100] is directly connected, enp0s9, weight 1, 2d23h24m
O>* 10.0.12.0/30 [110/200] via 10.0.11.1, enp0s9, weight 1, 00:00:15
O>* 192.168.10.0/24 [110/300] via 10.0.11.1, enp0s9, weight 1, 00:00:15
O   192.168.20.0/24 [110/100] is directly connected, enp0s10, weight 1, 2d23h24m
O>* 192.168.30.0/24 [110/200] via 10.0.11.1, enp0s9, weight 1, 2d23h23m
```
Видно, что маршрут c router2 на сеть 192.168.0.10 теперь идет симметрично router3.

          
