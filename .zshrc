EDITOR=/usr/bin/nvim

PATH="$PATH:$HOME/.local/bin"

# Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ross/.zshrc'

fpath+=~/.zfunc

autoload -Uz compinit
compinit
# End of lines added by compinstall
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function v() {
  if [ $# -eq 0 ]
    then
      nvim .
  else 
    nvim $@
  fi
}

alias g='git'
alias gst='git status'
alias gck='git checkout'
alias gp='git pull'
alias ds='docker ps'
alias pbcopy='xsel --clipboard --input'
alias open='nautilus'
alias jpi='git commit -m "just pushing it" && git push'
alias c='clear'
alias gckm='git checkout $(git branch | cut -c 3- | grep -E "^master$|^main$")'
alias gal='git add . && git status'
alias gl='git --no-pager log --oneline -n 20'

function gr() {
  local remote_url=$(git config --get remote.origin.url)

  if [[ -z "$remote_url" ]]; then
    echo "Error: No remote 'origin' found."
    return 1
  fi

  # Check and handle SSH vs. HTTPS URLs
  if [[ "$remote_url" =~ ^git@ ]]; then
    # Convert SSH to HTTPS
    remote_url=${remote_url/git@/https://}
    remote_url=${remote_url/:/\/}
  fi

  # Remove the .git suffix
  remote_url=${remote_url/.git//}

  # Use 'xdg-open' for Linux, 'open' for macOS, and 'start' for Windows (Git Bash)
  if command -v xdg-open > /dev/null; then
    xdg-open "$remote_url"
  elif command -v open > /dev/null; then
    open "$remote_url"
  elif command -v start > /dev/null; then
    start "$remote_url"
  else
    echo "Error: Could not find a suitable command to open a browser."
    return 1
  fi
}

# Local Cargo instance
alias lc=/home/$USER/projects/cargo/target/debug/cargo
alias lcr=/home/$USER/projects/cargo/target/release/cargo

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# Disable autocorrect
unsetopt correct

# Override the default command not found handler.
# Its sometimes slow because its trying to find the command on the internet. maybe?
command_not_found_handle() {
    echo "'$1' command not found" >&2
    return 1
}

# pnpm
export PNPM_HOME="/home/ross/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Keyboard layout switching on linux
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx

# Make cursor a vertical line
echo -en "\033[6 q"

