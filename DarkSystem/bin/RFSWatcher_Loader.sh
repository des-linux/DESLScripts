#!/bin/sh

DetectUSB(){
	local IFS=$'\n\r';
	local ROOT='';
	for x in `mount`; do
		IFS=' ';
		set -- ${x}
		[ "${3}" = '/' ] && {
			ROOT="${1}";
			ROOT="${ROOT##*/}";
			ROOT="${ROOT//[0-9]/}";
			break;
		}
	done

	echo "${ROOT:-sda}"
	return 0;
}

Main(){
	local ROOT=`DetectUSB`;

	exec "${sRoot}/RFSWatcher" /sys/block/${ROOT}

	return 1;
}

SELF=`readlink -f ${0}`;
sRoot=${SELF%/*};

Main "${@}"
