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
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

if ! command_exists "python"; then
    brew install python --framework --with-brewed-openssl
fi

if ! command_exists "pip"; then
    sudo easy_install pip
fi

rvm autolibs homebrew

ansible-playbook --ask-sudo-pass -i ansible/inventories/osx ansible/site.yml --connection=local
brew linkapps
brew cleanup

source ~/.bash_profile
