source ~/.zsh/plugins/zsh-async/async.zsh
async_init
async_start_worker prompt_worker -u
async_register_callback prompt_worker update_prompt

CBACKZEN_INSTALLATION_PATH="$(dirname $0)"

# set the default prompt
source "$CBACKZEN_INSTALLATION_PATH/status_functions.zsh"
local default_prompt="%F{green}»%f $(get_path) %F{blue}%#%f "
export PROMPT="${default_prompt}"

# this function is called by the async worker with the result of async_update.sh
function update_prompt() {
  # if $3 is empty then return a default prompt
  if [[ -z "${3}" ]]; then
    export PROMPT="${default_prompt}" &&
  else
    export PROMPT="${3}"
  fi
}

# called before the prompt is drawn
function precmd() {
  async_job prompt_worker zsh $CBACKZEN_INSTALLATION_PATH/async_update.sh
}
