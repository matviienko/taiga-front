FROM python:3.6
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /tmp
###
RUN set -x; apt-get update
RUN apt-get install -y nodejs npm nginx
RUN npm install -g gulp npm@latest
RUN apt-get install -y --no-install-recommends \
        locales \
        gettext \
        ca-certificates \
        # nginx=${NGINX_VERSION} \
    && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales
###
ENV TAIGA_HOSTNAME localhost
ENV TAIGA_FRONT_HOSTNAME=$TAIGA_HOSTNAME
ARG TAIGA_SCRIPT_REPOSITORY=git@github.com:taigaio/taiga-scripts.git
###
ARG TAIGA_BACK_REPOSITORY=git@github.com:taigaio/taiga-back.git
ENV TAIGA_BACK_REPOSITORY=$TAIGA_BACK_REPOSITORY
ARG TAIGA_BACK_BRANCH=stable
ENV TAIGA_BACK_BRANCH=$TAIGA_BACK_BRANCH
###
ARG TAIGA_FRONT_DIST_REPOSITORY=git@github.com:taigaio/taiga-front-dist.git
ENV TAIGA_FRONT_DIST_REPOSITORY=$TAIGA_FRONT_DIST_REPOSITORY
ARG TAIGA_FRONT_DIST_BRANCH=stable
ENV TAIGA_FRONT_DIST_BRANCH=$TAIGA_FRONT_DIST_BRANCH
###
ARG TAIGA_FRONT_REPOSITORY=git@github.com:taigaio/taiga-front.git
ENV TAIGA_FRONT_REPOSITORY=$TAIGA_FRONT_REPOSITORY
ARG TAIGA_FRONT_BRANCH=stable
ENV TAIGA_FRONT_BRANCH=$TAIGA_FRONT_BRANCH
###
ENV TAIGA_SSL False
ENV TAIGA_SSL_BY_REVERSE_PROXY False
ENV TAIGA_ENABLE_EMAIL False
ENV TAIGA_SECRET_KEY "!!!REPLACE-ME-j1598u1J^U*(y251u98u51u5981urf98u2o5uvoiiuzhlit3)!!!"
###
# RUN git clone -b ${TAIGA_FRONT_BRANCH} ${TAIGA_FRONT_REPOSITORY} taiga-front-dist
# RUN cd ./taiga-front-dist && npm ci && npx gulp deploy
# RUN mkdir -p /usr/src/taiga-front-dist && cp -r ./taiga-front-dist/dist /usr/src/taiga-front-dist
###
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
###
COPY . taiga-front-dist
###
RUN mkdir -p /taiga
COPY docker/conf/taiga/conf.json /taiga/conf.json
###
COPY docker/conf/locale.gen /etc/locale.gen
COPY docker/conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/conf/nginx/taiga.conf /etc/nginx/conf.d/default.conf
COPY docker/conf/nginx/ssl.conf /etc/nginx/ssl.conf
COPY docker/conf/nginx/taiga-events.conf /etc/nginx/taiga-events.conf
COPY docker/docker-entrypoint.sh /docker-entrypoint.sh
###
WORKDIR /tmp/taiga-front-dist
RUN npm install
# WORKDIR /usr/src/taiga-front-dist
EXPOSE 80 443
# VOLUME /usr/src/taiga-back/media
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["npm", "start"]
