function __symdir_string_match_flag --argument arg
    string match --quiet --regex '^--?[a-z]+=?' -- "$arg"
end
