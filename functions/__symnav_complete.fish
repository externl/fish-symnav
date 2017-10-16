#
# Fish completion handler. It must be installed in place of Fish's completion (typically tab completion)
#
# If the path is '/usr/local/symlink1/' and the user tries to complete 'cd ../', we rewrite
# the path as 'cd /usr/local/'
#
function __symnav_complete
    # Ensure symnav is initialized
    __symnav_initialize

    set -l current_token (commandline --current-token)
    set -l relative_path (__symnav_relative_to "$current_token")

    # If the "relative path" returned by __symnav_relative_to is actually an absolute path then
    # we may have encountered a symbolic link during path resolution so we should try to substitute
    # the for current_buffer token. The other possibility is that the user provided an absolute real path
    # This test is an optimization to avoid extra calls for relative path completion
    if test -n "$relative_path"
    and __symnav_is_absolute $relative_path
        set -l before_buffer (commandline --current-buffer)

        __symnav_replace_current_token (__symnav_get_substitution "$current_token")

        # If we've modified the command line then don't perform "a second" completion unless
        # symnav_execute_substitution is set
        test $symnav_execute_substitution -eq 0
        and test $before_buffer != (commandline --current-buffer)
        and return
    end

    commandline -f complete
end
