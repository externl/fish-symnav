#
# Replaces the current token with 'new_token'. Since the cursor position may be anywhere inside of the token
# we first need construct a new commandline string as if the cursor position was at the end of the token.
#
# Note: For some reason using 'commandline -f forward-word' (and friends) does not work here.
#       They seem to only be executed later can not be used in real time
#
# We construct the new commandline string by appending the end of the token onto the cut-at position until we have
# a complete string. Eg. 'cd /usr/local/opt/fi' with token '/usr/local/opt/fish/'. We would fist try
# 1. 'cd /usr/local/opt/fi/', then
# 2. 'cd /usr/local/opt/fih/', and finally
# 3. 'cd /usr/local/opt/fish/'
#
# We also need to be sure to save anything thats to the right of the cursor at the time of completion ('the_right').
#
function __symnav_replace_current_token --argument new_token
    set -l before_buffer (commandline --current-buffer)
    set -l before_at_cursor (commandline --cut-at-cursor)
    set -l token (commandline --current-token)
    set -l commandline_at_cursor_with_token
    # Since this token will be placed raw onto the command line (no quotes)
    # we need to escape any spaces (assuming they're not already escaped)
    set -l escaped_token (string replace --all --regex -- "(?<!\\\\)\s" "\\\\\\\\ " "$new_token")
    if not string match --quiet -- "*$token" "$before_at_cursor"
        set -l token_array (string split -- '' "$token")
        set -l test_commandline $before_at_cursor
        set -l test_append_chars
        while not string match --quiet -- "*$token" "$test_commandline"; and test (count $token_array) -gt 0
            set -l char $token_array[-1]
            set -e token_array[-1]
            set test_append_chars "$char$test_append_chars"
            set test_commandline "$before_at_cursor$test_append_chars"
        end
        set commandline_at_cursor_with_token $test_commandline
    else
        set commandline_at_cursor_with_token $before_at_cursor
    end

    set -l the_left (string split --right --max 1 -- "$token" "$commandline_at_cursor_with_token")[1]
    set -l the_right (string sub --start (echo (string length -- "$the_left$token")" + 1" | bc ) -- "$before_buffer")

    commandline --replace "$the_left$escaped_token"
    commandline --insert -- "$the_right" # empty if the cursor was already at the end of the line
    commandline --cursor (string length "$the_left$escaped_token")
end
