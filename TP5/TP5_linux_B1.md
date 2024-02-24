Partie 1 : Script carte d'identité


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


🐚 hostnamectl



le nom de l'OS de la machine

regardez le fichier /etc/redhat-release ou /etc/os-release


🐚 source



la version du noyau Linux utilisé par la machine


🐚 uname



l'adresse IP de la machine


🐚 ip



l'état de la RAM


🐚 free

espace dispo en RAM (en Go, Mo, ou Ko)
taille totale de la RAM (en Go, Mo, ou Ko)


l'espace restant sur le disque dur, en Go (ou Mo, ou Ko)


🐚 df



le top 5 des processus qui pompent le plus de RAM sur la machine actuellement. Procédez par étape :


🐚 ps

listez les process
affichez la RAM utilisée par chaque process
triez par RAM utilisée
isolez les 5 premiers


la liste des ports en écoute sur la machine, avec le programme qui est derrière

préciser, en plus du numéro, s'il s'agit d'un port TCP ou UDP

🐚 ss

je vous recommande d'utiliser une syntaxe while read



la liste des dossiers disponibles dans la variable $PATH

un lien vers une image/gif random de chat


🐚 curl

il y a de très bons sites pour ça hihi
avec celui-ci par exemple, une simple requête HTTP vous retourne l'URL d'une random image de chat

une requête sur cette adresse retourne directement l'image, il faut l'enregistrer dans un fichier
parfois le fichier est un JPG, parfois un PNG, parfois même un GIF

🐚 file peut vous aider à déterminer le type de fichier





Pour vous faire manipuler les sorties/entrées de commandes, votre script devra sortir EXACTEMENT :

$ /srv/idcard/idcard.sh
Machine name : ...
OS ... and kernel version is ...
IP : ...
RAM : ... memory available on ... total memory
Disk : ... space left
Top 5 processes by RAM usage :
  - ...
  - ...
  - ...
  - ...
  - ...
Listening ports :
  - 22 tcp : sshd
  - ...
  - ...
PATH directories :
  - /usr/local/bin
  - ...
  - ...

Here is your random cat (jpg file) : ./cat.jpg



⚠️ Votre script doit fonctionner peu importe les conditions : peu importe le nom de la machine, ou son adresse IP (genre il est interdit de récupérer pile 10 char sous prétexte que ton adresse IP c'est 10.10.10.1 et qu'elle fait 10 char de long)


Rendu
📁 Fichier /srv/idcard/idcard.sh
🌞 Vous fournirez dans le compte-rendu Markdown, en plus du fichier, un exemple d'exécution avec une sortie

genre t'exécutes ton script et tu copie/colles ça dans le compte-rendu