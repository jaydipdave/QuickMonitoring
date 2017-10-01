FROM nginx:1.13.1-alpine
MAINTAINER jayipdave@gmail.com

ENV GLIBC_VERSION "2.23-r3"
ENV REGISTRAR_URL "https://monitoring-server.yourcompany.com"

RUN apk --no-cache add ca-certificates wget device-mapper curl openssl docker && \
    apk --no-cache add zfs --repository http://dl-3.alpinelinux.org/alpine/edge/main/ && \
    apk --no-cache add thin-provisioning-tools --repository http://dl-3.alpinelinux.org/alpine/edge/main/ && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    wget https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk && \
    apk add glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf


# Installing software needed by monitoring rules.
## OpenJDK8
ENV LANG C.UTF-8
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u131
ENV JAVA_ALPINE_VERSION 8.121.13-r0

RUN set -x \
	&& apk add -U \
		openjdk8-jre="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]
## MaVeN
RUN apk -U add maven

## findutils
RUN apk -U add findutils

## expect
RUN apk -U add findutils

# Grab cadvisor from the staging directory.
ADD cadvisor /bin/cadvisor
ADD node_exporter /bin/node_exporter
ADD vault /bin/vault
ADD entry-point.sh /entry-point.sh
ADD shell_exporter.sh /shell_exporter.sh
ADD genssl /bin/genssl
ADD nginx/default.conf /etc/nginx/conf.d/default.conf
RUN chmod +x /entry-point.sh /shell_exporter.sh /bin/genssl /bin/cadvisor /bin/node_exporter

EXPOSE 9123 9321

ENTRYPOINT ["/entry-point.sh"]
