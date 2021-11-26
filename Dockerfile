FROM alpine:3.10

RUN apk update && \
    apk add --no-cache ca-certificates caddy && \
    rm -rf /var/cache/apk/*

ADD run.sh /run.sh

RUN chmod 0755 /run.sh

CMD /run.sh
