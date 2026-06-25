source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plug.zsh"

# Options
unsetopt BEEP
setopt GLOB_DOTS
setopt MENU_COMPLETE
setopt EXTENDED_GLOB


# History
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_SAVE_BY_COPY
setopt HIST_FCNTL_LOCK
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY

export EDITOR='nvim'
export VISUAL='nvim'

bindkey -e

# Keybinds 
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H' backward-kill-word

# Aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias gs='git status'
alias gc='git commit -m'
alias gp='git pull'
alias gP='git push'

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

plug "zsh-users/zsh-autosuggestions"

# Colors
autoload -Uz colors && colors

# Load and initialize completion system
autoload -Uz compinit
zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zmodload zsh/complist
_comp_options+=(globdots)		# Include hidden files.
zle_highlight=('paste:none')

_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
_zcompdump_stale=( "$_zcompdump"(N.mh+24) )
if [[ ! -s "$_zcompdump" || $#_zcompdump_stale -gt 0 ]]; then
    compinit -d "$_zcompdump"
else
    compinit -C -d "$_zcompdump"
fi
unset _zcompdump _zcompdump_stale

# GStreamer ships bash completions; load them through zsh's bash bridge.
_gst_completion_dir="/usr/share/bash-completion/completions"
if [[ -r "$_gst_completion_dir/gst-launch-1.0" || -r "$_gst_completion_dir/gst-inspect-1.0" ]]; then
    autoload -Uz bashcompinit
    bashcompinit

    _source_bash_completion() {
        emulate -L zsh
        setopt ksh_arrays

        local completion_file="$1"
        local -a BASH_SOURCE=("$completion_file")
        source "$completion_file"
    }

    [[ -r "$_gst_completion_dir/gst-launch-1.0" ]] && _source_bash_completion "$_gst_completion_dir/gst-launch-1.0"
    [[ -r "$_gst_completion_dir/gst-inspect-1.0" ]] && _source_bash_completion "$_gst_completion_dir/gst-inspect-1.0"

    unfunction _source_bash_completion
fi
unset _gst_completion_dir

# Prompt
PROMPT="%F{blue}%~%F{white}%% %f"

# Terminal Title
case $TERM in
    alacritty*|tmux*|xterm*)
        autoload -Uz add-zsh-hook
        _set_terminal_title() { print -Pn "\e]0;${PWD/$HOME/\~}\a" }
        add-zsh-hook precmd _set_terminal_title
        ;;
esac

# nnn config
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_COLORS='444'
export NNN_ORDER="t:$HOME/Downloads;"
export LC_COLLATE="C"
export NNN_SHOW_HIDDEN=1
export NNN_BMS="h:$HOME;d:$HOME/dev/;c:$HOME/.dotfiles/;"

BLK="0B" CHR="0B" DIR="02" EXE="00" REG="00" HARDLINK="06" SYMLINK="06" MISSING="07" ORPHAN="01" FIFO="0F" SOCK="0F" OTHER="04"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

n() {
    # Block nesting of nnn in subshells
    if [[ -n "$NNNLVL" && "${NNNLVL:-0}" -ge 1 ]]; then
        echo "nnn is already running"
        return
    fi
    if ! command -v nnn > /dev/null 2>&1; then
        echo "nnn is not installed"
        return 1
    fi

    local NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    nnn -H -o -U "$@" 

    if [[ -f "$NNN_TMPFILE" ]]; then
        source "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
}


[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# opencode
if [[ -d "$HOME/.opencode/bin" ]]; then
    case ":$PATH:" in
        *:"$HOME/.opencode/bin":*) ;;
        *) export PATH="$HOME/.opencode/bin:$PATH" ;;
    esac
fi

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    _load_nvm() {
        unfunction nvm node npm npx corepack 2> /dev/null
        source "$NVM_DIR/nvm.sh"
        [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
        "$@"
    }

    nvm() { _load_nvm nvm "$@" }
    node() { _load_nvm node "$@" }
    npm() { _load_nvm npm "$@" }
    npx() { _load_nvm npx "$@" }
    corepack() { _load_nvm corepack "$@" }
fi

plug "zsh-users/zsh-syntax-highlighting"
