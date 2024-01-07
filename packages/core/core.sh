
function core_function_exists()
{
	if [ "$(type -t $1)" == "function" ]; then
		return 0
	fi
	return 1
}

function core_trap()
{
	if core_function_exists $1; then
		if ! $DESTRUCTOR_IS_CALLED; then
			"$1"
		fi
		DESTRUCTOR_IS_CALLED=true
	fi

	rm -f -- $PID_FILE
	unset PID_FILE DESTRUCTOR_IS_CALLED
	exit
}

function core()
{
	PID_FILE="/var/run/$(basename $0)-$(cat /dev/urandom | tr -cd [:alnum:] | head -c 4).pid"
	#PID_FILE="/var/run/$(basename $0).pid"
	DESTRUCTOR_IS_CALLED=false

	# Perform program exit housekeeping
	trap "core_trap $2" 0 1 2 3 6

	if [ -f $PID_FILE ]; then
		# Remove trap function
		trap - 0 1 2 3 6
		echo "Process is already running with PID $(cat $PID_FILE)" 1>&2 && exit 1
	else
		echo $$ > $PID_FILE
	fi

	if core_function_exists $1; then
		"$1" $APP_ARGUMENTS
	fi
}
