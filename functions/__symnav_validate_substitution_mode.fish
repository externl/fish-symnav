#
# If substitution mode is set to 'ask', check that tool used to
# perform the asking is available (currently only fzf).
#
function __symnav_validate_substitution_mode --on-variable symnav_substitution_mode
    if test $symnav_substitution_mode = 'ask'
    and not type fzf > /dev/null 2>&1
        echo "symnav: fzf is not available. Setting symnav_substitution_mode to 'symlink'" 1>&2
        set -g symnav_substitution_mode 'symlink'
    end
end
