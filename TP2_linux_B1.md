I. Fichiers

1. Find me
🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur

```
[vincent@vincent ~]$ cd ../
[vincent@vincent home]$ ls
toto  vincent
[vincent@vincent home]$
```

🌞 Trouver le chemin du fichier de logs SSH

```
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

```
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
```
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
```
[vincent@vincent home]$ cat /etc/passwd | grep marmotte
marmotte:x:1001:1001::/home/papier_alu/:/bin/bash
```



2. Infos enregistrées par le système
🌞 Prouver que cet utilisateur a été créé

```
[vincent@vincent home]$ cat /etc/passwd | grep marmotte
marmotte:x:1001:1001::/home/papier_alu/:/bin/bash
```


🌞 Déterminer le hash du password de l'utilisateur marmotte

```
[vincent@vincent home]$ sudo cat /etc/shadow | grep marmotte
[sudo] password for vincent:
marmotte:$6$zJdzTzacXaSulLJ0$mEPD6dcK6KxmIRAi2ATmsEiotBcmTvWYm4eB80O0Uk7vu6wRi5cWnwJYSiC6/ONxu0BAuPKVKQIBRQq0sxAiT.:19744:0:99999:7:::
[vincent@vincent home]$
```


3. Connexion sur le nouvel utilisateur
🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur

```
[vincent@vincent home]$ exit
logout
Connection to 10.7.1.10 closed.
PS C:\Users\vince> ssh vincent@10.7.1.10
vincent@10.7.1.10's password:
Last login: Mon Jan 22 10:47:33 2024 from 10.7.1.1
[vincent@vincent ~]$
```

🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte

```
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