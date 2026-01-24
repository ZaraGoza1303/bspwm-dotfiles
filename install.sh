#!/bin/bash
set -e

read -p "Yakin ingin melakukan instalasi dotfiles ? (Y/n)" CONFIRMATION
if [[ "$CONFIRMATION" == "y" || "$CONFIRMATION" == "Y" ]]; then

	echo "Installing Packages.."
	sudo pacman -S --noconfirm bspwm sxhkd picom nitrogen dunst network-manager-applet flameshot polybar xdg-desktop-portal-gtk xss-lock
	if ! command -v yay > /dev/null 2>&1; then
		echo "yay belum terinstall, Install yay ?(Y/n)"
		read INSTALL_YAY
		if [[ "$INSTALL_YAY" == "n" || "$INSTALL_YAY" == "N" ]]; then
			echo "yay harus terinstall untuk melanjutkan."
			exit 1
		else
			sudo pacman -S --noconfirm yay
		fi
	fi

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

