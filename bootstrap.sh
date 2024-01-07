APP_ROOT_DIRECTORY="$(readlink -f $(dirname ${BASH_SOURCE[0]})/../..)"

# Save arguments
APP_ARGUMENTS=$@

# Global configuration
if [ -f "$APP_ROOT_DIRECTORY/etc/config" ]; then
	. "$APP_ROOT_DIRECTORY/etc/config"
fi

# Script configuration
APP_CONFIG_PATH=$APP_ROOT_DIRECTORY/etc
if [ -d $APP_CONFIG_PATH/$(basename $0) ]; then
	APP_CONFIG_PATH=$APP_CONFIG_PATH/$(basename $0)
fi

__CONFIG_FILE=$APP_CONFIG_PATH/$(basename $0)

if [ -f $__CONFIG_FILE ]; then
	. $__CONFIG_FILE
elif [ -f $__CONFIG_FILE.conf ]; then
	. $__CONFIG_FILE.conf
fi

# Requires directory and already loaded
APP_REQUIRES_DIRECTORY=($APP_ROOT_DIRECTORY/vendor/sheleton/lib)
APP_REQUIRES_LOADED=()

function require()
{
	REQUIRES=$@

	for REQUIRE_DIRECTORY in ${APP_REQUIRES_DIRECTORY[@]}; do
		for REQUIRE in ${REQUIRES[@]}; do
			REQUIRE_PATH="$REQUIRE_DIRECTORY/$REQUIRE.sh"

			if [ -f $REQUIRE_PATH ]; then
				# Requiement found and not already loaded
				if [[ ! "${APP_REQUIRES_LOADED[@]}" =~ "${REQUIRE_PATH}" ]]; then
					# Add for not reload in the future
					APP_REQUIRES_LOADED+=("$REQUIRE_PATH")

					# Load script
					. $REQUIRE_PATH
				fi
			fi
		done
	done
}
