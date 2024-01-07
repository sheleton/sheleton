
function fs_is_mounted()
{
	if mountpoint -q "$1"; then
		# Is mounted
		return 0
	else
		return 1
	fi
}

function fs_is_label()
{
	EXISTE=1

	for LABEL_PATH in /dev/disk/by-label/*; do
		if [ "$(basename $LABEL_PATH)" == "$1" ]; then
			EXISTE=0
		fi
	done

	return $EXISTE
}
