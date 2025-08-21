FROM alpine:3.14

RUN apk add --no-cache nginx

COPY nginx-conf/default.conf /etc/nginx/http.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
