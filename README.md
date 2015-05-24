= Install

```
ln -s profile ~/.profile
ln -s tmux.conf ~/.tmux.conf
ln -s vimrc ~/.vimrc

git config --global core.excludesFile .../gitignore
git config --global include.path .../gitconfig
git config --global init.templateDir .../gittemplate

brew install ctags git reattach-to-user-namespace the_silver_searcher tmux

vim +PluginInstall +qall
```
