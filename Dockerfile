ARG version=latest

FROM node:14-alpine as BASE
WORKDIR /srv/screeps-server

RUN	apk add --no-cache --virtual .build-deps \
		build-base \
		gcc \
		g++ \
		curl \
		git \
		python3 \
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

FROM base

EXPOSE 21025 21026

CMD ["npx", "screeps", "start"]