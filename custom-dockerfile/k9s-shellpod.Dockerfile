FROM  debian:bullseye

ADD https://github.com/alibaba/arthas/releases/download/arthas-all-4.0.0/arthas-bin.zip /tmp

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	locales ca-certificates unzip curl telnet openjdk-17-jdk \
	&& rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
	&& update-ca-certificates

RUN mkdir /arthas && unzip -qj /tmp/arthas-bin.zip -d /arthas 
RUN ln -sf /arthas/as.sh /bin/arthas

ARG JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"

ENV LANG en_US.utf8
ENV JAVA_HOME="${JAVA_HOME}"
ENV PATH="$JAVA_HOME/bin:$PATH"
