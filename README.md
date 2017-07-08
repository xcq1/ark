# ark
Automated dedicated Ark: Survival Evolved server

## ToDo
**Planned features:**

* Configurable mod list
* Configurable setting entries
* Auto-Restart on update rollout, with broadcast & delayed until no more players present
* Auto-Restart on mods update, with broadcast & delayed until no more players present

## Usage

### Start

In order to run the server, you should perform the following operations:

The save game folder `/ark/ShooterGame/Saved` is a data volume. You should either mount in a host path or a named Docker volume container, or else Docker will create a new volume container on every start.

You will need to publish the following ports:

- 7778
- 7778/udp
- 27015
- 27015/udp
- 32330 (if you want rcon support, the password can be found and/or replaced in `/ark/rcon_pass`)

### Envs

- `SERVER_NAME` **must** be set to your desired server name (visible in the server browser)
- `MAP_NAME` can be set to load a different map (default `TheIsland`), other options at the time of writing are the DLCs `TheCenter`, `ScorchedEarth_P` and `Ragnarok`
- `DIFFICULTY` can be set to an `OverrideOfficialDifficulty` value, if so desired, otherwise it will not be used in the start command line
- `MAX_PLAYERS` can be set to change the maximum players allowed at the same time on the server (default 70)
- `BATTLE_EYE` can be set to any value besides `true` to disable it (default `true`)
- `RCON_HOST` must be set to the external IP/DNS that your server should be reachable on (the rcon server does not respond on localhost)
- `RCON_GAME_LOG_BUFFER` sets the max length of the game log via `?RCONServerGameLogBuffer` (default 100)
- `WHITELIST_USERS` can be set to a comma-separated list of [steamID64s](https://steamid.io/) which will initialize the `PlayersJoinNoCheckList.txt` file, if it does not exist yet, and set `-exclusivejoin`. To manage the whitelisted users you can use the RCON commands `AllowPlayerToJoinNoCheck <SteamID>` and `DisallowPlayerToJoinNoCheck <SteamID>`.
- `ADDITIONAL_COMMAND_LINE` can be set to all the additional server parameters (*if they are not already supported through another env*) you want to use on start-up, e.g. `?NonPermanentDiseases=true?PreventOfflinePvP=true -insecure -noantispeedhack`. The [Ark Gamepedia](http://ark.gamepedia.com/Server_Configuration) is probably a good source for this.
- `SAVE_GAME_NAME` can be set to an individual save game name (useful mainly for clusters, game default is `SavedArks`)
- `CLUSTER_NAME` can be set to a cluster id (for `-clusterid`) so that you can join multiple servers in a cluster. This will also set `-NoTransferFromFiltering`. If you want to do this make sure that:
-- You have multiple servers running, e.g. by creating a local image via `docker commit` and starting multiple instances (so you don't have to re-download all game files)
-- All the servers have the same `CLUSTER_NAME` set
-- All the servers have the same data volume mounted in
-- All the servers have a distinct `SAVE_GAME_NAME` set
-- All the servers have the default ports in the container published to distinct ports on the host
-- AFAIK the servers do **not** need to share a network

### Example

This is how I start my non-public Ark servers at the time of developing this image:

- `TBD`
