


Partie 1 : Script carte d'identité

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


Rendu
📁 Fichier /srv/idcard/idcard.sh
🌞 Vous fournirez dans le compte-rendu Markdown, en plus du fichier, un exemple d'exécution avec une sortie




1. Premier script youtube-dl


B. Rendu attendu
📁 Le script /srv/yt/yt.sh
📁 Le fichier de log /var/log/yt/download.log, avec au moins quelques lignes
🌞 Vous fournirez dans le compte-rendu, en plus du fichier, un exemple d'exécution avec une sortie

comme pour le script précédent : juste tu le lances, et tu cme copie/colles ça dans le rendu


2. MAKE IT A SERVICE

A. Adaptation du script
YES. Yet again. On va en faire un service.
L'idée :
➜ plutôt que d'appeler la commande à la main quand on veut télécharger une vidéo, on va créer un service qui les téléchargera pour nous
➜ le service s'exécute en permanence en tâche de fond

il surveille un fichier précis
s'il trouve une nouvelle ligne dans le fichier, il vérifie que c'est bien une URL de vidéo youtube

si oui, il la télécharge, puis enlève la ligne
sinon, il enlève juste la ligne



➜ qui écrit dans le fichier pour ajouter des URLs ? Bah vous !

vous pouvez écrire une liste d'URL, une par ligne, et le service devra les télécharger une par une


Pour ça, procédez par étape :


partez de votre script précédent (gardez une copie propre du premier script, qui doit être livré dans le dépôt git)

le nouveau script s'appellera yt-v2.sh




adaptez-le pour qu'il lise les URL dans un fichier plutôt qu'en argument sur la ligne de commande

faites en sorte qu'il tourne en permanence, et vérifie le contenu du fichier toutes les X secondes

boucle infinie qui :

lit un fichier
effectue des actions si le fichier n'est pas vide
sleep pendant une durée déterminée





il doit marcher si on précise une vidéo par ligne

il les télécharge une par une
et supprime les lignes une par une




B. Le service
➜ une fois que tout ça fonctionne, enfin, créez un service qui lance votre script :

créez un fichier /etc/systemd/system/yt.service. Il comporte :

une brève description
un ExecStart pour indiquer que ce service sert à lancer votre script
une clause User= pour indiquer que c'est l'utilisateur yt qui lance le script

créez l'utilisateur s'il n'existe pas
faites en sorte que le dossier /srv/yt et tout son contenu lui appartienne
le dossier de log doit lui appartenir aussi
l'utilisateur yt ne doit pas pouvoir se connecter sur la machine






[Unit]
Description=<Votre description>

[Service]
ExecStart=<Votre script>
User=yt

[Install]
WantedBy=multi-user.target



Pour rappel, après la moindre modification dans le dossier /etc/systemd/system/, vous devez exécuter la commande sudo systemctl daemon-reload pour dire au système de lire les changements qu'on a effectué.

Vous pourrez alors interagir avec votre service à l'aide des commandes habituelles systemctl :

systemctl status yt
sudo systemctl start yt
sudo systemctl stop yt



C. Rendu
📁 Le script /srv/yt/yt-v2.sh
📁 Fichier /etc/systemd/system/yt.service
🌞 Vous fournirez dans le compte-rendu, en plus des fichiers :

un systemctl status yt quand le service est en cours de fonctionnement
un extrait de journalctl -xe -u yt



Hé oui les commandes journalctl fonctionnent sur votre service pour voir les logs ! Et vous devriez constater que c'est vos echo qui pop. En résumé, le STDOUT de votre script, c'est devenu les logs du service !