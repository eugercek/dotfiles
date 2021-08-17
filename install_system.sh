./zsh_setup.sh
./create_links.sh
sudo dnf install $(cat dnf-packages)
flatpak install $(cat flatpak-packages)
dnf install $(cat pip-packages)
