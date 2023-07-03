# history size
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
# export HISTCONTROL=ignoredups:erasedups

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

bindkey -s '\e\e' 'sudo !!'

set -o emacs

alias nv="nvim"
alias lg="lazygit"
alias rm='rm -i'
alias mv='mv -i'
alias act='source venv/bin/activate'
alias deact='deactivate'
alias ls='exa'
alias ll='exa -labh --no-time --no-filesize --icons'
alias src='source ~/.config/zsh/.zshrc'
export EDITOR="nvim"
export VISUAL="nvim"
export EDITOR=nvim
export OPENER=xdg-open

PROMPT="[%n %~]$ "

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

for file in /home/brian/.config/zsh/plugins/*.zsh; do
  source "$file"
done

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  IFS=$'\n' files=($(find . -type f | fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fe() {
#   find . -type f ! -name "*/.mozilla/*" | fzf | xargs nvim
# }

fd() {
  local dir
  dir=$(find ${1:-.} -path 'placeholder11' -prune \
                  -o -path '*/.mozilla' -prune \
                  -o -path '*/.git' -prune \
                  -o -path '*/.pyenv' -prune \
                  -o -path '*/.cache' -prune \
                  -o -path '*/.texlive' -prune \
                  -o -path '*/Repos/*/*' -prune \
                  -o -path '*/.config/*/*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# lf cd function
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

alias lf="lfcd"
