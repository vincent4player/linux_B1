Partie 1 : Partitionnement du serveur de stockage


🌞 Partitionner le disque à l'aide de LVM

créer un physical volume (PV) :

```
[vincent@storage ~]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda           8:0    0   20G  0 disk
├─sda1        8:1    0    1G  0 part /boot
└─sda2        8:2    0   19G  0 part
  ├─rl-root 253:0    0   17G  0 lvm  /
  └─rl-swap 253:1    0    2G  0 lvm  [SWAP]
sdb           8:16   0    2G  0 disk
sdc           8:32   0    2G  0 disk
sr0          11:0    1 1024M  0 rom

[vincent@storage ~]$ sudo pvcreate /dev/sdb
[sudo] password for vincent:
  Physical volume "/dev/sdb" successfully created.

[vincent@storage ~]$ sudo pvcreate /dev/sdc
  Physical volume "/dev/sdc" successfully created.
  
[vincent@storage ~]$ sudo pvs
  PV         VG Fmt  Attr PSize  PFree
  /dev/sdb      lvm2 ---  <2.00g <2.00g
  /dev/sdc      lvm2 ---  <2.00g <2.00g
```

créer un nouveau volume group (VG)

```
[vincent@storage ~]$ sudo vgcreate storage /dev/sdb /dev/sdc
  Volume group "storage" successfully created
[vincent@storage ~]$ sudo pvs
  PV         VG      Fmt  Attr PSize PFree
  /dev/sdb   storage lvm2 a--  1.99g 1.99g
  /dev/sdc   storage lvm2 a--  1.99g 1.99g
```

créer un nouveau logical volume (LV) : ce sera la partition utilisable

```
[vincent@storage ~]$ sudo lvcreate -l 100%FREE -n lv_storage storage
  Logical volume "lv_storage" created.
  [vincent@storage ~]$ sudo vgs
  VG      #PV #LV #SN Attr   VSize VFree
  storage   2   1   0 wz--n- 3.98g    0
```


🌞 Formater la partition

```
[vincent@storage ~]$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/storage/lv_storage
  LV Name                lv_storage
  VG Name                storage
  LV UUID                OcGx41-3XX6-VseN-13Z8-TyaC-Rcny-pt74xo
  LV Write Access        read/write
  LV Creation host, time storage.tp4.linux, 2024-02-24 11:17:26 +0100
  LV Status              available
  # open                 0
  LV Size                3.98 GiB
  Current LE             1020
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2

[vincent@storage ~]$ sudo mkfs.ext4 /dev/storage/lv_storage
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 1044480 4k blocks and 261120 inodes
Filesystem UUID: ae07851c-2a44-4661-a23d-beffc19f72ee
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```


🌞 Monter la partition

```
[vincent@storage ~]$ sudo touch /storage/test_file
[vincent@storage ~]$ sudo echo "Hello, World!" | sudo tee -a /storage/test_file
Hello, World!
[vincent@storage ~]$ sudo nano /etc/fstab
[vincent@storage ~]$ sudo mount -a
[vincent@storage ~]$ df -h | grep '/storage'
/dev/mapper/storage-lv_storage  3.9G   28K  3.7G   1% /storage
```

Partie 2 : Serveur de partage de fichiers

🌞 Donnez les commandes réalisées sur le serveur NFS storage.tp4.linux

