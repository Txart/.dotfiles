# Activate python env in the current directory, if present at .venv/
alias apy='source .venv/bin/activate'

# todo.sh -> t
alias t='todo.sh'

# zoxide return to latest dir
alias zz='z -'

# ls -> eza
alias ls='eza --long'

# lazygit -> gg
alias gg='lazygit'

# File deleting operations.
# - Make rm default to asking for confirmation. rm eliminates the file
# - Move file to system trash with the command `rmtt` "ReMove To Trash"
alias rm='rm -i'
alias rmtt='gio trash'

# different neovim configs
alias nvim-quarto="NVIM_APPNAME=quarto-nvim-kickstarter nvim"
alias nw="NVIM_APPNAME=nvim-writer nvim -c 'normal \`0'" # The strange thing at the end opens last file 

# Pika backup software
alias pika="flatpak run org.gnome.World.PikaBackup"

# Zotero
alias zotero="./software/zotero/zotero"

# bat
alias bat="batcat"

# Reminder to use trash instead of rm
alias rm="echo Consider using trash instead. If you insist, use the full path, i.e. 'usr/bin/rm', instead."

# Set screen temperatures
alias ,day="xsct 0 1"
alias ,night="xsct 2500 0.5"

# Zola
alias zola="/home/txart/software/zola-v0.22.1-x86_64-unknown-linux-gnu/zola"

# Added key for ssh git operations
alias gitkey='ssh-add -c ~/.ssh/id_ed25519'

# jlab: Run jupyter lab with extensions
alias jlab='uv run --with jupyterlab-vim --with jupyterlab-lsp --with basedpyright --with jupyterlab-code-formatter jupyter lab'
