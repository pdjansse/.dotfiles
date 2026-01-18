[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"

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

export EDITOR='nvim'
export VISUAL='nvim'

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
for dump in "${ZDOTDIR:-$HOME}/.zcompdump"(N.mh+24); do
    compinit
done
compinit -C

## Prompt

# Check for a Debian chroot environment
if [[ -r /etc/debian_chroot ]]; then
    debian_chroot="$(cat /etc/debian_chroot)"
fi

# Function to set terminal title
set_title() {
  echo -ne "\033]0;${PWD}\007"
}

# Prompt
autoload -Uz promptinit
promptinit

# Define the theme
prompt_mytheme_setup() {
    PS1="%F{blue}%~%F{white}%% "
}

# Add the theme to promptsys
prompt_themes+=( mytheme )

# Load the theme
prompt mytheme

# Terminal Title
case $TERM in
        xterm*)
            precmd () {print -Pn "\e]0;${PWD/$HOME/\~}\a"}
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

n () {
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    nnn -H -o -U "$@" 

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

eval `keychain --agents ssh --eval id_ed25519 --quiet`

# fnm
FNM_PATH="/home/patrick/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/patrick/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi
