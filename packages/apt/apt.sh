
function apt_package_is_installed()
{
	if [ "$(dpkg -l|awk '{print $1 " " $2}'|grep -e "^ii $1$")" ]; then
		return 0
	else
		return 1
	fi
}

function apt_package_install()
{
	REQUIRE_PACKAGES=""

	for PACKAGE in $@; do
		if [ ! "$(dpkg -l|awk '{print $1 " " $2}'|grep -e "^ii $PACKAGE$")" ]; then
			REQUIRE_PACKAGES+=" $PACKAGE"
		fi
	done

	if [ "$REQUIRE_PACKAGES" != "" ]; then
		DEBIAN_FRONTEND=noninteractive apt-get -y install $REQUIRE_PACKAGES
	fi
}

function apt_cleanup()
{
	#DEBIAN_FRONTEND=noninteractive apt-get autoremove
	apt-get clean
}
