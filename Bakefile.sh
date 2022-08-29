# shellcheck shell=bash

task.init() {
	mkdir -p './repos'

	util.clone_and_symlink 'server-deno'
	util.clone_and_symlink 'client-web'
	util.clone_and_symlink 'webext'
	util.clone_and_symlink 'webext-broker'
	util.clone_and_symlink 'launcher'
	util.clone_and_symlink 'docs'
	util.clone_and_symlink 'common'
	util.clone_and_symlink '.github'

	for dir in 'server-deno' 'client-web' 'webext-broker'; do
		ln -sfT "$BAKE_ROOT/repos/common" "$BAKE_ROOT/repos/$dir/common"
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
