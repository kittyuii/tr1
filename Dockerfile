FROM alpine:edge

RUN apk update && \
    apk add --no-cache ca-certificates caddy tor wget && \
    rm -rf /var/cache/apk/*

ADD run.sh /run.sh

RUN chmod 0755 /run.sh

CMD /run.sh
