#!/bin/sh
# This script run as PID=0
Main(){
	local SELF=`readlink -f ${0}`;
	local sRoot=${SELF%/*};

	exec "${sRoot}/DarkSystem/bin/DESLService"
}

Main "${@}"
