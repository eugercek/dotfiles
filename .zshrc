eval "$(starship init zsh)"
# https://github.com/starship/starship/discussions/4221
PS1=$'%{\e]133;P;k=i\a%}'$PS1$'%{\e]133;B\a\e]122;> \a%}'
PS2=$'%{\e]133;P;k=s\a%}'$PS2$'%{\e]133;B\a%}'

PATH=$PATH:/Users/umut/bin
PATH=$PATH:/Users/umut/go/bin
PATH=$PATH:/Users/umut/.local/bin
PATH=$PATH:/Users/umut/.cargo/bin
PATH="$PATH:/opt/homebrew/bin"

export PATH="/usr/local/opt/libpq/bin:$PATH"

# k8s
alias ns="kubectl config set-context --current --namespace"
alias ka="kubectl apply -f"
alias tmp="kubectl run test --rm -it --image curlimages/curl -- sh"
d="--dry-run=client -o yaml"
alias k=kubectl
alias tf="terraform"

HISTSIZE=999999999
SAVEHIST=$HISTSIZE
export HOMEBREW_NO_AUTO_UPDATE=1

# used in nginx repo
ng() {
  op=$1
  dst_path=${2-/Users/umut/nginx}
  code_path="/Users/umut/Desktop/cont/nginx"
  bin_path="$dst_path/sbin/nginx"


  case "$op"; in
  k | kill)
	pkill nginx ;;

  s | start)
	$bin_path ;;

  e | edit)
	vim $dst_path/conf/nginx.conf ;;
  cd)
	cd $dst_path ;;

  ps)
	ps aux | grep nginx ;;

  x)
	rm $dst_path/logs/error.log
	ng kill
	ng build
	ng start
	ng ps 
	ng logs
		;;

  r | reload)
	$bin_path -s reload ;;

  l | logs)
	tail -f $dst_path/logs/error.log ;;

  b | build)
    echo "configure"
     # $code_path/auto/configure \
     # --prefix=$dst_path \
     # --with-debug \
     # --with-debug \
     # --add-dynamic-module=$code_path/ngx_http_early_hint_module || return


    echo "make"
    make || return

    echo "install"
    make install  || return
    cp objs/ngx_http_early_hint_module.so $dst_path/modules || return
  esac
}

export DOCKER_BUILDKIT=1

alias grep='grep --color'

export PAGER=less

alias zs='source ~/.zshrc'

alias vim='nvim'
alias n='nvim'
alias v='nvim'
eval "$(zoxide init zsh)"

export EDITOR="nvim"
note() {
  local vault="$HOME/Desktop/Obsidian Vault"
  local query="$*"

  local out
  out=$(find "$vault" -name '*.md' -type f | sed "s|^$vault/||" \
    | fzf --prompt="note> " --query="$query" --print-query --expect=ctrl-n)

  local lines=("${(@f)out}")
  local typed=${lines[1]} key=${lines[2]} picked=${lines[3]}

  local file
  if [[ "$key" == "ctrl-n" || -z "$picked" ]]; then
    file="$typed"
  else
    file="$picked"
  fi

  [[ -z "$file" ]] && return 1
  [[ "$file" != *.md ]] && file="${file}.md"

  local full="$vault/$file"
  nvim "$full"
}

tmux() {
  if [[ $# -gt 0 ]]; then
    command tmux "$@"
    return
  fi

  local query selection target
  selection=$(
    command tmux list-sessions -F '#S' 2>/dev/null | \
      fzf --prompt='tmux session> ' --print-query --no-multi
  )

  query=$(printf '%s\n' "$selection" | sed -n '1p')
  target=$(printf '%s\n' "$selection" | sed -n '2p')
  target=${target:-$query}

  [[ -z $target ]] && return

  if command tmux has-session -t "$target" 2>/dev/null; then
    if [[ -n ${TMUX-} ]]; then
      command tmux switch-client -t "$target"
    else
      command tmux attach-session -t "$target"
    fi
    return
  fi

  command tmux new-session -s "$target"
}
# Git aliases
alias g="git"
alias gco="git checkout"
alias ga="git add"
alias gl="git log --oneline"
alias glp="git log --patch"
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias gc="git commit --verbose"
alias gp="git push"
alias gpl="git pull origin"
alias gplm="git pull origin master"

alias m='make'

alias pass="LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16; echo"
alias normalvim='/usr/bin/vim'

alias l="ls"

# Set terminal title so tmux/Ghostty show useful names instead of stale ones.
autoload -Uz add-zsh-hook
_tmux_title_precmd()  { print -Pn '\e]2;%1~\a' }
_tmux_title_preexec() { print -Pn "\e]2;${1%% *}\a" }
add-zsh-hook precmd  _tmux_title_precmd
add-zsh-hook preexec _tmux_title_preexec

export CLAUDE_CODE_NO_FLICKER=1
