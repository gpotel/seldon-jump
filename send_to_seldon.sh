#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="$1"
DESTINATION="$2"

SELDON_USER="potel"
SELDON_HOST="81.194.35.180"

if [ -z "${SELDON_PASSWORD:-}" ]; then
    echo "Erreur : SELDON_PASSWORD absent."
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Erreur : dossier source introuvable : $SOURCE_DIR"
    exit 1
fi

export SSHPASS="$SELDON_PASSWORD"

echo "Creation du dossier sur Seldon..."

sshpass -e ssh -o StrictHostKeyChecking=accept-new "$SELDON_USER@$SELDON_HOST" "mkdir -p '$DESTINATION'"

echo "Envoi vers Seldon..."

sshpass -e rsync -av -e "ssh -o StrictHostKeyChecking=accept-new" "$SOURCE_DIR/" "$SELDON_USER@$SELDON_HOST:$DESTINATION/"

echo "Nettoyage du Codespace..."

rm -rf "$SOURCE_DIR"

echo "Transfert termine."
