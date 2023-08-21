source ~/.zsh/plugins/zsh-async/async.zsh
async_init

async_start_worker prompt_worker -u
async_register_callback prompt_worker update_prompt

CBACKZEN_INSTALLATION_PATH="$(dirname $0)"

function update_prompt() {
  # if $3 is empty then return a default prompt
  if [[ -z "${3}" ]]; then
    PROMPT="%F{green}»%f ${current_path} %F{blue}%#%f " &&
  else
    PROMPT="${3}"
  fi
}

function precmd() {
  async_job prompt_worker zsh $CBACKZEN_INSTALLATION_PATH/async_update.sh $CBZEN_FULL_PATH
}

source "$CBACKZEN_INSTALLATION_PATH/status_functions.zsh"

local current_path=$(get_path)

PROMPT="$(check_tmux)%F{green}»%f ${current_path} %F{blue}%#%f "
