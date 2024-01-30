1. Analyse du service
On va, dans cette première partie, analyser le service SSH qui est en cours d'exécution.
🌞 S'assurer que le service sshd est démarré

```SHELL
[vincent@node1 ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-01-29 10:07:12 CET; 43min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 711 (sshd)
      Tasks: 1 (limit: 5896)
     Memory: 5.6M
        CPU: 118ms
     CGroup: /system.slice/sshd.service
             └─711 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Jan 29 10:07:12 node1.tp3.b1 systemd[1]: Starting OpenSSH server daemon...
Jan 29 10:07:12 node1.tp3.b1 sshd[711]: Server listening on 0.0.0.0 port 22.
Jan 29 10:07:12 node1.tp3.b1 sshd[711]: Server listening on :: port 22.
```

🌞 Analyser les processus liés au service SSH

```SHELL
[vincent@node1 ~]$ ps -ef | grep sshd
root         711       1  0 10:07 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         924     711  0 10:42 ?        00:00:00 sshd: vincent [priv]
vincent      928     924  0 10:42 ?        00:00:00 sshd: vincent@pts/0
vincent     1012     929  0 11:05 pts/0    00:00:00 grep --color=auto sshd
[vincent@node1 ~]$
```

🌞 Déterminer le port sur lequel écoute le service SSH

```SHELL
[vincent@node1 ~]$ sudo ss -alnpt | grep ssh
[sudo] password for vincent:
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*    users:(("sshd",pid=711,fd=3))
LISTEN 0      128             [::]:22           [::]:*    users:(("sshd",pid=711,fd=4))
[vincent@node1 ~]$
```

🌞 Consulter les logs du service SSH

```SHELL
[vincent@node1 ~]$ journalctl -xe -u sshd
~
Jan 29 10:07:12 node1.tp3.b1 systemd[1]: Starting OpenSSH server daemon...
░░ Subject: A start job for unit sshd.service has begun execution
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has begun execution.
░░
░░ The job identifier is 244.
Jan 29 10:07:12 node1.tp3.b1 sshd[711]: Server listening on 0.0.0.0 port 22.
Jan 29 10:07:12 node1.tp3.b1 sshd[711]: Server listening on :: port 22.
Jan 29 10:07:12 node1.tp3.b1 systemd[1]: Started OpenSSH server daemon.
░░ Subject: A start job for unit sshd.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has finished successfully.
░░
░░ The job identifier is 244.
Jan 29 10:07:37 node1.tp3.b1 sshd[848]: Accepted password for vincent from 10.2.1.1 port 50384 ssh2
Jan 29 10:07:37 node1.tp3.b1 sshd[848]: pam_unix(sshd:session): session opened for user vincent(uid=1000) by (uid=0)
Jan 29 10:39:02 node1.tp3.b1 sshd[884]: Accepted password for vincent from 10.2.1.1 port 50500 ssh2
Jan 29 10:39:02 node1.tp3.b1 sshd[884]: pam_unix(sshd:session): session opened for user vincent(uid=1000) by (uid=0)
Jan 29 10:42:24 node1.tp3.b1 sshd[924]: Accepted password for vincent from 10.2.1.1 port 50508 ssh2
Jan 29 10:42:24 node1.tp3.b1 sshd[924]: pam_unix(sshd:session): session opened for user vincent(uid=1000) by (uid=0)
[vincent@node1 ~]$
```
```
[vincent@node1 ~]$ cd /var/log
[vincent@node1 log]$ tail -n 10 dnf.log
2024-01-29T10:43:33+0100 DEBUG countme: no event for extras: budget to spend: 1
2024-01-29T10:43:33+0100 DEBUG reviving: failed for 'extras', mismatched repomd.
2024-01-29T10:43:33+0100 DEBUG repo: downloading from remote: extras
2024-01-29T10:43:33+0100 DEBUG countme: event triggered for extras: bucket 1
2024-01-29T10:43:34+0100 DEBUG extras: using metadata from Sun 31 Dec 2023 02:20:21 AM CET.
2024-01-29T10:43:34+0100 DEBUG User-Agent: constructed: 'libdnf (Rocky Linux 9.0; generic; Linux.x86_64)'
2024-01-29T10:43:34+0100 DDEBUG timer: sack setup: 6148 ms
2024-01-29T10:43:34+0100 DEBUG Completion plugin: Generating completion cache...
2024-01-29T10:43:34+0100 INFO Metadata cache created.
2024-01-29T10:43:34+0100 DDEBUG Cleaning up.
[vincent@node1 log]$
```

