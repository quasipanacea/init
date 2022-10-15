# shellcheck shell=bash

init() {
	declare -g global_repos=(aggregator agent server-deno client-web webext launcher docs common .github)
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

	for dir in ./repos/agent; do
		pushd "$dir"
		poetry install
		popd
	done

	for dir in 'client-web' 'server-deno' 'agent'; do
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

task.get-nightly() {
	rm -rf './nightly'
	mkdir -p './nightly'
	cd './nightly'

	for name in 'agent' 'webext' 'server-deno' 'client-web' 'aggregator'; do
		util.dl-nightly "$name"

		mkdir -p "$name"
		tar -C "$name" -xf "$name.tar.gz"
	done

	cp -r './client-web/dist' './server-deno/output/public'
}

task.run-nightly() {
	local script="$1"
	shift

	cd './nightly'
	case $script in
	agent)
		exec ./agent/build/bin/agent "$@"
		;;
	aggregator)
		exec ./aggregator/build/bin/aggregator "$@"
		;;
	server)
		exec deno run --allow-all ./server-deno/output/bundle.js -- "$@"
		;;
	esac
}

util.dl-nightly() {
	local repo="$1"

	curl -#SfLo "$repo.tar.gz" "https://github.com/project-kaxon/$repo/releases/download/nightly/build.tar.gz"
}

util.clone() {
	local repo_name="$1"

	if [ ! -d "$BAKE_ROOT/repos/$repo_name" ]; then
		bake.info "Cloning: project-kaxon/$repo_name"
		git clone "git@github.com:project-kaxon/$repo_name" "$BAKE_ROOT/repos/$repo_name"
	fi
}
