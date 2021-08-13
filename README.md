## Neovim Plugins

### Adding

```
# Add the plugin as a submodule in our package.
git submodule add --name nerdtree \
  https://github.com/preservim/nerdtree \
  etc/nvim/pack/matthewtodd/start/nerdtree
```

### Tracking a Different Branch

```
git config -f .gitmodules submodule.nerdtree.branch stable
```

### Updating

```
./install
```

### Removing

```
# Via https://git-scm.com/docs/gitsubmodules
#
# Deleted submodule: A submodule can be deleted by running
# `git rm <submodule path> && git commit`. This can be undone using git revert.
#
# The deletion removes the superproject’s tracking data, which are both the
# gitlink entry and the section in the .gitmodules file. The submodule’s working
# directory is removed from the file system, but the Git directory is kept around
# as it to make it possible to checkout past commits without requiring fetching
# from another repository.
#
# To completely remove a submodule, manually delete `$GIT_DIR/modules/<name>/`.

git rm etc/nvim/pack/matthewtodd/start/nerdtree
```

