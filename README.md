# ark
Automated dedicated Ark: Survival Evolved server

## ToDo
**Planned features:**

* Configurable user whitelist
* Configurable server start options, including clusters with individual saves
* Configurable setting entries
* Configurable mod list 
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

- `RCON_HOST` must be set to the external IP/DNS that your server should be reachable on (the rcon server does not respond on localhost)

