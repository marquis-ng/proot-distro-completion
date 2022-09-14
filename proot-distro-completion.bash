# completion for proot-distro made by marquis-ng

_proot-distro_completions_filter() {
	local words="$1"
	local cur=${COMP_WORDS[COMP_CWORD]}
	local result=()

	if [ "${cur:0:1}" = "-" ]; then
		echo "$words"
	else
		for word in $words; do
			[ "${word:0:1}" != "-" ] && result+=("$word")
		done
		echo "${result[*]}"
	fi
}

_proot-distro_completions_list() {
	ls /data/data/com.termux/files/usr/etc/proot-distro 2>/dev/null |\
	grep -v "distro.sh.sample" |\
	sed "s/\.sh$//g" | tr "\n" " "
}

_proot-distro_completions_list_installed() {
	ls /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs 2>/dev/null | tr "\n" " "
}

_proot-distro_completions_list_users() {
	shift
	while [ "$#" != 0 ]; do
		case "$1" in
			--*)
				case "$1" in
					--user|--bind)
						if [ -n "$2" ]; then
							shift
						fi
						;;
				esac
				;;

			*)
				awk -F: "\$3 >= 1000 && \$1 != \"nobody\" || \$3 == 0 {printf(\"%s \", \$1)}" "/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/$1/etc/passwd" 2>/dev/null
				break
				;;
		esac
		shift
	done
}

_proot-distro_completions() {
	local cur=${COMP_WORDS[COMP_CWORD]}
	local compwords=("${COMP_WORDS[@]:1:$COMP_CWORD-1}")
	local compline="${compwords[*]}"

	case "$compline" in
		backup*--output)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -A file -- "$cur")
		;;

		install*--override-alias)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "$(_proot-distro_completions_list)")" -- "$cur")
			;;

		login*--user)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "$(_proot-distro_completions_list_users "${compwords[@]}")")" -- "$cur")
			;;

		login*--bind)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -A file -A directory -- "$cur")
			;;

		help*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "" -- "$cur")")
			;;

		backup*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "--help --output $(_proot-distro_completions_list_installed)")" -- "$cur")
			;;

		install*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "--help --override-alias $(_proot-distro_completions_list)")" -- "$cur")
			;;

		list*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "" -- "$cur")")
			;;

		login*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "--help --user --fix-low-ports --isolated --termux-home --shared-tmp --bind --no-link2symlink --no-sysvipc --no-kill-on-exit $(_proot-distro_completions_list_installed)")" -- "$cur")
			;;

		remove*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "--help $(_proot-distro_completions_list_installed)")" -- "$cur")
			;;

		reset*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "--help $(_proot-distro_completions_list_installed)")" -- "$cur")
			;;

		restore*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -A file -W "$(_proot-distro_completions_filter "--help")" -- "$cur")
			;;

		clear-cache*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "--help" -- "$cur")")
			;;

		*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "--help help backup install list login remove reset restore")" -- "$cur")
			;;
	esac
}

complete -F _proot-distro_completions proot-distro
if command -v pd > /dev/null && [ "$(basename -- "$(realpath -- "$(command -v pd)")")" = "proot-distro" ]; then
	complete -F _proot-distro_completions pd
fi
