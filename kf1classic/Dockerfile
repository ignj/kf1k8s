FROM cm2network/steamcmd:root as base

FROM base as build
WORKDIR /home/steam/steamcmd/

ARG STEAM_USERNAME
ARG STEAM_PASSWORD

RUN ./steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD +force_install_dir ../killingfloor +app_update 215360 validate +quit

FROM build as default_game_files
WORKDIR /home/steam/killingfloor/System

COPY ["./config_files/KillingFloor.ini", "./KillingFloor.ini"]

FROM default_game_files as default_game_settings
WORKDIR /home/steam/killingfloor/System

ARG SERVERNAME
ARG GAME_PASSWORD
# ARG GAME_DIFFICULTY
# ARG GAME_LENGTH
# ARG ENABLE_VOTING
# ARG REPEAT_LIMIT
# ARG DEFAULT_MAPLIST

RUN sed -i "s/ServerName=Killing Floor Server/ServerName=$SERVERNAME/g" KillingFloor.ini \
    && sed -i "s/GamePassword=/GamePassword=$GAME_PASSWORD/g" KillingFloor.ini \
    && sed -i "/[UWeb.WebServer]/,/bEnabled/s/bEnabled.*/bEnabled=True/" KillingFloor.ini
# RUN sed -i "s/RepeatLimit=/RepeatLimit=$REPEAT_LIMIT/g" KillingFloor.ini
# RUN sed -i "s/GameDifficulty/GameDifficulty=$GAME_DIFFICULTY/g" KillingFloor.ini
# RUN sed -i "s/KFGameLength/KFGameLength=$GAME_LENGTH/g" KillingFloor.ini
# RUN sed -i "s/bMapVote=/bMapVote=$ENABLE_VOTING/g" KillingFloor.ini
# RUN sed -i "s/bUseMapList=/bUseMapList=$DEFAULT_MAPLIST/g" KillingFloor.ini

FROM default_game_settings as custom_mutators_hook
WORKDIR /home/steam/killingfloor/System

# Remember to activate these through the WebAdmin page
# Mut Kill Message
ADD ./mutators/mut_kill_messages .

# All Traders Open
ADD ./mutators/all_traders_open .

# Map Vote Handler V2
ADD ./mutators/map_vote_v2 .
RUN sed -i "s/VotingHandlerType=xVoting.xVotingHandler/VotingHandlerType=KFMapVoteV2.KFVotingHandler/g" KillingFloor.ini

FROM custom_mutators_hook as publish
WORKDIR /home/steam/killingfloor/System

ARG GAME_ADMIN_NAME
ARG GAME_ADMIN_PASSWORD
ENV GAME_ADMIN_NAME_ENV=${GAME_ADMIN_NAME}
ENV GAME_ADMIN_PASSWORD_ENV=${GAME_ADMIN_PASSWORD}

ENTRYPOINT ./ucc-bin server KF-bioticslab.rom?game=KFmod.KFGameType?VACSecured=true?MaxPlayers=6?AdminName=${GAME_ADMIN_NAME_ENV}?AdminPassword=${GAME_ADMIN_PASSWORD_ENV} -nohomedir
