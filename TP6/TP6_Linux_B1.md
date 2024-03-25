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



🌞 Install de PHP



🌞 Récupérer NextCloud


🌞 Adapter la configuration d'Apache



🌞 Redémarrer le service Apache pour qu'il prenne en compte le nouveau fichier de conf




🌞 Installez les deux modules PHP dont NextCloud vous parle


🌞 Pour que NextCloud utilise la base de données, ajoutez aussi


🌞 Exploration de la base de données


