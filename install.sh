#pacman -S bspwm sxhkd alacritty firefox thunar dmenu picom stow
#mkdir ~/.config/bspwm
#stow -vSt bspwm
#mkdir ~/.config/sxhkd
#stow -vSt sxhkd

foo=$(cat /etc/os-release | grep -E ^ID= | cut -d '=' -f 2)

if [ $foo = "arch" ]; then
    sudo awk '{print $1}'  ./packages/arch/pacman |  xargs pacman -S
    awk '{print $1}'  ./packages/arch/yay |  xargs yay -S
elif [ $foo = "fedora" ]; then
    echo "It is fedora"
elif [ $foo = "centos" ]; then
     echo "It is centOS"
else
    echo "Unknown Distro"
fi

