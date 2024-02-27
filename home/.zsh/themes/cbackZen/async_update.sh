cd "$1" # change to the directory provided from theme.zsh

source "/Users/zac/.zsh/themes/cbackZen/status_functions.zsh"

local ret_status="%(?:%F{green}»:%F{red}»%s)%f"
local virtual_env_status="$(check_virtual_env)"
local git_status="$(git_prompt_info)"
local current_path=$(get_path)

echo "${ret_status}${virtual_env_status} ${current_path} ${git_status}%F{blue}%#%f "
