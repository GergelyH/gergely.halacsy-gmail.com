sudo pacman -Syyu
# SSH
ssh-keygen -t ed25519 -C "gergely.halacsy@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
sudo pacman -S xclip
xclip -selection clipboard < ~/.ssh/id_ed25519.pub
while true; do
    read -p "Ssh keys has been added to the clipboard, please copy it to your github account" yn
    case $yn in
        [Yy]* ) make install; break;;
        * ) echo "Please answer yes to continue";;
    esac
done

alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
cd
mkdir dotfiles
config init
git add remote origin git@github.com:GergelyH/linux-config.git
git pull
# Delete TODO files herre

sudo pacman-mirrors -f5 
sudo pacman-key --populate archlinux chaotic
sudo pacman-key --refresh-keys
sudo pacman-key --populate archlinux chaotic
sudo pacman -Syyu --noconfirm
cat .config/pacman_list.txt | xargs sudo pacman --noconfirm -S



#NVIM
sudo pacman -S python-pip
~/.config/lunar-vim-install.sh
cd ~/.config/nvim
git remote remove origin
git remote add origin git@github.com:GergelyH/nvim-config.git
git fetch origin
git checkout own

#flutter
yay -S flutter --noconfirm
sudo chown -R $USER /opt/flutter
flutter
yay -S android-sdk android-sdk-platform-tools android-sdk-build-tools android-sdk-cmdline-tools-latest android-platform
sudo flutter doctor --android-licenses
sudo sdkmanager --install "system-images;android-29;default;x86"
sudo chown -R $USER $ANDROID-SDK-ROOT

#zsh
KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#tmux
cd
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf


