export TERM="xterm-256color"
# Update $? to account for the rightmost non-zero failure in a pipeline
set -o pipefail

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Languages
export GOPATH="${HOME}/go"
export GOROOT="$(brew --prefix golang)/libexec"

# If you come from bash you might have to change your $PATH.
export PYENV_ROOT="${HOME}/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
PYTHON_LOCAL=$(python3 -c "import site, pathlib; print(pathlib.Path(site.USER_BASE, 'bin'))")
export PATH="${HOME}/bin:/usr/local/bin:/usr/local/sbin:${HOME}/.rd/bin:${GOPATH}/bin:${GOROOT}/bin:/usr/local/opt/ruby/bin:/usr/local/opt/grep/libexec/gnubin:${PYTHON_LOCAL}:$PATH:/Users/jonzeolla/.local/bin"
# Ensure that pipx uses the pyenv version of python
PIPX_DEFAULT_PYTHON="${HOME}/.pyenv/versions/$(pyenv version | cut -f1 -d\ )/bin/python3"
export PIPX_DEFAULT_PYTHON
# Ensure that pipenv uses the pyenv python versions
PIPENV_PYTHON="${PYENV_ROOT}/shims/python"
export PIPENV_PYTHON

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  ansible
  aws
  brew
  direnv
  docker
  docker-compose
  git
  golang
  iterm2
  jsontools
  macos
  python
  terraform
  vagrant
  vault
  vscode
)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

## Additional zsh configs
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs virtualenv aws azure kubecontext)
POWERLEVEL9K_KUBECONTEXT_BACKGROUND="006"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
setopt no_share_history
unsetopt share_history

## Configure things
# OS
alias ll="ls -al"
alias cls=clear # C-l
alias calc="bc -l"
alias sha1="openssl sha1"
#alias md5="openssl md5" # Native on macOS
alias thetime="date +\"%T\""
alias thedate="date +\"%Y-%m-%d\""
alias headers="curl -I"
if type nvim > /dev/null 2>&1; then
  alias vi=nvim_exrc_security_check
fi
alias brewupgrade='bubo ; brew upgrade --cask ; bubc'

# Python
alias pri='pipenv run invoke'
alias pip3upgrade="pip3 list --outdated --format=json | jq -r '.[] | \"\(.name)=\(.latest_version)\"' | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U"
alias upgradepipx='pipx upgrade-all'

# k8s
alias kctx="kubectx"
alias kns="kubens"
alias k="kubectl"
export PATH="${PATH}:${HOME}/.krew/bin"
alias kkrewupgrade="k krew update && k krew upgrade"

# git
alias newfeature="git checkout main && git pull origin main --tags && git checkout -b $1"
alias gpom="git push origin main"
alias gpomf="git push origin main --force"
alias gdc="git diff --cached"
export GITSIGN_CREDENTIAL_CACHE="${HOME}/Library/Caches/.sigstore/gitsign/cache.sock"

# Docker
alias dps="docker ps"
alias docker-cleanup="docker system df; docker container rm \$(docker ps -a -q) ; docker builder prune -f; docker image prune; docker system df"
alias docker-cleanup-more="docker system df; docker container rm \$(docker ps -a -q) ; docker builder prune -f; docker image prune -a; docker system df"

# Vagrant
alias vagrant-cleanup="vagrant global-status --prune && vagrant box list | cut -f 1 -d ' ' | xargs -L 1 vagrant box remove -f"

# Screen
alias s="screen -S"
alias sl="screen -ls"
alias sr="screen -r"

# Powershell
alias pwsh="docker pull microsoft/powershell:latest && docker run -it -v $(pwd):/src microsoft/powershell:latest"

