# Symnav

> Symbolic link navigation for [Fish](https://fishshell.com/)

## Install

Symnav was developed and tested on Fish 2.6.0. Please report any issues.

### [Fisherman](https://fisherman.github.io/)

```fish
fisher externl/fish-symnav
```

### Manually

Copy all files in the [functions](./functions) directory into your fish functions directory, typically `~/.config/fish/functions`. Several key bindings need to be added, see [key_bindings.fish](./key_bindings.fish) for the required binding list and the [bind command documentation](https://fishshell.com/docs/current/commands.html#bind) for instructions.

Use `bind | grep __symnav` to check that symnav key bindings are enabled.

## Features

* Tracks directory changes involving symbolic links
* Performs completion of `../` directories involving symbolic links
* Mode for user to choose between symbolic link and real path during completion
* Substitution of `$PWD` on the command line
* Automatic prompt configuration

## Configuration

```fish
# Update function 'prompt_pwd' to use '$symnav_pwd'.
set symnav_prompt_pwd 1 (0 to disable)

# Update function 'fish_prompt' to use '$symnav_pwd'.
set symnav_fish_prompt 1 (0 to disable)

# Whether substituting or completing directories such as '../' should use symbolic links ('symlink')
# or asked the user to choose between the symbolic link and the real path ('ask').
set symnav_substitution_mode symlink (or 'ask')

# Execute immediately after command line substitution has occurred.
set symnav_execute_substitution 0 (1 to enable)

# Substitute '$PWD' for '$symnav_pwd' prior to command execution.
set symnav_substitute_PWD 1 (0 to disable)

# Initialize symnav during first execution or completion.
set symnav_lazy_initialize 0 (1 to enable)

# List of additional functions to modify for symnav compatibility.
# Instances of '$PWD', 'realpath', etc are replaced (in memory) by 'symnav_pwd'
set symnav_fix_function_user_list 'func1' 'func2' ...
```
