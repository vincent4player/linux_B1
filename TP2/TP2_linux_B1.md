I. Fichiers

1. Find me
🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur

```SHELL
[vincent@vincent ~]$ cd ../
[vincent@vincent home]$ ls
toto  vincent
[vincent@vincent home]$
```

🌞 Trouver le chemin du fichier de logs SSH

```SHELL
[vincent@vincent ~]$ cd /
[vincent@vincent /]$ sudo cat /var/log/secure | grep sshd
Jan 22 10:04:40 localhost sshd[713]: Server listening on 0.0.0.0 port 22.
Jan 22 10:04:40 localhost sshd[713]: Server listening on :: port 22.
Jan 22 10:22:01 localhost sshd[706]: Server listening on 0.0.0.0 port 22.
Jan 22 10:22:01 localhost sshd[706]: Server listening on :: port 22.
Jan 22 10:26:31 localhost sshd[706]: Server listening on 0.0.0.0 port 22.
Jan 22 10:26:31 localhost sshd[706]: Server listening on :: port 22.
Jan 22 10:27:10 localhost sshd[865]: Accepted password for vincent from 10.7.1.1 port 50994 ssh2
Jan 22 10:27:10 localhost sshd[865]: pam_unix(sshd:session): session opened for user vincent(uid=1000) by (uid=0)
Jan 22 10:29:29 localhost sshd[869]: Received disconnect from 10.7.1.1 port 50994:11: disconnected by user
Jan 22 10:29:29 localhost sshd[869]: Disconnected from user vincent 10.7.1.1 port 50994
Jan 22 10:29:29 localhost sshd[865]: pam_unix(sshd:session): session closed for user vincent
Jan 22 10:29:42 localhost sshd[896]: Accepted password for vincent from 10.7.1.1 port 50998 ssh2
Jan 22 10:29:42 localhost sshd[896]: pam_unix(sshd:session): session opened for user vincent(uid=1000) by (uid=0)
Jan 22 10:30:35 vincent sshd[711]: Server listening on 0.0.0.0 port 22.
Jan 22 10:30:35 vincent sshd[711]: Server listening on :: port 22.
Jan 22 10:32:17 vincent sshd[855]: Accepted password for vincent from 10.7.1.1 port 50999 ssh2
Jan 22 10:32:17 vincent sshd[855]: pam_unix(sshd:session): session opened for user vincent(uid=1000) by (uid=0)
Jan 22 10:33:38 vincent sshd[880]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.7.1.1  user=vincent
Jan 22 10:33:40 vincent sshd[880]: Failed password for vincent from 10.7.1.1 port 51012 ssh2
Jan 22 10:33:42 vincent sshd[880]: Accepted password for vincent from 10.7.1.1 port 51012 ssh2
Jan 22 10:33:42 vincent sshd[880]: pam_unix(sshd:session): session opened for user vincent(uid=1000) by (uid=0)
Jan 22 10:33:50 vincent sshd[859]: Received disconnect from 10.7.1.1 port 50999:11: disconnected by user
Jan 22 10:33:50 vincent sshd[859]: Disconnected from user vincent 10.7.1.1 port 50999
Jan 22 10:33:50 vincent sshd[855]: pam_unix(sshd:session): session closed for user vincent
Jan 22 10:47:24 vincent sshd[885]: Received disconnect from 10.7.1.1 port 51012:11: disconnected by user
Jan 22 10:47:24 vincent sshd[885]: Disconnected from user vincent 10.7.1.1 port 51012
Jan 22 10:47:24 vincent sshd[880]: pam_unix(sshd:session): session closed for user vincent
Jan 22 10:47:33 vincent sshd[937]: Accepted password for vincent from 10.7.1.1 port 51146 ssh2
Jan 22 10:47:33 vincent sshd[937]: pam_unix(sshd:session): session opened for user vincent(uid=1000) by (uid=0)
[vincent@vincent /]$
```



🌞 Trouver le chemin du fichier de configuration du serveur SSH

