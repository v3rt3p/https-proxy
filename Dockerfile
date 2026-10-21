FROM alpine:3.22 AS generator

RUN apk add --no-cache openssl

WORKDIR /build
COPY certs/ certs/
COPY domains/ domains/
COPY generate.sh generate.sh

RUN chmod +x generate.sh && NGINX_ROOT=/app ./generate.sh

FROM nginx:1.27-alpine

WORKDIR /app
COPY nginx.conf /app/nginx.conf
COPY --from=generator /build/generated /app/generated

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;", "-c", "/app/nginx.conf"]
