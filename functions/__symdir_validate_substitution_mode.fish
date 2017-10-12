#
# If substitution mode is set to 'ask', check that tool used to
# perform the asking is available (currently only fzf).
#
function __symdir_validate_substitution_mode --on-variable symdir_substitution_mode
    if test $symdir_substitution_mode = 'ask'
    and not type fzf ^ /dev/null
        echo "symdir: fzf is not available. Setting symdir_substitution_mode to 'symlink'" 1>&2
        set -g symdir_substitution_mode 'symlink'
    end
end
