# Check if the current directory is a Git repository.
function is_git_repository() {
	if [[ ! -d .git ]]; then
		echo "Not found .git directory in the root of the project"
		exit 1
	fi
}

# Get the Git remote URL.
function git_remote_url() {
	is_git_repository

	local GIT_REMOTE_URL_REGEX='^(https://|git@)([^:/?#]+):?([0-9]+)?(/|:)(.*).git'
	local GIT_REMOTE_URL=$(git remote get-url origin)
	local PARTS="${1}"

	if [[ ! "${GIT_REMOTE_URL}" =~ ${GIT_REMOTE_URL_REGEX} ]]; then
		echo "Not found Git remote URL"
		exit 1
	fi

	if [[ -z "${PARTS}" ]]; then
		echo "${BASH_REMATCH[@]}"
	else
		echo "${BASH_REMATCH[${PARTS}]}"
	fi
}

# Get host from the Git remote URL.
function git_remote_url_host() {
	echo $(git_remote_url 2)
}

# Get path from the Git remote URL.
function git_remote_url_path() {
	echo $(git_remote_url 5)
}
