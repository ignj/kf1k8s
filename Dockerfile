FROM cm2network/steamcmd as base

FROM base as build
WORKDIR /home/steam/steamcmd/

ARG STEAM_USERNAME
ARG STEAM_PASSWORD

RUN ./steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD +force_install_dir ../killingfloor +app_update 215360 validate +quit

FROM build as publish
WORKDIR /home/steam/killingfloor/System

ENTRYPOINT ["./ucc-bin", "server KF-bioticslab.rom?game=KFmod.KFGameType?VACSecured=true?MaxPlayers=6", "-nohomedir"]