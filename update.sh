#!/bin/bash
# Script to update local config files and do cleanup etc
manage_dotfile () {
	#substitution doesn't work properly unless named variable
	filetomanage=$1
	#must use $HOME not ~ as otherwise scope causes breakage
	abspathtomanage="$HOME/$filetomanage"
	abspathtobackup="$HOME/$filetomanage.df"
	dotfilessource="$HOME/dotfiles/$2"
	echo "Managing file $filetomanage from $dotfilessource"
	if [ -f $abspathtomanage ]; then
		echo "$filetomanage exists"
		#check if there is a symlink available
		if [ -L $abspathtomanage ]; then
			echo "is a symlink"
			#check if is in the file
			if grep -qF "$filetomanage" $HOME/.dotfiles; then
				echo "Managed By dotfiles, leaving"
			else
				echo "Removing existing symlink"
				rm $abspathtomanage
				echo "Managing file ${filetomanage:1}"
				echo "$filetomanage\n" >> $HOME/.dotfiles
				ln -s $dotfilessource $abspathtomanage
			fi
		else
			echo "Existing file not symlink, backing up"
		 	
			if [ -f $abspathtobackup ]; then
				echo "Existing Backup Detected, removing"
				rm $abspathtobackup
			fi
			echo "Backed up to $abspathtobackup"
			mv $abspathtomanage $abspathtobackup
			echo "Managing file"
			echo "$filetomanage" >> $HOME/.dotfiles
			ln -s $dotfilessource $abspathtomanage
		fi
	else
		echo "File does not exist"
		echo "$filetomanage\n" >> $HOME/.dotfiles
		echo "Creating New Symlink and managing"	
		ln -s $dotfilessource $abspathtomanage
	fi

}

#check if Vundle is Installed
if [ -d ~/.vim/bundle/Vundle.vim ]; then
	git -C ~/.vim/bundle/Vundle.vim pull
else
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim 
fi

pip install powerline-status

manage_dotfile ".vimrc" "vim/vimrc"
manage_dotfile ".bashrc" "bashrc"
manage_dotfile ".tmux.conf" "tmux.conf"

#updating 
vim +PluginInstall +qall

