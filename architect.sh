#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

export ARCHITECT_DIR="$(dirname "$(readlink -f "$0")")"

source "${ARCHITECT_DIR}/lib/ascii.sh"

main() {
	local action

	display_menu
	execute_action
}

display_menu() {
	local options=(
		"Bakcup"
		"Git"
		"Exit"
	)

	action=$(
		printf "%s\n" "${options[@]}" |
		gum choose \
			--header="${ascii_art}"
	)
}

execute_action() {
	case "$action" in
		"Bakcup")
			echo "Backup!"
			;;
		"Git")
			echo "Git!"
			;;
		"Exit")
			exit 0
			;;
	esac
}

main "$@"
