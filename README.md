# Install

```
echo "source-file ${PWD}/tmux.conf" >> ~/.tmux.conf
echo "source ${PWD}/vimrc" >> ~/.vimrc
echo "source ${PWD}/zshrc" >> ~/.zshrc

git config --global core.excludesFile ${PWD}/gitignore
git config --global include.path ${PWD}/gitconfig

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall

brew bundle
```
