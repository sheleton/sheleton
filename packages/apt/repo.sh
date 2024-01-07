function repo_install() {
	local DIST=$1
	local FILE=$2
	local HASH=$3

	# Remove dist, file and hash arguments
	shift
	shift
	shift

	if [[ $(lsb_release -s -c) == "$DIST" ]]; then
		if [[ ! -f $FILE ]]; then
			touch $FILE
		fi

		if [[ ! $(sha1sum $FILE | awk '{print $1}') = $HASH ]]; then
			>$FILE
			for LINE in "${@}"; do
				echo "$LINE" >>$FILE
			done

			return 1
		fi
	fi

	return 0
}
