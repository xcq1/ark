#!/bin/bash

if [ -z "${SERVER_NAME}" ]; then
	echo "No server name configured, cannot start up without one."
	exit 1
fi

/steam/install.sh

# copy SteamCMD for workshop/automanagedmod support
if [ ! -e "/ark/cmd_installed" ]; then
	mkdir -p /ark/Engine/Binaries/ThirdParty/SteamCMD/Linux/
	cp -r /steam/* /ark/Engine/Binaries/ThirdParty/SteamCMD/Linux/
	touch /ark/cmd_installed
fi

# RCON password magic

if [ ! -e "/ark/rcon_pass" ]; then
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1 > /ark/rcon_pass
	echo "No password configured in /ark/rcon_pass, created a new random one..."
fi

export RCON_PASSWORD=$(cat /ark/rcon_pass)

# configure version checker magic

sed -i "s/AUTO_UPDATE=/AUTO_UPDATE=${AUTO_UPDATE}/" /ark/versioncheck/versioncheck.sh
sed -i "s/RCON_HOST=/RCON_HOST=${RCON_HOST}/" /ark/versioncheck/versioncheck.sh
sed -i "s/RCON_PASS=/RCON_PASS=${RCON_PASS}/" /ark/versioncheck/versioncheck.sh

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
	echo ${WHITELIST_PLAYERS} | sed 's/,/\n/g' > /ark/ShooterGame/Binaries/Linux/PlayersJoinNoCheckList.txt
	WHITELIST_CMD="-exclusivejoin"
else
	rm -f /ark/ShooterGame/Binaries/Linux/PlayersJoinNoCheckList.txt
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

cd /ark/ShooterGame/Binaries/Linux
set -x
exec /ark/ShooterGame/Binaries/Linux/ShooterGameServer ${MAP_NAME}?listen${MOD_CMD}?SessionName=${SERVER_NAME}?RCONEnabled=True?RCONPort=32330?ServerAdminPassword=${RCON_PASSWORD}?RCONServerGameLogBuffer=${RCON_GAME_LOG_BUFFER}?MaxPlayers=${MAX_PLAYERS}${DIFFICULTY_CMD}${SAVE_GAME_CMD}${ADDITIONAL_SERVER_COMMAND_LINE} -server -servergamelog -log -automanagedmods ${WHITELIST_CMD} ${BATTLE_EYE_CMD} ${CLUSTER_CMD}
