#!/usr/bin/env bash

# TODO:  Configure NVM

## Always update first
sudo softwareupdate -i -a

## Set some macOS settings
defaults write com.apple.finder AppleShowAllFiles YES
defaults write com.apple.menuextra.battery ShowPercent YES
defaults write -g KeyRepeat -int 1
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2
# I don't think this currently works, so I put something in the README to do it manually
defaults write ~/Library/Preferences/.GlobalPreferences com.apple.swipescrolldirection -bool false
sudo fdesetup enable
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

## Install some basic tools
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew cask install java caskroom/versions/java8
brew install python python3 go maven@3.3 maven git wget gnupg2 ant npm yarn nmap bro swig cmake openssl jq azure-cli hashcat shellcheck packer bro nvm dos2unix testssl ttygif tree vim imagemagick ruby autoconf automake libtool gnu-tar pandoc aircrack-ng bash libextractor fortune cowsay lolcat wine winetricks awscli terraform kubectl nuget
npm install -g @angular/cli
brew cask install vagrant virtualbox google-chrome sublime-text vmware-fusion wireshark mysqlworkbench iterm2 slack steam firefox the-unarchiver gpg-suite docker burp-suite etcher playonmac atom powershell veracrypt beyond-compare drawio visual-studio-code little-snitch micro-snitch launchbar gfxcardstatus snagit Keyboard-Maestro hazel bloodhound neo4j xquartz playonmac tunnelblick google-cloud-sdk keybase surge keka microsoft-office evernote wire yubico-yubikey-manager yubico-authenticator
brew install weechat --with-aspell --with-curl --with-python@2 --with-perl --with-ruby --with-lua
# Twisted version is for sslstrip
sudo pip install virtualenv boto twisted==16.4.1 service_identity pyasn1-modules cryptography
sudo pip3 install boto3 paramiko selenium jupyter pyasn1-modules cryptography bcrypt asn1crypto ipaddress jedi docopt impacket
brew install numpy scipy ansible
brew cleanup
sudo gem install jekyll
# TODO:  powershell install-module azurerm azure

## Set some application settings
defaults write com.aone.keka ZipUsingAES TRUE # https://github.com/aonez/Keka/wiki/ZipAES

## Configure the environment
wget -O ~/.bash_profile https://raw.githubusercontent.com/jonzeolla/configs/master/apple/productivity/.bash_profile
source ~/.bash_profile
wget -O ~/.bash_prompt https://raw.githubusercontent.com/jonzeolla/configs/master/apple/productivity/.bash_prompt
source ~/.bash_prompt
wget -O ~/.screenrc https://raw.githubusercontent.com/jonzeolla/configs/master/apple/productivity/.screenrc
mkdir -p ~/bin ~/etc ~/src/testing ~/src/seiso
sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/local/bin/airport

## Start some things up
open /Applications/Docker.app
open /Applications/LaunchBar.app
open /Applications/gfxcardStatus.app
open /Applications/Micro\ Snitch.app
open /Applications/Evernote.app

## Clone some good repos
cd ~/src
git clone https://github.com/jordansissel/fpm
git clone https://github.com/apache/metron
git clone https://github.com/apache/metron-bro-plugin-kafka
git clone https://github.com/bro/bro --recurse-submodules
git clone https://github.com/jonzeolla/configs ~/src/jonzeolla/configs/
git clone https://github.com/jonzeolla/development ~/src/jonzeolla/development/

## Setup fpm
cd ~/src/fpm
latesttag=$(git describe --tags)
git checkout ${latesttag}
gem install --no-ri --no-rdoc fpm

## Setup vagrant
# Install the hostmanager
vagrant plugin install vagrant-hostmanager

