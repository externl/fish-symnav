function __symdir_replace --description "Default symdir path replacement"

    set -l tokens (commandline --tokenize)
    test (count $tokens) -eq 1
        and return

    set -l cmd $tokens[1]

    for token in $tokens[2..-1]
        set -l arg $token
        if not string match --quiet --regex '^-' -- "$token"
            set resolved (__symdir_resolve_to $token)
            test -e "$resolved"
                and set arg "$resolved"
        end
        set cmd $cmd "$arg"
    end

    commandline --replace (string join ' ' -- $cmd)
end
