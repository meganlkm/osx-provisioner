# osx-provisioner

1. [Get It](#user-content-get-the-package)
2. [Configure It](#user-content-reviewedit-variable-values-and-files)
3. [Provision It](#user-content-only-install-what-you-want)

[TODO](#user-content-todo)

* fix osxdefaults script execution

===

### get the package

download package with pre-installed tools:
````
python -c "import urllib; urllib.urlretrieve('https://github.com/meganlkm/osx-provisioner/archive/master.tar.gz', 'tmp.tar.gz')" && tar zxvf tmp.tar.gz && rm tmp.tar.gz
````

OR

Clone it:
````
git clone https://github.com/meganlkm/osx-provisioner.git
````

### Review/Edit variable values and files:

- ansible/roles/brew/defaults/*.yml
- ansible/roles/brew/vars/*.yml
- ansible/roles/brew-cask/defaults/main.yml
- ansible/roles/brew-cask/vars/main.yml
- ansible/roles/dotfiles/defaults/*.yml
- ansible/roles/dotfiles/files/*
- ansible/roles/mkdirs/defaults/*.yml
- ansible/roles/osx-defaults/files/osxdefaults.sh
- ansible/roles/python/defaults/*.yml
- ansible/roles/ssh/defaults/*.yml
- ansible/roles/sublime-text3/defaults/*.yml
- ansible/st3_configs/Package Control.sublime-settings


### Only install what you want

Remove or add things to the main playbook:
````
ansible/site.yml
````

Provision your system:
````
sh init.sh
````

## TODO

1. finish refactoring osx-defaults
2. port mkpy stuff to python package
3. gimp (http://www.gimp.org/source/howtos/gimp-git-build.html)
4. readmes for each role
5. move st3_configs to sublime-text3 role
6. install curl if it does not exist before installing rvm
