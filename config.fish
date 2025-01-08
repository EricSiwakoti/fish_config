#!/usr/bin/env fish

set fish_greeting
alias ls "eza --icons --group-directories-first"
alias lf "yazi"

# Initialize starship
starship init fish | source

# Tmux aliases
function tls
    tmux ls
end

function ta
    tmux a
end

function tnew
    tmux new -s $argv
end

function tkl
    tmux kill-server
end

function tk
    tmux kill-session -t $argv
end

# Fisher plugin manager
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Load mongodb-compass
function compass
    mongodb-compass > /dev/null 2>&1 &
end

# Set NVM directory to the correct path
set -gx NVM_DIR $HOME/.local/share/nvm

# Use Node.js version 22
nvm use 22

# Clear the terminal
clear
