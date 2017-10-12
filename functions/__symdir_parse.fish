function __symdir_parse --description "Default symdir path parser"

    # --tokenize provides only string-type tokens. Ie. Pipes, redirections and excluded.
    set -l tokens (commandline --tokenize)
    test (count $tokens) -eq 1
    and return

    set -l pos 0
    set -l buffer (commandline --current-buffer)
    set -l new_commandline
    for token in $tokens
        set -l index (string split ' ' -- (string match --regex --index -- "\Q$token\E" "$buffer"))[1]
        # token is further into buffer, so there are non-string characters which need
        # to be copied first
        if test $index -ne 1
            set -l length (echo $index - 1 | bc)
            set -l non_token_substr (string sub --start 1 --length $length -- "$buffer")
            set new_commandline "$new_commandline$non_token_substr"
            set buffer (string sub --start $index -- "$buffer")
        end

        set -l new_buffer_start (echo (string length -- $token) + 1 | bc)
        set -l new_token (__symdir_get_substitution $token)

        set new_commandline "$new_commandline$new_token"
        set buffer (string sub --start $new_buffer_start -- "$buffer")
    end

    # Include buffer at the end in case there are trailing non-string tokens
    commandline --replace $new_commandline$buffer
end