🌞 Identifier le fichier de configuration du serveur SSH

```SHELL
[vincent@node1 etc]$ cd ssh
[vincent@node1 ssh]$ ls
moduli        sshd_config         ssh_host_ecdsa_key.pub    ssh_host_rsa_key
🌞ssh_config🌞    sshd_config.d       ssh_host_ed25519_key      ssh_host_rsa_key.pub
ssh_config.d  ssh_host_ecdsa_key  ssh_host_ed25519_key.pub
[vincent@node1 ssh]$
```


🌞 Modifier le fichier de conf

```SHELL
[vincent@node1 ssh]$ echo $RANDOM
25847
[vincent@node1 ssh]$ sudo nano sshd_config
#       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
Port 25847
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
```
```
[vincent@node1 ssh]$ sudo firewall-cmd --remove-port=22/tcp --permanent
Warning: NOT_ENABLED: 22:tcp
success
[vincent@node1 ssh]$ sudo firewall-cmd --add-port=25847/tcp --permanent
Warning: ALREADY_ENABLED: 25847:tcp
success
[vincent@node1 ssh]$ sudo firewall-cmd --reload
success
[vincent@node1 ssh]$ sudo cat sshd_config | grep Port
Port 25847
#GatewayPorts no
```

🌞 Redémarrer le service

```
[vincent@node1 ~]$ sudo systemctl restart firewalld
```

🌞 Effectuer une connexion SSH sur le nouveau port

```
PS C:\Users\vince> ssh -p 25847 vincent@10.2.1.11
vincent@10.2.1.11's password:
Last login: Mon Jan 29 12:00:41 2024
[vincent@node1 ~]$
```








II. Service HTTP

🌞 Installer le serveur NGINX

```
[vincent@node1 ~]$ sudo dnf install nginx
Rocky Linux 9 - BaseOS                                                404  B/s | 4.1 kB     00:10
Rocky Linux 9 - BaseOS                                                142 kB/s | 2.2 MB     00:15
Rocky Linux 9 - AppStream                                             447  B/s | 4.5 kB     00:10
Rocky Linux 9 - AppStream                                             475 kB/s | 7.4 MB     00:15
Rocky Linux 9 - Extras                                                290  B/s | 2.9 kB     00:10
Package nginx-1:1.20.1-14.el9_2.1.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
```

🌞 Démarrer le service NGINX

```
[vincent@node1 ~]$ sudo systemctl start nginx
[sudo] password for vincent:
[vincent@node1 ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Tue 2024-01-30 09:07:19 CET; 13s ago
    Process: 905 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 906 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 907 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 908 (nginx)
      Tasks: 2 (limit: 5896)
     Memory: 3.3M
        CPU: 17ms
     CGroup: /system.slice/nginx.service
             ├─908 "nginx: master process /usr/sbin/nginx"
             └─909 "nginx: worker process"

Jan 30 09:07:19 node1.tp3.b1 systemd[1]: Starting The nginx HTTP and reverse proxy server...
```

🌞 Déterminer sur quel port tourne NGINX

```
[vincent@node1 ~]$ sudo dnf update
[vincent@node1 ~]$ sudo dnf install net-tools
[vincent@node1 ~]$ netstat --version
```
```SHELL
[vincent@node1 ~]$ sudo netstat -plnt | grep nginx
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      908/nginx: master p
tcp6       0      0 :::80                   :::*                    LISTEN      908/nginx: master p
```
```
[vincent@node1 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[vincent@node1 ~]$ sudo firewall-cmd --reload
success
```

🌞 Déterminer les processus liés au service NGINX

```
[vincent@node1 ~]$ ps aux | grep nginx
root         908  0.0  0.0  10084   300 ?        Ss   09:07   0:00 nginx: master process /usr/sbin/nginx
nginx        909  0.0  0.2  13852  2396 ?        S    09:07   0:00 nginx: worker process
vincent    42794  0.0  0.2   6408  2176 pts/0    S+   09:35   0:00 grep --color=auto nginx
```

