## My Personal Dev Workstation setup

These dotfiles sets up a dev environment for my personal use. It install all necessary tools I need for my common development work. My personal choice of OS/Distro at the moment is Linux/Debian variants. 
So, these dotfiles are primarily focused on those.

### Tools Installed

1. [git](https://git-scm.com/)
2. [tmux](https://github.com/tmux/tmux/wiki)
    - Prefix: `<C-Space>`
    - Run `prefix + I` to install TPM plugins.
4. [tmuxinator](https://github.com/tmuxinator/tmuxinator)
5. zsh
    - `zsh` need to run after setup completes to load the zsh configurations.
6. [direnv](https://direnv.net/)
7. [neovim](https://github.com/neovim/neovim)
   - `:MasonInstallAll` needs to be run manually to install the LSP servers.
   - Prefix: `/`
9. [powerlevel10k](https://github.com/romkatv/powerlevel10k)
10. Golang and language tools
11. containerd and nerdctl
12. kubectl and kubectx

## VMs tested

### DigitalOcean Droplet with Ubuntu 22.04 LTS

Steps to run:

1. Create the droplet
2. Clone this repo.
3. Run `./setup.sh`

## ToDo

- [ ] Add Darwin setup for MacOs
- [ ] Fix and add setup for vagrant

## Refs

1. https://youtu.be/DzNmUNvnB04?si=M2pBqXR8VYreIZ-s