```
[vincent@storage ~]$ sudo dnf update
Rocky Linux 9 - BaseOS                                                 10 kB/s | 4.1 kB     00:00
Rocky Linux 9 - AppStream                                              14 kB/s | 4.5 kB     00:00
Rocky Linux 9 - AppStream                                             1.8 MB/s | 7.4 MB     00:04
Rocky Linux 9 - Extras                                                7.9 kB/s | 2.9 kB     00:00
Rocky Linux 9 - Extras                                                9.4 kB/s |  14 kB     00:01
Dependencies resolved.

[vincent@storage ~]$ sudo dnf install nfs-utils
Last metadata expiration check: 0:08:34 ago on Sat 24 Feb 2024 11:25:13 AM CET.
Package nfs-utils-1:2.5.4-20.el9.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!

[vincent@storage ~]$ sudo mkdir -p /storage/site_web_1
[vincent@storage ~]$ sudo mkdir -p /storage/site_web_2
[vincent@storage ~]$ sudo chown -R nobody /storage/site_web_1
[vincent@storage ~]$ sudo chown -R nobody /storage/site_web_2
[vincent@storage ~]$ sudo chmod -R 777 /storage/site_web_1
[vincent@storage ~]$ sudo chmod -R 777 /storage/site_web_2
[vincent@storage ~]$ sudo nano /etc/exports
[vincent@storage ~]$

[vincent@storage ~]$ sudo systemctl list-unit-files | grep nfs
proc-fs-nfsd.mount                         static          -
var-lib-nfs-rpc_pipefs.mount               static          -
nfs-blkmap.service                         disabled        disabled
nfs-idmapd.service                         static          -
nfs-mountd.service                         static          -
nfs-server.service                         disabled        disabled
nfs-utils.service                          static          -
nfsdcld.service                            static          -
nfs-client.target                          enabled         disabled
[vincent@storage ~]$ cat /etc/exports
/storage/site_web_1   10.7.1.10(rw,sync,no_subtree_check)
/storage/site_web_2   10.7.1.10(rw,sync,no_subtree_check)

[vincent@storage ~]$ sudo systemctl start nfs-utils
[vincent@storage ~]$ sudo systemctl status nfs-utils
● nfs-utils.service - NFS server and client services
     Loaded: loaded (/usr/lib/systemd/system/nfs-utils.service; static)
     Active: active (exited) since Sat 2024-02-24 11:49:43 CET; 14s ago
    Process: 42850 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 42850 (code=exited, status=0/SUCCESS)
        CPU: 3ms

Feb 24 11:49:43 storage.tp4.linux systemd[1]: Starting NFS server and client services...
Feb 24 11:49:43 storage.tp4.linux systemd[1]: Finished NFS server and client services.
```
```
[vincent@storage ~]$ cat /etc/exports
/storage/site_web_1   10.7.1.10(rw,sync,no_subtree_check)
/storage/site_web_2   10.7.1.10(rw,sync,no_subtree_check)
```

🌞 Donnez les commandes réalisées sur le client NFS web.tp4.linux

```
[vincent@web ~]$ sudo systemctl status nfs-utils
○ nfs-utils.service - NFS server and client services
     Loaded: loaded (/usr/lib/systemd/system/nfs-utils.service; static)
     Active: inactive (dead)
[vincent@web ~]$ sudo systemctl restart nfs-utils
[vincent@web ~]$ sudo systemctl status nfs-utils
● nfs-utils.service - NFS server and client services
     Loaded: loaded (/usr/lib/systemd/system/nfs-utils.service; static)
     Active: active (exited) since Sat 2024-02-24 11:48:58 CET; 2s ago
    Process: 11254 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 11254 (code=exited, status=0/SUCCESS)
        CPU: 3ms

Feb 24 11:48:58 web.tp4.linux systemd[1]: Starting NFS server and client services...
Feb 24 11:48:58 web.tp4.linux systemd[1]: Finished NFS server and client services.
(s'occuper des firewall)
[vincent@web ~]$ sudo mount -a
[vincent@web ~]$ df -h | grep '/var/www'
10.7.1.11:/storage/site_web_1  3.9G  128K  3.7G   1% /var/www/site_web_1
10.7.1.11:/storage/site_web_2  3.9G  128K  3.7G   1% /var/www/site_web_2
```
```
[vincent@web ~]$ cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Mon Oct 23 09:14:19 2023
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=1524dc96-9905-467a-a102-ac5a459bb138 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0
10.7.1.11:/storage/site_web_1  /var/www/site_web_1  nfs  defaults  0  0
10.7.1.11:/storage/site_web_2  /var/www/site_web_2  nfs  defaults  0  0
```


2. Install
🖥️ VM web.tp4.linux
🌞 Installez NGINX

```
[vincent@web ~]$ sudo dnf install nginx
[sudo] password for vincent:
Last metadata expiration check: 0:23:34 ago on Sat 24 Feb 2024 11:48:21 AM CET.
Dependencies resolved.
```
```
[vincent@web ~]$ sudo systemctl start nginx
[vincent@web ~]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Sat 2024-02-24 12:13:00 CET; 4s ago
    Process: 11636 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 11637 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 11638 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 11639 (nginx)
      Tasks: 2 (limit: 5896)
     Memory: 1.9M
        CPU: 19ms
     CGroup: /system.slice/nginx.service
             ├─11639 "nginx: master process /usr/sbin/nginx"
             └─11640 "nginx: worker process"

Feb 24 12:13:00 web.tp4.linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 24 12:13:00 web.tp4.linux nginx[11637]: nginx: the configuration file /etc/nginx/nginx.conf synta>
Feb 24 12:13:00 web.tp4.linux nginx[11637]: nginx: configuration file /etc/nginx/nginx.conf test is s>
Feb 24 12:13:00 web.tp4.linux systemd[1]: Started The nginx HTTP and reverse proxy server.
lines 1-18/18 (END)
```

