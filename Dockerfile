FROM fedora:23
MAINTAINER avinash.s@yukthi.com

RUN dnf -y install pdns-recursor
RUN dnf -y install lua-ldap
RUN dnf -y install lua-sql-sqlite
RUN dnf -y install openldap-clients

EXPOSE 53/udp

CMD ["pdns_recursor", "--loglevel=5",                                 \
                      "--daemon=no",                                  \
                      "--local-address=0.0.0.0",                      \
                      "--lua-dns-script=/totaloffice/lua/recursor.lua"]
