function __symdir_is_absolute --argument path
    test (string split '' -- $path)[1] = '/'
end
