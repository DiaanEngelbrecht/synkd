# Synkd Development Docker Image

# To build run:
#	docker build -t diaan/synkd:dev ./

FROM elixir:1.12.1
LABEL "maintainer"="Diaan Engelbrecht" "appname"="Synkd"

RUN apt update && \
apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates inotify-tools \
&& rm -rf /var/cache/apk/*

RUN addgroup --gid 1000 --system synkd_group && adduser --system --uid 1000 synkd_user --ingroup synkd_group

ENV APP_HOME /home/synkd_user/synkd
RUN mkdir $APP_HOME
COPY ./ $APP_HOME

RUN chown -R 1000:1000 $APP_HOME

USER synkd_user

WORKDIR $APP_HOME

RUN mix local.hex --force && \
mix archive.install hex phx_new 1.5.0 --force && \
mix local.rebar --force

RUN mix deps.clean --all && mix deps.get && mix deps.compile

CMD mix ecto.setup && mix phx.server

