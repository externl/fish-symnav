#
# Shadows fish's cd. Resolve new symlink path and pass to builtin cd
#
function __symdir_shadow_cd --argument arg
    if test (count $argv) -eq 0
        set symdir_pwd "$HOME"
        __symdir_fish_cd
    else if __symdir_string_match_flag "$arg"
        __symdir_fish_cd $argv
    else if test "$arg" = "/"
        set symdir_pwd "$arg"
        __symdir_fish_cd $symdir_pwd
    else
        set -l symdir_prevd "$symdir_pwd"
        set -l cd_dir (__symdir_trim_trailing_slash $argv[1])

        set -l relative_path (__symdir_relative_to "$cd_dir")

        if __symdir_is_absolute "$relative_path"
            set symdir_pwd $relative_path
        else
            set symdir_pwd (__symdir_resolve_to $relative_path)
        end

        __symdir_fish_cd $symdir_pwd
        set -l cd_status $status
        if test $cd_status -ne 0
            set symdir_pwd $symdir_prevd
        end
        return $cd_status
    end
end
