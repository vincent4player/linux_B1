#!/bin/bash
# Auteur: Vincent.B
# Date: 05/03/2024


URL="$1"
TELECHARGEMENT_DIR="/srv/yt/downloads"
LOG_DIR="/var/log/yt"
LOG_FILE="${LOG_DIR}/download.log"


if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR" || { echo "Impossible de créer le répertoire des journaux : $LOG_DIR"; exit 1; }
fi

# Bon url?
if [ -z "$URL" ]; then
    echo "Erreur : aucune URL fournie."
    exit 1
fi

# verifié si ytb est installé
if ! command -v youtube-dl &> /dev/null; then
    echo "Erreur : youtube-dl n'est pas installé."
    exit 1
fi

# Récupérer titre video
TITLE=$(youtube-dl --get-filename -o "%(title)s" "$URL" 2>/dev/null)


SAFE_TITLE=$(echo "$TITLE" | sed 's/[\/:*?"<>|]/_/g')

VIDEO_DIR="${TELECHARGEMENT_DIR}/${SAFE_TITLE}"
VIDEO_PATH="${VIDEO_DIR}/${SAFE_TITLE}.mp4"

# Create the download directory if it doesn't exist
mkdir -p "$VIDEO_DIR" || { echo "Impossible de créer le répertoire vidéo: $VIDEO_DIR"; exit 1; }

# Telecharger video
if youtube-dl -o "$VIDEO_PATH" "$URL" &>/dev/null; then
    
    DATE=$(date "+%y/%m/%d %H:%M:%S")
    LOG_MESSAGE="[${DATE}] La video ${URL} a été téléchargé. Chemin du fichier : ${VIDEO_PATH}"

    
    echo "$LOG_MESSAGE" >> "$LOG_FILE"
    
    
    echo "Téléchargement réussi: $TITLE"
    echo "Lien de la vidéo: $URL"
    echo "Le fichier est stocké dans: $VIDEO_PATH"
else
    echo "Échec du téléchargement de la vidéo: $URL"
    exit 1
fi
