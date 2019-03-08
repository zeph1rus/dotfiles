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
	echo "Vundle Exists, updating"
	git -C ~/.vim/bundle/Vundle.vim pull
else
	echo "Vundle Doesn't exist, pulling from git"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim 
fi

echo "Installing powerline in default python"
pip install powerline-status

if [ -d ~/.oh-my-zsh ]; then
	echo "oh my zsh exists, updating"
	git -C ~/.oh-my-zsh pull
else
	echo "oh my zsh doesn't exist, pulling from git"
	git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

if [ -d ~/.oh-my-zsh/custom/themes/powerlevel9k ]; then
	echo "Powerlevel 9k present, updating"
	git -C ~/.oh-my-zsh/custom/themes/powerlevel9k pull
else
	echo "Powerlevel 9k not present, updating"
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
fi

echo "Setting OMZ directory to 700"
chmod -R 700 ~/.oh-my-zsh

manage_dotfile ".vimrc" "vim/vimrc"
manage_dotfile ".bashrc" "bashrc"
manage_dotfile ".tmux.conf" "tmux.conf"
manage_dotfile ".flake8" "flake8"
manage_dotfile ".zshrc" "zshrc"
#updating 
vim +PluginInstall! +qall

