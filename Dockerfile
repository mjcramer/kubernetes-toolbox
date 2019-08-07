FROM alpine:3.10 

LABEL maintainer="michael@cramer.name"

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
RUN rm -rf /var/cache/apk/*

ADD bashrc /root/.bashrc

ENTRYPOINT ["/bin/bash"]