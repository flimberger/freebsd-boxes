#!/bin/sh

set -e
set -u

hostname="$1"

if [ ! -n "$hostname" ]
then
	echo "fatal: no hostname provided" >&2
	exit 1
fi

# set hostname
sysrc hostname="$hostname"
# also set it for first boot
hostname "$hostname"

# set UTF-8
cat <<EOF >>/etc/login.conf
utf8|UTF-8 Encoding:\\
:charset=utf-8:\\
:lang=en_US.UTF-8:\\
:tc=default:
EOF
cap_mkdb /etc/login.conf
pw usermod vagrant -L utf8

# change the package repo from ``quaterly'' to ``latest''
mkdir -p /usr/local/etc/pkg/repos
sed s:quarterly:latest: </etc/pkg/FreeBSD.conf >/usr/local/etc/pkg/repos/FreeBSD.conf

# install software
pkg update

# install salt
pkg install -y py36-salt

# general tools
pkg install -y git mksh tmux vim-console

# the vm will be used interactively, so change the default shell
pw usermod vagrant -s /usr/local/bin/mksh
