#!/bin/bash

is_installed() {
  package="$1"

  for package; do
    if pacman -Qi "$package" > /dev/null; then
      return 0
    fi

    return 1
  done
}

install_packages() {
  uninstalled_packages=()

  for package; do
    if is_installed "$package"; then
      echo ":: $package is already installed"
      continue
    fi

    uninstalled_packages+=("$package")
  done

  [[ -z "${uninstalled_packages[@]}" ]] && return

  echo "The following packages will be installed:"
  printf "  %s\n" "${uninstalled_packages[@]}"
  sudo pacman --noconfirm -S "${uninstalled_packages[@]}"
}

command_exists() {
  command="$1"

  if command -v "$command" > /dev/null; then
    return 0
  else
    return 1
  fi
}

install_yay() {
  script_path="$(realpath $0)"
  temp_path="$(dirname $script_path)"
  install_path="$HOME/yay"
  needed_packages=("git" "base-devel")

  install_packages "${needed_packages[@]}"

  if [ -d "$install_path" ]; then
    echo "The install directory for yay ($install_path) already exists"
    read -p "Would you like to delete the existing yay install directory? [Y/n]: "
    case $yn in
      [Nn]*)
        cd "$install_path"
        makepkg -si
        echo ":: yay has been installed successfully"
        ;;
      *)
        rm -rf "$install_path"
        git clone https://aur.archlinux.org/yay.git "$install_path"
        cd "$install_path"
        makepkg -si
        echo ":: yay has been installed successfully"
        ;;
    esac
  else
    git clone https://aur.archlinux.org/yay.git "$install_path"
    cd "$install_path"
    makepkg -si
    echo ":: yay has been installed successfully"
  fi

  cd "$temp_path"
}

install_packages_with_yay() {
  uninstalled_packages=()

  for package; do
    if is_installed "$package"; then
      echo ":: $package is already installed"
      continue
    fi

    uninstalled_packages+=("$package")
  done

  [[ -z "${uninstalled_packages[@]}" ]] && return

  echo "The following packages will be installed:"
  printf "  %s\n" "${uninstalled_packages[@]}"
  yay -S "${uninstalled_packages[@]}"
}

DOTFILES_DIR="$HOME/dotfiles"

packages=(
  "zsh"
  "fzf"
  "vivid"
  "eza"
  "bat"
  "zoxide"
  "gcc"
  "make"
  "git"
  "github-cli"
  "ripgrep"
  "fd"
  "unzip"
  "neovim"
  "tmux"
  "pokeget"
  "fastfetch"
  "cmatrix"
  "pipes.sh"
  "cava"
  "stow"
)

clear

cat << "EOF"
  ____       _
 / ___|  ___| |_ _   _ _ __
 \___ \ / _ \ __| | | | '_ \
  ___) |  __/ |_| |_| | |_) |
 |____/ \___|\__|\__,_| .__/
                      |_|

EOF

echo ":: Installing yay..."
if command_exists "yay"; then
  echo ":: yay is already installed"
else
  install_yay
fi

sudo pacman -Sy

cat << "EOF"
  ___           _        _ _
 |_ _|_ __  ___| |_ __ _| | |
  | || '_ \/ __| __/ _` | | |
  | || | | \__ \ || (_| | | |
 |___|_| |_|___/\__\__,_|_|_|

EOF

read -p "Would you like to continue with the installation process? [Y/n]: " yn
case $yn in
  [Nn]*)
    echo "Aborting installation process..."
    exit
    ;;
  *)
    ;;
esac

echo ":: Installing packages..."
install_packages_with_yay "${packages[@]}"

echo ":: Cloning dotfiles GitHub repository"
if [ -d "$DOTFILES_DIR" ]; then
  echo "The dotfiles directory ($DOTFILES_DIR) already exists and must be deleted in order to continue"
  read -p "Would you like to delete it the existing dotfiles directory? [y/N]: " yn
  case $yn in
    [Yy]*)
      rm -rf "$DOTFILES_DIR"
      git clone "https://github.com/kirjahri/dotfiles.git" "$DOTFILES_DIR"
      ;;
    *)
      echo "Aborting installation process..."
      exit
      ;;
  esac
else
  git clone "https://github.com/kirjahri/dotfiles.git" "$DOTFILES_DIR"
fi

echo ":: Changing into dotfiles directory..."
cd "$DOTFILES_DIR"

echo "WARNING: Any existing files in the '~/.config' directory that interfere will be overwritten"
read -p "Are you sure you want to continue? [y/N]: " yn
case $yn in
  [Yy]*)
    ;;
  *)
    echo "Aborting installation process..."
    exit
    ;;
esac

echo "The .gitconfig file contains Git configuration files for the repo owner; it is likely you do not want this"
read -p "Would you like to delete .gitconfig? [Y/n]: " yn
case $yn in
  [Nn]*)
    ;;
  *)
    rm .gitconfig
    ;;
esac

echo ":: Symlinking configuration files..."
stow --adopt .
git restore . # the --adopt on stow flog overwrites the files in the dotfiles folder so this is done in order to restore them

chsh -s $(which zsh)

cat << "EOF"
  ____           _       ___           _        _ _
 |  _ \ ___  ___| |_    |_ _|_ __  ___| |_ __ _| | |
 | |_) / _ \/ __| __|____| || '_ \/ __| __/ _` | | |
 |  __/ (_) \__ \ ||_____| || | | \__ \ || (_| | | |
 |_|   \___/|___/\__|   |___|_| |_|___/\__\__,_|_|_|

EOF

echo "A reboot must be done in order to ensure that all configurations are working correctly"
read -p "Would you like to reboot your system? [Y/n]: " yn
case $yn in
  [Nn]*)
    ;;
  *)
    echo ":: Rebooting..."
    systemctl reboot
    ;;
esac
