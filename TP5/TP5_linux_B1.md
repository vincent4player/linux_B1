
Partie 1 : Script carte d'identité.

```
[vincent@localhost srv]$ sudo mkdir idcard
[sudo] password for vincent:
[vincent@localhost srv]$ ls
idcard  test.sh
[vincent@localhost srv]$ cd idcard/
[vincent@localhost idcard]$ sudo touch idcard.sh
[vincent@localhost idcard]$ ls
idcard.sh
```

```
=============================
Machine-name
=============================

TP5linuxB1

=============================
OS_name
=============================

Rocky Linux release 9.0 (Blue Onyx)

=============================
Kernel_version
=============================

Linux TP5linuxB1 5.14.0-70.13.1.el9_0.x86_64 #1 SMP PREEMPT Wed May 25 21:01:57 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

=============================
IP_adress
=============================

10.7.1.10
10.0.3.15

=============================
Ram_condition
=============================

Used: 173 Mo, Available: 648 Mo, Total: 960 Mo

=============================
Disk_info
=============================

Total space: 17G, Used space: 1.2G, Free space: 16G

=============================
Top 5 processes by RAM usage
=============================

685 firewalld 3.9%
703 NetworkManager 2.1%
1 systemd 1.5%
818 systemd 1.3%
688 systemd-logind 1.2%

=============================
Listening_ports
=============================

 - 127.0.0.1:323 udp
 - [::1]:323 udp
 - 0.0.0.0:22 tcp
 - [::]:22 tcp

=============================
PATH_directories
=============================

 - /home/vincent/.local/bi
 - /home/vincent/bin
 - /usr/local/bin
 - /usr/bin
 - /usr/local/sbin
 - /usr/sbin

=============================
link to a random cat image
=============================

https://cdn2.thecatapi.com/images/MTczMDk2Nw.jpg
```


II. Script youtube-dl



voir yt.sh
```
[vincent@TP5linuxB1 yt]$ /srv/yt/yt.sh "https://www.youtube.com/watch?v=jBdTpDCs7X0"
Téléchargement réussi: L’entreprise qui détrône Google et bouleverse l’humanité (Nvidia)
Lien de la vidéo: https://www.youtube.com/watch?v=jBdTpDCs7X0
Le fichier est stocké dans: /srv/yt/downloads/L’entreprise qui détrône Google et bouleverse l’humanité (Nvidia)/L’entreprise qui détrône Google et bouleverse l’humanité (Nvidia).mp4
[vincent@TP5linuxB1 yt]$
```

logs:
```
[24/03/20 10:56:38] Video https://www.youtube.com/watch?v=jBdTpDCs7X0 was downloaded. File path : /srv/yt/downloads/L’entreprise qui détrône Google et bouleverse l’humanité (Nvidia)/L’entreprise qui détrône Google et bouleverse l’humanité (Nvidia).mp4
[24/03/20 11:00:42] Video https://www.youtube.com/watch?v=jBdTpDCs7X0 was downloaded. File path : /srv/yt/downloads/L’entreprise qui détrône Google et bouleverse l’humanité (Nvidia)/L’entreprise qui détrône Google et bouleverse l’humanité (Nvidia).mp4
[24/03/20 11:02:21] Video https://www.youtube.com/watch?v=XzwhZfw2gUo was downloaded. File path : /srv/yt/downloads/Le plan de Poutine, la réponse à Emmanuel Macron/Le plan de Poutine, la réponse à Emmanuel Macron.mp4
[24/03/20 11:03:02] Video https://www.youtube.com/watch?v=jUz0MKf0RJs was downloaded. File path : /srv/yt/downloads/La France est-elle encore une grande puissance  (Mappemonde Ep. 7, avec François Hollande)/La France est-elle encore une grande puissance  (Mappemonde Ep. 7, avec François Hollande).mp4
```

2. MAKE IT A SERVICE

```
[vincent@TP5linuxB1 yt]$ sudo nano /etc/systemd/system/yt.service
[vincent@TP5linuxB1 yt]$ sudo systemctl daemon-reload
[vincent@TP5linuxB1 yt]$ systemctl status yt
○ yt.service - Téléchargement de vidéos YouTube en batch
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: disabled)
     Active: inactive (dead)
[vincent@TP5linuxB1 yt]$ sudo systemctl start yt
[vincent@TP5linuxB1 yt]$ systemctl status yt
● yt.service - Téléchargement de vidéos YouTube en batch
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: disabled)
     Active: active (running) since Wed 2024-03-20 11:33:25 CET; 6s ago
   Main PID: 1485 (yt-v2.sh)
      Tasks: 2 (limit: 5896)
     Memory: 632.0K
        CPU: 7ms
     CGroup: /system.slice/yt.service
             ├─1485 /bin/bash /srv/yt/yt-v2.sh
             └─1486 sleep 60

Mar 20 11:33:25 TP5linuxB1 systemd[1]: Started Téléchargement de vidéos YouTube en batch.
[vincent@TP5linuxB1 yt]$ sudo systemctl stop yt
[vincent@TP5linuxB1 yt]$

[vincent@TP5linuxB1 yt]$ journalctl -xe -u yt
~
~
~
~
~
~
~
~
~
~
~
~
~
~
Mar 20 11:33:25 TP5linuxB1 systemd[1]: Started Téléchargement de vidéos YouTube en batch.
░░ Subject: A start job for unit yt.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit yt.service has finished successfully.
░░
░░ The job identifier is 1157.
Mar 20 11:33:48 TP5linuxB1 systemd[1]: Stopping Téléchargement de vidéos YouTube en batch...
░░ Subject: A stop job for unit yt.service has begun execution
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A stop job for unit yt.service has begun execution.
░░
░░ The job identifier is 1243.
Mar 20 11:33:48 TP5linuxB1 systemd[1]: yt.service: Deactivated successfully.
░░ Subject: Unit succeeded
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ The unit yt.service has successfully entered the 'dead' state.
Mar 20 11:33:48 TP5linuxB1 systemd[1]: Stopped Téléchargement de vidéos YouTube en batch.
░░ Subject: A stop job for unit yt.service has finished
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A stop job for unit yt.service has finished.
░░
░░ The job identifier is 1243 and the job result is done.
Mar 20 11:39:23 TP5linuxB1 systemd[1]: Started Téléchargement de vidéos YouTube en batch.
░░ Subject: A start job for unit yt.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit yt.service has finished successfully.
░░
░░ The job identifier is 1244.
[vincent@TP5linuxB1 yt]$
```