```SHELL
[vincent@vincent ~]$ cd /etc
[vincent@vincent etc]$ ls
adjtime                  GREP_COLORS               man_db.conf             selinux
aliases                  groff                     microcode_ctl           services
alternatives             group                     mke2fs.conf             sestatus.conf
anacrontab               group-                    modprobe.d              shadow
audit                    grub2.cfg                 modules-load.d          shadow-
authselect               grub.d                    motd                    shells
bash_completion.d        gshadow                   motd.d                  skel
bashrc                   gshadow-                  mtab                    ssh
binfmt.d                 gss                       nanorc                  ssl
chrony.conf              host.conf                 NetworkManager          sssd
[vincent@vincent etc]$ cd ssh
[vincent@vincent ssh]$ ls
moduli        🌞sshd_config🌞         ssh_host_ecdsa_key.pub    ssh_host_rsa_key
ssh_config    sshd_config.d       ssh_host_ed25519_key      ssh_host_rsa_key.pub
ssh_config.d  ssh_host_ecdsa_key  ssh_host_ed25519_key.pub
[vincent@vincent ssh]$
```


II. Users

1. Nouveau user
🌞 Créer un nouvel utilisateur

```SHELL
[vincent@vincent ~]$ sudo useradd marmotte
[vincent@vincent ~]$ sudo passwd marmotte
Changing password for user marmotte.
New password:
BAD PASSWORD: The password fails the dictionary check - it is based on a dictionary word
Retype new password:
passwd: all authentication tokens updated successfully.
useradd: user 'marmotte' already exists
[vincent@vincent ~]$ sudo usermod -m -d /home/papier_alu/ marmotte
[vincent@vincent ~]$ cd /
[vincent@vincent /]$ ls
afs  boot  etc   lib    media  opt   root  sbin  sys  usr
bin  dev   home  lib64  mnt    proc  run   srv   tmp  var
[vincent@vincent /]$ cd
[vincent@vincent /]$ cd home
[vincent@vincent home]$ ls
papier_alu  vincent
```
```SHELL
[vincent@vincent home]$ cat /etc/passwd | grep marmotte
marmotte:x:1001:1001::/home/papier_alu/:/bin/bash
```



2. Infos enregistrées par le système
🌞 Prouver que cet utilisateur a été créé

```SHELL
[vincent@vincent home]$ cat /etc/passwd | grep marmotte
marmotte:x:1001:1001::/home/papier_alu/:/bin/bash
```


🌞 Déterminer le hash du password de l'utilisateur marmotte

```SHELL
[vincent@vincent home]$ sudo cat /etc/shadow | grep marmotte
[sudo] password for vincent:
marmotte:$6$zJdzTzacXaSulLJ0$mEPD6dcK6KxmIRAi2ATmsEiotBcmTvWYm4eB80O0Uk7vu6wRi5cWnwJYSiC6/ONxu0BAuPKVKQIBRQq0sxAiT.:19744:0:99999:7:::
[vincent@vincent home]$
```


3. Connexion sur le nouvel utilisateur
🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur

```SHELL
[vincent@vincent home]$ exit
logout
Connection to 10.7.1.10 closed.
PS C:\Users\vince> ssh vincent@10.7.1.10
vincent@10.7.1.10's password:
Last login: Mon Jan 22 10:47:33 2024 from 10.7.1.1
[vincent@vincent ~]$
```

🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte

```SHELL
C:\Users\vince> ssh marmotte@10.7.1.10
marmotte@10.7.1.10's password:
[marmotte@vincent ~]$

[marmotte@vincent ~]$ cd ../
[marmotte@vincent home]$ ls
papier_alu  vincent
[marmotte@vincent home]$ cd vincent
-bash: cd: vincent: Permission denied
[marmotte@vincent home]$
```

Partie 2 : Programmes et paquets
II. Paquets


I. Programmes et processus
➜ Dans cette partie, afin d'avoir quelque chose à étudier, on va utiliser le programme sleep

c'est une commande (= un programme) dispo sur tous les OS
ça permet de... ne rien faire pendant X secondes
la syntaxe c'est sleep 90 pour attendre 90 secondes
on s'en fout de sleep en doit, c'est une commande utile parmi plein d'autres, elle est pratique pour étudier les trucs que j'veux vous montrer


1. Run then kill
🌞 Lancer un processus sleep

```
PS C:\Users\vince> ssh vincent@10.7.1.10
vincent@10.7.1.10's password:
Last login: Mon Jan 22 12:14:40 2024 from 10.7.1.1
[vincent@vincent ~]$ sleep 1000
```

