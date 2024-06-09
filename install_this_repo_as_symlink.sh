#!/bin/bash

cd "$(dirname "$0")"

DEST="${HOME}/.local/share/plasma/plasmoids/org.kde.plasma.audiodeviceswitcher-ng"

if [[ ! -e "${DEST}" ]] ; then
	echo "Creating symlink at ${DEST}"
	ln -sn "${PWD}/package" "${DEST}"
elif [[ -L "${DEST}" ]] ; then
	echo "Updating symlink at ${DEST}"
	ln -snf "${PWD}/package" "${DEST}"
else
	echo "Path already exists and isn't a symlink: ${DEST}"
	echo "Aborting to prevent unwanted data loss."
	exit 1
fi
