FROM nginx:1.27-alpine

RUN apk add --no-cache openssl

WORKDIR /app
COPY certs/ certs/
COPY domains/ domains/
COPY generate.sh generate.sh
COPY nginx.conf nginx.conf

RUN chmod +x generate.sh && mkdir -p generated

EXPOSE 80 443

# Generate at startup so *_UPSTREAM_URL variables can be supplied at runtime.
CMD ["/bin/sh", "-c", "/app/generate.sh && exec nginx -g 'daemon off;' -c /app/nginx.conf"]
