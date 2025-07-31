FROM alpine:3.14

RUN echo "hello from apline nginx image"

RUN apk add --no-cache nginx

RUN ls /usr/share/nginx/ && ls /etc/nginx/

EXPOSE 7000

CMD ["nginx", "-g", "daemon off;"]
