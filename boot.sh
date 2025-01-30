#!/bin/sh
# This script run as PID=0
Main(){
	local SELF=`readlink -f ${0}`;
	local sRoot=${SELF%/*};

	local PSF="${sRoot}/DarkSystem/DESLinux.psf";

	[ -e "${PSF}" ] && {
		loadfont < "${PSF}"
	}

	exec "${sRoot}/DarkSystem/bin/DESLService"
}

Main "${@}"
