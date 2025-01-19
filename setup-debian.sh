#!/bin/bash

function setup_debian() {
    arch=$(dpkg --print-architecture)

    # Install tmux
    apt-get update
    apt install -y software-properties-common fontconfig
  
    add-apt-repository ppa:neovim-ppa/unstable
    
    apt-get update && \
      apt-get install -y git tmux tmuxinator zsh zsh-syntax-highlighting && \
      apt-get install -y direnv neovim ripgrep nodejs npm unzip
    
    
    git config --global user.email "dastms@gmail.com"
    git config --global user.name "Nayan Das"
    
    ## Install Tmux Plugin manager
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
    wget -q -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip
    temp_dir=$(mktemp -d)
    unzip ~/.local/share/fonts/Meslo.zip -x "$temp_dir"
    fc-cache -fv "$temp_dir"
    rm -rf "$temp_dir"
    
    # Configure oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    
    # Set zshrc config
    cp .zshrc /root/.zshrc
    
    # Install zsh plugins
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
      git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    # Install zsh-syntax-highlighting
    echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
    
    # Install powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    cp .p10k.zsh ~/.p10k.zsh
    
    # Commenting this becasue this stops the script and requires
    # running exit manually while the scripts run
    # Reload zshrc
    # zsh
    
    # Install Alacritty theme
    mkdir -p ~/.config/alacritty/themes
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

    # Copy nvim config if NvChad dir exists
    if [ "$(ls -A NvChad 2> /dev/null)" ]; then
      cp -r NvChad ~/.config/nvim
    else
      echo "NvChad dir does not contain anything. The Dotfiles repo has been cloned without --recurse-submodule. Skipping copying nvim config!"
    fi

    wget -q "https://go.dev/dl/go1.22.1.linux-${arch}.tar.gz" -O go.tar.gz
    tar -C /usr/local -xzf go.tar.gz

    # Install go debugger. It's required for nvim-dap as well.
    go install github.com/go-delve/delve/cmd/dlv@latest
    
    # Zsh is not appending go bin path to $PATH. This is a temp fix.
    export PATH=$PATH:/usr/local/go/bin
    
    echo $PATH
    
    go install mvdan.cc/gofumpt@latest
    go install github.com/segmentio/golines@latest
    go install -v github.com/incu6us/goimports-reviser/v3@latest
    go install -v golang.org/x/tools/gopls@latest

    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl python3 -y
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    # Add the repository to Apt sources:
    echo \
      "deb [arch=$arch signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update and install containerd
    sudo apt-get update
    sudo apt-get install containerd.io -y
    
    # Get and install nerdctl
    wget -q "https://github.com/containerd/nerdctl/releases/download/v1.7.5/nerdctl-full-1.7.5-linux-${arch}.tar.gz"
    tar Cxzf /usr/local "nerdctl-full-1.7.5-linux-${arch}.tar.gz"
    nerdctl --version
    
    # To run cross platform images
    sudo nerdctl run --privileged --rm tonistiigi/binfmt:master --install all
    
    # To allow image building
    sudo systemctl enable --now buildkit
    
    # Download kubectl
    wget -q "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" -O /usr/local/bin/kubectl
    chmod +x /usr/local/bin/kubectl
    
    # Install kubectx and kubens
    snap install kubectx --classic

    # Change default login shell for root
    chsh -s $(which zsh)
}
