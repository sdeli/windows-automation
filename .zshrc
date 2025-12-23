# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/usr/local/opt/openjdk@17"
# OH-MY-ZSH SETUP ===========
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
FZF_BASE="/usr/local/opt/fzf"

plugins=(
    git
    sudo
    nvm
    npm
    fzf
    history
    node
    zsh-autosuggestions
    zsh-syntax-highlighting
    doctl
    npm
    nvm
    minikube
    kubectl
    doctl
    docker
    wp-cli
    jump
    ngrok
    ionic
    helm
    # dirhistory
)

source $ZSH/oh-my-zsh.sh

export JAVA_HOME="/usr/local/opt/openjdk@17"
# PATH ====================
PATH="$PATH:/usr/local/opt/openjdk@17/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$HOME/.nvm/versions/node/v10.16.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.antigen/bundles/robbyrussell/oh-my-zsh/lib:$HOME/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git:$HOME/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/fzf:$HOME/.antigen/bundles/zsh-users/zsh-syntax-highlighting:$HOME/.antigen/bundles/zsh-users/zsh-autosuggestions:$HOME/.antigen/bundles/romkatv/powerlevel10k:$HOME/.fzf/bin:$HOME/Projects/usr-local-bin"

# ALIASES ================
alias myip="curl http://ipecho.net/plain; echo"
alias gcm="git checkout master"
alias amm="git commit --amend --no-edit; git push origin HEAD -f"
export FZF_CTRL_T_COMMAND='find ~/Projects ~/Documents ~/Downloads ~/ \
  -not -path "*/dist/*" \
  -not -path "*/ios/*" \
  -not -path "*/android/*" \
  -not -path "*/node_modules/*" \
  -not -path "*/wp/*" \
  -not -path "*/.git/*" \
  -not -path "*/vendor/*" \
  -not -path "*/bower_components/*" \
  -not -path "*/.npm/*" \
  -not -path "*/.yarn/*" \
  -not -path "*/dist/*" \
  -not -path "*/build/*" \
  -not -path "*/.next/*" \
  -not -path "*/.nuxt/*" \
  -not -path "*/coverage/*" \
  -not -path "*/.nyc_output/*" \
  -not -path "*/tmp/*" \
  -not -path "*/temp/*" \
  -not -path "*/__pycache__/*" \
  -not -path "*/venv/*" \
  -not -path "*/.env/*" \
  -not -path "*/target/*" \
  -not -path "*/.mvn/*" \
  -not -path "*/gradle/*" \
  -not -path "*/.gradle/*" \
  -not -path "*/Pods/*" \
  -not -path "*/.DS_Store"'
# FZF SETUP =============
# custom_fzf() {
#    find $HOME/Projects $HOME/Downloads | fzf --height 80% --layout reverse --no-info --prompt="${LBUFFER}" --color 'fg:#52ca51,fg+:#e04156,border:#e8cd02,info:#52ca51,pointer:#52ca51,prompt:#e04156'
# }

# zle -N custom_fzf_widget custom_fzf

# bindkey 'qq' custom_fzf_widget

# fzfHistorySearch() {
#   echo $(fc -l -n 1 | sed 's/^\s*//' | fzf --height 80% --layout reverse --no-info --border --prompt="${LBUFFER}" --color 'fg:#52ca51,fg+:#e04156,border:#e8cd02,info:#52ca51,pointer:#52ca51,prompt:#e04156')
# }

# fzfHistoryWidget() {
#   choices=$(fzfHistorySearch)
#   if [ ! -z $choices ];
#   then
#     LBUFFER="${LBUFFER}${choices}"
#   fi
  
#   local ret=$?
#   zle reset-prompt
#   return $ret
# }

# zle     -N   fzfHistoryWidget
# bindkey 'hs' fzfHistoryWidget

fzfGitBranchDeleteSearch() {
  prompt=$1
  echo $(git branch --format='%(refname:short)' | fzf --height 80% --multi --layout reverse --no-info --border --prompt="${prompt}" --color 'fg:#52ca51,fg+:#e04156,border:#e8cd02,info:#52ca51,pointer:#52ca51,prompt:#e04156')
}

fzfGitBranchDeleteSearchWidget() {
  choices=$(fzfGitBranchDeleteSearch 'git branch -D')
  if [ ! -z $choices ];
  then
    LBUFFER="git branch -D ${LBUFFER}${choices}"
  fi

  local ret=$?
  zle reset-prompt
  return $ret
}

