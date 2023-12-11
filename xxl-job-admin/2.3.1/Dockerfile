FROM xuxueli/xxl-job-admin:2.3.1 as xxl

FROM --platform=$TARGETPLATFORM openjdk:8-jre-slim

ENV PARAMS=""

ENV TZ=PRC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=xxl /app.jar /app.jar

ENTRYPOINT ["sh","-c","java -jar $JAVA_OPTS /app.jar $PARAMS"]
EXPOSE 8080
