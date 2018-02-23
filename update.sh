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

echo "updating bashrc"
if [ -f ~/.bashrc ]; then
	echo "moving bashrc (will be sourced)"
	mv ~/.bashrc ~/.bashrc.df
	echo "symlink replacing bashrc"
	ln -s ~/dotfiles/bashrc ~/.bashrc
else
	if [ -L ~/.bashrc ]; then
		echo "Bashrc is already a symlink, leaving alone"
	else
		echo "Bashrc doesn't exist - creating"
		ln -s ~/dotfiles/bashrc ~/.bashrc
	fi
fi
echo "Reloading bashrc"
source ~/.bashrc

