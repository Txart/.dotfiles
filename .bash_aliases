# Activate python env in the current directory, if present at .venv/
alias apy='source .venv/bin/activate'

# todo.sh -> t
alias t='todo.sh'

# cd -> zoxide
alias cd='z'
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
