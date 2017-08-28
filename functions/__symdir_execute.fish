function __symdir_execute
    if __symdir_is_pwd
        set -l cmd (commandline --token)[1]
        set -l replacer "__symdir_replace_$cmd"
        if functions -q "$replacer"
            eval "$replacer"
        else
            eval __symdir_replace
        end
    end
    commandline -f execute
end
