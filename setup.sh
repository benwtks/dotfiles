#!/bin/bash

is_yes () {
	if [[ $1 == "Yes" || $1 == "YES" || $1 == "yes" || $1 == "Y" || $1 == "y" ]]; then
		return 0
	else
		return 1
	fi
}


echo -e "\033[0;32mSetting up environment...\033[0m"

read -p "Enter your dotfiles path [~/dotfiles]: " dot
dot=${dot:-~/dotfiles}

echo -e "\n\033[0;33m[1/5] Setting up Zsh\033[0m"
read -p "Do you wish to install Zsh? ([y]/n): " yn
if is_yes ${yn:-y}; then
 	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	read -p "Do you wish to configure Zsh? ([y]/n): " yn
	if is_yes ${yn:-y}; then
		ln -s $DOT/zshrc ~/.zshrc
		git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
		git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
		~/.fzf/install
	fi
fi

echo -e "\033[0;33m[2/5] Setting up Neovim\033[0m"
read -p "Do you wish to install Neovim? ([y]/n): " yn
if is_yes ${yn:-y}; then
	if [ "$(uname)" == "Darwin" ]; then
		brew install neovim
	else
		sudo apt-get install neovim
	fi

	read -p "Do you wish to configure Neovim? ([y]/n): " yn
	if is_yes ${yn:-y}; then
		ln -s $DOT/nvim ~/.config/nvim
		ln -s $DOT/benwtks.zsh-theme ~/.oh-my-zsh/themes/benwtks.zsh-theme # For some reason I had to put it as robbyrussell.zsh-theme
	fi
fi

echo -e "\033[0;33m[3/5] Setting up tmux\033[0m"
read -p "Do you wish to install tmux? ([y]/n): " yn
if is_yes ${yn:-y}; then
	if [ "$(uname)" == "Darwin" ]; then
		brew install tmux
	else
		sudo apt-get install tmux
	fi

	read -p "Do you wish to configure tmux? ([y]/n): " yn
	if is_yes ${yn:-y}; then
		ln -s $DOT/tmux.conf ~/.tmux.conf
	fi
fi

echo -e "\033[0;33m"
read -p "[4/5] Do you wish to alias gitconfig? ([y]/n): " yn
echo -e "\033[0;0m"
if is_yes ${yn:-y}; then
	ln -s $DOT/gitconfig ~/.gitconfig
fi

echo -e "\033[0;33m"
read -p "[5/5] Do you wish to install Ag? ([y]/n): " yn
echo -e "\033[0;0m"
if is_yes ${yn:-y}; then
	if [ "$(uname)" == "Darwin" ]; then
		brew install the_silver_searcher
	else
		sudo apt-get install silversearcher-ag
	fi
fi

