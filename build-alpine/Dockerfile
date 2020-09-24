FROM alpine:latest

RUN apk update && apk upgrade && apk add --no-cache tzdata

COPY ./entrypoint.sh /entrypoint.sh
COPY ./dummycrontab /etc/cron/crontab

ENTRYPOINT ["/entrypoint.sh"]
CMD ["*"]