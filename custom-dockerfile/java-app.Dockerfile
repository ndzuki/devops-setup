FROM debian:stable AS base

ADD https://github.com/alibaba/arthas/releases/download/arthas-all-4.0.0/arthas-bin.zip /tmp

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 /bin/dumb-init

RUN apt-get update \
	&& apt-get -y install unzip \
	&& unzip -qj /tmp/arthas-bin.zip -d /arthas \
	&& chmod +x /bin/dumb-init

FROM openjdk:23-ea-17-oraclelinux8
LABEL component="arthas"
LABEL jdk="openjdk-17"
# different between them: https://www.delftstack.com/howto/java/_java_options/
ENV JAVA_OPTS="" JAVA_TOOL_OPTIONS=""
ENV JAR_FILE="app.jar"

WORKDIR /app


# COPY ./target/${JOB_BASE_NAME}.jar ./app.jar

COPY --from=base /arthas /arthas
COPY --from=base /bin/dumb-init /bin/dumb-init

RUN apt-get update \
	&& apt-get -y install unzip curl telnet \
	&& apt-get purge\
	&& rm -rf /var/cache/apt/* \
	&& ln -sf /arthas/as.sh /bin/arthas \
	&& rm -f /bin/rmdir \
	&& rm -f /bin/rm

ENTRYPOINT ["/bin/dumb-init", "--"]
CMD ["bash", "-c", "exec java ${JAVA_TOOL_OPTIONS} -jar ${JAR_FILE} ${JAVA_OPTS}"]
