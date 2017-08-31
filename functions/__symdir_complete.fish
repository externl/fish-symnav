#
# Completion handler for tab completions
# eg. Path is '/usr/local/symlink1/' and the user tries to complete 'cd ../', this will be
# rewritten as 'cd /usr/local/'
#
function __symdir_complete
    __symdir_initialize
    if not __symdir_is_pwd
        set -l token (commandline --current-token)
        if string match --regex --quiet '^\.\./?$' "$token"

            set -l symlink_dir (__symdir_resolve_to "$token")

            switch $symdir_complete_mode
                case "ask"
                    printf "$symlink_dir\n"(dirname $PWD) | fzf | read -l selection
                    commandline -f repaint
                    if test $selection = $symlink_dir
                        set -l commandline_list (commandline --tokenize)[1..-2] "$symlink_dir"
                        commandline --replace (string join ' ' $commandline_list)
                    else
                        #XXX Maybe this should just leave the path alone?
                        set -l commandline_list (commandline --tokenize)[1..-2] (dirname $PWD)
                        commandline --replace (string join ' ' $commandline_list)
                    end
                case "symlink"
                    set -l commandline_list (commandline --tokenize)[1..-2] "$symlink_dir"
                    commandline --replace (string join ' ' $commandline_list)
                    commandline -f complete
                case *
                    echo "$symdir_complete_mode is not a valid option for \$symdir_complete_mode" 1>&2
            end
        end
    end
    commandline -f complete
end