🌞 Déterminer le nom de l'utilisateur qui lance NGINX

```
[vincent@node1 ~]$ ps aux | grep nginx
🌞root         908  0.0  0.0  10084   300 ?        Ss   09:07   0:00 nginx: master process /usr/sbin/nginx🌞
nginx        909  0.0  0.2  13852  2396 ?        S    09:07   0:00 nginx: worker process
vincent    42794  0.0  0.2   6408  2176 pts/0    S+   09:35   0:00 grep --color=auto nginx
```
```
[vincent@node1 ~]$ cat /etc/passwd | grep nginx
nginx:x:991:991:Nginx web server:/var/lib/nginx:/sbin/nologin
```

🌞 Test !

```
[vincent@node1 ~]$ sudo curl http://10.2.1.11:80 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
100  7620  100  7620    0     0   744k      0 --:--:-- --:--:-- --:--:--  826k
curl: (23) Failed writing body
```


2. Analyser la conf de NGINX
🌞 Déterminer le path du fichier de configuration de NGINX

```
[vincent@node1 ~]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 Oct 16 20:00 /etc/nginx/nginx.conf
```


🌞 Trouver dans le fichier de conf

```SHELL
[vincent@node1 ~]$ cat /etc/nginx/nginx.conf | grep server -A 10
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
--
# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }
```

```
[vincent@node1 ~]$ cat /etc/nginx/nginx.conf | grep include
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
```


3. Déployer un nouveau site web
🌞 Créer un site web

```
[vincent@node1 ~]$ sudo mkdir -p /var/www/tp3_linux
```
```
[vincent@node1 ~]$ cd /var/www/tp3_linux
```
```
[vincent@node1 tp3_linux]$ sudo nano index.html
```
```
[vincent@node1 tp3_linux]$ sudo cat index.html
<h1>MEOW mon premier serveur web</h1>
```

🌞 Gérer les permissions

```
[vincent@node1 ~]$ sudo chown -R nginx:nginx /var/www/tp3_linux
[sudo] password for vincent:
```

🌞 Adapter la conf NGINX
```
[vincent@node1 ~]$ sudo systemctl restart nginx
[vincent@node1 ~]$ sudo nano /etc/nginx/nginx.conf

[vincent@node1 nginx]$ ls
[vincent@node1 nginx]$ cd conf.d
[vincent@node1 conf.d]$ ls
[vincent@node1 conf.d]$ sudo nano tp3.conf
[vincent@node1 conf.d]$ echo $RANDOM
21850
[vincent@node1 conf.d]$ sudo nano tp3.conf
[vincent@node1 conf.d]$ sudo systemctl restart nginx
[vincent@node1 conf.d]$ sudo firewall-cmd --add-port=21850/tcp --permanent
success
[vincent@node1 conf.d]$ sudo firewall-cmd --reload
success
```

🌞 Visitez votre super site web

```
[vincent@node1 conf.d]$ curl http://10.2.1.11:21850
<h1>MEOW mon premier serveur web</h1>
```


III. Your own services



🌞 Afficher le fichier de service SSH

```
[vincent@node1 ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
     Active: active (running) since Tue 2024-01-30 09:24:06 CET; 1h 45min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 18011 (sshd)
      Tasks: 1 (limit: 5896)
     Memory: 3.1M
        CPU: 47ms
     CGroup: /system.slice/sshd.service
             └─18011 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Jan 30 09:24:06 node1.tp3.b1 systemd[1]: Starting OpenSSH server daemon...
Jan 30 09:24:06 node1.tp3.b1 sshd[18011]: Server listening on 0.0.0.0 port 25847.
Jan 30 09:24:06 node1.tp3.b1 sshd[18011]: Server listening on :: port 25847.
```
```
[vincent@node1 ~]$ cat /usr/lib/systemd/system/sshd.service | grep 'ExecStart='
ExecStart=/usr/sbin/sshd -D $OPTIONS
```
```
[vincent@node1 ~]$ sudo systemctl start sshd
```


🌞 Afficher le fichier de service NGINX

