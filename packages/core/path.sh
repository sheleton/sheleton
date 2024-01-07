#
#
#
function path_remove_begin()
{
	echo "$1"|sed "s#^$2/##"
}

#
#
#
function path_escaping()
{
	#echo "$1"|sed 's/[()&%:|@ ]/\\&/g'
	echo "$1"|sed 's/[& ]/\\&/g'
}
