FROM alpine
RUN apk update && apk add openssh
COPY . /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]