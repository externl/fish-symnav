# Symdir

__symdir__ handles directory navigation of symbolic links for Fish shell.


## Install
With [Fisherman](https://github.com/fisherman/fisherman):
```
    fisher externl/fish-symdir
```

## Known issues and limitations
* Missing handling for `pushd`, `popd`, etc.
* The variable `PWD` is read-only in fish. Opening any application from fish will result in that application inheriting the absolute path, not the symlink relative path.
