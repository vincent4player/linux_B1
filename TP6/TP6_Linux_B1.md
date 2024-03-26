1. Installation


🌞 Installer le serveur Apache
```
[vincent@web ~]$ sudo dnf install httpd
[sudo] password for vincent:
Rocky Linux 9 - BaseOS                                                8.6 kB/s | 4.1 kB     00:00
Rocky Linux 9 - BaseOS                                                3.2 MB/s | 2.2 MB     00:00
Rocky Linux 9 - AppStream                                              11 kB/s | 4.5 kB     00:00
Rocky Linux 9 - AppStream                                             7.7 MB/s | 7.4 MB     00:00
Rocky Linux 9 - Extras                                                7.6 kB/s | 2.9 kB     00:00
Rocky Linux 9 - Extras                                                 23 kB/s |  14 kB     00:00
Dependencies resolved.
======================================================================================================
 Package                      Architecture      Version                    Repository            Size
======================================================================================================
Installing:
 httpd                        x86_64            2.4.57-5.el9               appstream             46 k
```
```
 [vincent@web ~]$ sudo nano /etc/httpd/conf/httpd.conf
[vincent@web ~]$ sudo sed -i '/#/d' /etc/httpd/conf/httpd.conf
[vincent@web ~]$ sudo nano /etc/httpd/conf/httpd.conf
 ```

🌞 Démarrer le service Apache

```
[vincent@web ~]$ sudo systemctl start httpd.service
[vincent@web ~]$ sudo systemctl enable httpd.service
[vincent@web ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
     Active: active (running) since Wed 2024-03-20 14:16:00 CET; 2min 33s ago
       Docs: man:httpd.service(8)
   Main PID: 1515 (httpd)
     Status: "Total requests: 0; Idle/Busy workers 100/0;Requests/sec: 0; Bytes served/sec:   0 B/sec"
      Tasks: 213 (limit: 5896)
     Memory: 29.0M
        CPU: 152ms
     CGroup: /system.slice/httpd.service
             ├─1515 /usr/sbin/httpd -DFOREGROUND
             ├─1516 /usr/sbin/httpd -DFOREGROUND
             ├─1517 /usr/sbin/httpd -DFOREGROUND
             ├─1518 /usr/sbin/httpd -DFOREGROUND
             └─1519 /usr/sbin/httpd -DFOREGROUND

Mar 20 14:16:00 web.tp6.linux systemd[1]: Starting The Apache HTTP Server...
Mar 20 14:16:00 web.tp6.linux systemd[1]: Started The Apache HTTP Server.
Mar 20 14:16:00 web.tp6.linux httpd[1515]: Server configured, listening on: port 80
[vincent@web ~]$
```
```
[vincent@web ~]$ ss -tuln
Netid    State     Recv-Q    Send-Q        Local Address:Port         Peer Address:Port    Process
udp      UNCONN    0         0                 127.0.0.1:323               0.0.0.0:*
udp      UNCONN    0         0                     [::1]:323                  [::]:*
tcp      LISTEN    0         128                 0.0.0.0:22                0.0.0.0:*
tcp      LISTEN    0         511                       🌞*:80 🌞                     *:*
tcp      LISTEN    0         128                    [::]:22                   [::]:*
[vincent@web ~]$
```
```
[vincent@web ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
     Active: active (running) since Wed 2024-03-20 14:16:00 CET; 6min ago
       Docs: man:httpd.service(8)
   Main PID: 1515 (httpd)
     Status: "Total requests: 0; Idle/Busy workers 100/0;Requests/sec: 0; Bytes served/sec:   0 B/sec"
      Tasks: 213 (limit: 5896)
     Memory: 29.0M
        CPU: 253ms
     CGroup: /system.slice/httpd.service
             ├─1515 /usr/sbin/httpd -DFOREGROUND
             ├─1516 /usr/sbin/httpd -DFOREGROUND
             ├─1517 /usr/sbin/httpd -DFOREGROUND
             ├─1518 /usr/sbin/httpd -DFOREGROUND
             └─1519 /usr/sbin/httpd -DFOREGROUND

Mar 20 14:16:00 web.tp6.linux systemd[1]: Starting The Apache HTTP Server...
Mar 20 14:16:00 web.tp6.linux systemd[1]: Started The Apache HTTP Server.
Mar 20 14:16:00 web.tp6.linux httpd[1515]: Server configured, listening on: port 80
[vincent@web ~]$ sudo systemctl is-enabled httpd
enabled
[vincent@web ~]$ curl localhost
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
```
[vincent@web ~]$ curl http://10.6.1.11/
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