zle     -N   fzfGitBranchDeleteSearchWidget
bindkey 'gd' fzfGitBranchDeleteSearchWidget

fzfGitBranchCheckoutSearchWidget() {
  choices=$(fzfGitBranchDeleteSearch 'git checkout')
  if [ ! -z $choices ];
  then
    LBUFFER="git checkout ${LBUFFER}${choices}"
  fi

  local ret=$?
  zle reset-prompt
  return $ret
}

zle     -N   fzfGitBranchCheckoutSearchWidget
bindkey 'gt' fzfGitBranchCheckoutSearchWidget

QUICK_DIRS=(
  "$HOME/Downloads"
  "$HOME/Documents"
  "$HOME"
)

fzfQuickDirSearch() {
  local dir_list=""
  local -a all_dirs
  
  # Add QUICK_DIRS to the list
  all_dirs=("${QUICK_DIRS[@]}")
  
  # Add all directories from ~/Projects
  if [ -d "$HOME/Projects" ]; then
    for dir in "$HOME/Projects"/*; do
      if [ -d "$dir" ]; then
        all_dirs+=("$dir")
      fi
    done
  fi
  
  # Remove duplicates using associative array
  local -A seen
  local -a unique_dirs
  for dir in "${all_dirs[@]}"; do
    if [ ! ${seen[$dir]+_} ]; then
      seen[$dir]=1
      unique_dirs+=("$dir")
    fi
  done
  
  # Build the display list
  for dir in "${unique_dirs[@]}"; do
    if [ -d "$dir" ]; then
      local label=$(basename "$dir")
      if [ "$dir" = "$HOME" ]; then
        label="~"
      fi
      dir_list="${dir_list}${label} -> ${dir}\n"
    fi
  done
  
  echo $(echo -e "$dir_list" | fzf --height 80% --layout reverse --no-info --border --prompt="Jump to: " --color 'fg:#52ca51,fg+:#e04156,border:#e8cd02,info:#52ca51,pointer:#52ca51,prompt:#e04156' | sed 's/.* -> //')
}

fzfQuickDirWidget() {
  choice=$(fzfQuickDirSearch)
  if [ ! -z "$choice" ]; then
    BUFFER="cd \"$choice\""
    zle accept-line
  fi
  
  local ret=$?
  zle reset-prompt
  return $ret
}

zle     -N   fzfQuickDirWidget
bindkey 'zx' fzfQuickDirWidget


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh;

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Created by `pipx` on 2025-09-26 15:30:35
export PATH="$PATH:/Users/delisandor/.local/bin"


function my-redraw-prompt() {
  {
    builtin echoti civis
    builtin local f
    for f in chpwd "${chpwd_functions[@]}" precmd "${precmd_functions[@]}"; do
      (( ! ${+functions[$f]} )) || "$f" &>/dev/null || builtin true
    done
    builtin zle reset-prompt
  } always {
    builtin echoti cnorm
  }
}

function my-cd-rotate() {
  () {
    builtin emulate -L zsh
    while (( $#dirstack )) && ! builtin pushd -q $1 &>/dev/null; do
      builtin popd -q $1
    done
    (( $#dirstack ))
  } "$@" && my-redraw-prompt
}

function my-cd-up()      { builtin cd -q .. && my-redraw-prompt; }
function my-cd-back()    { my-cd-rotate +1; }
function my-cd-forward() { my-cd-rotate -0; }

builtin zle -N my-cd-up
builtin zle -N my-cd-back
builtin zle -N my-cd-forward

() {
  builtin local keymap
  for keymap in emacs viins vicmd; do
    builtin bindkey '^[^[[A'  my-cd-up
    builtin bindkey '^[[1;3A' my-cd-up
    builtin bindkey '^[[1;9A' my-cd-up

    builtin bindkey '^[^[[D'  my-cd-back
    builtin bindkey '^[[1;3D' my-cd-back
    builtin bindkey '^[[1;9D' my-cd-back
    
    builtin bindkey '^[^[[C'  my-cd-forward
    builtin bindkey '^[[1;3C' my-cd-forward
    builtin bindkey '^[[1;9C' my-cd-forward
  done
}

setopt auto_pushd
