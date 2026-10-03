# homebrew
# - mac only, doesn't do anything if brew isn't installed
if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
  echo "zinit is not installed in $ZINIT_HOME."
  echo "To install it, run:"
  echo "  mkdir -p \"\$(dirname \"$ZINIT_HOME\")\" && git clone https://github.com/zdharma-continuum/zinit.git \"$ZINIT_HOME\""
fi

source "${ZINIT_HOME}/zinit.zsh"

# - plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# - snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# - load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

autoload -Uz add-zsh-hook

# - initialize fzf and zoxide
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# keybinds
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# aliases
alias c='clear'
alias l='eza -lh  --icons=auto' # long list
alias ls='eza -G   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias mkdir='mkdir -p'
alias vim="nvim"
alias lg="lazygit"

# run ls automatically when changing dir
function chpwd() {
  ls
}

# starship new line styling hack
PROMPT_NEEDS_NEWLINE=false

precmd() {
	if [[ "$PROMPT_NEEDS_NEWLINE" == true ]]; then
		echo
	fi
		PROMPT_NEEDS_NEWLINE=true
}

clear() {
	PROMPT_NEEDS_NEWLINE=false
	command clear
}

# nnn file manager settings, alias is "f" as function call
f() {
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }
 
    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_COLORS='#51e2d0c652d59f7b;36735673'
    export NNN_OPENER="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins/nuke"
    export NNN_PLUG='a:autojump;'
 
    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef
    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn -e -d -D -H -Q "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE" > /dev/null
    }
}

# PATH variables
export PATH=$PATH:~/.cargo/bin
export PATH=$PATH:~/go/bin

# ENV variables
export TERM='xterm-256color'
export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER='nvim +Man!'

eval "$(starship init zsh)"
