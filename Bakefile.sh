# shellcheck shell=bash

init() {
	declare -g global_repos=(server-deno client-web webext webext-broker launcher docs common .github)
}

task.init() {
	mkdir -p './repos'

	for repo in "${global_repos[@]}"; do
		util.clone "$repo"
	done

	for dir in ./repos/{client-web,webext}; do
		pushd "$dir"
		pnpm install
		popd
	done

	for dir in ./repos/webext-broker; do
		pushd "$dir"
		poetry install
		popd
	done

	for dir in 'client-web' 'server-deno' 'webext-broker'; do
		ln -sfT "$BAKE_ROOT/repos/common" "$BAKE_ROOT/repos/$dir/common"
	done
}

task.update() {
	for repo in "${global_repos[@]}"; do
		pushd "./repos/$repo"

		if [ -n "$(git status -s)" ]; then
			bake.die "There are unstaged changes in repo: $repo"
		fi

		git pull origin main

		popd
	done
}

task.dev() {
	code './kaxon.code-workspace'
	nohup kitty tmuxinator &>/dev/null </dev/null &
}

util.clone() {
	local repo_name="$1"

	if [ ! -d "$BAKE_ROOT/repos/$repo_name" ]; then
		bake.info "Cloning: project-kaxon/$repo_name"
		git clone "git@github.com:project-kaxon/$repo_name" "$BAKE_ROOT/repos/$repo_name"
	fi
}
