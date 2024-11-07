#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

source "${ARCHITECT_DIR}/lib/ascii.sh"

main() {
	local action
	local file_name="backup.tar.gz"

	display_menu
	execute_action
}

display_menu() {
	local options=(
		"Create bakcup"
		"Restore backup"
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
		"Create bakcup")
			create_backup
			;;
		"Restore backup")
			restore_backup
			;;
		"Exit")
			exit 0
			;;
	esac
}

create_backup() {
	local backup_files=(
		".local/share/fonts/dank-mono"
		".mozilla/firefox/personal"
		".mozilla/firefox/work"
		".ssh"
	)

	echo "Files to backup:"
	for file in "${backup_files[@]}"; do
		echo " - $file"
	done

	local dest
	dest=$(
		gum input \
			--header="Backup destination" \
			--placeholder="/path/to/backup"
	)

	gum spin \
		--title="Creating backup at ${dest}..." \
		--show-error="true" \
		-- tar -czf "${dest}/${file_name}" -C "${HOME}" "${backup_files[@]}"

	gum spin \
		--title="Syncing cached writes to persistent storage" \
		--show-error="true" \
		-- sync
	
	echo "✓ Backup successfully created at ${dest}/${file_name}"
}

restore_backup() {
	local source
	source=$(
		gum input \
			--header="Backup source" \
			--placeholder="/path/to/backup"
	)

	gum spin \
		--title="Restoring backup from ${source}..." \
		--show-error="true" \
		-- tar -xzf "${source}/${file_name}" -C "${HOME}"

	gum spin \
		--title="Syncing cached writes to persistent storage" \
		--show-error="true" \
		-- sync

	echo "✓ Backup successfully restored from ${source}/${file_name}"
}

main "$@"
