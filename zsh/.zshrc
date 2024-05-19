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
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Aliases
alias ls='ls --color=auto'

# Colors
autoload -Uz colors && colors

# Load and initialise completion system
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
    PS1="%F{green}%n@%m%F{white}:%F{blue}%~%F{white}%% "
}

# Add the theme to promptsys
prompt_themes+=( mytheme )

# Load the theme
prompt mytheme

# Termnal Title
case $TERM in
        xterm*)
            precmd () {print -Pn "\e]0;${PWD/$HOME/\~}\a"}
            ;;
    esac

