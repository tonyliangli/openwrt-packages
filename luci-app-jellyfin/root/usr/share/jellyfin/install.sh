#!/bin/sh
# Author Xiaobao(xiaobao@linkease.com)

ACTION=${1}
shift 1

ARCH=''
IMAGE_NAME='default'

get_image() {
  ARCH="arm64"
  if echo `uname -m` | grep -Eqi 'x86_64'; then
    ARCH="amd64"
  elif  echo `uname -m` | grep -Eqi 'aarch64'; then
    ARCH="arm64"
  else
    ARCH="arm64"
  fi

  if [ "${ARCH}" = "amd64" ]; then
    IMAGE_NAME="jellyfin/jellyfin"
  else
    if [ "$IMAGE_NAME" == "default" ]; then
        IMAGE_NAME="jjm2473/jellyfin-rtk:latest"
        if uname -r | grep -q '^4\.9\.'; then
          IMAGE_NAME="jjm2473/jellyfin-rtk:4.9-latest"
        fi
    fi
  fi
}

do_install() {
  get_image
  echo "docker pull ${IMAGE_NAME}"
  docker pull ${IMAGE_NAME}
  docker rm -f jellyfin

  do_install_detail
}

do_install_detail() {
  local hostnet=`uci get jellyfin.@jellyfin[0].hostnet 2>/dev/null`
  local media=`uci get jellyfin.@jellyfin[0].media_path 2>/dev/null`
  local config=`uci get jellyfin.@jellyfin[0].config_path 2>/dev/null`
  local cache=`uci get jellyfin.@jellyfin[0].cache_path 2>/dev/null`
  local port=`uci get jellyfin.@jellyfin[0].port 2>/dev/null`

  if [ -z "$config" ]; then
      echo "config path is empty!"
      exit 1
  fi

  [ -z "$port" ] && port=8096

  local cmd="docker run --restart=unless-stopped -d -v \"$config:/config\" "
  if [ "${ARCH}" = "arm64" ]; then
    cmd="$cmd\
    --device /dev/rpc0:/dev/rpc0 \
    --device /dev/rpc1:/dev/rpc1 \
    --device /dev/rpc2:/dev/rpc2 \
    --device /dev/rpc3:/dev/rpc3 \
    --device /dev/rpc4:/dev/rpc4 \
    --device /dev/rpc5:/dev/rpc5 \
    --device /dev/rpc6:/dev/rpc6 \
    --device /dev/rpc7:/dev/rpc7 \
    --device /dev/rpc100:/dev/rpc100 \
    --device /dev/uio250:/dev/uio250 \
    --device /dev/uio251:/dev/uio251 \
    --device /dev/uio252:/dev/uio252 \
    --device /dev/uio253:/dev/uio253 \
    --device /dev/ion:/dev/ion \
    --device /dev/ve3:/dev/ve3 \
    --device /dev/vpu:/dev/vpu \
    --device /dev/memalloc:/dev/memalloc \
    -v /tmp/shm:/dev/shm \
    -v /sys/class/uio:/sys/class/uio \
    -v /var/tmp/vowb:/var/tmp/vowb \
    --pid=host "
  fi
  if [ "$hostnet" = 1 ]; then
    cmd="$cmd\
    --dns=127.0.0.1 \
    --network=host "
  else
    cmd="$cmd\
    --dns=172.17.0.1 \
    -p $port:8096 "
  fi

  [ -z "$cache" ] || cmd="$cmd -v \"$cache:/config/transcodes\""
  [ -z "$media" ] || cmd="$cmd -v \"$media:/media\""

  cmd="$cmd -v /mnt:/mnt"
  mountpoint -q /mnt && cmd="$cmd:rslave"
  cmd="$cmd --name jellyfin \"$IMAGE_NAME\""

  echo "$cmd"
  eval "$cmd"

}

usage() {
  echo "usage: $0 sub-command"
  echo "where sub-command is one of:"
  echo "      install                Install the jellyfin"
  echo "      upgrade                Upgrade the jellyfin"
  echo "      rm/start/stop/restart  Remove/Start/Stop/Restart the jellyfin"
  echo "      status                 Jellyfin status"
  echo "      status                 Jellyfin port"
}

case ${ACTION} in
  "install")
    do_install
  ;;
  "upgrade")
    do_install
  ;;
  "rm")
    docker rm -f jellyfin
  ;;
  "start" | "stop" | "restart")
    docker ${ACTION} jellyfin
  ;;
  "status")
    docker ps --all -f 'name=jellyfin' --format '{{.State}}'
  ;;
  "port")
    docker ps --all -f 'name=jellyfin' --format '{{.Ports}}' | grep -om1 '0.0.0.0:[0-9]*' | sed 's/0.0.0.0://'
  ;;
  *)
    usage
    exit 1
  ;;
esac
