# .dotfiles

These are my dotfiles

### Stow
Use stow to symlink files to home dir

```sh
cd ~/.dotfiles
stow home
```

### Submodules
Some external tools are just added as submodules.

##### Pulling submodule data:
Run: `git submodule update --init --recursive`

##### Updating submodules to newest commit:
Run: `git submodule update --remote --merge`
