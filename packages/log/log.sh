require "apt" "prompt"

if ! apt_package_is_installed rsyslog; then
	if prompt_ask "Rsyslog is not installed do you wish to install?" Y; then
		apt_package_install rsyslog
	else
		exit 1
	fi
fi

if [ ! -f /etc/rsyslog.d/$APP_NAME.conf ]; then
	cat <<-EOF > /etc/rsyslog.d/$APP_NAME.conf
	if \$programname == '$APP_NAME' then $APP_LOG_FILE
	& ~
	EOF

	service rsyslog force-reload > /dev/null
fi

if [ ! -f /etc/logrotate.d/$APP_NAME ]; then
	cat <<-EOF > /etc/logrotate.d/$APP_NAME
	$APP_LOG_FILE {
	  daily
	  missingok
	  rotate 10
	  compress
	  delaycompress
	  notifempty
	}
	EOF
fi

function log_emerg  { log "$1" "emerg";  }
function log_alert  { log "$1" "alert";  }
function log_crit   { log "$1" "crit";   }
function log_err    { log "$1" "err";    }
function log_warn   { log "$1" "warn";   }
function log_notice { log "$1" "notice"; }
function log_info   { log "$1" "info";   }
function log_debug  { log "$1" "debug";  }

function log()
{
	if [[ "$2" == "" ]]; then
		echo "Priority name require" 1>&2 && exit 1
	fi

	PRIORITIES=(emerg alert crit err warn notice info debug)
	if [[ ! "${PRIORITIES[@]}" =~ "${2}" ]]; then
		echo "Unknown priority name: local3.$2" 1>&2 && exit 1
	fi

	if [[ "$1" != "" ]]; then
		logger -i --priority "local3.$2" -t "$APP_NAME" "$0 - $1"
	fi
}
