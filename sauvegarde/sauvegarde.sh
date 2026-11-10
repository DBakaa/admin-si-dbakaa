#!/bin/bash
# Sauvegarde quotidienne de SRV-WEB01 : /srv/partage, /home et /etc
set -euo pipefail
DEST=/var/backups/sauvegarde
JOUR=$(date +%F)
for SRC in /srv/partage /home /etc; do
    mkdir -p "$DEST/$JOUR$SRC"
    rsync -aAXH --delete "$SRC/" "$DEST/$JOUR$SRC/"
done
# On garde 7 jours de sauvegardes
find "$DEST" -mindepth 1 -maxdepth 1 -type d -mtime +7 -exec rm -rf {} +
echo "Sauvegarde $JOUR terminee"
