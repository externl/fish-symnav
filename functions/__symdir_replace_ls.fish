function __symdir_replace_ls --description "symdir path replacement for ls command"
    set -l cmd 'ls'
    set -l tokens (commandline --tokenize)

    test (count $tokens) -eq 1
        and return

    for token in (commandline --tokenize)[2..-1]
        set -l arg $token
        if not __symdir_string_match_flag "$token"
            set arg (__symdir_resolve_to $token)
        end
        set cmd $cmd "$arg"
    end

    commandline --replace (string join ' ' -- $cmd)
end
