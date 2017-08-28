function __symdir_handle_ls
    set -l cmd 'ls'
    set -l tokens (commandline --tokenize)

    test (count $tokens) -eq 1
        and return

    for token in (commandline --tokenize)[2..-1]
        set -l arg $token
        if not string match --quiet --regex '^-' -- "$token"
            set arg (__symdir_resolve_to $token)
        end
        set cmd $cmd "$arg"
    end

    commandline --replace (string join ' ' -- $cmd)
end
