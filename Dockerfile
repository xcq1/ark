FROM xcq1/steamcmd-rcon
LABEL maintainer="mail@tobiaskuhn.de"

# set inherited variables

ENV STEAMID "376030"
ENV INSTALLDIR "/ark/"

ENV RCON_HOST "localhost" # this needs to be set to the external IP on run
ENV RCON_PORT "32330"
ENV RCON_PASSWORD "" # will be read in from /ark/rcon_pass
ENV RCON_HEALTH_COMMAND "listplayers"
ENV RCON_HEALTH_REGEXP "(No players|[0-9]\.)"

WORKDIR /ark/

ADD run.sh /ark/run.sh

CMD ["/ark/run.sh"]