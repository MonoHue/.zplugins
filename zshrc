# ==============================================================================
# ZSH Configuration - Enhanced .zshrc
# ==============================================================================

# -----------------------------------------------------------------------------
# Environment Variables
# -----------------------------------------------------------------------------
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export EDITOR=vim
export LANG=en_US.UTF-8

# History Configuration
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# -----------------------------------------------------------------------------
# ZSH Options
# -----------------------------------------------------------------------------
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS         # Don't display a line previously found
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry
setopt HIST_VERIFY               # Show command with history expansion to user before running it
setopt SHARE_HISTORY             # Share history between all sessions
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format

# Other useful options
setopt AUTO_CD                   # Change directory just by typing directory name
setopt GLOB_COMPLETE             # Show autocompletion menu with globs
setopt MENU_COMPLETE             # Automatically highlight first element of completion menu
setopt AUTO_LIST                 # Automatically list choices on ambiguous completion
setopt COMPLETE_IN_WORD          # Complete from both ends of a word

# -----------------------------------------------------------------------------
# Prompt Configuration
# -----------------------------------------------------------------------------
autoload -Uz promptinit
promptinit

# Enhanced prompt with git support
autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b '
zstyle ':vcs_info:*' enable git

setopt PROMPT_SUBST
PROMPT='%F{cyan}%n@%m%f:%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f%# '

# -----------------------------------------------------------------------------
# Key Bindings
# -----------------------------------------------------------------------------
bindkey -e  # Use emacs keybindings

# Better history search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Word movement (Alt + arrow keys)
bindkey '^[^[[C' forward-word      # Alt + Right
bindkey '^[^[[D' backward-word     # Alt + Left

# Line editing
bindkey '^A' beginning-of-line     # Ctrl + A
bindkey '^E' end-of-line          # Ctrl + E
bindkey '^K' kill-line            # Ctrl + K
bindkey '^U' kill-whole-line      # Ctrl + U
bindkey '^W' backward-kill-word   # Ctrl + W

# -----------------------------------------------------------------------------
# Completion System
# -----------------------------------------------------------------------------
autoload -Uz compinit

# Check if compinit needs to run (performance optimization)
if [[ -n ${ZDOTDIR:-${HOME}}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Enhanced completion styles
zstyle ':completion:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

# Kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Directory completion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# Completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
# Color support
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enhanced ls aliases (OS-specific)
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'
    alias ll='ls -alFG'
    alias la='ls -AG'  
    alias l='ls -CFG'
else
    alias ls='ls --color=auto'
    alias ll='ls -alF --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'
fi

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# System aliases
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias h='history'
alias which='type -a'
alias du='du -h'
alias df='df -h'
alias free='free -h'
alias ps='ps aux'

# Network aliases
alias ping='ping -c 5'
alias ports='netstat -tuln'

# Git aliases (only if git is available)
if command -v git >/dev/null 2>&1; then
    alias g='git'
    alias gs='git status'
    alias ga='git add'
    alias gc='git commit'
    alias gp='git push'
    alias gl='git log --oneline --graph --decorate'
    alias gd='git diff'
    alias gb='git branch'
    alias gco='git checkout'
    alias gcb='git checkout -b'
fi

# -----------------------------------------------------------------------------
# Plugin Loading (with error checking)
# -----------------------------------------------------------------------------
PLUGIN_DIR="$HOME/.zplugins"

# Function to safely source plugins
load_plugin() {
    local plugin_path="$1"
    if [[ -f "$plugin_path" ]]; then
        source "$plugin_path"
    else
        echo "Warning: Plugin not found at $plugin_path"
    fi
}

# Load plugins
load_plugin "$PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
load_plugin "$PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Plugin configurations
if [[ -f "$PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    # ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# -----------------------------------------------------------------------------
# Machine-Specific Configurations
# -----------------------------------------------------------------------------
