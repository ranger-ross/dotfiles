alias gst='git status'
alias ga='git add .'
alias cl='clear'

# Use winpty to allow the Docker -it flag in Git bash
alias docker='winpty docker'

# Enable for Kubernetes Autocomplete
# alias k='kubectl'
# source <(kubectl completion bash)
# complete -F __start_kubectl k

# Enable for GNU Make autocomplete
# complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make

git_stats() {
  local STATUS=$(git status -s 2> /dev/null)
  local ADDED=$(echo "$STATUS" | grep '??' | wc -l)
  local DELETED=$(echo "$STATUS" | grep ' D' | wc -l)
  local MODIFIED=$(echo "$STATUS" | grep ' M' | wc -l)
  local STATS=''
  if [ $ADDED != 0 ]; then
    STATS="\e[32m•\e[0m"
  fi
  if [ $DELETED != 0 ]; then
    STATS="$STATS\e[91m•"
  fi
  if [ $MODIFIED != 0 ]; then
    STATS="$STATS\e[30;93m•"
  fi
  echo -e "\e[0m$STATS\e[0m"
}

# Customize Bash prompt
PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\n\033[38;5;177m\u \[\033[37m\]at \033[38;5;208m\h \[\033[37m\]in \033[38;5;119m\w\[\033[36m\]`__git_ps1`\[\033[0m\] `git_stats` \n$ '

