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

## Compatibility matrix

| VM | Is Supported | Automated Provisioning | Note |
| -------- | -------- | -------- | --------- |
| DigitalOcean Droplet (Ubuntu 22.04 LTS)   | ✅   | ✅  |  |
| Lima VM (Ubuntu 22.04 LTS)   |  ✅   | ✅  | [1] |

1. If the boot time takes too much time (probably due to system constraints),
provisioning might fail.
 
## VMs tested

### DigitalOcean Droplet with Ubuntu 22.04 LTS

Steps to run to provision:

1. Run `export DIGITALOCEAN_API_TOKEN=<Your API key>`
2. Find your accouts ssh keys using `doctl compute ssh-key list` and export them as 
    `export TF_VAR_ssh_key_ids='["41184238", "41183809"]`
2. Run `make droplet-create` to provision the droplet.
3. Login to the vm using ssh and run `tail -f /var/log/cloud-init-output.log` to check the progress

Steps to cleanup:

1. Run `make droplet-cleanup`.

### [Lima VM](https://lima-vm.io/) with Ubuntu 22.04 LTS

1. Run below:
   ```shell
   limactl create --name=personal ./lima-vm/ubuntu2204.yaml
   limactl start personal
   ```
2. Step 1 should provision the vm if there are no errors. SSH into the vm:
   ```shell
   limactl shell personal
   ```

   or if you are a [kitty](https://sw.kovidgoyal.net/kitty/) user:

   ```shell
   kitty +kitten ssh -F /Users/nayandas/.lima/lima-test/ssh.config lima-test
   ```
    1. If there are any errors, run below to check for errors;
       ```shell
       cat /var/log/cloud-init-output.log
       ```
       
## Building Neovim

Why are we building neovim when it's available in debian repos? Because for 22.04 the version of neovim available
is very old (~0.6). Also, availability of arm images is also a question. Hence, we build neovim to a deb package and 
host it in our own repo's release page. Hopefully, there is a better way to do this in future. Currently, all the plugins
are tried and tested with v0.10.3 of neovim.

Run below after cloning neovim:

1. Install basics:
```shell
apt-get install -y libtool autoconf automake cmake libcurses5-dev g++ gettext
```
2. Build Neovim:
```shell
git checkout v0.10.3
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build
cpack -G DEB
```
3. This should create a `nvim-linux64.deb` file. Change it to a approprite file name and push to github release page
4. (Optional) This step is already done by the script `setup-debian.sh`. To install from deb package:
```shell
dpkg -i <nvim deb package>
```

If nvim was already installed, run:
```shell
dpkg -i --force-overwrite <nvim deb package>
```

## ToDo

- [ ] Add Darwin setup for MacOs
- [ ] ~Fix and add setup for vagrant~
- [ ] Test DigitalOcean Droplet with latest changes
- [ ] Use terraform for Digitalocean Droplet
- [ ] `clangd` can't be installed using Mason in neovim. Need to be installed manually. 

## Refs

1. https://youtu.be/DzNmUNvnB04?si=M2pBqXR8VYreIZ-s
