# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# golang
if [ -d "/usr/local/go/bin" ] ; then
    PATH="/usr/local/go/bin:$PATH"
fi
if [ -d "$HOME/go/bin" ] ; then
    PATH="$HOME/go/bin:$PATH"
fi

# WSL
if [ -d "/mnt/c/Users/Patrick/AppData/Local/Programs/Microsoft VS Code/bin/" ] ; then
    PATH="/mnt/c/Users/Patrick/AppData/Local/Programs/Microsoft VS Code/bin/:$PATH"
fi
