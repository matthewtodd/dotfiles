# Install

```
echo "source $(PWD)/profile" >> ~/.profile
echo "source-file $(PWD)/tmux.conf" >> ~/.tmux.conf
echo "source $(PWD)/vimrc" >> ~/.vimrc

git config --global core.excludesFile $(PWD)/gitignore
git config --global include.path $(PWD)/gitconfig
git config --global init.templateDir $(PWD)/gittemplate

brew tap homebrew/bundle
brew bundle

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall
```
