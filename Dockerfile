FROM alpine:3.17

RUN apk add --no-cache git build-base make flex bison gperf ruby openssl-dev freetype-dev fontconfig-dev icu-dev \
    sqlite-dev libpng-dev jpeg-dev python3

WORKDIR /tmp
RUN git config --global advice.detachedHead false && git clone -q --depth=1 --branch=2.1.1 --single-branch --recurse-submodules --shallow-submodules https://github.com/ariya/phantomjs.git

WORKDIR /tmp/phantomjs
RUN ./build.py -y
