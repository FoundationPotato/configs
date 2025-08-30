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

PS1="\[\e[95m\]\\u@\\h: \[\e[96m\]\\W\\[\e[97m\] $ "

# End bash funcs
