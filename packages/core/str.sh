# @file lib/str
# @brief String utils library.

# @description Join array elements with a string.
# @example
#    ARRAY=(Pacta sunt servanda); echo "$(str_join " " ${ARRAY[@]})"
#
# @arg $1 string Glue
# @arg $@ array The array of strings to join
#
# @stdout String containing a string representation
function str_join() {
	local STRING=$1
	shift
	local ARRAY=("$@")
	echo $(
		local IFS=$STRING
		echo "${ARRAY[*]}"
	)
}
