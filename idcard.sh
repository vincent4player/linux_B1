#!/bin/bash
# Auteur: Vincent.B
# Date: 23/02/2024

# Fonction pour afficher les sections
display_section() {
    bold=$(tput bold)
    normal=$(tput sgr0)
    echo "${bold}============================="
    echo "$1"
    echo "=============================${normal}"
    echo "${normal}"
}
echo

# Nom de la machine :
display_section "Machine-name"
machine_name=$(hostnamectl --static)
echo "$machine_name"
echo

# Nom de l'OS :
display_section "OS_name"
if [ -f "/etc/redhat-release" ]; then
    os_name=$(cat /etc/redhat-release)
elif [ -f "/etc/os-release" ]; then
    source /etc/os-release
    os_name=$PRETTY_NAME
else
    os_name="Unknown"
fi
echo "$os_name"
echo

# Version du noyau :
display_section "Kernel_version"
kernel_version=$(uname -a)
echo "$kernel_version"
echo

# Adresse IP :
display_section "IP_adress"
ip_address=$(ip a | awk '/inet / && !/127.0.0.1/ {gsub("/.*", "", $2); print $2}')
echo "$ip_address"
echo

# RAM :
display_section "Ram_condition"
ram_info=$(free -m | awk '/Mem/{print "Used: " $3 " Mo, Available: " $7 " Mo, Total: " $2 " Mo"}')
echo "$ram_info"
echo

# Espace sur le disque dur :
display_section "Disk_info"
disk_info=$(df -h / | awk 'NR==2{print "Total space: " $2 ", Used space: " $3 ", Free space: " $4}')
echo "$disk_info"
echo

# Top 5 des processus consommant le plus de RAM :
display_section "Top 5 processes by RAM usage"
top_processes=$(ps -eo pid,comm,%mem --sort=-%mem | head -6 | awk 'NR>1{print $1, $2, $3"%"}')
echo "$top_processes"
echo

# Ports en écoute avec le programme derrière et le type de port :
display_section "Listening_ports"
listening_ports=$(ss -tuln | awk 'NR>1 {print " - " $5, $1}')
echo "$listening_ports"
echo

# Dossiers disponibles dans la variable $PATH :
display_section "PATH_directories"
echo $PATH | tr ':' '\n' | awk '{print " - " $1}'
echo

# "Lien vers une image"
display_section "link to a random cat image"
json_data=$(curl -s "https://api.thecatapi.com/v1/images/search")
url=$(echo "$json_data" | grep -o '"url":"[^"]*"' | cut -d '"' -f 4)
echo "$url"
echo