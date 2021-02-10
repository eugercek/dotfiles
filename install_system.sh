git clone https://github.com/EminUmutGercek/.dotfiles.git  ~/.config/dotfiles
./zsh_setup.sh
./create_links.sh
dnf install $(cat dnf_packages)