🌞 Le service Apache...

```
[vincent@web ~]$ cat /usr/lib/systemd/system/httpd.service
# See httpd.service(8) for more information on using the httpd service.

# Modifying this file in-place is not recommended, because changes
# will be overwritten during package upgrades.  To customize the
# behaviour, run "systemctl edit httpd" to create an override unit.

# For example, to pass additional options (such as -D definitions) to
# the httpd binary at startup, create an override unit (as is done by
# systemctl edit) and enter the following:

#       [Service]
#       Environment=OPTIONS=-DMY_DEFINE

[Unit]
Description=The Apache HTTP Server
Wants=httpd-init.service
After=network.target remote-fs.target nss-lookup.target httpd-init.service
Documentation=man:httpd.service(8)

[Service]
Type=notify
Environment=LANG=C

ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
# Send SIGWINCH for graceful stop
KillSignal=SIGWINCH
KillMode=mixed
PrivateTmp=true
OOMPolicy=continue

[Install]
WantedBy=multi-user.target
```

🌞 Déterminer sous quel utilisateur tourne le processus Apache

```
[vincent@web ~]$ grep "^User" /etc/httpd/conf/httpd.conf
User apache
```
```
[vincent@web ~]$ ps -ef | grep httpd
root        1515       1  0 14:15 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1516    1515  0 14:16 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1517    1515  0 14:16 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1518    1515  0 14:16 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1519    1515  0 14:16 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
vincent     1845    1459  0 14:33 pts/0    00:00:00 grep --color=auto httpd
[vincent@web ~]$
```
```
[vincent@web ~]$ ls -al /usr/share/testpage/
total 12
drwxr-xr-x.  2 root root   24 Mar 20 14:05 .
drwxr-xr-x. 83 root root 4096 Mar 20 14:05 ..
-rw-r--r--.  1 root root 7620 Feb 21 14:12 index.html
[vincent@web ~]$
```
🌞 Changer l'utilisateur utilisé par Apache
```
[vincent@web ~]$ grep apache /etc/passwd
apache:x:48:48:Apache:/usr/share/httpd:/sbin/nologin
[vincent@web ~]$
```
```
[vincent@web ~]$ sudo useradd -r -d /usr/share/httpd -s /sbin/nologin nouvelutilisateur
[sudo] password for vincent:
[vincent@web ~]$
```
```
[vincent@web ~]$ sudo nano /etc/httpd/conf/httpd.conf
[vincent@web ~]$ grep "^User" /etc/httpd/conf/httpd.conf
User nouvelutilisateur
[vincent@web ~]$
```
```
[vincent@web ~]$ sudo systemctl restart httpd.service
[vincent@web ~]$ ps -ef | grep httpd
root        1872       1  0 14:39 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
nouvelu+    1873    1872  0 14:39 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
nouvelu+    1874    1872  0 14:39 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
nouvelu+    1875    1872  0 14:39 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
nouvelu+    1876    1872  0 14:39 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
vincent     2089    1459  0 14:39 pts/0    00:00:00 grep --color=auto httpd
[vincent@web ~]$
```

