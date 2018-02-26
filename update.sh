#!/bin/bash
# Script to update local config files and do cleanup etc

if [ -f ~/.vimrc ]; then
	echo "Updating vimrc"
	if [ -f ~/.vimrc.bak ]; then
		echo "Removing Old vimrc backup"
		rm ~/.vimrc.bak
	fi
	if [ -L ~/.vimrc ]; then
		echo "VimRC is a symlink, fix manually if an error"
	else
		mv ~/.vimrc ~/.vimrc.bak
		ln -s ~/dotfiles/vim/vimrc ~/.vimrc
	fi
else
	echo "Creating new vimrc"
	ln -s ~/dotfiles/vim/vimrc ~/.vimrc
fi

echo "Updating VIM Plugins"

if [ -d ~/.vim/bundle/Vundle.vim ]; then
	git -C ~/.vim/bundle/Vundle.vim pull
else
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +qall

echo "updating bashrc"
if [ -f ~/.bashrc ]; then
	if [ -L ~/.bashrc ]; then
		echo "BashRC is a symlink, left alone - update manually if not correct"
	else
		echo "moving bashrc (will be sourced)"
		mv ~/.bashrc ~/.bashrc.df
		echo "symlink replacing bashrc"
		ln -s ~/dotfiles/bashrc ~/.bashrc
	fi
fi

echo "Reloading bashrc"
exec bash