🌞 Analysez le service NGINX

```
[vincent@web ~]$ ps -aux | grep nginx
root       11639  0.0  0.0  10116   952 ?        Ss   12:13   0:00 nginx: master process /usr/sbin/nginx
nginx      11640  0.0  0.5  13884  5024 ?        S    12:13   0:00 nginx: worker process
vincent    11646  0.0  0.2   6412  2172 pts/0    S+   12:14   0:00 grep --color=auto nginx
```
```
[vincent@web ~]$ ss -tuln | grep nginx
[vincent@web ~]$ sudo nano /etc/nginx/nginx.conf
 server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;
```
```
[vincent@web ~]$ grep -i 'root' /etc/nginx/nginx.conf
        root         /usr/share/nginx/html;
#        root         /usr/share/nginx/html;
```
```
[vincent@web ~]$ ls -l /usr/share/nginx/html
total 12
-rw-r--r--. 1 root root 3332 Oct 16 19:58 404.html
-rw-r--r--. 1 root root 3404 Oct 16 19:58 50x.html
drwxr-xr-x. 2 root root   27 Feb 24 12:11 icons
lrwxrwxrwx. 1 root root   25 Oct 16 20:00 index.html -> ../../testpage/index.html
-rw-r--r--. 1 root root  368 Oct 16 19:58 nginx-logo.png
lrwxrwxrwx. 1 root root   14 Oct 16 20:00 poweredby.png -> nginx-logo.png
lrwxrwxrwx. 1 root root   37 Oct 16 20:00 system_noindex_logo.png -> ../../pixmaps/system-noindex-logo.png
```

4. Visite du service web
Et ça serait bien d'accéder au service non ? Genre c'est un serveur web. On veut voir un site web !
🌞 Configurez le firewall pour autoriser le trafic vers le service NGINX

```
[vincent@web ~]$ sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
success
[vincent@web ~]$ sudo firewall-cmd --reload
success
[vincent@web ~]$
```

🌞 Accéder au site web

```
[vincent@web ~]$ curl http://10.7.1.10
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
        height: 100%;
        width: 100%;
      }
        body {
  background: rgb(20,72,50);
  background: -moz-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%)  ;
  background: -webkit-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%) ;
  background: linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%);
  background-repeat: no-repeat;
  background-attachment: fixed;
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#3c6eb4",endColorstr="#3c95b4",GradientType=1);
        color: white;
        font-size: 0.9em;
        font-weight: 400;
        font-family: 'Montserrat', sans-serif;
        margin: 0;
        padding: 10em 6em 10em 6em;
        box-sizing: border-box;
```

🌞 Vérifier les logs d'accès

```
[vincent@web ~]$ ls /var/log/nginx/access.log
/var/log/nginx/access.log
[vincent@web ~]$ tail -n 3 /var/log/nginx/access.log
10.7.1.1 - - [24/Feb/2024:12:25:31 +0100] "GET /poweredby.png HTTP/1.1" 200 368 "http://10.7.1.10/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.7.1.1 - - [24/Feb/2024:12:25:31 +0100] "GET /favicon.ico HTTP/1.1" 404 3332 "http://10.7.1.10/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.7.1.10 - - [24/Feb/2024:12:25:54 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
[vincent@web ~]$
```

5. Modif de la conf du serveur web
🌞 Changer le port d'écoute

