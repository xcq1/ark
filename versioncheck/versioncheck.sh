#!/bin/bash -xe

if [ "${AUTO_UPDATE}" != "true" ]; then
	exit
fi

API_VERSION=$(curl http://arkdedicated.com/version)
LOCAL_VERSION=$(cat /ark/version.txt)

if [ "${API_VERSION}" != "${LOCAL_VERSION}" ]; then
	echo "Newer version found, trying to update..."
	export RCON_PASSWORD=$(cat /ark/rcon_pass)

	PLAYERS=$(python playercheck.py)
	if [ "$PLAYERS" = "0" ]; then
		kill -SIGINT `pgrep ShooterGame`
	else
		python broadcast.py "Newer version found: ${API_VERSION} instead of ${LOCAL_VERSION}.\nWill auto-update once no more players on the server..."
	fi
fi
