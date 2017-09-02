function __symdir_parse --description "Default symdir path parser"

    set -l tokens (__symdir_commandline_tokenize)

    test (count $tokens) -eq 1
        and return

    set -l cmd $tokens[1]

    for token in $tokens[2..-1]
        set -l arg $token
        set -l relative_path (__symdir_relative_to $token)
        test -e "$relative_path"
            and set arg "$relative_path"
        set cmd $cmd "$arg"
    end

    commandline --replace (string join ' ' -- $cmd)
end
