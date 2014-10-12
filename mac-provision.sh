#!/bin/bash
# mac provisioner

# resources
#   https://gist.github.com/brandonb927/3195465
#   http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
#   http://il.luminat.us/blog/2014/04/19/how-i-fully-automated-os-x-with-ansible/
#   https://github.com/shrikeh/mac-provisioning/blob/master/install.sh

DATE=$(date +"%Y%m%d")
LOGDIR="${HOME}/.logs/local-provisioning"
LOGFILE="provision_${DATE}.log"
MYLOG="${LOGDIR}/$LOGFILE"

[[ ! -d ${LOGDIR} ]] && mkdir -p ${LOGDIR}
echo '' > ${MYLOG} # for dev..

function command_exists () {
    \command -v ${1} > /dev/null 2>&1 || {
        return 1
    }
}

# Download and install Command Line Tools
if ! command_exists "gcc"; then
    echo "installing xcode..." >> ${MYLOG}
    xcode-select --install
else
    echo "xcode already installed - skipping..." >> ${MYLOG}
fi

# install ruby/rvm
if ! command_exists "rvm"; then
    echo "installing rvm..." >> ${MYLOG}
    \curl -L https://get.rvm.io | bash -s stable --autolibs=read-fail --auto-dotfiles
    source ~/.rvm/scripts/rvm
    rvm install ruby
    type rvm | head -1
else
    echo "rvm already installed - skipping..." >> ${MYLOG}
fi

# Check for Homebrew
if ! command_exists "brew"; then
  echo "installing homebrew..." >> ${MYLOG}
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" >> ${MYLOG}
else
    echo "homebrew already installed - skipping..." >> ${MYLOG}
fi
echo "updating brew..." >> ${MYLOG}
brew update
brew doctor

# Set up rvm to use homebrew for dependencies
echo "Set up rvm to use homebrew for dependencies..." >> ${MYLOG}
rvm autolibs homebrew

echo "updated system utils..." >> ${MYLOG}
unix_stuff=(coreutils findutils bash)
brew install ${unix_stuff[@]}

echo "installing binaries with brew..." >> ${MYLOG}
brew_bins=(
    fontconfig gettext jpeg libyaml ossp-uuid unixodbc freetype libpng mcrypt
    python python3 openssl sqlite zlib git
    wget htop ansible ssh-copy-id gnu-sed curl curl-ca-bundle dos2unix
    gd icu4c libtiff mhash readline autoconf gdbm imagemagick libtool
    grc  vcprompt optipng  tmux
)

#    graphicsmagick webkit2png rename zopfli ffmpeg sshfs
#    trash node tree ack hub

for pkg in ${brew_bins[@]}; do
    if [[ -d "/usr/local/Cellar/${pkg}" ]] || command_exists ${pkg}; then
        echo "${pkg} is already installed" >> ${MYLOG}
    else
        echo "installing [${pkg}]" >> ${MYLOG}
        brew install ${pkg}
    fi
done

brew cleanup

echo "installing gnugrep..." >> ${MYLOG}
brew tap homebrew/dupes
brew install homebrew/dupes/grep
$PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH

CASKDIR=/etc/Caskroom
[[ ! -d ${CASKDIR} ]] && sudo mkdir -p ${CASKDIR}
sudo chown -R ${DEFAULT_USER}:${DEFAULT_GROUP} ${CASKDIR}

# Install Cask
# https://github.com/caskroom/homebrew-cask/blob/master/USAGE.md
echo "installing cask..." >> ${MYLOG}
brew install caskroom/cask/brew-cask
brew update

# add to .bash_profile
export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/etc/Caskroom"

# qlcolorcode   https://code.google.com/p/qlcolorcode/
# qlmarkdown    https://github.com/toland/qlmarkdown
#               https://github.com/sindresorhus/quick-look-plugins
# shiori        http://aki-null.net/shiori/
# nvalt         http://brettterpstra.com/projects/nvalt/
cask_apps=(
  alfred
  google-chrome firefox flash
  qlcolorcode qlmarkdown qlprettypatch qlstephen quicklook-json
  appcleaner
  vagrant virtualbox
  shiori nvalt
  dropbox mailbox
  skype adium
)
# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing cask apps..." >> ${MYLOG}
brew cask install ${cask_apps[@]}

echo "installing sublime-text3..." >> ${MYLOG}
brew tap caskroom/versions
# brew cask install --appdir="/Applications" sublime-text3
brew cask install sublime-text3
# install sublime text packages?

# not now... screenflick slack hazel seil spotify arq iterm2 flux sketch tower
# not now... vlc cloudup atom

echo "linking apps..." >> ${MYLOG}
brew linkapps
brew cask alfred link

# install pip and pip packages
sudo pip install virtualenv virtualenvwrapper PyYAML shyaml

# create rsa pub/priv key
# gimp
# install my dot files

sh mac-defaults.sh
