# shellcheck shell=bash
# shellcheck disable=SC2164

init() {
	declare -g npm_repos=(client-web webext)
	declare -g cargo_repos=(cli)
}

task.bootstrap() {
	printf '%s\n' 'Not Implemented'
}

task.init() {
	repo init 'https://github.com/quasipanacea/init'
	repo sync
	task.do-deps
}

task.do-deps() {
	mkdir -p './repositories'

	for dir in "${npm_repos[@]}"; do cd "./repositories/$dir"
		bake.info "Installing dependencies for: $dir"
		pnpm install
	cd ~-; done

	for dir in "${cargo_repos[@]}"; do cd "./repositories/$dir"
		bake.info "Installing dependencies for: $dir"
		cargo install
	cd ~-; done
}

task.dev() {
	code './quasipanacea.code-workspace'
	nohup kitty tmuxinator &>/dev/null </dev/null &
}
