FROM xcq1/steamcmd-rcon
LABEL maintainer="mail@tobiaskuhn.de"

# set inherited variables

ENV STEAMID "376030"
ENV INSTALLDIR "/home/steam/ark/"

ENV RCON_HOST "localhost"
ENV RCON_PORT "32330"
ENV RCON_PASSWORD ""
ENV RCON_HEALTH_COMMAND "listplayers"
ENV RCON_HEALTH_REGEXP "(No Players|[0-9]\.)"

# auto-fetch the rcon password from /home/steam/ark/rcon_pass
USER root
RUN sed -i 's|python|export RCON_PASSWORD=$(cat /home/steam/ark/rcon_pass)\n&|' /home/steam/rcon/healthcheck.sh

# sudo so run.sh can start cron
RUN echo "steam   ALL=NOPASSWD:ALL" >> /etc/sudoers

# Ark stuff

ENV SERVER_NAME ""
ENV MAP_NAME "TheIsland"
ENV MOD_LIST ""
ENV DIFFICULTY ""
ENV MAX_PLAYERS "70"
ENV BATTLE_EYE "true"
ENV RCON_GAME_LOG_BUFFER "100"
ENV WHITELIST_PLAYERS ""
ENV ADDITIONAL_SERVER_COMMAND_LINE ""
ENV AUTO_UPDATE "true"
ENV SAVE_GAME_NAME ""
ENV CLUSTER_NAME ""

EXPOSE 7778
EXPOSE 7778/udp
EXPOSE 27015
EXPOSE 27015/udp
EXPOSE 32330

VOLUME /home/steam/ark/ShooterGame/Saved
STOPSIGNAL SIGINT
WORKDIR /home/steam/ark/

ADD run.sh /home/steam/ark/run.sh
RUN chmod +x /home/steam/ark/run.sh && \
	chown -R steam:steam /home/steam/ark

ADD versioncheck/versioncheck.sh /home/steam/ark/versioncheck/versioncheck.sh
ADD versioncheck/playercheck.py /home/steam/ark/versioncheck/playercheck.py
ADD versioncheck/broadcast.py /home/steam/ark/versioncheck/broadcast.py
RUN chmod +x /home/steam/ark/versioncheck/*

RUN apt update && \
	apt install -y cron && \
	apt clean
ADD versioncheck/crontab /etc/cron.d/ark-cron
RUN chmod +x /etc/cron.d/ark-cron

USER steam

CMD ["/ark/run.sh"]