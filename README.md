# ark
Automated dedicated Ark: Survival Evolved server

## ToDo
**Planned features:**

* clusters with individual saves in save folder as data volume
* Configurable mod list 
* Configurable setting entries
* Auto-Restart on update rollout, with broadcast & delayed until no more players present
* Auto-Restart on mods update, with broadcast & delayed until no more players present

## Usage

### Start

In order to run the server, you should perform the following operations:

The `/ark/saved` folder is recommended to be a mounted in data location.

You will need to forward the following ports:

- 7778
- 7778/udp
- 27015
- 27015/udp
- 32330 (if you want rcon support, the password can be found in `/ark/rcon_pass`)

### Envs

- `SERVER_NAME` **must** be set to your desired server name (visible in the server browser)
- `DIFFICULTY` can be set to an `OverrideOfficialDifficulty` value, if so desired, otherwise it will not be used in the start command line
- `MAX_PLAYERS` can be set to change the maximum players allowed at the same time on the server (default 70)
- `BATTLE_EYE` can be set to any value besides `true` to disable it (default `true`)
- `RCON_HOST` must be set to the external IP/DNS that your server should be reachable on (the rcon server does not respond on localhost)
- `RCON_GAME_LOG_BUFFER` sets the max length of the game log via `?RCONServerGameLogBuffer` (default 100)
- `WHITELIST_USERS` can be set to a comma-separated list of [steamID64s](https://steamid.io/) which will initialize the `PlayersJoinNoCheckList.txt` file, if it does not exist yet, and set `-exclusivejoin`. To manage the whitelisted users you can use the RCON commands `AllowPlayerToJoinNoCheck <SteamID>` and `DisallowPlayerToJoinNoCheck <SteamID>`.
- `ADDITIONAL_COMMAND_LINE` can be set to all the additional server parameters (*if they are not already supported through another env*) you want to use on start-up, e.g. `?NonPermanentDiseases=true?PreventOfflinePvP=true -insecure -noantispeedhack`. The [Ark Gamepedia](http://ark.gamepedia.com/Server_Configuration) is probably a good source for this.

### Example

This is how I start my non-public Ark servers at the time of developing this image:

- `TBD`
