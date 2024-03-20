#!/bin/bash
# Auteur: Vincent.B
# Date: 20/03/2024

TELECHARGEMENT_DIR="/srv/yt/downloads"
LOG_DIR="/var/log/yt"
LOG_FILE="${LOG_DIR}/download.log"
URL_FILE="/srv/yt/url_list.txt"  
CHECK_INTERVAL=60  

if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR" || { echo "Impossible de créer le répertoire des journaux : $LOG_DIR"; exit 1; }
fi

if ! command -v youtube-dl &> /dev/null; then
    echo "Erreur : youtube-dl n'est pas installé."
    exit 1
fi

while true; do
    if [ -s "$URL_FILE" ]; then  
        while IFS= read -r URL; do
            TITLE=$(youtube-dl --get-filename -o "%(title)s" "$URL" 2>/dev/null)
            SAFE_TITLE=$(echo "$TITLE" | sed 's/[\/:*?"<>|]/_/g')
            VIDEO_DIR="${TELECHARGEMENT_DIR}/${SAFE_TITLE}"
            VIDEO_PATH="${VIDEO_DIR}/${SAFE_TITLE}.mp4"

            mkdir -p "$VIDEO_DIR" || { echo "Impossible de créer le répertoire vidéo: $VIDEO_DIR"; exit 1; }

            if youtube-dl -o "$VIDEO_PATH" "$URL" &>/dev/null; then
                DATE=$(date "+%y/%m/%d %H:%M:%S")
                LOG_MESSAGE="[${DATE}] La video ${URL} a été téléchargée. Chemin du fichier : ${VIDEO_PATH}"
                echo "$LOG_MESSAGE" >> "$LOG_FILE"
                echo "Téléchargement réussi: $TITLE"
            else
                echo "Échec du téléchargement de la vidéo: $URL"
            fi
        done < "$URL_FILE"
        > "$URL_FILE"  
    fi
    sleep "$CHECK_INTERVAL"
done