🌞 Faites en sorte que Apache tourne sur un autre port
```
[vincent@web ~]$ sudo nano /etc/httpd/conf/httpd.conf
[vincent@web ~]$ grep "^Listen" /etc/httpd/conf/httpd.conf
Listen 8080
[vincent@web ~]$
```
```
[vincent@web ~]$ sudo firewall-cmd --permanent --add-port=8080/tcp
success
[vincent@web ~]$ sudo firewall-cmd --permanent --remove-service=http
success
[vincent@web ~]$ sudo firewall-cmd --reload
success
[vincent@web ~]$
```
```
[vincent@web ~]$ sudo systemctl restart httpd.service
[vincent@web ~]$ ss -tuln | grep 8080
tcp   LISTEN 0      511                *:8080            *:*
[vincent@web ~]$ curl http://localhost:8080
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

Partie 2 : Mise en place et maîtrise du serveur de base de données

🌞 Install de MariaDB sur db.tp6.linux

```
[vincent@db ~]$ sudo dnf update
[vincent@db ~]$ sudo dnf install mariadb-server
[vincent@db ~]$ sudo systemctl start mariadb
[vincent@db ~]$ sudo systemctl enable mariadb
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.
[vincent@db ~]$ sudo mysql_secure_installation
[vincent@db ~]$ mysql -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 16
Server version: 10.5.22-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
```

🌞 Port utilisé par MariaDB

```
[vincent@db ~]$ ss -tuln
Netid    State     Recv-Q    Send-Q        Local Address:Port         Peer Address:Port    Process
udp      UNCONN    0         0                 127.0.0.1:323               0.0.0.0:*
udp      UNCONN    0         0                     [::1]:323                  [::]:*
tcp      LISTEN    0         128                 0.0.0.0:22                0.0.0.0:*
tcp      LISTEN    0         128                    [::]:22                   [::]:*
tcp      LISTEN    0         80                        *:3306                    *:*
[vincent@db ~]$ ss -tuln | grep 3306
tcp   LISTEN 0      80                 *:3306            *:*
[vincent@db ~]$ sudo firewall-cmd --permanent --add-port=3306/tcp
success
[vincent@db ~]$ sudo firewall-cmd --reload
success
[vincent@db ~]$
```

🌞 Processus liés à MariaDB

```
[vincent@db ~]$ ps aux | grep mariadb
mysql      44950  0.0  9.5 1085320 93908 ?       Ssl  15:00   0:00 /usr/libexec/mariadbd --basedir=/usr
vincent    45107  0.0  0.2   6408  2264 pts/0    S+   15:08   0:00 grep --color=auto mariadb
[vincent@db ~]$
```
```
[vincent@db ~]$ ps aux | grep mysqld
vincent    45109  0.0  0.2   6408  2324 pts/0    S+   15:09   0:00 grep --color=auto mysqld
[vincent@db ~]$
```


Partie 3 : Configuration et mise en place de NextCloud

```
🌞 Préparation de la base pour NextCloud
[vincent@db ~]$ sudo mysql -u root -p
[sudo] password for vincent:
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 17
Server version: 10.5.22-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> CREATE USER 'nextcloud'@'10.6.1.11' IDENTIFIED BY 'pewpewpew';
Query OK, 0 rows affected (0.351 sec)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.6.1.11';
Query OK, 0 rows affected (0.099 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.000 sec)

MariaDB [(none)]>
```

🌞 Exploration de la base de données

```
[vincent@web ~]$ mysql --version
mysql  Ver 8.0.36 for Linux on x86_64 (Source distribution)
[vincent@web ~]$ sudo dnf provides mysql
Last metadata expiration check: 1:28:16 ago on Wed 20 Mar 2024 02:18:18 PM CET.
mysql-8.0.36-1.el9_3.x86_64 : MySQL client programs and shared libraries
Repo        : @System
Matched from:
Provide    : mysql = 8.0.36-1.el9_3

mysql-8.0.36-1.el9_3.x86_64 : MySQL client programs and shared libraries
Repo        : appstream
Matched from:
Provide    : mysql = 8.0.36-1.el9_3

[vincent@web ~]$ sudo mysql -u nextcloud -h 10.6.1.12 -p
Enter password:
ERROR 1045 (28000): Access denied for user 'nextcloud'@'10.6.1.11' (using password: YES)
[vincent@web ~]$ sudo mysql -u nextcloud -h 10.6.1.12 -p
[sudo] password for vincent:
Sorry, try again.
[sudo] password for vincent:
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 22
Server version: 5.5.5-10.5.22-MariaDB MariaDB Server

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| nextcloud          |
+--------------------+
2 rows in set (0.00 sec)

mysql> USE nextcloud;
Database changed
mysql> SHOW TABLES;
Empty set (0.00 sec)

mysql>
```

🌞 Trouver une commande SQL qui permet de lister tous les utilisateurs de la base de données

```
[vincent@db ~]$ sudo mysql -u root -p
[sudo] password for vincent:
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 8
Server version: 10.5.22-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> SELECT User, Host FROM mysql.user;
+-------------+-----------+
| User        | Host      |
+-------------+-----------+
| nextcloud   | 10.6.1.11 |
| mariadb.sys | localhost |
| mysql       | localhost |
| root        | localhost |
+-------------+-----------+
4 rows in set (0.184 sec)

MariaDB [(none)]> MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'root'@'10.6.1.11' IDENTIFIED BY 'root' WITH GRANT OPTION;
Query OK, 0 rows affected (0.091 sec)
```
```
[vincent@web ~]$ mysql -u root -h 10.6.1.12 -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 5.5.5-10.5.22-MariaDB MariaDB Server

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SELECT User, Host FROM mysql.user;
+-------------+-----------+
| User        | Host      |
+-------------+-----------+
| nextcloud   | 10.6.1.11 |
| root        | 10.6.1.11 |
| mariadb.sys | localhost |
| mysql       | localhost |
| root        | localhost |
+-------------+-----------+
5 rows in set (0.00 sec)