# Other
export COWPATH="/usr/local/Cellar/cowsay/*/share/cows"
alias happiness="while true; do fortune -n 1 | cowsay -f \`find $COWPATH -type f | sort -R | head -n1\` | lolcat -a -s 100; sleep 2; done"
alias vinerd="vim +NERDTree"
alias asciicast2gif='docker run --rm -v "$PWD:/data" asciinema/asciicast2gif'
alias testssl="docker run -t --rm mvance/testssl"
alias upgradenvimpacks='for folder in ~/.local/share/nvim/site/pack/git-plugins/start/*; do pushd "${folder}"; ggpull; popd; done'
alias upgradep10k='pushd "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" && ggpull && popd'
alias upgradespaceship='pushd "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" && ggpull && popd'
alias upgradevagrantplugins='vagrant plugin update vagrant-parallels'
alias upgradecoc="nvim +CocUpdate +qa; pushd ~/.local/share/nvim/site/pack/coc/start; curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -; popd"
alias upgradeallthethings="brewupgrade; kkrewupgrade; pip3upgrade; upgradenvimpacks; upgradep10k; upgradespaceship; upgradepipx; upgradevagrantplugins"
alias mastertomain="git branch -m master main && git push -u origin main && git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main && echo Successfully migrated from master to main"
alias chromermfavicons='rm -rf "$HOME/Library/Application Support/Google/Chrome/Default/Favicons"'
eval "$(mcfly init zsh)"
# Autocomplete
autoload -U compinit; compinit
autoload -U +X bashcompinit && bashcompinit
source /opt/homebrew/etc/bash_completion.d/az

## Functions
function nvim_exrc_security_check() {
  if [[ -r .exrc ]]; then
    read -k "answer?.exrc file detected, this will modify your vim settings!  Are you sure (y/N)? "
    if [[ "${answer}" =~ ^[yY]$ ]]; then
      nvim "$@"
    else
      echo "\nNot opening nvim"
    fi
  else
    nvim "$@"
  fi
}

function unsetawstoken() {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
  unset AWS_PROFILE
  unset AWS_DEFAULT_REGION
  unset AWS_DEFAULT_OUTPUT
}
function setawstoken() {
  eval "$(cat /dev/stdin | aws_session_token_to_env.py)" ;
  if [[ -z "${AWS_PROFILE}" ]]; then
    export AWS_PROFILE='default'
  fi
  export AWS_DEFAULT_REGION='us-east-1'
  export AWS_DEFAULT_OUTPUT='json'
  docker pull seiso/easy_infra
}
function getawstoken() {
  if ! [[ $1 =~ ^[0-9]{6}$ ]]; then
    echo "Input must be six digits"
    return 1
  elif [[ $# > 2 ]]; then
    echo "Must provide either 1 or 2 inputs"
    return 1
  fi
  echo "You must modify this function to insert your account and IAM user (See the TODOs below)"
  if [[ $# == 1 ]]; then
    #docker run --rm -v ${HOME}/.aws:/root/.aws seiso/easy_infra "aws sts get-session-token --serial-number arn:aws:iam::TODO:mfa/TODO --token-code ${1}"
  else
    docker run --rm -v ${HOME}/.aws:/root/.aws seiso/easy_infra "aws sts get-session-token --serial-number "${2}" --token-code ${1}"
  fi
}
function setawsTODO() {
  unsetawstoken
  getawstoken "${1}" | setawstoken
  echo "TODO: Look in ~/.zshrc and update AWS_PROFILE so it uses your .aws/config, then uncomment"
  #export AWS_PROFILE="Organization -> Account"
  echo "TODO: Replace the TODO appropriately and uncomment"
  #docker run --rm --env-file <(env | grep ^AWS_) -v ${HOME}/.aws:/root/.aws seiso/easy_infra "aws sts assume-role --role-arn arn:aws:iam::TODO:role/TODO --role-session-name TODO" | setawstoken
}

## Other env vars
export DEFAULT_USER='jonzeolla'
export HISTCONTROL="ignorespace${HISTCONTROL:+:$HISTCONTROL}"
# This turns off all direnv stdout
export DIRENV_LOG_FORMAT=""

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
