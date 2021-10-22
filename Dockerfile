ARG version=latest

FROM node:14-alpine as BASE
WORKDIR /srv/screeps-server

RUN useradd --shell /bin/bash -u screeps -o -c "" -m screeps
RUN chown -R screeps:screeps /srv/screeps-server

RUN	apk add --no-cache --virtual .build-deps \
		build-base \
		gcc \
		g++ \
		curl \
		git \
		python \
		make

RUN npm --global config set user root

RUN	npm --global install \
	"screeps@${version}" \
	screepsmod-auth \
	screepsmod-features \
	screepsmod-mongo \
	screepsmod-admin-utils \
	screepsmod-dynamicmarket \
	screepsmod-cors \
	screepsmod-pvp-api \
	screepsmod-leaderboard \
	--cache /tmp/empty-cache; \
	apk del --no-cache .build-deps; \
	rm -fr /tmp/empty-cache /root/.cache /root/.config;

USER screeps

EXPOSE 21025 21026
CMD ["npx", "screeps", "start"]