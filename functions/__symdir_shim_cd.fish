#
# Wrapper for cd. Resolve new symlink path and pass to builtin cd
#
function _symdir_shim_cd --wraps cd --argument directory
    if test (count $argv) -eq 0
        set symdir_pwd "$HOME"
        __symdir_fish_cd
    else if test "$directory" = "/"
        set symdir_pwd "$directory"
        __symdir_fish_cd $symdir_pwd
    else
        set -l symdir_prevd "$symdir_pwd"
        set -l cd_dir (__symdir_trim_trailing_slash $argv[1])
        set symdir_pwd (__symdir_resolve_to "$cd_dir")
        __symdir_fish_cd $symdir_pwd
        set -l cd_status $status
        if test $cd_status -ne 0
            set symdir_pwd $symdir_prevd
        end
        return $cd_status
    end
end
