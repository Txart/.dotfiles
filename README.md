# My dotfiles
This directory contains the relevant dotfiles for my system

## Stow
I use gnu stow to manage the dotfiles.

This repo lives inside `~/.config/dotfiles/`.

`stow` is used to symlink the child to the parent directory. So, running
`stow .`
inside `~/.config/dotfiles/` creates the correct symlinked folder structure in `~/.config`
