#---------#
# General #
#---------#

bindkey -e

autoload -Uz colors
colors

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt nobeep
setopt nolistbeep

#------------#
# Complement #
#------------#

autoload -Uz compinit
compinit
setopt auto_list
setopt auto_menu
# setopt list_packed
# setopt list_types
# zstyle ':completion:*' matcher-list 'm:{a-z}=[A-Z}'

#---------#
# History #
#---------#

HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt hist_no_store
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt share_history

#-----#
# Git #
#-----#

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
function _update_vcs_info_msg() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _update_vcs_info_msg

#---------#
# Prompts #
#---------#

setopt prompt_subst
local p_cdir="%F{blue}[%~]%f"
local p_info="%n@%m${WINDOW:+"[$WINDOW]"}"
local p_mark="%(?,%F{green},%F{red})%(!,#,$)%f"
PROMPT="[$p_info]$p_mark "
PROMPT2="(%_) %(!,#,&) "
SPROMPT="correct: %R -> %r ? [n,y,a,e]: "
RPROMPT="$p_cdir %1(v|%1v|)"

#---------#
# Aliases #
#---------#

alias ls='ls -F --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

alias sudo='sudo '

alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g L='| less'

alias reload='source ~/.zshrc'

# mosh
compdef mosh=ssh

# z
. `brew --prefix`/etc/profile.d/z.sh
