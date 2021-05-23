FROM alpine:3.10

ADD run.sh /run.sh

RUN chmod 0755 /run.sh

CMD /run.sh
