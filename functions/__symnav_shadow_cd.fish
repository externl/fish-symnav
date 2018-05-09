#
# Shadows fish's cd. Resolve new symlink path and pass to builtin cd
#

function __symnav_shadow_cd --argument arg

    if test (count $argv) -gt 1
        echo "Too many args for cd command"
        return 1
    end

    set -l previous "$symnav_pwd"

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
    end

    # __symnav_fish_cd should be the last call in each if block
    set -l cd_status $status

    if test $cd_status -ne 0
        set symnav_pwd $previous
    end

    if not status --is-command-substitution
        if test $cd_status -eq 0 -a "$symnav_pwd" != "$previous"
            set -l MAX_DIR_HIST 25

            set -q symnav_dirprev
            or set -l symnav_dirprev

            set -q symnav_dirprev[$MAX_DIR_HIST]
            and set -e symnav_dirprev[1]

            set -g symnav_dirprev $symnav_dirprev $previous
        end
    end

    return $cd_status
end
