#!/bin/bash
if [ -f ~/.bashrc.df ]; then
	if [ -L ~/.bashrc.df ]; then
		rm ~/.bashrc.df		#do nothing
	else
		#this stops the script getting into an infinite loop
		#where bashrc and bashrc.df are symlinks to the same file
		source ~/.bashrc.df
	fi
fi

alias ls='ls --color'
case "$(uname -s)" in
	Darwin)
		#this fixes git completion and status on OSX
		source /usr/local/etc/bash_completion.d/git-prompt.sh
		alias ls='ls -G'
		;;
esac

set_prompt()
{
   local last_cmd=$?
   local txtreset='$(tput sgr0)'
   local txtbold='$(tput bold)'
   local txtblack='$(tput setaf 0)'
   local txtred='$(tput setaf 1)'
   local txtgreen='$(tput setaf 2)'
   local txtyellow='$(tput setaf 3)'
   local txtblue='$(tput setaf 4)'
   local txtpurple='$(tput setaf 5)'
   local txtcyan='$(tput setaf 6)'
   local txtwhite='$(tput setaf 7)'
   # unicode "✗"
   local fancyx='\342\234\227'
   # unicode "✓"
   local checkmark='\342\234\223'
   # Line 1: Full date + full time (24h)
   # Line 2: current path
   if [[ $EUID == 0 ]]; then
       PS1="\[$txtred\]"
   else
       PS1="\[$txtyellow\]"   
   fi

   PS1+="\[$txtbold\]\u\[$txtblue\]@\[$txtyellow\]\h\[$txtwhite\] \t \d\[$txtgreen\]\n"
   # User color: red for root, yellow for others
   if [[ $last_cmd == 0 ]]; then
      PS1+="\[$txtgreen\]$checkmark \[$txtwhite\](0)"
   else
      PS1+="\[$txtred\]$fancyx \[$txtwhite\]($last_cmd)"
   fi
   # Line 4: green git branch
   PS1+="\[$txtgreen\]$(__git_ps1 ' (%s)')\[$txtwhite\]"
   # Line 4: good old prompt, $ for user, # for root
   PS1+="\[$txtcyan\]\w> \\$ "
}
#PROMPT_COMMAND='set_prompt'
export XDG_CONFIG_HOME="/home/jon/.config"
export LESS="-iMFXR"
shopt -s checkwinsize
#stop stupid ctrl-s freezes
#stty -ixon
export TERM="xterm-256color"
LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS
export PATH="$PATH:/usr/local/bin"


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
# NVM Installation
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
