FROM centos
MAINTAINER avinash.s@yukthi.com

RUN yum -y install epel-release
RUN yum -y install pdns-recursor
RUN yum -y install openldap-clients
RUN yum -y install lua-ldap
RUN yum -y install lua-dbi

EXPOSE 53/udp

CMD ["pdns_recursor", "--loglevel=5",                                 \
                      "--daemon=no",                                  \
                      "--local-address=0.0.0.0",                      \
                      "--forward-zones-recurse=.=8.8.8.8,8.8.4.4",    \
                      "--lua-dns-script=/totaloffice/lua/recursor.lua"]
