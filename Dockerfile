FROM nginx:1.27-alpine

RUN apk add --no-cache openssl

WORKDIR /app
COPY certs/ certs/
COPY domains/ domains/
COPY generate.sh generate.sh
COPY start.sh start.sh
COPY nginx.conf /etc/nginx/templates/nginx.conf.template

RUN chmod +x generate.sh start.sh && mkdir -p generated && rm -f /etc/nginx/conf.d/default.conf

EXPOSE 80 443

# Generate at startup so *_UPSTREAM_URL variables can be supplied at runtime.
ENV NGINX_ENTRYPOINT_LOCAL_RESOLVERS=true

CMD ["/app/start.sh"]