```
[vincent@web ~]$ sudo nano /etc/nginx/nginx.conf
server {
        listen       8080;
        listen       [::]:8080;
        server_name  _;
        root         /usr/share/nginx/html;
```
```
[vincent@web ~]$ sudo systemctl restart nginx
[vincent@web ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Sat 2024-02-24 12:30:07 CET; 4s ago
    Process: 11756 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 11757 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 11758 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 11759 (nginx)
      Tasks: 2 (limit: 5896)
     Memory: 1.9M
        CPU: 23ms
     CGroup: /system.slice/nginx.service
             ├─11759 "nginx: master process /usr/sbin/nginx"
             └─11760 "nginx: worker process"

Feb 24 12:30:07 web.tp4.linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 24 12:30:07 web.tp4.linux nginx[11757]: nginx: the configuration file /etc/nginx/nginx.conf synta>
Feb 24 12:30:07 web.tp4.linux nginx[11757]: nginx: configuration file /etc/nginx/nginx.conf test is s>
Feb 24 12:30:07 web.tp4.linux systemd[1]: Started The nginx HTTP and reverse proxy server.
lines 1-18/18 (END)
^C
[vincent@web ~]$ sudo ss -tuln | grep nginx
[vincent@web ~]$ sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
success
[vincent@web ~]$ sudo firewall-cmd --zone=public --remove-port=80/tcp --permanent
success
[vincent@web ~]$ sudo firewall-cmd --reload
success
[vincent@web ~]$ curl http://10.7.1.10:8080
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
        height: 100%;
        width: 100%;
      }
```

🌞 Changer l'utilisateur qui lance le service

```
[vincent@web ~]$ sudo useradd -m -d /home/web -s /bin/bash web
[vincent@web ~]$ sudo passwd web
Changing password for user web.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
passwd: all authentication tokens updated successfully.
[vincent@web ~]$ sudo nano /etc/nginx/nginx.conf
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user web;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
[vincent@web ~]$ sudo systemctl restart nginx
[vincent@web ~]$ ps -aux | grep nginx
root       11815  0.0  0.0  10116   952 ?        Ss   12:34   0:00 nginx: master process /usr/sbin/nginx
web        11816  0.0  0.4  13884  4852 ?        S    12:34   0:00 nginx: worker process
vincent    11818  0.0  0.2   6412  2312 pts/0    S+   12:35   0:00 grep --color=auto nginx
```
🌞 Changer l'emplacement de la racine Web

```
[vincent@web ~]$ sudo nano /var/www/site_web_1/index.html
[vincent@web ~]$ sudo nano /etc/nginx/nginx.conf
 server {
        listen       8080;
        listen       [::]:8080;
        server_name  _;
        root         /var/www/site_web_1;
[vincent@web ~]$ sudo systemctl restart nginx
[vincent@web ~]$ sudo systemctl status nginx.service
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Sat 2024-02-24 12:40:54 CET; 5s ago
[vincent@web ~]$ sudo systemctl restart nginx
[vincent@web ~]$ curl http://10.7.1.10:8080/index.html
tp4.linux: terminé le samedi 24/02
```
🌞 Repérez dans le fichier de conf

```
[vincent@web ~]$ grep -i 'include' /etc/nginx/nginx.conf
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
```

🌞 Créez le fichier de configuration pour le premier site

```
[vincent@web ~]$ sudo nano /etc/nginx/conf.d/site_web_1.conf
[vincent@web ~]$ cat /etc/nginx/conf.d/site_web_1.conf
server {
    listen       8080;
    listen       [::]:8080;
    server_name  _;
    root         /var/www/site_web_1;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    error_page 404 /404.html;
    location = /404.html {
    }
}
[vincent@web ~]$ sudo systemctl restart nginx
[vincent@web ~]$
```

🌞 Créez le fichier de configuration pour le deuxième site

```
[vincent@web ~]$ sudo nano /etc/nginx/conf.d/site_web_2.conf
[vincent@web ~]$ cat /etc/nginx/conf.d/site_web_2.conf
server {
    listen       8888;
    listen       [::]:8888;
    server_name  _;
    root         /var/www/site_web_2;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    error_page 404 /404.html;
    location = /404.html {
    }
}
[vincent@web ~]$ sudo firewall-cmd --zone=public --add-port=8888/tcp --permanent
success
[vincent@web ~]$ sudo firewall-cmd --reload
success
[vincent@web ~]$ sudo systemctl restart nginx
[vincent@web ~]$ ss -tuln | grep 8888
tcp   LISTEN 0      511          0.0.0.0:8888      0.0.0.0:*
tcp   LISTEN 0      511             [::]:8888         [::]:*
```

🌞 Prouvez que les deux sites sont disponibles

```
[vincent@web ~]$ curl http://10.7.1.10:8080/index.html
tp4.linux: terminé le samedi 24/02
[vincent@web ~]$ curl http://10.7.1.10:8888/index.html
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.20.1</center>
</body>
</html>
```