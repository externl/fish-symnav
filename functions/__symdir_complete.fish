#
# Completion handler for tab completions
# eg. Path is '/usr/local/symlink1/' and the user tries to complete 'cd ../', this will be
# rewritten as 'cd /usr/local/'
#
function __symdir_complete
    __symdir_initialize
    if not __symdir_is_pwd
        set -l token (commandline --current-token)
        if string match --regex --quiet '^\.\./' "$token"
            set -l commandline_list (commandline --tokenize)[1..-2] (__symdir_resolve_to "$token")
            commandline --replace (string join ' ' $commandline_list)
        end
    end
    commandline -f complete
end
