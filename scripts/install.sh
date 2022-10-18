#!/usr/bin/env bash
set -e

main() {
	local original_pwd="$PWD"

	# Go to temporary directory and download necessary scripts
	local tempdir=
	tempdir=$(mktemp -d)
	cd "$tempdir"

	local bake_script='https://raw.githubusercontent.com/project-kaxon/init/main/bake'
	local bake_file='https://raw.githubusercontent.com/project-kaxon/init/main/Bakefile.sh'

	curl -sfLo './bake' "$bake_script"
	curl -sSfLo './Bakefile.sh' "$bake_file"
	chmod +x './bake'

	# Go to original directory and execute 'bootstrap' task
	cd "$original_pwd"
	"$tempdir/bake" -f "$tempdir/Bakefile.sh" bootstrap "$@"
}

main "$@"
