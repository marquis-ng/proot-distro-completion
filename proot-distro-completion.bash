# completion for proot-distro made by marquis-ng

if ! command -v proot-distro > /dev/null; then
	return
fi

_proot-distro_completions_filter() {
	local words="$1"
	local optargs="${2:-}"
	local optcount=0
	local optend=false
	local cur=${COMP_WORDS[COMP_CWORD]}
	local result=()

	set -- "${COMP_WORDS[@]:1:$COMP_CWORD-1}"
	while [ "$#" != 0 ]; do
		case "$1" in
			--)
				return 0
				;;

			--*)
				if echo "$1" | grep -qEx -- "$optargs"; then
					if [ -n "$2" ]; then
						shift
					else
						optend=true
					fi
				fi
				;;

			*)
				((++optcount))
				;;
		esac
		shift
	done

	if [ "${cur:0:1}" = "-" ]; then
		echo "$words"
	elif [ "$optcount" -lt 2 ] || [ "$optend" = "true" ]; then
		for word in $words; do
			[ "${word:0:1}" != "-" ] && result+=("$word")
		done
		echo "${result[*]}"
	fi
}

_proot-distro_completions_list() {
	ls /data/data/com.termux/files/usr/etc/proot-distro 2>/dev/null |\
	grep -v "^distro.sh.sample$" | sed "s/\.sh$//g" | sed "s/\.override$//g"
}

_proot-distro_completions_list_installed() {
	ls /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs 2>/dev/null | tr "\n" " "
}

_proot-distro_completions_list_users() {
	set -- "${COMP_WORDS[@]:2:$COMP_CWORD-1}"
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
			done < <(compgen -W "$(_proot-distro_completions_filter "$(_proot-distro_completions_list)" "--override-alias")" -- "$cur")
			;;

		login*--user)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "$(_proot-distro_completions_list_users)" "--user|--bind")" -- "$cur")
			;;

		login*--bind)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -A file -A directory -- "$cur")
			;;

		-h*|--help*|help*|list*)
			:
			;;

		backup*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "--help --output $(_proot-distro_completions_list_installed)" "--backup")" -- "$cur")
			;;

		install*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "--help --override-alias $(_proot-distro_completions_list)" "--override-alias")" -- "$cur")
			;;

		login*)
			while read -r; do
				COMPREPLY+=("$REPLY")
			done < <(compgen -W "$(_proot-distro_completions_filter "--help --user --fix-low-ports --isolated --termux-home --shared-tmp --bind --no-link2symlink --no-sysvipc --no-kill-on-exit $(_proot-distro_completions_list_installed)" "--user|--bind")" -- "$cur")
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
			done < <(compgen -W "$(_proot-distro_completions_filter "-h --help help backup install list login remove reset restore clear-cache")" -- "$cur")
			;;
	esac
}

complete -F _proot-distro_completions proot-distro
if command -v pd > /dev/null && [ "$(basename -- "$(realpath -- "$(command -v pd)")")" = "proot-distro" ]; then
	complete -F _proot-distro_completions pd
fi
