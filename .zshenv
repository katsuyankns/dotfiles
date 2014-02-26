#---------#
# General #
#---------#

export LANG=ja_JP.UTF-8
export EDITOR=vi
export PAGER=lv

#-------#
# Paths #
#-------#

typeset -U path
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
if [ -d ${HOME}/.rbenv ] ; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi
