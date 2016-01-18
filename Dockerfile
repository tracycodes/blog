FROM ubuntu:14.04

RUN apt-get dist-upgrade -y
RUN apt-get update
RUN apt-get install -y curl git mercurial

ENV GO_VERSION 1.5.2
ENV NODE_VERSION 4.2.4
ENV NODE_TAR node-v$NODE_VERSION-linux-x64.tar.gz
ENV NODE_PATH /usr/local/node-v$NODE_VERSION-linux-x64/bin
ENV GO_TAR go$GO_VERSION.linux-amd64.tar.gz
ENV GOPATH /opt/go
ENV PATH $GOPATH/bin:$NODE_PATH:/usr/local/go/bin:$PATH
EXPOSE 1313

# It's currently very difficult to pin a go project to a version. You need to manually version all dependencies
# without godep, this is awful.
RUN mkdir -p /tmp/go && curl -o /tmp/go/$GO_TAR https://storage.googleapis.com/golang/$GO_TAR
RUN tar -C /usr/local -xzf /tmp/go/$GO_TAR
RUN go get -v github.com/spf13/hugo

RUN mkdir -p /tmp/node && curl -o /tmp/node/$NODE_TAR https://nodejs.org/dist/v$NODE_VERSION/$NODE_TAR
RUN tar -C /usr/local -xzf /tmp/node/$NODE_TAR
RUN npm install -g postcss && \
    npm install -g postcss-cli && \
    npm install -g postcss-use && \
    npm install -g postcss-autoreset && \
    npm install -g postcss-initial && \
    npm install -g postcss-neat

WORKDIR /opt/blog