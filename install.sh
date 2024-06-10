#!/bin/bash

cd "$(dirname "$0")"

DEST="${HOME}/.local/share/plasma/plasmoids/org.kde.plasma.audiodeviceswitcher-ng"

echo "Copying ${PWD}/package/"
echo "  to -> ${DEST}/"

rm -rf "${DEST}"
cp -a "package" "${DEST}"
