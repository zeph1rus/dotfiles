#!/bin/bash
if [ -f ~/.bashrc.df ]; then
	source ~/.bashrc.df
fi

case "$(uname -s)" in
	Darwin)
	source /usr/local/etc/bash_completion.d/git-prompt.sh
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
PROMPT_COMMAND='set_prompt'
export LESS="-iMFXR"
shopt -s checkwinsize

