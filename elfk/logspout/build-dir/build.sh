#!/bin/sh

# source: https://github.com/gliderlabs/logspout/blob/621524e/custom/build.sh

export proxy="http://tw.twgiot.com:37890"
export http_proxy=$proxy
export https_proxy=$proxy
export ftp_proxy=$proxy
export no_proxy="localhost, 127.0.0.1, ::1"

echo "设置代理"

set -e
apk add --update go build-base git mercurial ca-certificates
cd /src
go build -ldflags "-X main.Version=$1" -o /bin/logspout
apk del go git mercurial build-base
rm -rf /root/go /var/cache/apk/*

# backwards compatibility
ln -fs /tmp/docker.sock /var/run/docker.sock


unset http_proxy
unset https_proxy
unset ftp_proxy
unset no_proxy
echo "取消代理"

