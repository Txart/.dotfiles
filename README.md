# My dotfiles
This directory contains the relevant dotfiles for my system

## Stow
I use gnu stow to manage the dotfiles.

In my machine this repo lives inside `~/.dotfiles/`.

`stow` is used to symlink the child to the parent directory. So, running
`stow .`
inside `~/.dotfiles/` creates the correct symlinked folder structure for:
- `.bashrc` and possibly others in `$HOME`
- all the program-specific configs in `~/.config`