```SHELL
PS C:\Users\vince> ssh vincent@10.7.1.10
vincent@10.7.1.10's password:
Last login: Tue Jan 23 09:01:16 2024 from 10.7.1.1
[vincent@vincent ~]$ ps aux | grep sleep
🌞vincent      873  0.0  0.1   5588  1048 pts/0    S+   09:04   0:00 sleep 1000
vincent      898  0.0  0.2   6412  2160 pts/1    S+   09:06   0:00 grep --color=auto sleep
[vincent@vincent ~]$
```

🌞 Terminez le processus sleep depuis le deuxième terminal

```SHELL
[vincent@vincent ~]$ ps aux | grep sleep
🌞vincent      873  0.0  0.1   5588  1048 pts/0    S+   09:04   0:00 sleep 1000🌞
vincent      898  0.0  0.2   6412  2160 pts/1    S+   09:06   0:00 grep --color=auto sleep
[vincent@vincent ~]$ kill 873
[vincent@vincent ~]$ kill -9 873
-bash: kill: (873) - No such process
[vincent@vincent ~]$ ps aux | grep sleep
vincent      941  0.0  0.2   6412  2144 pts/1    S+   09:09   0:00 grep --color=auto sleep
[vincent@vincent ~]$
```


2. Tâche de fond
🌞 Lancer un nouveau processus sleep, mais en tâche de fond

```SHELL
[vincent@vincent ~]$ 🌞sleep 1000 &
[1] 943🌞
[vincent@vincent ~]$ ps aux | grep sleep
vincent     🌞 943🌞  0.0  0.1   5588  1044 pts/1    S    09:14   0:00 sleep 1000
vincent      945  0.0  0.2   6412  2320 pts/1    S+   09:14   0:00 grep --color=auto sleep
```

🌞 Visualisez la commande en tâche de fond

```SHELL
[vincent@vincent ~]$ ps aux | grep sleep
🌞vincent      943  0.0  0.1   5588  1044 pts/1    S    09:14   0:00 sleep 1000🌞
vincent      948  0.0  0.2   6412  2172 pts/1    S+   09:16   0:00 grep --color=auto sleep
[vincent@vincent ~]$
```


3. Find paths
➜ La commande sleep, comme toutes les commandes, c'est un programme

sous Linux, on met pas l'extension .exe, s'il y a pas d'extensions, c'est que c'est un exécutable généralement

🌞 Trouver le chemin où est stocké le programme sleep

```SHELL
[vincent@vincent ~]$ command -v sleep
/usr/bin/sleep
[1]+  Done                    sleep 1000
```
```SHELL
[vincent@vincent ~]$ ls -al /usr/bin/sleep
-rwxr-xr-x. 1 root root 36992 May 18  2022 /usr/bin/sleep
[vincent@vincent ~]$
```
```SHELL
[vincent@vincent ~]$ ls -al /usr/bin/sleep | grep sleep
-rwxr-xr-x. 1 root root 36992 May 18  2022 /usr/bin/sleep
```

🌞 Tant qu'on est à chercher des chemins : trouver les chemins vers tous les fichiers qui s'appellent .bashrc

```SHELL
[vincent@vincent ~]$ sudo find / -name "*.bashrc"
/etc/skel/.bashrc
/root/.bashrc
/home/vincent/.bashrc
/home/papier_alu/.bashrc
[vincent@vincent ~]$
```



🌞 Vérifier que

les commandes sleep, ssh, et ping sont bien des programmes stockés dans l'un des dossiers listés dans votre PATH

```SHELL
[vincent@vincent ~]$ which sleep
/usr/bin/sleep
[vincent@vincent ~]$ which ssh
/usr/bin/ssh
[vincent@vincent ~]$ which ping
/usr/bin/ping
[vincent@vincent ~]$
```

II. Paquets
➜ Tous les OS Linux sont munis d'un store d'application

