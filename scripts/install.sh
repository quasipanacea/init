#!/usr/bin/env bash
set -e

main() {
	local bake_script='https://raw.githubusercontent.com/quasipanacea/init/main/bake'
	local bake_file='https://raw.githubusercontent.com/quasipanacea/init/main/Bakefile.sh'

	curl -fsSLo './bake' "$bake_script"
	curl -fsSLo './Bakefile.sh' "$bake_file"
	chmod +x './bake'

	./bake bootstrap "$@"
}

main "$@"
