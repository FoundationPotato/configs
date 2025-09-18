# Begin bash funcs

function fvi {
  nvim $(fzf)
}

function rvi {
  cd && nvim $(fzf) && cd -
}

function fcd {
  cd $(find * -type d | fzf)
}

function rcd {
  cd && cd $(find * -type d | fzf)
}

function source-bash {
  source ~/.bashrc
}

function edit-vim {
  nvim ~/.config/nvim/init.lua
}

function git_branch {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1="\[\e[95m\]\\u@\\h: \[\e[96m\]\\W\\[\e[97m\] $ "

# End bash funcs
