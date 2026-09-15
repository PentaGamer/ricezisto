# ==============================================================================
# Ricezisto - Zsh Configuration (Lightweight & High Performance)
# ==============================================================================

# Ensure ~/.local/bin and other user paths are present
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

# History Configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# Completion System
autoload -Uz compinit
compinit -d "$HOME/.zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Keybindings
bindkey -e
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Lightweight Plugins (Natively sourced without heavy frameworks)
# 1. Autosuggestions
for as_path in \
    "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
    "$HOME/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
    "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"; do
    if [ -f "$as_path" ]; then
        source "$as_path"
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#585b70'
        break
    fi
done

# 2. Syntax Highlighting (Must be loaded near the end)
for sh_path in \
    "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
    "$HOME/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
    "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; do
    if [ -f "$sh_path" ]; then
        source "$sh_path"
        break
    fi
done

# Prompt Setup (Starship with graceful fallback)
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
else
    PROMPT='%F{#cba6f7}%n@%m%f:%F{#89b4fa}%~%f %F{#cba6f7}❯%f '
fi

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ff='fastfetch'
alias gs='git status'
alias gp='git push'
alias gl='git pull'

# Fastfetch on interactive terminal launch
if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi
