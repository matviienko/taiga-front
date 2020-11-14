#!/bin/bash

# Sleep when asked to, to allow the database time to start
# before Taiga tries to run /checkdb.py below.
: ${TAIGA_SLEEP:=0}
sleep $TAIGA_SLEEP

# ls -la .
# npm ci && npx gulp deploy
# mkdir -p /usr/src/taiga-front-dist
# cp -r ./dist /usr/src/taiga-front-dist
# ln -s /taiga/conf.json /usr/src/taiga-front-dist/dist/conf.json
# mkdir -p /usr/src/taiga-front-dist/dist/js/
# ln -s /taiga/conf.json /usr/src/taiga-front-dist/dist/js/conf.json
# ls -la /usr/src/taiga-front-dist

ls -la /taiga
# Automatically replace "TAIGA_HOSTNAME" with the environment variable
sed -i "s/TAIGA_HOSTNAME/$TAIGA_HOSTNAME/g" /taiga/conf.json
ln -s /taiga/conf.json /tmp/taiga-front-dist/conf/conf.json
ls -la /tmp/taiga-front-dist/conf
cat /tmp/taiga-front-dist/conf/conf.json

ln -s /taiga/conf.json /tmp/taiga-front-dist/dist/conf.json
ls -la /tmp/taiga-front-dist/dist


# # Handle enabling/disabling SSL
# if [ "$TAIGA_SSL_BY_REVERSE_PROXY" = "True" ]; then
#   echo "Enabling external SSL support! SSL handling must be done by a reverse proxy or a similar system"
#   sed -i "s/http:\/\//https:\/\//g" /taiga/conf.json
#   sed -i "s/ws:\/\//wss:\/\//g" /taiga/conf.json
# elif [ "$TAIGA_SSL" = "True" ]; then
#   echo "Enabling SSL support!"
#   sed -i "s/http:\/\//https:\/\//g" /taiga/conf.json
#   sed -i "s/ws:\/\//wss:\/\//g" /taiga/conf.json
#   mv /etc/nginx/ssl.conf /etc/nginx/conf.d/default.conf
# elif grep -q "wss://" "/taiga/conf.json"; then
#   echo "Disabling SSL support!"
#   sed -i "s/https:\/\//http:\/\//g" /taiga/conf.json
#   sed -i "s/wss:\/\//ws:\/\//g" /taiga/conf.json
# fi

# Start nginx service (need to start it as background process)
# nginx -g "daemon off;"
# service nginx start

# Start Taiga backend Django server
exec "$@"
