#!/bin/bash

/steam/install.sh

if [ ! -e "/ark/rcon_pass" ]; then
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1 > /ark/rcon_pass
	echo "No password configured in /ark/rcon_pass, created a new random one..."
fi

export RCON_PASSWORD=$(cat /ark/rcon_pass)

/ark/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?RCONEnabled=True?RCONPort=32330?ServerAdminPassword=${RCON_PASSWORD} -server -automanagedmods
