set -gx CDPATH ~/Code ~/stripe
set -gx CLAUDE_CONFIG_DIR $HOME/.config/claude
set -gx CLICOLOR yes
# https://withbridge.slack.com/archives/C046AKR922E/p1755718718228729
set -gx DOCKERIZED_PG_DUMP true
set -gx EDITOR nvim
set -gx ENABLE_WORKTREE_SCOPED_DB 1
set -gx FZF_DEFAULT_COMMAND 'fd --hidden --type f'
set -gx GIT_CONFIG_GLOBAL $HOME/.config/git/config
set -gx GIT_CONFIG_SYSTEM '/dev/null'
set -gx HOMEBREW_CELLAR '/opt/homebrew/Cellar';
set -gx HOMEBREW_PREFIX '/opt/homebrew';
set -gx HOMEBREW_REPOSITORY '/opt/homebrew';
set -gx INFOPATH '/opt/homebrew/share/info:'
set -gx LESSHISTFILE -
set -gx MANPATH '/opt/homebrew/share/man:'
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

fish_add_path -g $HOME/.local/bin
fish_add_path -g /opt/homebrew/bin
fish_add_path -g /opt/homebrew/sbin
fish_add_path -g /opt/homebrew/opt/libpq/bin
fish_add_path -g $HOME/stripe

alias vim=nvim

# Completions for the build script in
# https://github.com/matthewtodd/zmk-config
# I tried to put these in completions/build.fish, but I think maybe something
# about depending on the full path (-p), since `build` isn't exactly
# a globally-unique name, makes that not work?
set -l build $HOME/Code/zmk-config/build
set -l commands firmware keymap shell
set -l keyboards ferris_sweep corne_min
complete -p $build -f
complete -p $build -n "not __fish_seen_subcommand_from $commands" -s I -d "Build docker image"
complete -p $build -n "not __fish_seen_subcommand_from $commands" -a "firmware" -d "Build keyboard firmware"
complete -p $build -n "not __fish_seen_subcommand_from $commands" -a "keymap" -d "Draw keyboard keymap"
complete -p $build -n "not __fish_seen_subcommand_from $commands" -a "shell" -d "Start an interactive shell in the docker container"
complete -p $build -n "__fish_seen_subcommand_from firmware keymap" -s k -x -a "$keyboards" -d "Select keyboard"
