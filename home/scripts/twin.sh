#! /bin/zsh

autoload -Uz compinit && compinit

# tmux window helper function
function twin() {
  # Check for exactly one argument (project name)
  if [ $# -ne 1 ]; then
    echo "Usage: twin <project_name>"
    return 1
  fi

  project_name="$1"
  project_path=~/Projects/$project_name

  # Check if a tmux window exists with the specified name
  if tmux list-windows -F '#{window_name}' 2>/dev/null | grep -q "^$project_name$"; then
    echo "Window '$project_name' already exists. Switching to it."
  else
    # Check if the specified name matches a folder in ~/Projects
    if [ -d "$project_path" ]; then
      # Create a new detached window with the specified name and change to the project folder
      tmux new-window -d -n "$project_name" "cd $project_path; zsh"
      echo "Window '$project_name' is ready in folder '$project_path'. Switching to it."
    else
      # Create a new detached window with the specified name
      tmux new-window -d -n "$project_name"
      echo "Window '$project_name' is ready. Switching to it."
    fi
  fi

  # Switch to the window with the specified name
  tmux select-window -t "$project_name"
}

# Autocomplete function for twin
_twin() {
  local -a project_dirs
  local -a exclude_dirs

  # List the names of folders to exclude here
  exclude_dirs=("Projects" "pre-worktree")

  # Build the find command with the exclude conditions
  local find_cmd="find ~/Projects -maxdepth 1 -type d"
  for exclude in "${exclude_dirs[@]}"; do
    find_cmd="$find_cmd -not -name '$exclude'"
  done

  project_dirs=(${(f)"$(eval $find_cmd | sed 's#.*/##')"})
  _describe 'project directory' project_dirs
}

# Tell Zsh to use the _twin function for autocompletion of the twin command
compdef _twin twin
