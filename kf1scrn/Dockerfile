FROM cm2network/steamcmd:root as base

FROM base as build
WORKDIR /home/steam/steamcmd/

ARG STEAM_USERNAME
ARG STEAM_PASSWORD

RUN ./steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD +force_install_dir ../killingfloor +app_update 215360 validate +quit

FROM build as configuration_tools_install

RUN apt-get update \
    && apt-get -y install python-pip p7zip-full \
    && pip install gdown

FROM configuration_tools_install as scrn_configuration
# KillingFloor.ini will be pulled with the other SCRN files
WORKDIR /home/steam/killingfloor

ARG SCRN_GDRIVE_ID
ARG SCRN_GDRIVE_FILE_NAME

RUN gdown https://drive.google.com/uc?id=$SCRN_GDRIVE_ID \
    && 7za x $SCRN_GDRIVE_FILE_NAME

FROM scrn_configuration as default_game_settings
WORKDIR /home/steam/killingfloor/System

ARG SERVERNAME
ARG GAME_PASSWORD

RUN sed -i "s/ServerName=Killing Floor Server/ServerName=$SERVERNAME/g" KillingFloor.ini \
    | sed -i "s/GamePassword=/GamePassword=$GAME_PASSWORD/g" KillingFloor.ini

FROM default_game_settings as publish
WORKDIR /home/steam/killingfloor/System

ARG GAME_ADMIN_NAME
ARG GAME_ADMIN_PASSWORD
ENV GAME_ADMIN_NAME_ENV=${GAME_ADMIN_NAME}
ENV GAME_ADMIN_PASSWORD_ENV=${GAME_ADMIN_PASSWORD}

ENTRYPOINT ./ucc-bin server KF-bioticslab.rom?game=KFmod.KFGameType?VACSecured=true?MaxPlayers=6?AdminName=${GAME_ADMIN_NAME_ENV}?AdminPassword=${GAME_ADMIN_PASSWORD_ENV} -nohomedir