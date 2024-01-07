
function mysql_query()
{
	mysql --defaults-extra-file=/etc/mysql/debian.cnf -se "$1"
}

function mysql_create_database_utf8()
{
	if [[ ! $(mysql_query "show databases"|grep -c "$1") == 1 ]]; then
	  mysql_query "CREATE DATABASE $1 CHARACTER SET utf8 COLLATE utf8_general_ci;"
	fi
}

#
# Arguments:
#
#   $1 - username@hostname
#
# Return:
#
#   0 if valide user or error string
#
function mysql_user_valide()
{
	if [[ "$1" =~ .*@.* ]]; then
		return 0
	else
		echo "Error: $1 is not valide username (ex. user@host)"
	fi
}

function mysql_user_exist()
{
	if [[ $(mysql_query "SELECT CONCAT(User, '@', Host) FROM mysql.user"|grep -c "$1") == 1 ]]; then
		return 0
	else
		return 1
	fi
}

function mysql_user_add()
{
	if ! mysql_user_valide "$1"; then
		echo $?
	elif ! mysql_user_exist "$1"; then
		IFS='@' read USER HOST <<< $1
		mysql_query "CREATE USER '${USER}'@'${HOST}' IDENTIFIED BY '${USER}'"
	fi
}

function mysql_user_password()
{
	if ! mysql_user_valide "$1"; then
		echo $?
	elif mysql_user_exist "$1"; then
			IFS='@' read USER HOST <<< $1
			mysql_query "SET PASSWORD FOR '${USER}'@'${HOST}' = PASSWORD('$2')"
			mysql_query "FLUSH PRIVILEGES"
	fi
}

function mysql_grant()
{
	if ! mysql_user_valide "$1"; then
		echo $?
	elif mysql_user_exist "$1"; then
		if [[ $3 = "all" ]]; then
			PRIVILEGES="ALL PRIVILEGES"
		else
			PRIVILEGES="$3 ALTER"
		fi

		IFS='@' read USER HOST <<< $1
		mysql_query "GRANT $PRIVILEGES ON \`${2}\`.* TO '${USER}'@'${HOST}'"
	fi
}
