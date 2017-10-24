#
# Parses command line looking for symbolic links.
# Called before Fish's commandline execute
#
function __symnav_execute
    # Ensure symnav is initialized
    __symnav_initialize

    set -l current_buffer (commandline --current-buffer)

    # Parse the command line and replace symbolic links as necessary. eg. 'fooCmd ../'
    __symnav_parse_commandline

    if test $symnav_substitute_PWD -eq 1
        commandline --replace (string replace --all '$PWD' '$symnav_pwd' (commandline --current-buffer))
    end

    test $symnav_execute_substitution -eq 0
    and test $current_buffer != (commandline --current-buffer)
    and return

    commandline -f execute
end
