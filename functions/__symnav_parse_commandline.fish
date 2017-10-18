function __symnav_parse_commandline --description "Symnav commandline parser"

    # --tokenize provides only string-type tokens. Ie. Pipes, redirections and excluded. \ escapes are also removed
    set -l tokens (commandline --tokenize)
    test (count $tokens) -le 1
    and return

    set -l pos 0
    set -l buffer (commandline --current-buffer)
    set -l new_commandline
    for token in $tokens
        # First try to match the sting as is
        set -l match (string match --regex --index -- "\Q$token\E" "$buffer")

        # If test match failed then try to escape the token without quotes
        # It's possible it was a path with spaces (tokenize removes them as it first 'evals'? the token :[)
        if test -z "$match"
            set -l escaped_token (string escape --no-quoted "$token")
            set -l match (string match --regex --index -- "\Q$escaped_token\E" "$buffer")
        end

        # Last try. Escape with quotes if necessary and try to match
        if test -z "$match"
            set -l escaped_token (string escape "$token")
            set -l match (string match --regex --index -- "\Q$escaped_token\E" "$buffer")
        end

        # Did not match unable to continue. Abort.
        if test -z "$match"
            # TODO: Should we log something or print a warning here?
            return
        end

        set -l index (string split ' ' -- $match)[1]

        # token is further into buffer, so there are non-string characters which need
        # to be copied first
        if test $index -ne 1
            set -l length (echo $index - 1 | bc)
            set -l non_token_substr (string sub --start 1 --length $length -- "$buffer")
            set new_commandline "$new_commandline$non_token_substr"
            set buffer (string sub --start $index -- "$buffer")
        end

        set -l new_buffer_start (echo (string length -- $token) + 1 | bc)
        set -l new_token  (__symnav_get_substitution $token)

        set new_commandline "$new_commandline$new_token"
        set buffer (string sub --start $new_buffer_start -- "$buffer")
    end

    # Include buffer at the end in case there are trailing non-string tokens
    commandline --replace $new_commandline$buffer
end
