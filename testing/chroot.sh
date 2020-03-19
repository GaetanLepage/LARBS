#Potential variables: timezone, lang and local

getuserandpass() { \
	# Prompts user for new username an password.
	pass1=$(dialog --no-cancel --passwordbox "Enter a password for root." 10 60 3>&1 1>&2 2>&3 3>&1)
	pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	while ! [ "$pass1" = "$pass2" ]; do
		unset pass2
		pass1=$(dialog --no-cancel --passwordbox "Passwords do not match.\\n\\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
		pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	done ;}


pacman --noconfirm --needed -S dialog

getuserandpass

echo "root:$pass1" | chpasswd

TZuser=$(cat tzfinal.tmp)

ln -sf /usr/share/zoneinfo/$TZuser /etc/localtime

hwclock --systohc

echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen

# Change keyboard layout permanently
echo "KEYMAP=fr-latin1" > /etc/vconsole.conf

pacman --noconfirm --needed -S networkmanager
systemctl enable NetworkManager
#systemctl start NetworkManager

# Install bootloader (grub)
pacman --noconfirm --needed -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

pacman --noconfirm --needed -S dialog
larbs() { curl -O https://raw.githubusercontent.com/GaetanLepage/LARBS/master/larbs.sh && bash larbs.sh ;}
dialog --title "Install Luke's Rice" --yesno "This install script will easily let you access Luke's Auto-Rice Boostrapping Scripts (LARBS) which automatically install a full Arch Linux i3-gaps desktop environment.\n\nIf you'd like to install this, select yes, otherwise select no.\n\nLuke"  15 60 && larbs
