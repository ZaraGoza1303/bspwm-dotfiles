#!/bin/bash
set -e

read -p "Are you sure want to install this dotfiles ? (Y/n)" CONFIRMATION
if [[ "$CONFIRMATION" == "y" || "$CONFIRMATION" == "Y" ]]; then

	echo "Installing Packages.."
	sudo pacman -S --noconfirm bspwm sxhkd picom dunst network-manager-applet flameshot polybar xdg-desktop-portal-gtk xss-lock alacritty rofi thunar pamixer \
	brightnessctl libnotify ttf-jetbrains-mono-nerd lxappearance base-devel git

	if ! command -v yay > /dev/null 2>&1; then
		echo "yay isn't installed yet, Install yay ?(Y/n)"
		read INSTALL_YAY
		if [[ "$INSTALL_YAY" == "n" || "$INSTALL_YAY" == "N" ]]; then
			echo "yay must be installed to continue."
			exit 1
		else
			cd /tmp
			rm -rf /tmp/yay
			git clone https://aur.archlinux.org/yay.git
			cd yay
			makepkg -si --noconfirm
		fi
	fi

	yay -S --noconfirm betterlockscreen nitrogen

	echo "Overwriting config folders..."
   	rm -rf \
        "$HOME/.config/bspwm" \
        "$HOME/.config/sxhkd" \
        "$HOME/.config/picom" \
        "$HOME/.config/polybar" \
        "$HOME/.config/rofi" \
	"$HOME/.config/alacritty"


	mkdir -p "$HOME/.config"

	echo "Cloning config folder..."
	git clone https://github.com/ZaraGoza1303/bspwm.git "$HOME/.config/bspwm"
	git clone https://github.com/ZaraGoza1303/sxhkd.git "$HOME/.config/sxhkd"
	git clone https://github.com/ZaraGoza1303/picom.git "$HOME/.config/picom"
	git clone https://github.com/ZaraGoza1303/polybar.git "$HOME/.config/polybar"
	git clone https://github.com/ZaraGoza1303/rofi.git "$HOME/.config/rofi"
	git clone https://github.com/ZaraGoza1303/alacritty.git "$HOME/.config/alacritty"

	echo "Done cloning folder."

	echo "Make Executable bspwm..."
	chmod +x "$HOME/.config/bspwm/bspwmrc"

	echo "exec bspwm in .xinitrc..."
	cat <<EOF > "$HOME/.xinitrc"
#!/bin/bash
exec bspwm
EOF
	chmod +x "$HOME/.xinitrc"
	echo "Done. reboot or startx to use bspwm"
else
	echo "Bye"
	exit 1
fi