```
[vincent@node1 ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; preset: disabled)
     Active: active (running) since Tue 2024-01-30 10:56:27 CET; 17min ago
    Process: 42996 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 42997 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 42998 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 42999 (nginx)
      Tasks: 2 (limit: 5896)
     Memory: 1.9M
        CPU: 16ms
     CGroup: /system.slice/nginx.service
             ├─42999 "nginx: master process /usr/sbin/nginx"
             └─43000 "nginx: worker process"

Jan 30 10:56:27 node1.tp3.b1 systemd[1]: nginx.service: Deactivated successfully.
Jan 30 10:56:27 node1.tp3.b1 systemd[1]: Stopped The nginx HTTP and reverse proxy server.
Jan 30 10:56:27 node1.tp3.b1 systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jan 30 10:56:27 node1.tp3.b1 nginx[42997]: nginx: the configuration file /etc/nginx/nginx.conf syntax>
Jan 30 10:56:27 node1.tp3.b1 nginx[42997]: nginx: configuration file /etc/nginx/nginx.conf test is su>
Jan 30 10:56:27 node1.tp3.b1 systemd[1]: Started The nginx HTTP and reverse proxy server.
```
```
[vincent@node1 ~]$ cat /usr/lib/systemd/system/nginx.service | grep 'ExecStart='
ExecStart=/usr/sbin/nginx
```

🌞 Créez le fichier /etc/systemd/system/tp3_nc.service

```
[vincent@node1 ~]$ echo $RANDOM
13584
[vincent@node1 ~]$ sudo nano /etc/systemd/system/tp3_nc.service
[vincent@node1 ~]$ sudo firewall-cmd --add-port=13584/tcp --permanent
success
[vincent@node1 ~]$ sudo firewall-cmd --reload
success
```

🌞 Indiquer au système qu'on a modifié les fichiers de service

```
[vincent@node1 ~]$ sudo systemctl daemon-reload
```

🌞 Démarrer notre service de ouf

```
[vincent@node1 ~]$ sudo systemctl start tp3_nc.service
```

🌞 Vérifier que ça fonctionne

```
[vincent@node1 ~]$ sudo systemctl status tp3_nc.service
● tp3_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp3_nc.service; static)
     Active: active (running) since Tue 2024-01-30 11:23:19 CET; 50s ago
   Main PID: 43109 (nc)
      Tasks: 1 (limit: 5896)
     Memory: 1.1M
        CPU: 4ms
     CGroup: /system.slice/tp3_nc.service
             └─43109 /usr/bin/nc -l 13584 -k

Jan 30 11:23:19 node1.tp3.b1 systemd[1]: Started Super netcat tout fou.
```
```
[vincent@node1 ~]$ ss -tln | grep 13584
LISTEN 0      10           0.0.0.0:13584      0.0.0.0:*
LISTEN 0      10              [::]:13584         [::]:*
```

```
[vincent@node1 ~]$ sudo journalctl -xe -u tp3_nc.service -f
Jan 30 11:23:19 node1.tp3.b1 systemd[1]: Started Super netcat tout fou.
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░
░░ A start job for unit tp3_nc.service has finished successfully.
░░
░░ The job identifier is 3615.
Jan 30 11:29:00 node1.tp3.b1 nc[43109]: SSH-2.0-OpenSSH_9.5
Jan 30 11:29:07 node1.tp3.b1 nc[43109]: SSH-2.0-OpenSSH_9.5
Jan 30 11:59:04 node1.tp3.b1 nc[43109]: gfd
Jan 30 12:11:39 node1.tp3.b1 nc[43109]: dfs
Jan 30 12:11:40 node1.tp3.b1 nc[43109]: fdsq
Jan 30 12:11:40 node1.tp3.b1 nc[43109]: dfsq
Jan 30 12:13:20 node1.tp3.b1 nc[43109]: bonjour
Jan 30 12:13:23 node1.tp3.b1 nc[43109]: ça va
Jan 30 12:13:26 node1.tp3.b1 nc[43109]: no
```


🌞 Les logs de votre service

