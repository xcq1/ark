#!/bin/bash

if [ -z "${SERVER_NAME}" ]; then
	echo "No server name configured, cannot start up without one."
	exit 1
fi

/home/steam/Steam/install.sh

# copy SteamCMD for workshop/automanagedmod support
if [ ! -e "/home/steam/ark/cmd_installed" ]; then
	mkdir -p /home/steam/ark/Engine/Binaries/ThirdParty/SteamCMD/Linux/
	cp -r /home/steam/Steam/* /home/steam/ark/Engine/Binaries/ThirdParty/SteamCMD/Linux/
	touch /home/steam/ark/cmd_installed
fi

# RCON password magic

if [ ! -e "/home/steam/ark/rcon_pass" ]; then
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1 > /home/steam/ark/rcon_pass
	echo "No password configured in /home/steam/ark/rcon_pass, created a new random one..."
fi

export RCON_PASSWORD=$(cat /home/steam/ark/rcon_pass)

# configure version checker magic

sudo sed -i "s/AUTO_UPDATE=$/AUTO_UPDATE=${AUTO_UPDATE}/" /home/steam/ark/versioncheck/versioncheck.sh
sudo sed -i "s/RCON_HOST=$/RCON_HOST=${RCON_HOST}/" /home/steam/ark/versioncheck/versioncheck.sh
sudo sed -i "s/RCON_PORT=$/RCON_PORT=${RCON_PORT}/" /home/steam/ark/versioncheck/versioncheck.sh

# parameter parsing

if [ -n "${MOD_LIST}" ]; then
	MOD_CMD="?GameModIds=${MOD_LIST}"
else
	MOD_CMD=""
fi

if [ "${BATTLE_EYE}" = "true" ]; then
	BATTLE_EYE_CMD="-UseBattleye"
else
	BATTLE_EYE_CMD="-NoBattlEye"
fi

if [ -n "${DIFFICULTY}" ]; then
	DIFFICULTY_CMD="?OverrideOfficialDifficulty=${DIFFICULTY}"
else
	DIFFICULTY_CMD=""
fi

if [ -n "${WHITELIST_PLAYERS}" ]; then	
	echo ${WHITELIST_PLAYERS} | sed 's/,/\n/g' > /home/steam/ark/ShooterGame/Binaries/Linux/PlayersJoinNoCheckList.txt
	WHITELIST_CMD="-exclusivejoin"
else
	rm -f /home/steam/ark/ShooterGame/Binaries/Linux/PlayersJoinNoCheckList.txt
	WHITELIST_CMD=""
fi

if [ -n "${SAVE_GAME_NAME}" ]; then
	SAVE_GAME_CMD="?AltSaveDirectoryName=${SAVE_GAME_NAME}"
else
	SAVE_GAME_CMD=""
fi

if [ -n "${CLUSTER_NAME}" ]; then
	CLUSTER_CMD="-NoTransferFromFiltering -clusterid=${CLUSTER_NAME}"
else
	CLUSTER_CMD=""
fi

sudo chmod -R o+rw /home/steam/ark/ShooterGame/Saved
cd ~/ark
python3 ark-moddodo-master/moddodo.py --modids ${MOD_LIST//,/ }

sudo service cron start

cd /home/steam/ark/ShooterGame/Binaries/Linux
set -x
exec /home/steam/ark/ShooterGame/Binaries/Linux/ShooterGameServer ${MAP_NAME}?listen${MOD_CMD}?SessionName=${SERVER_NAME}?Port=${PORT}?QueryPort=${QUERYPORT}?RCONEnabled=True?RCONPort=32330?ServerAdminPassword=${RCON_PASSWORD}?RCONServerGameLogBuffer=${RCON_GAME_LOG_BUFFER}?MaxPlayers=${MAX_PLAYERS}${DIFFICULTY_CMD}${SAVE_GAME_CMD}${ADDITIONAL_COMMAND_LINE} -server -servergamelog -log -automanagedmods ${WHITELIST_CMD} ${BATTLE_EYE_CMD} ${CLUSTER_CMD}
