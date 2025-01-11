#!/bin/bash

set -eox

os=$(uname -s)

# Install tmux
if [ "$os" == "Linux" ]; then
  apt-get update
  apt install -y software-properties-common

  add-apt-repository ppa:neovim-ppa/unstable
  
  
  apt-get update && \
    apt-get install -y git tmux tmuxinator zsh zsh-syntax-highlighting && \
    apt-get install -y direnv neovim
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
cp /vagrant/.zshrc /root/.zshrc

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

# Reload zshrc
zsh

# Change default login shell for root
chsh -s $(which zsh)

# Install Alacritty theme
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

# Copy nvim config if NvChad dir exists
if [ "$(ls -A NvChad 2> /dev/null)" ]; then
  cp -r NvChad ~/.config/nvim
else
  echo "NvChad dir does not contain anything. The Dotfiles repo has been cloned without --recurse-submodule. Skipping copying nvim config!"
fi

wget https://go.dev/dl/go1.22.1.linux-arm64.tar.gz -O go.tar.gz

tar -C /usr/local -xzvf go.tar.gz

export PATH=$PATH:/usr/local/go/bin

echo $PATH

go install mvdan.cc/gofumpt@latest
go install github.com/segmentio/golines@latest
go install -v github.com/incu6us/goimports-reviser/v3@latest

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl python3 
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update and install containerd
sudo apt-get update
sudo apt-get install containerd.io

# Get and install nerdctl
wget https://github.com/containerd/nerdctl/releases/download/v1.7.5/nerdctl-1.7.5-linux-arm64.tar.gz
tar Cxzvvf /usr/local/bin nerdctl-full-1.7.5-linux-arm64.tar.gz
nerdctl --version

# To run cross platform images
sudo nerdctl run --privileged --rm tonistiigi/binfmt:master --install all

# To allow image building
sudo systemctl enable --now buildkit

# Download kubectl
wget "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" -O /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl

# Install kubectx and kubens
snap install kubectx --classic
