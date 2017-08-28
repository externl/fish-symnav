set -q symdir_complete
    or set -l symdir_complete 1

if test "$symdir_complete" -eq 1
    bind \t '__symdir_complete'
    bind \r '__symdir_execute'
    bind \n '__symdir_execute'
end
