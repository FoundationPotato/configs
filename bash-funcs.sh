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

function parse_git_branch {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1="\[\e[95m\]\\u@\\h: \[\e[96m\]\\W\\[\e[97m\] $(parse_git_branch)\[\e[00m\]$ "

# End bash funcs
