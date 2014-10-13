#!/bin/bash

function command_exists () {
    \command -v ${1} > /dev/null 2>&1 || {
        return 1
    }
}

if ! command_exists "gcc"; then
    xcode-select --install
fi

if ! command_exists "rvm"; then
    \curl -L https://get.rvm.io | bash -s stable --autolibs=read-fail --auto-dotfiles
    source ~/.rvm/scripts/rvm
    rvm install ruby
    type rvm | head -1
fi

if ! command_exists "brew"; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

source $HOME/.bash_profile

if ! command_exists "ansible"; then
    brew install ansible
fi

if ! command_exists "python"; then
    brew install python --framework --with-brewed-openssl
fi

if ! command_exists "pip"; then
    sudo easy_install pip
fi

if command_exists "rvm"; then
    rvm autolibs homebrew
fi

if command_exists "ansible-playbook"; then
    ansible-playbook --ask-sudo-pass -i ansible/inventories/osx ansible/site.yml --connection=local
fi

if command_exists "brew"; then
    brew linkapps
    brew cleanup
fi

echo "Completed... A restart might be requried. You may need to reload your bash_profile - execute this command:\n   source ~/.bash_profile"
