# Generate the .env file from the .env.sample file.
function generate_env_from_env_sample() {
	if [[ ! -f .env.sample ]]; then
		echo "Not found .env.sample file in the root of the project"
		exit 1
	fi

	# Here do not use `envsubst` because this command does not support the
	# default values of bash variables.
	cat .env.sample | tr -s '\n' '\n' | sed '/^\s*#/d' | xargs -I {} sh -c 'eval echo {}'
}
