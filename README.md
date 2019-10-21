# Install

```
echo "source-file ${PWD}/tmux.conf" >> ~/.tmux.conf
echo "source ${PWD}/vimrc" >> ~/.vimrc
echo "source ${PWD}/zshrc" >> ~/.zshrc

git config --global core.excludesFile ${PWD}/gitignore
git config --global include.path ${PWD}/gitconfig
git config --global user.name "$(id -F)"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall

brew bundle

open Solarized\ Light.terminal
open Solarized\ Dark.terminal

osascript <<END
  tell application "Terminal"
    set default settings to settings set "Solarized Light"
  end tell
END
```
