function check_tmux() {
  if [[ -z $TMUX ]]; then
    echo '¤'
  fi
}

function parse_git_dirty() {
  local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [[ -n $(git status -s --ignore-submodules 2> /dev/null) ]]; then
    echo "%F{11}${branch}%f"
  else
    echo "%F{12}${branch}%f"
  fi
}

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "%F{blue}(%f$(parse_git_dirty)%F{blue})%f "
}

function check_virtual_env() {
  # Check for Conda environment
  if [[ -n $CONDA_DEFAULT_ENV ]]; then
    if [[ $CONDA_DEFAULT_ENV == 'base' ]]; then
      return
    fi
    echo " %F{magenta}($CONDA_DEFAULT_ENV)%f"
  # Check for pyenv or other virtual environments
  elif [[ -n $VIRTUAL_ENV ]]; then
    echo " %F{magenta}($(basename $VIRTUAL_ENV))%f"
  fi
}

function get_path() {
  local path_var="%~"
  if [ "$1" = "0" ] || [ "$1" = "false" ]; then
      path_var="%1~"
  fi
  echo "%F{10}${path_var}%f"
}
