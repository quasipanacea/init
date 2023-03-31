# shellcheck shell=bash
# shellcheck disable=SC2164

init() {
	declare -g all_repos=(aggregator cli agent server-deno client-web webext docs common .github)
	declare -g npm_repos=(client-web webext)
	declare -g poetry_repos=(agent)
}

task.bootstrap() {
	printf '%s\n' 'Not Implemented'
}

task.init() {
	task.clone
	task.do-deps
}

task.do-clone() {
	mkdir -p './repos'

	for repo in "${all_repos[@]}"; do
		util.clone "$repo"
	done
}

task.do-deps() {
	mkdir -p './repos'

	for dir in "${npm_repos[@]}"; do cd "./repos/$dir"
		bake.info "Installing dependencies for: $dir"
		pnpm install
	cd ~-; done

	for dir in "${poetry_repos[@]}"; do cd "./repos/$dir"
		bake.info "Installing dependencies for: $dir"
		poetry install
	cd ~-; done
}

task.update() {
	for repo in "${all_repos[@]}"; do
		pushd "./repos/$repo"

		if [ -n "$(git status -s)" ]; then
			bake.die "There are unstaged changes in repo: $repo"
		fi

		git pull origin main

		popd
	done
}

task.dev() {
	code './quasipanacea.code-workspace'
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

	curl -#SfLo "$repo.tar.gz" "https://github.com/quasipanacea/$repo/releases/download/nightly/build.tar.gz"
}

util.clone() {
	local repo_name="$1"

	if [ ! -d "$BAKE_ROOT/repos/$repo_name" ]; then
		bake.info "Cloning: quasipanacea/$repo_name"
		git clone "git@github.com:quasipanacea/$repo_name" "$BAKE_ROOT/repos/$repo_name"
	fi
}