mysql>
```


🌞 Install de PHP

```
[vincent@web ~]$ sudo dnf install php
[vincent@web ~]$ php -v
PHP 8.0.30 (cli) (built: Aug  3 2023 17:13:08) ( NTS gcc x86_64 )
Copyright (c) The PHP Group
Zend Engine v4.0.30, Copyright (c) Zend Technologies
    with Zend OPcache v8.0.30, Copyright (c), by Zend Technologies
[vincent@web ~]$
```
```
[vincent@web ~]$ sudo nano /etc/httpd/conf/httpd.conf
[sudo] password for vincent:
ServerRoot "/etc/httpd"

Listen 80

Include conf.modules.d/*.conf

User apache
Group apache


ServerAdmin root@localhost
```
```
[vincent@web ~]$ sudo firewall-cmd --permanent --add-port=80/tcp
success
[vincent@web ~]$ sudo firewall-cmd --permanent --remove-service=http
Warning: NOT_ENABLED: http
success
[vincent@web ~]$ sudo firewall-cmd --permanent --add-port=80/tcp
Warning: ALREADY_ENABLED: 80:tcp
success
[vincent@web ~]$ sudo firewall-cmd --reload
success
```
```
[vincent@web ~]$ sudo systemctl restart httpd
[vincent@web ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; preset: disabled)
     Active: active (running) since Mon 2024-03-25 20:02:21 CET; 4s ago
       Docs: man:httpd.service(8)
   Main PID: 43933 (httpd)
     Status: "Started, listening on: port 80"
      Tasks: 213 (limit: 5896)
     Memory: 23.2M
        CPU: 59ms
     CGroup: /system.slice/httpd.service
             ├─43933 /usr/sbin/httpd -DFOREGROUND
             ├─43934 /usr/sbin/httpd -DFOREGROUND
             ├─43935 /usr/sbin/httpd -DFOREGROUND
             ├─43936 /usr/sbin/httpd -DFOREGROUND
             └─43937 /usr/sbin/httpd -DFOREGROUND

Mar 25 20:02:20 web.tp6.linux systemd[1]: Starting The Apache HTTP Server...
Mar 25 20:02:21 web.tp6.linux systemd[1]: Started The Apache HTTP Server.
Mar 25 20:02:21 web.tp6.linux httpd[43933]: Server configured, listening on: port 80
[vincent@web ~]$
```


🌞 Récupérer NextCloud

```
[vincent@web ~]$ sudo mkdir -p /var/www/tp6_nextcloud/
[vincent@web ~]$ sudo dnf install wget
[vincent@web ~]$ sudo wget https://download.nextcloud.com/server/releases/latest.zip -P /var/www/tp6_nextcloud/
--2024-03-25 20:10:11--  https://download.nextcloud.com/server/releases/latest.zip
Resolving download.nextcloud.com (download.nextcloud.com)... 5.9.202.145, 2a01:4f8:210:21c8::145
Connecting to download.nextcloud.com (download.nextcloud.com)|5.9.202.145|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 220492795 (210M) [application/zip]
Saving to: ‘/var/www/tp6_nextcloud/latest.zip’

latest.zip                100%[===================================>] 210.28M   268KB/s    in 4m 26s

2024-03-25 20:14:38 (810 KB/s) - ‘/var/www/tp6_nextcloud/latest.zip’ saved [220492795/220492795]

[vincent@web ~]$
```
```
[vincent@web tp6_nextcloud]$ ls
latest.zip  nextcloud
[vincent@web tp6_nextcloud]$ cd nextcloud/
[vincent@web nextcloud]$ cd ..
[vincent@web tp6_nextcloud]$ sudo mv nextcloud/* ./
[sudo] password for vincent:
[vincent@web tp6_nextcloud]$ cd nextcloud/
[vincent@web nextcloud]$ ls -la
total 4
drwxr-xr-x.  2 root root    6 Mar 25 20:25 .
drwxr-xr-x. 14 root root 4096 Mar 25 20:25 ..
[vincent@web nextcloud]$ cd ..
[vincent@web tp6_nextcloud]$ sudo rmdir nextcloud
[vincent@web tp6_nextcloud]$
```
```
[vincent@web tp6_nextcloud]$ sudo chown -R apache:apache /var/www/tp6_nextcloud/
[vincent@web tp6_nextcloud]$
```
```
[vincent@web tp6_nextcloud]$ ls -al /var/www/tp6_nextcloud/
total 216520
drwxr-xr-x. 13 apache apache      4096 Mar 25 20:26 .
drwxr-xr-x.  5 root   root          54 Mar 25 20:07 ..
drwxr-xr-x. 44 apache apache      4096 Feb 29 08:49 3rdparty
drwxr-xr-x. 50 apache apache      4096 Feb 29 08:47 apps
-rw-r--r--.  1 apache apache     23796 Feb 29 08:46 AUTHORS
-rw-r--r--.  1 apache apache      1906 Feb 29 08:46 composer.json
-rw-r--r--.  1 apache apache      3140 Feb 29 08:46 composer.lock
drwxr-xr-x.  2 apache apache        67 Feb 29 08:49 config
-rw-r--r--.  1 apache apache      4124 Feb 29 08:46 console.php
-rw-r--r--.  1 apache apache     34520 Feb 29 08:46 COPYING
drwxr-xr-x. 24 apache apache      4096 Feb 29 08:49 core
-rw-r--r--.  1 apache apache      6317 Feb 29 08:46 cron.php
drwxr-xr-x.  2 apache apache     12288 Feb 29 08:46 dist
-rw-r--r--.  1 apache apache      3993 Feb 29 08:46 .htaccess
-rw-r--r--.  1 apache apache       156 Feb 29 08:46 index.html
-rw-r--r--.  1 apache apache      4403 Feb 29 08:46 index.php
-rw-r--r--.  1 apache apache 220492795 Feb 29 08:52 latest.zip
drwxr-xr-x.  6 apache apache       125 Feb 29 08:46 lib
-rw-r--r--.  1 apache apache       283 Feb 29 08:46 occ
drwxr-xr-x.  2 apache apache        55 Feb 29 08:46 ocs
drwxr-xr-x.  2 apache apache        23 Feb 29 08:46 ocs-provider
-rw-r--r--.  1 apache apache      7072 Feb 29 08:46 package.json
-rw-r--r--.  1 apache apache   1044055 Feb 29 08:46 package-lock.json
-rw-r--r--.  1 apache apache      3187 Feb 29 08:46 public.php
-rw-r--r--.  1 apache apache      5597 Feb 29 08:46 remote.php
drwxr-xr-x.  4 apache apache       133 Feb 29 08:46 resources
-rw-r--r--.  1 apache apache        26 Feb 29 08:46 robots.txt
-rw-r--r--.  1 apache apache      2452 Feb 29 08:46 status.php
drwxr-xr-x.  3 apache apache        35 Feb 29 08:46 themes
drwxr-xr-x.  2 apache apache        43 Feb 29 08:47 updater
-rw-r--r--.  1 apache apache       101 Feb 29 08:46 .user.ini
-rw-r--r--.  1 apache apache       403 Feb 29 08:49 version.php
```

🌞 Adapter la configuration d'Apache

```
[vincent@web tp6_nextcloud]$ sudo tail -n 5 /etc/httpd/conf/httpd.conf


EnableSendfile on

🌞IncludeOptional conf.d/*.conf🌞
[vincent@web tp6_nextcloud]$
```
```
[vincent@web tp6_nextcloud]$ sudo nano /etc/httpd/conf.d/nextcloud.conf
[vincent@web tp6_nextcloud]$ sudo cat /etc/httpd/conf.d/nextcloud.conf
<VirtualHost *:80>
  DocumentRoot /var/www/tp6_nextcloud/
  ServerName web.tp6.linux

  <Directory /var/www/tp6_nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
[vincent@web tp6_nextcloud]$
```

🌞 Redémarrer le service Apache pour qu'il prenne en compte le nouveau fichier de conf
```
[vincent@web tp6_nextcloud]$ sudo systemctl restart httpd
[vincent@web tp6_nextcloud]$ sudo apachectl configtest
Syntax OK
[vincent@web tp6_nextcloud]$
```

🌞 Installez les deux modules PHP dont NextCloud vous parle

```
[vincent@web tp6_nextcloud]$ sudo dnf install php-zip php-gd
[sudo] password for vincent:
[vincent@web tp6_nextcloud]$ sudo systemctl restart httpd
[vincent@web tp6_nextcloud]$
```

🌞 Pour que NextCloud utilise la base de données, ajoutez aussi

```
[vincent@web tp6_nextcloud]$ sudo dnf install php-pdo php-mysqlnd
[vincent@web tp6_nextcloud]$ sudo systemctl restart httpd
```

🌞 Exploration de la base de données


