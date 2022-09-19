# shellcheck shell=bash

init() {
	declare -g global_repos=(server-deno client-web webext webext-broker launcher docs common .github)
}

task.init() {
	mkdir -p './repos'
	
	for repo in "${global_repos[@]}"; do
		util.clone "$repo"
	done

	for dir in 'server-deno' 'client-web' 'webext-broker'; do
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
}

util.clone() {
	local repo_name="$1"

	if [ ! -d "$BAKE_ROOT/repos/$repo_name" ]; then
		bake.info "Cloning: project-kaxon/$repo_name"
		git clone "git@github.com:project-kaxon/$repo_name" "$BAKE_ROOT/repos/$repo_name"
	fi
}
