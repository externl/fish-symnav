#
# Shadows fish's cd. Resolve new symlink path and pass to builtin cd
#
function __symnav_shadow_cd --argument arg

    set -l symnav_prevd "$symnav_pwd"

    if test (count $argv) -eq 0
        set symnav_pwd "$HOME"
        __symnav_fish_cd
    else if __symnav_string_match_flag "$arg"
        __symnav_fish_cd $argv
    else if test "$arg" = "/"
        set symnav_pwd "$arg"
        __symnav_fish_cd $symnav_pwd
    else if test "$arg" = "-"
        set symnav_pwd "$symnav_dirprev[-1]"
        __symnav_fish_cd $symnav_pwd
    else
        set -l cd_dir (__symnav_trim_trailing_slash $argv[1])

        set -l relative_path (__symnav_relative_to "$cd_dir")

        if __symnav_is_realpath "$relative_path"
            set symnav_pwd $relative_path
        else
            set symnav_pwd (__symnav_resolve_to $relative_path)
        end

        __symnav_fish_cd $symnav_pwd
        set -l cd_status $status
        if test $cd_status -ne 0
            set symnav_pwd $symnav_prevd
        end

        if not test "$symnav_prevd" = "$symnav_pwd"
            set -g symnav_dirprev $symnav_dirprev "$symnav_prevd"
        end

        return $cd_status
    end

    if not test "$symnav_prevd" = "$symnav_pwd"
        set -g symnav_dirprev $symnav_dirprev "$symnav_prevd"
    end
end
