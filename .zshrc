export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8

# export PATH
export PATH=$HOME/local/bin:$PATH
export PERL_CPANM_OPT="--local-lib=$HOME/.perl-extlib"
export PERL5LIB="$HOME/.perl-extlib/lib/perl5:$PERL5LIB"
export PATH=$HOME/.perl-extlib/bin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH
export NODE_PATH=/usr/local/lib/node
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH
export PATH=~/.gem/ruby/1.8/bin:$PATH

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

autoload colors
colors

case ${UID} in
0)
	PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
	PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
	SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
	[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
		PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
	;;
*)
	PROMPT="%{${fg[red]}%}%/%%%{${reset_color}%} "
	PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
	SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
	[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
		PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
	;;
esac

#set terminal title including current directory
case "${TERM}" in
kterm*|xterm*)
	precmd() {
		echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
	}
	export LSCOLORS=exfxcxdxbxegedabagacad
	export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
	zstyle ':completion:*' list-colors \
		'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
	;;
esac

if [ -f ~/.zsh/auto-fu.zsh ]; then
	source ~/.zsh/auto-fu.zsh
	function zle-line-init () {
		auto-fu-init
	}
	zle -N zle-line-init
	zstyle ':completion:*' completer _oldlist _complete
fi
eval "$(rbenv init -)"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
