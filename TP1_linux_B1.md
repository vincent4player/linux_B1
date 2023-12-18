2. Fichier
🌞 Supprimer des fichiers

rendre la machine complètement foutue en supprimant des fichiers
y'a moyen de la rendre inopérante en supprimant juste un seul fichier ou deux
y'en a plein qui sont super critiques, faites-vos recherches !

```
[vincent@localhost /]$ ls
afs  boot  etc   lib    media  opt   root  sbin  sys  usr
bin  dev   home  lib64  mnt    proc  run   srv   tmp  var
```
```
[vincent@localhost /]$ cd boot
```
```
[vincent@localhost boot]$ ls
config-5.14.0-70.13.1.el9_0.x86_64
efi
grub2
initramfs-0-rescue-3433e2fe435a4886bc957150da17bbff.img
initramfs-5.14.0-70.13.1.el9_0.x86_64.img
loader
symvers-5.14.0-70.13.1.el9_0.x86_64.gz
System.map-5.14.0-70.13.1.el9_0.x86_64
⭐vmlinuz-0-rescue-3433e2fe435a4886bc957150da17bbff⭐
⭐vmlinuz-5.14.0-70.13.1.el9_0.x86_64⭐
```
```
```
[vincent@localhost boot]$ ⭐sudo rm vmlinuz-0-rescue-3433e2fe435a4886bc957150da17bbff⭐
[sudo] password for vincent:
```
```
[vincent@localhost boot]$ ls
config-5.14.0-70.13.1.el9_0.x86_64                       loader
efi                                                      symvers-5.14.0-70.13.1.el9_0.x86_64.gz
grub2                                                    System.map-5.14.0-70.13.1.el9_0.x86_64
initramfs-0-rescue-3433e2fe435a4886bc957150da17bbff.img  vmlinuz-5.14.0-70.13.1.el9_0.x86_64
initramfs-5.14.0-70.13.1.el9_0.x86_64.img
```
```
[vincent@localhost boot]$ ⭐sudo rm vmlinuz-5.14.0-70.13.1.el9_0.x86_64⭐
```
```
[vincent@localhost boot]$ ls
config-5.14.0-70.13.1.el9_0.x86_64                       initramfs-5.14.0-70.13.1.el9_0.x86_64.img
efi                                                      loader
grub2                                                    symvers-5.14.0-70.13.1.el9_0.x86_64.gz
initramfs-0-rescue-3433e2fe435a4886bc957150da17bbff.img  System.map-5.14.0-70.13.1.el9_0.x86_64
```
3. Utilisateurs
🌞 Mots de passe

changez le mot de passe de tous les utilisateurs qui en ont déjà un
trouvez donc un moyen de lister les utilisateurs, et trouver ceux qui ont déjà un mot de passe
```
[vincent@localhost ~]$ sudo awk -F: '$2 ~ /^[^!*]/ {print $1}' /etc/shadow
root
vincent
```

```
[vincent@localhost ~]$ users_with_password=$(sudo awk -F: '$2 ~ /^[^!*]/ {print $1}' /etc/shadow)

for user in $users_with_password; do
    sudo passwd $user
done
[sudo] password for vincent:
Changing password for user root.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
Sorry, passwords do not match.
New password:
Retype new password:
Sorry, passwords do not match.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
passwd: all authentication tokens updated successfully.
Changing password for user vincent.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
passwd: all authentication tokens updated successfully.
```

🌞 Another way ?

sans toucher aux mots de passe, faites en sorte qu'aucun utilisateur ne soit utilisable
trouver un autre moyen donc, en restant sur les utilisateurs !

```
[vincent@localhost ~]$ for user in $(cut -d: -f1 /etc/passwd); do
    sudo usermod --shell /usr/sbin/nologin $user
done
[sudo] password for vincent:
```
```
[vincent@localhost ~]$ grep '/usr/sbin/nologin' /etc/passwd
root:x:0:0:root:/root:/usr/sbin/nologin
bin:x:1:1:bin:/bin:/usr/sbin/nologin
daemon:x:2:2:daemon:/sbin:/usr/sbin/nologin
adm:x:3:4:adm:/var/adm:/usr/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/usr/sbin/nologin
sync:x:5:0:sync:/sbin:/usr/sbin/nologin
shutdown:x:6:0:shutdown:/sbin:/usr/sbin/nologin
halt:x:7:0:halt:/sbin:/usr/sbin/nologin
mail:x:8:12:mail:/var/spool/mail:/usr/sbin/nologin
operator:x:11:0:operator:/root:/usr/sbin/nologin
games:x:12:100:games:/usr/games:/usr/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/usr/sbin/nologin
nobody:x:65534:65534:Kernel Overflow User:/:/usr/sbin/nologin
systemd-coredump:x:999:997:systemd Core Dumper:/:/usr/sbin/nologin
dbus:x:81:81:System message bus:/:/usr/sbin/nologin
tss:x:59:59:Account used for TPM access:/dev/null:/usr/sbin/nologin
sssd:x:998:995:User for sssd:/:/usr/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/usr/share/empty.sshd:/usr/sbin/nologin
chrony:x:997:994::/var/lib/chrony:/usr/sbin/nologin
systemd-oom:x:992:992:systemd Userspace OOM Killer:/:/usr/sbin/nologin
vincent:x:1000:1000:vincent:/home/vincent:/usr/sbin/nologin
tcpdump:x:72:72::/:/usr/sbin/nologin
```
```
[vincent@localhost ~]$ su - testuser
⭐su: user testuser does not exist or the user entry does not contain all the required fields⭐
[vincent@localhost ~]$
```


4. Disques
🌞 Effacer le contenu du disque dur

ici on parle pas de toucher aux fichiers et dossiers qui existent au sein du disque dur de la VM
mais de toucher directement au disque dur
essayez de remplir le disque de zéros


```
[vincent@localhost ~]$ sudo dd if=/dev/zero of=/dev/sdX bs=4M status=progress
[sudo] password for vincent:
dd: error writing '/dev/sdX': No space left on device
116+0 records in
115+0 records out
483094528 bytes (483 MB, 461 MiB) copied, 0.643623 s, 751 MB/s
[vincent@localhost ~]$ df -h
Filesystem           Size  Used Avail Use% Mounted on
devtmpfs             461M  461M     0 100% /dev
tmpfs                481M     0  481M   0% /dev/shm
tmpfs                193M  2.9M  190M   2% /run
/dev/mapper/rl-root   17G  1.2G   16G   7% /
/dev/sda1           1014M  166M  849M  17% /boot
tmpfs                 97M     0   97M   0% /run/user/1000
[vincent@localhost ~]$ sudo dd if=/dev/zero of=/dev/mapper/rl-root bs=4M status=progress
18111004672 bytes (18 GB, 17 GiB) copied, 91 s, 199 MB/s
dd: error writing '/dev/mapper/rl-root': No space left on device
4352+0 records in
4351+0 records out
18249416704 bytes (18 GB, 17 GiB) copied, 91.6934 s, 199 MB/s
Segmentation fault
[vincent@localhost ~]$ df -h
⭐-bash: /usr/bin/df: Input/output error⭐
```

5. Malware
🌞 Reboot automatique

faites en sorte que si un utilisateur se connecte, ça déclenche un reboot automatique de la machine
```
[vincent@localhost ~]$ nano ~/.bashrc

# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
        for rc in ~/.bashrc.d/*; do
                if [ -f "$rc" ]; then
                        . "$rc"
                fi
        done
fi

unset rc


⭐sudo reboot⭐
```

6. You own way
🌞 Trouvez 4 autres façons de détuire la machine

tout doit être fait depuis le terminal de la machine
pensez à ce qui constitue un ordi/un OS
l'idée c'est de supprimer des trucs importants, modifier le comportement de trucs existants, surcharger tel ou tel truc...





