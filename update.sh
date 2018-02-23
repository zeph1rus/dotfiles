#!/bin/bash
# Script to update local config files and do cleanup etc

if [ -f ~/.vimrc]; then
	echo "Updating vimrc"
	if [ -f ~/.vimrc.bak ]; then
		echo "Removing Old vimrc backup"
		rm ~/.vimrc.bak
	fi
	cp ~/.vimrc ~/.vimrc.bak
	ln -s ~/dotfiles/vim/vimrc ~/.vimrc
else
	echo "Creating new vimrc"
	ln -s ~/dotfiles/vim/vimrc ~/.vimrc
fi

echo "Updating VIM Plugins"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
echo "source ~/dotfiles/bashrc" >> ~/.bashrc
