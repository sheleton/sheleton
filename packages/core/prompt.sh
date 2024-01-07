#
# Usage:
#
#	 if ask "Do you want to do such-and-such?"
#		 echo "Yes"
#	 else
#		 echo "No"
#	 fi
#
#	 # Default to Yes if the user presses enter without giving an answer:
#	 if ask "Do you want to do such-and-such?" Y; then
#	 ...
#	 # Default to No if the user presses enter without giving an answer:
#	 if ask "Do you want to do such-and-such?" N; then
#	 ...
#
#	 # Only do something if you say Yes
#	 if ask "Do you want to do such-and-such?"; then
#	 ...
#
#	 # Only do something if you say No
#	 if ! ask "Do you want to do such-and-such?"; then
#	 ...
#
#	 # Or if you prefer the shorter version:
#	 ask "Do you want to do such-and-such?" && said_yes
#	 ask "Do you want to do such-and-such?" || said_no
#
function prompt_ask()
{
	while true; do
		if [ "${2:-}" = "Y" ]; then
			prompt="Y/n"
			default=Y
		elif [ "${2:-}" = "N" ]; then
			prompt="y/N"
			default=N
		else
			prompt="y/n"
			default=
		fi

		read -p "$1 [$prompt] " ANSWER </dev/tty

		# Default
		if [ -z "$ANSWER" ]; then
			ANSWER=$default
		fi

		case $ANSWER in
			[Yy]*) return 0;;
			[Nn]*) return 1;;
		esac
	done
}
