FROM xcq1/steamcmd-rcon
LABEL maintainer="mail@tobiaskuhn.de"

# set inherited variables

ENV STEAMID "376030"
ENV INSTALLDIR "/ark/"

ENV RCON_HOST "localhost"
ENV RCON_PORT "32330"
ENV RCON_PASSWORD ""
ENV RCON_HEALTH_COMMAND "listplayers"
ENV RCON_HEALTH_REGEXP "(No Players|[0-9]\.)"

# auto-fetch the rcon password from /ark/rcon_pass
RUN sed -i 's|python|export RCON_PASSWORD=$(cat /ark/rcon_pass)\n&|' /rcon/healthcheck.sh

# Ark stuff

ENV SERVER_NAME ""
ENV MAP_NAME "TheIsland"
ENV MOD_LIST ""
ENV DIFFICULTY ""
ENV MAX_PLAYERS "70"
ENV BATTLE_EYE "true"
ENV RCON_GAME_LOG_BUFFER "100"
ENV WHITELIST_USERS ""
ENV ADDITIONAL_SERVER_COMMAND_LINE ""
ENV SAVE_GAME_NAME ""
ENV CLUSTER_NAME ""

EXPOSE 7778
EXPOSE 7778/udp
EXPOSE 27015
EXPOSE 27015/udp
EXPOSE 32330

VOLUME /ark/ShooterGame/Saved

WORKDIR /ark/

ADD run.sh /ark/run.sh

RUN chmod +x /ark/run.sh

CMD ["/ark/run.sh"]