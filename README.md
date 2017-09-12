# Symdir

> Symbolic link handling for [Fish](https://fishshell.com/)

## Install
### [Fisherman](https://fisherman.github.io/)

```fish
fisher externl/fish-symdir
```

### Manually

Copy all files in the [functions](./functions) directory into your fish functions directory, typically `~/.config/fish/functions`. Several key bindings need to be added to . See [key_bindings.fish](./key_bindings.fish) for the required
binding list and the [bind command documentation](https://fishshell.com/docs/current/commands.html#bind) for instructions.

Use `bind | grep __symdir` to check that symdir key bindings are enabled.

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
set symdir_fish_prompt 1

# Whether substituting or completing directories such as '../' should use symbolic links ('symlink')
# or asked the user to choose between the symbolic link and the real path ('ask').
set symdir_substitution_mode symlink

# Execute immediately after command line substitution has occurred.
set symdir_execute_substitution 0

# Substitute '$PWD' for '$symdir_pwd' prior to command execution.
set symdir_substitute_PWD 1
```
