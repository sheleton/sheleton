
function lvm_is_snapshot()
{
	VOLUMES=$(lvs --noheadings --separator ' ' --options lv_path,origin|sed -e '/^ /s/ *//')

	while read -r VOLUME; do
		VOLUME=($VOLUME)
		VOLUME_PATH="${VOLUME[0]}"
		VOLUME_ORIGIN="${VOLUME[1]}"

		if [[ "$VOLUME_PATH" == "$1" ]]; then
			if [[ "$VOLUME_ORIGIN" != "" ]]; then
				return 0
			fi
		fi
	done <<< "$VOLUMES"
	return 1
}
