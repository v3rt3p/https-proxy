#!/bin/sh
set -eu

if [ "${NGINX_ENTRYPOINT_LOCAL_RESOLVERS:-}" ]; then
    NGINX_LOCAL_RESOLVERS=$(awk 'BEGIN { ORS=" " } $1 == "nameserver" { if ($2 ~ /:/) print "[" $2 "]"; else print $2 }' /etc/resolv.conf)
    NGINX_LOCAL_RESOLVERS=${NGINX_LOCAL_RESOLVERS% }
    export NGINX_LOCAL_RESOLVERS
fi

envsubst '${NGINX_LOCAL_RESOLVERS}' \
    < /etc/nginx/templates/nginx.conf.template \
    > /etc/nginx/nginx.conf

/app/generate.sh
exec nginx -g 'daemon off;'
