FROM alpine:3.10 

LABEL maintainer="michael@cramer.name"

RUN apk add --no-cache ca-certificates 
RUN apk add --no-cache mtr
RUN apk add --no-cache netcat-openbsd
RUN apk add --no-cache wget
RUN apk add --no-cache curl
RUN apk add --no-cache bash
RUN apk add --no-cache bash-completion
RUN apk add --no-cache htop
RUN apk add --no-cache tcpdump
RUN apk add --no-cache nmap
RUN apk add --no-cache iperf
RUN apk add --no-cache jq 
RUN apk add --no-cache iftop 
RUN apk add --no-cache grep 
RUN apk add --no-cache openssh-client
RUN apk add --no-cache openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

RUN wget --quiet --output-document=/etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
	wget https://github.com/sgerrand/alpine-pkg-kafkacat/releases/download/1.5.0-r0/kafkacat-1.5.0-r0.apk && \
	apk add --no-cache kafkacat-1.5.0-r0.apk

RUN rm -rf /var/cache/apk/*

ARG avro_tools_path=/opt/avro-tools
ARG avro_tools_version=1.8.2
ARG avro_tools_path=/opt/avro-tools
RUN mkdir -p $avro_tools_path && \
	wget https://repo1.maven.org/maven2/org/apache/avro/avro-tools/$avro_tools_version/avro-tools-$avro_tools_version.jar -P $avro_tools_path && \
	wget -qO- http://apache.cs.uu.nl/kafka/2.4.0/kafka_2.12-2.4.0.tgz | tar -xvz

ADD bashrc /root/.bashrc

ENV PATH="/kafka_2.12-2.4.0/bin:$avro_tools_path:${PATH}"
VOLUME /schemas
ENTRYPOINT /bin/bash
