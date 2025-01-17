## My Personal Dev Workstation setup

These dotfiles sets up a dev environment for my personal use. It install all necessary tools I need for my common development work. My personal choice of OS/Distro at the moment is Linux/Debian variants. 
So, these dotfiles are primarily focused on those.

### Tools Installed

1. git
2. tmux
3. tmuxinator
4. zsh
5. direnv
6. neovim
7. powerlevel10k
8. nvim with NvChad config.
9. golang and language tools
10. containerd and nerdctl
11. kubectl and kubectx

## VMs tested

### DigitalOcean Droplet with Ubuntu 22.04 LTS

Steps to run:

1. Create the droplet
2. Clone this repo.
3. Run `./setup.sh`
4. Run `zsh` to load the zsh configurations.
5. In a first `tmux` session, run `cmd + shift + i` to install TPM plugins.

## ToDo

- [ ] Add Darwin setup for MacOs
- [ ] Update NvChad
- [ ] Fix and add setup for vagrant

## Refs

1. https://youtu.be/DzNmUNvnB04?si=M2pBqXR8VYreIZ-s
