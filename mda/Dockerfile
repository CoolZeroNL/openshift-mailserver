FROM jwilder/dockerize:0.6.0 AS dockerize

FROM alpine:3.8
LABEL maintainer="jeff@ressourcenkonflikt.de"
LABEL vendor="https://github.com/jeboehm/docker-mailserver"
LABEL de.ressourcenkonflikt.docker-mailserver.autoheal="true"

ENV MYSQL_HOST=db \
    MYSQL_USER=root \
    MYSQL_PASSWORD=changeme \
    MYSQL_DATABASE=mailserver \
    MAILNAME=mail.example.com \
    POSTMASTER=postmaster@example.com \
    SUBMISSION_HOST=mta \
    ENABLE_POP3=true \
    ENABLE_IMAP=true \
    SSL_CERT=/media/tls/mailserver.crt \
    SSL_KEY=/media/tls/mailserver.key \
    WAITSTART_TIMEOUT=1m

RUN apk --no-cache add \
         curl \
         dovecot \
         dovecot-mysql \
         dovecot-pigeonhole-plugin && \
    adduser -h /var/vmail -u 5000 -D vmail && \
    rm -rf /etc/ssl/dovecot && \
    openssl dhparam -out /etc/dovecot/dh.pem 4096

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin
COPY rootfs/ /

RUN sievec /etc/dovecot/sieve/global/spam-to-folder.sieve && \
    sievec /etc/dovecot/sieve/global/learn-ham.sieve && \
    sievec /etc/dovecot/sieve/global/learn-spam.sieve

EXPOSE 2003 9000 4190 143 110 993 995
VOLUME ["/var/vmail"]

HEALTHCHECK CMD echo "? LOGOUT" | nc 127.0.0.1 143 | grep "Dovecot ready."
CMD ["/usr/local/bin/entrypoint.sh"]
