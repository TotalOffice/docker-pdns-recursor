FROM fedora:23
MAINTAINER avinash.s@yukthi.com

RUN dnf -y install pdns-recursor
RUN dnf -y install lua-ldap

COPY recursor.lua /usr/local/src
COPY blacklist /var/local

EXPOSE 53/udp

CMD ["pdns_recursor", "--loglevel=5",                                 \
                      "--daemon=no",                                  \
                      "--local-address=0.0.0.0",                      \
                      "--lua-dns-script=/usr/local/src/recursor.lua"]
