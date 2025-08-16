alias gst='git status'
alias gck='git checkout'
alias gck='git checkout'
alias gckm='git checkout $(git branch | cut -c 3- | grep -E "^master$|^main$")'
alias gp='git pull'
alias jpi='git commit -m "just pushing it" && git push'
alias ds='docker ps'
alias c='clear'

# For Linux machines with Gnome
alias pbcopy='xsel --clipboard --input'
alias open='nautilus'

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


function idea() {
    open -na "IntelliJ IDEA.app" --args "$@"
}

function ns() {kubectl config set-context $(kubectl config current-context) --namespace=$1}

autoload -Uz compinit
compinit
# End of lines added by compinstall
#

 if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
 fi

# eval `ssh-agent -s`
#ssh-add ~/.ssh/id_rsa

plugins=(git ssh-agent)


autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -o nospace -C /usr/local/bin/terraform terraform

alias k=kubectl
complete -F __start_kubectl k
source <(kubectl completion zsh)

_kubecontext() {
    export _KUBECLUSTER=$(kubectl config get-contexts --no-headers | grep '*' | awk '{ print $3 }')
    export _KUBENAMESPACE=$(kubectl config get-contexts --no-headers | grep '*' | awk '{ print $5 }')
    if [[ "$_KUBECLUSTER" != "" ]]; then
        if [[ "$_KUBECLUSTER" =~ -prod ]]; then
            printf "[kube:${BLINK}${FG_WHITE}${BG_RED}$_KUBECLUSTER${RESET}"
        else
            printf "[kube:${FG_CYAN}$_KUBECLUSTER${RESET}"
        fi
        printf "/${FG_RED}${_KUBENAMESPACE:-default}${RESET}"
        printf "] "
    fi
}

eval "$(direnv hook bash)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

