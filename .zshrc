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

# Google Cloud shortcuts
alias klocal='kubectl config use-context docker-desktop'
alias tkn='gcloud auth print-access-token | pbcopy'


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

# source <(kubetpl completion zsh)
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

# alias idea='open -na "IntelliJ IDEA.app" --args "$@"'

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


UB_BASE_IMAGE=ubuntu
function __ub-shell {
    if [ -n "$1" ]; then
        NAMESPACE=$1
    else
        echo "Namespace no specified, deploying to default namespace"
        NAMESPACE="default"
    fi
    shift
    kubectl run ub-shell --rm -it -n $NAMESPACE --image UB_BASE_IMAGE -- bash
}


function __proxy-db() {
	DB_NAME=$1
	PROJECT_ID=$2
	PROXY_PORT=$3
	kill $(lsof -i :$PROXY_PORT -t)
	cloud_sql_proxy  -quiet -instances=$PROJECT_ID":us-central1:$DB_NAME=tcp:$PROXY_PORT" -dir ~/tmp/ &
	gcloud auth print-access-token --project=$PROJECT_ID | pbcopy
	sleep 1.5
	echo "\n\nCloud SQL proxy started on $PROXY_PORT for $DB_NAME in $PROJECT_ID. Your access token has been copied to your clipboard\n\n"
}


# function proxy-notifier-db-nonprod() {
# 	__proxy-db 'example-db1' 'example-project' 6700
# }



# export NVM_DIR="$HOME/.nvm"
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


function pod() {
    __ub-shell "$@"
}

# export JAVA8_HOME='/Users/s119516/Library/Java/JavaVirtualMachines/azul-1.8.0_302/Contents/Home'
# export JAVA_HOME=$JAVA8_HOME

