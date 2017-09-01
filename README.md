# Symdir

> Directory navigation (and more) of symbolic links for the [Fish](https://fishshell.com/) shell.

## Install
With [Fisherman](https://fisherman.github.io/):

```fish
fisher externl/fish-symdir
```

## Features

* Tracks directory changes involving symbolic links
* Performs completion of `../` directories involving symbolic links
* Mode for user to choose between symbolic link and real path during completion
* Substitution of `$PWD` on the command line
* Automatic prompt configuration

## Configuration

```fish
# Update function 'prompt_pwd' to use '$symdir_pwd'.
set symdir_prompt_pwd 1

# Update function 'fish_prompt' to use '$symdir_pwd'.
set simdir_fish_prompt 1

# Whether substituting or completing directories such as '../' should use symbolic links ('symlink')
# or asked the user to choose between the symbolic link and the real path ('ask').
set symdir_substitution_mode symlink

# Execute immediately after command line substitution has occurred.
set symdir_execute_substitution 0

# Substitute '$PWD' for '$symdir_pwd' prior to command execution.
set symdir_substitute_PWD 1
```

## Limitations
<!-- * Missing special handling for `pushd`, `popd`, `prevd`, `nextd` -->
The variable `PWD` is read-only in fish. Opening any application from fish will result in that application inheriting the real path and __not__ the symbolic path.
