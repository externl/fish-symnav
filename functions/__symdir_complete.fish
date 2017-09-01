#
# Completion handler for tab completions
# eg. Path is '/usr/local/symlink1/' and the user tries to complete 'cd ../', this will be
# rewritten as 'cd /usr/local/'
#
function __symdir_complete
    # Setup variables and install shadow functions
    __symdir_initialize
    set -l current_buffer (commandline --current-buffer)
    set -l token (commandline --current-token)
    set -l relative_path (__symdir_relative_to "$token")

    # If the "relative path" returned by __symdir_relative_to is actually an absolute path then
    # we know it encountered a symbolic link during path resolution so we should try to substitute
    # the for current token
    if __symdir_is_absolute $relative_path
        switch $symdir_substitution_mode
            case "ask"
                printf "$relative_path\n"(dirname $PWD) | fzf | read -l selection
                commandline -f repaint
                if test $selection = $relative_path
                    set -l commandline_list (commandline --tokenize)[1..-2] "$relative_path"
                    commandline --replace (string join ' ' $commandline_list)
                else
                    #XXX Maybe this should just leave the path alone?
                    set -l commandline_list (commandline --tokenize)[1..-2] (dirname $PWD)
                    commandline --replace (string join ' ' $commandline_list)
                end
            case "symlink"
                set -l commandline_list (commandline --tokenize)[1..-2] "$relative_path"
                commandline --replace (string join ' ' $commandline_list)
            case *
                echo "$symdir_substitution_mode is not a valid option for \$symdir_substitution_mode" 1>&2
        end

        test $symdir_execute_substitution -eq 0
            and test $current_buffer != (commandline --current-buffer)
            and return
    end
    commandline -f complete
end
