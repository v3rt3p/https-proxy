FROM nginx:1.27-alpine

RUN apk add --no-cache openssl

WORKDIR /app
COPY certs/ certs/
COPY domains/ domains/
COPY generate.sh generate.sh
COPY nginx.conf /etc/nginx/templates/nginx.conf.template

RUN chmod +x generate.sh && mkdir -p generated

EXPOSE 80 443

# The official entrypoint discovers /etc/resolv.conf nameservers and renders the template.
ENV NGINX_ENTRYPOINT_LOCAL_RESOLVERS=true
ENV NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx

# Generate at startup so *_UPSTREAM_URL variables can be supplied at runtime.
CMD ["/bin/sh", "-c", "/app/generate.sh && exec nginx -g 'daemon off;'"]
