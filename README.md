# Symdir

__symdir__ handles directory navigation of symbolic links for [Fish](https://fishshell.com/) shell.


## Install
With [Fisherman](https://fisherman.github.io/):

```fish
fisher externl/fish-symdir
```

# Configuration

```fish
# Update `prompt_pwd` to use `$symdir_pwd`.
set symdir_prompt_pwd 1

# Update `fish_prompt` to use `$symdir_pwd`.
set simdir_fish_prompt 1

# Whether completing directories such as `../` should track symbolic links (`symlink`) or asked
# if they would rather use absolute real path (`ask`).
set symdir_complete_mode symlink

# Rewrite the `PWD` variable to `symdir_pwd` prior to command execution
set symdir_rewrite_PWD 1

```

## Known issues and limitations
* Missing special handling for `pushd`, `popd`, `prevd`, `nextd`
* The variable `PWD` is read-only in fish. Opening any application from fish will result in that application inheriting the absolute path, not the symlink relative path.
