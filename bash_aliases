# Additional aliases
# completely hard-coded for my windows laptop running wsl

# alacritty config
alias acfg='nvim /mnt/c/Users/Josh/AppData/Roaming/alacritty/alacritty.toml'

# nvim config
alias nvcfg='nvim ~/.config/nvim/init.lua'

# bash aliases
alias aliascfg='nvim ~/.config/bash-extra/bash_aliases'

# make cd always auto ls
cd() {
    builtin cd "$@" && ls
}















# quick config git push
cfgpush() {
  # Map names to directories
  declare -A cfg_dirs=(
    [nvcfg]="$HOME/.config/nvim"
    [aliascfg]="$HOME/.config/bash-extra"
    [acfg]="/mnt/c/Users/Josh/AppData/Roaming/alacritty"
  )


  local cfg="$1"
  if [ -z "$cfg" ]; then
    echo "Usage: cfgpush <config-name>"
    echo "Available configs: ${!cfg_dirs[@]}"
    return 1

  fi

  local dir="${cfg_dirs[$cfg]}"
  if [ -z "$dir" ]; then
    echo "Unknown config: $cfg"

    echo "Available configs: ${!cfg_dirs[@]}"
    return 1
  fi


  # Go to directory
  cd "$dir" || { echo "Failed to cd into $dir"; return 1; }

  # Check for changes
  if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "Updated $cfg config"
    git push
    echo "$cfg config pushed successfully."
  else
    echo "No changes to commit in $dir"
  fi

  # Return to original directory
  cd - >/dev/null || return
}
