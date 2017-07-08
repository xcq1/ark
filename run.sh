#!/bin/bash -x

if [ -z "${SERVER_NAME}" ]; then
	echo "No server name configured, cannot start up without one."
	exit 1
fi

/steam/install.sh

# RCON password magic

if [ ! -e "/ark/rcon_pass" ]; then
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1 > /ark/rcon_pass
	echo "No password configured in /ark/rcon_pass, created a new random one..."
fi

export RCON_PASSWORD=$(cat /ark/rcon_pass)

# parameter parsing

if [ "$BATTLE_EYE" = "true" ]; then
	BATTLE_EYE_CMD="-UseBattleye"
else
	BATTLE_EYE_CMD="-NoBattlEye"
fi

if [ -n "${DIFFICULTY}" ]; then
	DIFFICULTY_CMD="?OverrideOfficialDifficulty${DIFFICULTY}"
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

/ark/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?SessionName=${SERVER_NAME}?listen?RCONEnabled=True?RCONPort=32330?ServerAdminPassword=${RCON_PASSWORD}?RCONServerGameLogBuffer=${RCON_GAME_LOG_BUFFER}?MaxPlayers=${MAX_PLAYERS}${DIFFICULTY_CMD}${ADDITIONAL_SERVER_COMMAND_LINE} -server -servergamelog -automanagedmods ${WHITELIST_CMD} ${BATTLE_EYE_CMD}
