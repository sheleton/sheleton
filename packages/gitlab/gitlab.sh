# Get the GitLab API URL.
function gitlab_api_url() {
	if [[ -z "${GITLAB_ACCESS_TOKEN}" ]]; then
		echo "Not found GitLab access token"
		exit 1
	fi

	echo "https://$(git_remote_url_host)/api/v4"
}

# Get current directory GitLab project.
function gitlab_api_project() {
	xh --pretty=none --body \
		$(gitlab_api_url)/projects/$(encode_url $(git_remote_url_path)) \
		PRIVATE-TOKEN:${GITLAB_ACCESS_TOKEN} owned==true
}

# Get the GitLab project path with namespace.
function gitlab_project_path_with_namespace() {
	gitlab_api_project | jq -r '.path_with_namespace'
}

# Get the GitLab project ID.
function gitlab_project_id() {
	gitlab_api_project | jq -r '.id'
}

# Register GitLab runner.
function gitlab_register_user_runner() {
	local PROJECT_ID=$(gitlab_project_id)
	local PROJECT_PATH_WITH_NAMESPACE=$(gitlab_project_path_with_namespace)
	local DESCRIPTION="dind-${PROJECT_PATH_WITH_NAMESPACE/\//-}"
	local RESPONSE=$(xh --pretty=none --body --form POST $(gitlab_api_url)/user/runners \
		PRIVATE-TOKEN:${GITLAB_ACCESS_TOKEN} \
		locked=true \
		run_untagged=true \
		tag_list=linux,docker \
		runner_type=project_type \
		project_id=${PROJECT_ID} \
		description=${DESCRIPTION})
	local RUNNER_TOKEN=$(echo ${RESPONSE} | jq -r '.token')
	local RUNNER_URL="https://$(git_remote_url_host)"

	cat <<-EOF
		# On the host where your GitLab runner is running run the command below to register it.
		gitlab-runner register \\
		  --non-interactive \\
		  --url ${RUNNER_URL} \\
		  --token "${RUNNER_TOKEN}" \\
		  --description "${DESCRIPTION}" \\
		  --executor docker \\
		  --docker-privileged \\
		  --docker-oom-kill-disable \\
		  --docker-image "docker:stable" \\
		  --docker-cpus \$(nproc) \\
		  --docker-volumes ${DESCRIPTION}-certs:/certs \\
		  --docker-volumes ${DESCRIPTION}-var-lib-docker:/var/lib/docker
	EOF
}
