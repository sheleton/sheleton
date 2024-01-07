
function md5()
{
	if [ $(md5sum $1|awk '{print $1}') == $2 ]; then
		return 0
	fi

	return 1
}
