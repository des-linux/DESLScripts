#!/bin/sh
SELF=`readlink -f ${0}`;
sRoot=${SELF%/*};

F_RED="\e[0;31;41m";
F_STD="\e[m\e[0;37m";
X="$F_RED""*""$F_STD";
LINE="$F_STD""E: ""$F_RED""***************************************************************************""$F_STD";

DB="${sRoot}/../conf/TelnetUser.db";

Main(){
	export PS1='\u@\H \$ \w>';

	cd '/DRoot/'

	CONF="${sRoot}/../conf/Telnetd.conf";

	[ -f "${CONF}" ] && {
		IFS=$'\n\r'
		for l in `cat "${CONF}"`;do
			IFS=$' =\t'
			set -- $l
			[ ! "${2}" = "" ] && local "TC_${1}"="${2}";
		done

	}

	ShowWelcome;
	Auth && return 0;
	Auth && return 0;
	Auth && return 0;

	return 1;
}

UserAuth(){
	local DWR_ID DWR_PW;

	[ -f "${1}" ] && DB="${1}";

	[ ! -f "${DB}" ] && {
		echo
		echo -e "${LINE}"
		echo "W: User Database is not found. [${DB}]"
		echo 'W: Authentication is disabled.'
		echo -e "${LINE}"
		echo

		. /DRoot/DarkSystem/DarkSystem /GetEnvEx
		exec "${TC_UserShell:-/bin/sh}"
	}

	read -p 'ID: ' DWR_ID
	read -s -p 'Password: ' DWR_PW
	echo '*'

	local IFS=$'\n\r';
	for l in `cat "${DB}"`;do
		IFS=$' =\t'
		set -- $l

		[ "${1}" = "${DWR_ID}:${DWR_PW}" ] && {
			ShowWelcome "${TC_UserDB}";

			case "${TC_UserRunAs:-root}" in
				'user'		) exec su "${DWR_ID}" -s "${TC_UserShell:-/bin/sh}";;
				'root' | *	) exec "${TC_UserShell:-/bin/sh}";;
			esac
			return 1;
		}
	done

	return 1;
}

ShowWelcome(){
	local HOSTNAME=`cat /proc/sys/kernel/hostname`;
	. "${sRoot}/../DarkSystem" /GetEnv
clear;
cat << EOF
******************************************************************************
* ${PRDNAME:-DESLinux} [${PRDCODE:-${HOSTNAME}}]
*
* http://e.xprj.net/
* (C)2014-2025 Dark Network Systems All Rights Reserved.
******************************************************************************

EOF

return 0;
}

Auth(){
	[ -e "${sRoot}/clearStdin" ] && "${sRoot}/clearStdin"
	case "${TC_AuthMode}" in
		'system' | 'System' )
			exec /bin/login -p
			exec login -p
			return 1;;

		'exec' | 'Exec' )
			exec ${TC_AuthExec};
			return 1;;

		'none' | 'None' )
			exec /bin/sh
			return 1;;

		'db' | 'DB' | * )
			UserAuth && return 0;
	esac

	sleep 1;
	echo 'E: User Authentication Failed'
	echo
	return 1;
}

Main;