c'est natif
quand tu fais apt install ou dnf install, ce genre de commandes, t'utilises ce store
on dit que apt et dnf sont des gestionnaires de paquets
ça permet aux utilisateurs de télécharger des nouveaux programmes (ou d'autres trucs) depuis un endroit safe

🌞 Installer le paquet firefox

```SHELL
[vincent@vincent ~]$ sudo dnf install git
Rocky Linux 9 - BaseOS                                                402  B/s | 4.1 kB     00:10
Rocky Linux 9 - AppStream                                             443  B/s | 4.5 kB     00:10
Rocky Linux 9 - AppStream                                             282 kB/s | 7.4 MB     00:26
Rocky Linux 9 - Extras                                                287  B/s | 2.9 kB     00:10
Dependencies resolved.
======================================================================================================
 Package                         Architecture    Version                     Repository          Size
======================================================================================================
Installing:
 git                             x86_64          2.39.3-1.el9_2              appstream           61 k
Installing dependencies:
 emacs-filesystem                noarch          1:27.2-9.el9                appstream          7.9 k
 git-core                        x86_64          2.39.3-1.el9_2              appstream          4.2 M

Transaction Summary
======================================================================================================
Install  67 Packages

Total download size: 14 M
Installed size: 61 M
Is this ok [y/N]: y
Downloading Packages:
(1/67): perl-Text-ParseWords-3.30-460.el9.noarch.rpm                  3.0 kB/s |  16 kB     00:05

Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                              1/1
  Installing       : perl-Digest-1.19-4.el9.noarch                                               1/67
  Installing       : perl-Digest-MD5-2.58-4.el9.x86_64                                           2/67

Installed:
  emacs-filesystem-1:27.2-9.el9.noarch              git-2.39.3-1.el9_2.x86_64
  git-core-2.39.3-1.el9_2.x86_64                    git-core-doc-2.39.3-1.el9_2.noarch
  perl-AutoLoader-5.74-480.el9.noarch               perl-B-1.80-480.el9.x86_64

🌞Complete!🌞
[vincent@vincent ~]$
```


🌞 Utiliser une commande pour lancer GIT

```SHELL
[vincent@vincent ~]$ which git
/usr/bin/git
[vincent@vincent ~]$ ls -al /usr/bin/git
-rwxr-xr-x. 1 root root 3960424 May 22  2023 /usr/bin/git
[vincent@vincent ~]$
```

🌞 Installer le paquet nginx

```SHELL
[vincent@vincent ~]$ sudo dnf install nginx
[sudo] password for vincent:
Sorry, try again.
[sudo] password for vincent:
Last metadata expiration check: 0:11:52 ago on Tue 23 Jan 2024 10:08:43 AM CET.
Dependencies resolved.
Total download size: 634 k
Installed size: 1.8 M
Is this ok [y/N]: y
Downloading Packages:
(1/4): nginx-filesystem-1.20.1-14.el9_2.1.noarch.rpm                  1.7 kB/s | 8.5 kB     00:05
Installed:
  nginx-1:1.20.1-14.el9_2.1.x86_64                     nginx-core-1:1.20.1-14.el9_2.1.x86_64
  nginx-filesystem-1:1.20.1-14.el9_2.1.noarch          rocky-logos-httpd-90.14-2.el9.noarch
Complete!
[vincent@vincent ~]$
```


🌞 Déterminer

```SHELL
[vincent@vincent nginx]$ cd
[vincent@vincent ~]$ cd /var
[vincent@vincent var]$ ls
adm    crash  empty  games     lib    lock  mail  opt       run    tmp
cache  db     ftp    kerberos  local  log   nis   preserve  spool  yp
[vincent@vincent var]$ cd log
[vincent@vincent log]$ ls
anaconda       cron-20240122        hawkey.log-20240123  messages-20240122  spooler
audit          dnf.librepo.log      lastlog              nginx              spooler-20231211
btmp           dnf.log              maillog              private            spooler-20240122
btmp-20240122  dnf.rpm.log          maillog-20231211     README             sssd
chrony         firewalld            maillog-20240122     secure             tallylog
cron           hawkey.log           messages             secure-20231211    wtmp
cron-20231211  hawkey.log-20231211  messages-20231211    secure-20240122
```
```
[vincent@vincent ~]$ ls /etc/nginx/
conf.d                fastcgi_params          mime.types          scgi_params           win-utf
default.d             fastcgi_params.default  mime.types.default  scgi_params.default
fastcgi.conf          koi-utf                 🌞nginx.conf🌞         uwsgi_params
fastcgi.conf.default  koi-win                 nginx.conf.default  uwsgi_params.default
[vincent@vincent ~]$
```

🌞 Mais aussi déterminer...

```SHELL
[vincent@vincent ~]$ cat /etc/yum.repos.d/*.repo | grep https
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=HighAvailability-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=HighAvailability-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=HighAvailability-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=ResilientStorage-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=ResilientStorage-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=ResilientStorage-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=NFV-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAP-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAP-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAP-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAPHANA-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAPHANA-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAPHANA-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=devel-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=extras-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=extras-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=extras-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=rockyplus-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=rockyplus-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=rockyplus-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=BaseOS-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=BaseOS-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=BaseOS-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=AppStream-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=AppStream-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=AppStream-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=CRB-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=CRB-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=CRB-$releasever-source$rltype
[vincent@vincent ~]$
```

Partie 3 : Poupée russe
🌞 Récupérer le fichier meow

```SHELL
[vincent@vincent ~]$ sudo dnf install wget
Last metadata expiration check: 0:42:01 ago on Tue 23 Jan 2024 10:08:43 AM CET.
Dependencies resolved.
======================================================================================================
 Package             Architecture          Version                     Repository                Size
======================================================================================================
Installing:
 wget                x86_64                1.21.1-7.el9                appstream                769 k

Transaction Summary
======================================================================================================
Install  1 Package

Total download size: 769 k
Installed size: 3.1 M
Is this ok [y/N]: y
Downloading Packages:
wget-1.21.1-7.el9.x86_64.rpm                                          149 kB/s | 769 kB     00:05
------------------------------------------------------------------------------------------------------
Total                                                                  74 kB/s | 769 kB     00:10
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                              1/1
  Installing       : wget-1.21.1-7.el9.x86_64                                                     1/1
  Running scriptlet: wget-1.21.1-7.el9.x86_64                                                     1/1
  Verifying        : wget-1.21.1-7.el9.x86_64                                                     1/1

Installed:
  wget-1.21.1-7.el9.x86_64

Complete!
[vincent@vincent ~]$
```
```SHELL
[vincent@vincent ~]$ 🌞sudo wget https://gitlab.com/it4lik/b1-linux-2023/-/blob/master/tp/2/meow🌞
--2024-01-23 10:51:36--  https://gitlab.com/it4lik/b1-linux-2023/-/blob/master/tp/2/meow
Resolving gitlab.com (gitlab.com)... 172.65.251.78, 2606:4700:90:0:f22e:fbec:5bed:a9b9
Connecting to gitlab.com (gitlab.com)|172.65.251.78|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 38561 (38K) [text/html]
Saving to: ‘meow’

meow                      100%[===================================>]  37.66K  --.-KB/s    in 0.002s

2024-01-23 10:51:42 (16.2 MB/s) - ‘meow’ saved [38561/38561]

[vincent@vincent ~]$
```

🌞 Trouver le dossier dawa/

```SHELL
[vincent@vincent ~]$ sudo dnf install unzip
[sudo] password for vincent:
Last metadata expiration check: 0:48:40 ago on Tue 23 Jan 2024 10:08:43 AM CET.
Dependencies resolved.
======================================================================================================
 Package               Architecture           Version                    Repository              Size
======================================================================================================
Installing:
 unzip                 x86_64                 6.0-56.el9                 baseos                 180 k

Transaction Summary
======================================================================================================
Install  1 Package

Total download size: 180 k
Installed size: 392 k
Is this ok [y/N]: y
Downloading Packages:
unzip-6.0-56.el9.x86_64.rpm                                            35 kB/s | 180 kB     00:05
------------------------------------------------------------------------------------------------------
Total                                                                  17 kB/s | 180 kB     00:10
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                              1/1
  Installing       : unzip-6.0-56.el9.x86_64                                                      1/1
  Running scriptlet: unzip-6.0-56.el9.x86_64                                                      1/1
  Verifying        : unzip-6.0-56.el9.x86_64                                                      1/1

Installed:
  unzip-6.0-56.el9.x86_64

Complete!
[vincent@vincent ~]$
```
```
[vincent@vincent ~]$ mv meow?inline=false meow
```
```
[vincent@vincent ~]$ file meow
```
```
[vincent@vincent ~]$ mv meow meow.zip
```
```
[vincent@vincent ~]$ unzip meow.zip
```


🌞 Dans le dossier dawa/, déterminer le chemin vers

```
[vincent@vincent ~]$ find dawa/ -size 15M
dawa/folder31/19/file39
```
```
[vincent@vincent dawa]$ find -name cookie
./folder14/25/cookie
```
```
[vincent@vincent dawa]$ find -name ".*"
.
./folder32/14/.hidden_file
```
```
[vincent@vincent dawa]$ find -newermt '2014-01-01 23:00' -not -newermt '2015-01-01 23:00'
./folder36/40/file43
```