```
[vincent@node1 ~]$ sudo journalctl -xe -u tp3_nc | grep start
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ A start job for unit tp3_nc.service has finished successfully.
```
```
[vincent@node1 ~]$ sudo journalctl -xe -u tp3_nc | grep nc
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ A start job for unit tp3_nc.service has finished successfully.
Jan 30 11:29:00 node1.tp3.b1 nc[43109]: SSH-2.0-OpenSSH_9.5
Jan 30 11:29:07 node1.tp3.b1 nc[43109]: SSH-2.0-OpenSSH_9.5
Jan 30 11:59:04 node1.tp3.b1 nc[43109]: gfd
Jan 30 12:11:40 node1.tp3.b1 nc[43109]: dfsq
Jan 30 12:13:20 node1.tp3.b1 nc[43109]: bonjour
Jan 30 12:13:23 node1.tp3.b1 nc[43109]: ça va
Jan 30 12:13:26 node1.tp3.b1 nc[43109]: no
```
```
[vincent@node1 ~]$  sudo journalctl -xe -u tp3_nc | grep finished
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ A start job for unit tp3_nc.service has finished successfully. 
```

🌞 S'amuser à kill le processus

```
[vincent@node1 ~]$ ps -fe | grep nc
dbus         657       1  0 08:58 ?        00:00:00 /usr/bin/dbus-broker-launch --scope system --audit
root         693       1  0 08:58 ?        00:00:00 login -- vincent
vincent      839       1  0 09:04 ?        00:00:00 /usr/lib/systemd/systemd --user
vincent      841     839  0 09:04 ?        00:00:00 (sd-pam)
vincent      849     693  0 09:04 tty1     00:00:00 -bash
🌞root       43109       1  0 11:23 ?        00:00:00 /usr/bin/nc -l 13584 -k🌞
root       43166   18011  0 12:01 ?        00:00:00 sshd: vincent [priv]
vincent    43170   43166  0 12:01 ?        00:00:00 sshd: vincent@pts/0
vincent    43171   43170  0 12:01 pts/0    00:00:00 -bash
vincent    43230   43171  0 12:20 pts/0    00:00:00 ps -fe
vincent    43231   43171  0 12:20 pts/0    00:00:00 grep --color=auto nc
```
```
[vincent@node1 ~]$ sudo kill 43109
```

🌞 Affiner la définition du service

```
[vincent@node1 ~]$ sudo cat /etc/systemd/system/tp3_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
Restart=always
ExecStart=/usr/bin/nc -l 13584 -k
```
```
[vincent@node1 ~]$ sudo systemctl start tp3_nc.service
[vincent@node1 ~]$  ps -fe | grep nc
dbus         657       1  0 08:58 ?        00:00:00 /usr/bin/dbus-broker-launch --scope system --audit
root         693       1  0 08:58 ?        00:00:00 login -- vincent
vincent      839       1  0 09:04 ?        00:00:00 /usr/lib/systemd/systemd --user
vincent      841     839  0 09:04 ?        00:00:00 (sd-pam)
vincent      849     693  0 09:04 tty1     00:00:00 -bash
root       43166   18011  0 12:01 ?        00:00:00 sshd: vincent [priv]
vincent    43170   43166  0 12:01 ?        00:00:00 sshd: vincent@pts/0
vincent    43171   43170  0 12:01 pts/0    00:00:00 -bash
root       43259       1  0 12:28 ?        00:00:00 /usr/bin/nc -l 13584 -k
vincent    43260   43171  0 12:29 pts/0    00:00:00 ps -fe
vincent    43261   43171  0 12:29 pts/0    00:00:00 grep --color=auto nc
```
```
[vincent@node1 ~]$ sudo kill 43259
```
```
[vincent@node1 ~]$  ps -fe | grep nc
dbus         657       1  0 08:58 ?        00:00:00 /usr/bin/dbus-broker-launch --scope system --audit
root         693       1  0 08:58 ?        00:00:00 login -- vincent
vincent      839       1  0 09:04 ?        00:00:00 /usr/lib/systemd/systemd --user
vincent      841     839  0 09:04 ?        00:00:00 (sd-pam)
vincent      849     693  0 09:04 tty1     00:00:00 -bash
root       43166   18011  0 12:01 ?        00:00:00 sshd: vincent [priv]
vincent    43170   43166  0 12:01 ?        00:00:00 sshd: vincent@pts/0
vincent    43171   43170  0 12:01 pts/0    00:00:00 -bash
root       43265       1  0 12:29 ?        00:00:00 /usr/bin/nc -l 13584 -k
vincent    43266   43171  0 12:29 pts/0    00:00:00 ps -fe
vincent    43267   43171  0 12:29 pts/0    00:00:00 grep --color=auto nc
```