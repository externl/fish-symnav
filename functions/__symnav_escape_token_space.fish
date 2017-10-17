#
# Escape space in tokens
# eg. 'src/GitHub Projects' -> 'src/GitHub\ Projects'
#
function __symnav_escape_token_space --argument token
    string replace --all --regex -- "(?<!\\\\)\s" "\\\\\\\\ " "$token"
end
