FROM alpine:3.17
LABEL org.opencontainers.image.authors="d3fk"

COPY ["gentle_whale.ascii", "serious_whale.ascii", "/files/" ]
COPY whalecome /usr/bin/

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories &&\
apk add --no-cache boxes figlet &&\
chmod u+x /usr/bin/whalecome

ENV WHALE_DRAWN='gentle_whale.ascii' 
ENV FONT_NAME='mini'
ENV MESSAGE="Whalecome to the ProDev's initiation training to Docker!"

WORKDIR /files

CMD ["whalecome"]