# Install VMWare Fusion plugin license
while [ -z "${prompt}" ]; do
  read -p "Is your license for vagrant-vmware-fusion in ~/license.lic? [Y/n]" prompt
  case "${prompt}" in
    ""|[yY]|[yY][eE][sS])
      echo -e "Installing the VMWare Fusion plugin for vagrant"
      vagrant plugin install vagrant-vmware-fusion
      vagrant plugin license vagrant-vmware-fusion ~/license.lic
      ;;
    [nN]|[nN][oO])
      read -p "Where is your license.lic file?  " location
      if [ -z "${location}" ]; then
        echo -e "No license file specified, not installing the VMWare Fusion plugin for vagrant"
      else
        vagrant plugin install vagrant-vmware-fusion
        vagrant plugin license vagrant-vmware-fusion "${location}"
      fi
      ;;
    *)
      echo -e "Unknown response, not configuring the VMWare Fusion plugin for vagrant" ;;
  esac
done

## Setup git
wget -O ~/.gitconfig https://raw.githubusercontent.com/JonZeolla/Configs/master/apple/productivity/.gitconfig
wget -O ~/src/seiso/.gitconfig https://raw.githubusercontent.com/JonZeolla/Configs/master/apple/productivity/.seisogitconfig

## Setup GnuPG
mkdir ~/.gnupg
echo "use-standard-socket" >> ~/.gnupg/gpg-agent.conf

## Setup vim
# Setup pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
# Pull down my .vimrc
wget -O ~/.vimrc https://raw.githubusercontent.com/jonzeolla/configs/master/apple/productivity/.vimrc
# Set up vim-sensible
cd ~/.vim/bundle && git clone https://github.com/tpope/vim-sensible.git
# Set up vim-colors-solarized
cd ~/.vim/bundle && git clone git://github.com/altercation/vim-colors-solarized.git
# Set up jedi-vim
cd ~/.vim/bundle && git clone --recursive https://github.com/davidhalter/jedi-vim.git

## Setup iTerm2
mkdir -p ~/.iterm2/
wget -O ~/.iterm2/solarized_dark.itermcolors https://raw.githubusercontent.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors
defaults write com.googlecode.iterm2 AboutToPasteTabsWithCancel 0
wget -O ~/Library/Preferences/com.googlecode.iterm2.plist https://raw.githubusercontent.com/jonzeolla/configs/master/apple/productivity/com.googlecode.iterm2.plist

## Setup weechat
mkdir -p ~/.weechat/certs/
# Update the ca-bundle
curl https://curl.haxx.se/ca/cacert.pem > ~/.weechat/certs/ca-bundle.crt

# Setup weechat
while [ -z "${prompt}" ]; do
  read -p "Open and then close weechat before moving forward.  Enter Yes to this prompt when you are done."
  case "${prompt}" in
    ""|[yY]|[yY][eE][sS])
      echo -e "Continuing..."
      ;;
    [nN]|[nN][oO])
      echo -e "Negative response, exiting..."
      exit
      ;;
    *)
      echo -e "Unknown response, exiting..."
      exit
      ;;
  esac
done

sed -i '' 's#gnutls_ca_file.*#gnutls_ca_file = "~/.weechat/certs/ca-bundle.crt"#' ~/.weechat/weechat.conf
# Setup irc.conf
# Freenode
echo '[server]
freenode.addresses = "chat.freenode.net/7000"
freenode.sasl_username = "jzeolla"
freenode.sasl_password "${sec.data.freenode}"
freenode.autoconnect = on
freenode.nicks = "jzeolla,jzeolla_"
freenode.username = "jzeolla"
freenode.realname = "jzeolla"
freenode.autojoin = "#apache-metron,#bro,#suricata,#pwning,#faraday-dev"
freenode.ssl = on' | tee -a ~/.weechat/irc.conf > /dev/null
#OFTC
echo '[server]
oftc.addresses = "irc.oftc.net/6697"
oftc.sasl_username = "jzeolla"
oftc.autoconnect = on
oftc.nicks = "jzeolla,jzeolla_"
oftc.username = "jzeolla"
oftc.realname = "jzeolla"
oftc.autojoin = "#ocmdev"
oftc.ssl = on' | tee -a ~/.weechat/irc.conf > /dev/null
