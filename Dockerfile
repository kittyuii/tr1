FROM alpine:edge

ADD run.sh /run.sh

RUN chmod 0755 /run.sh && \
    apk update && \
    apk add --no-cache ca-certificates caddy tor wget

CMD /run.sh
