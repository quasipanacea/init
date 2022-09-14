# shellcheck shell=bash

init() {
	declare -g global_repos=(server-deno client-web webext webext-broker launcher docs common .github)
}

task.init() {
	mkdir -p './repos'
	
	for repo in "${global_repos[@]}"; do
		util.clone_and_symlink "$repo"
	done

	for dir in server-deno client-web webext-broker; do
		ln -sfT "$BAKE_ROOT/repos/common" "$BAKE_ROOT/repos/$dir/common"
	done
}

task.update() {
	for repo in "${global_repos[@]}"; do
		(
			cd "./repos/$repo"
			
			if [ -n "$(git status -s)" ]; then
				bake.die "There are unstaged changes in repo: $repo"
			fi

			git pull origin main
		)
	done
}

task.dev() {
	code './kaxon.code-workspace'
	
}

util.clone_and_symlink() {
	local repo_name="$1"

	if [ ! -d "$BAKE_ROOT/../$repo_name" ]; then
		bake.info "Cloning: project-kaxon/$repo_name"
		git clone "git@github.com:project-kaxon/$repo_name" "$BAKE_ROOT/../$repo_name"
	fi

	bake.info "Symlinking: ./repos/$repo_name"
	ln -Tsf "$BAKE_ROOT/../$repo_name" "./repos/$repo_name"
}
