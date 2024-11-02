#!/bin/bash

set -eox

os=$(uname -s)

apt-get update

# Install tmux
if [ "$os" == "Linux" ]; then
  apt-get install -y git tmux tmuxinator zsh zsh-syntax-highlighting direnv
elif [ "$os" == "Darwin" ]; then
  brew install git tmux tmuxinator zsh zsh-syntax-highlighting direnv
else
  echo "OS: ${os} not supported"
  exit 1
fi

git config --global user.email "dastms@gmail.com"
git config --global user.name "Nayan Das"

# Install Tmux Plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Placing tmux config and applying
mkdir -p ~/.config/tmux
cp tmux.conf ~/.config/tmux/tmux.conf

# Commented because it does not work outside a tmux
# session
# tmux source ~/.config/tmux/tmux.conf

cp .tmuxinator.yaml ~/.tmuxinator.yaml

# Install Meslo Font
if [ "$os" == "Linux" ]; then
  wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip
  unzip ~/.local/share/fonts/Meslo.zip
  fc-cache -fv
elif [ "$os" == "Darwin" ]; then
  brew install font-meslo-lg-nerd-font
else
  echo "OS: ${os} not supported"
  exit 1
fi

# Configure oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set zshrc config
cp .zshrc ~/.zshrc

# Install zsh plugins
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Install Meslo Font
if [ "$os" == "Linux" ]; then
  echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
elif [ "$os" == "Darwin" ]; then
  brew install zsh-syntax-highlighting
  echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
else
  echo "OS: ${os} not supported"
  exit 1
fi

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cp .p10k.zsh ~/.p10k.zsh

source ~/.zshrc

# Install Alacritty theme
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

# Install nvim
apt install -y nvim
