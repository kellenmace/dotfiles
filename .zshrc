# Path to oh-my-zsh installation.
export ZSH="/Users/kellen.mace/.oh-my-zsh"

function git_branch_name() {
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [ "$branch" ]; then
    echo " (${branch})"
  fi
}

# Customize prompt
PROMPT='%F{81}%~%f%F{163}$(git_branch_name) '

# ZSH plugins. Path: ~/.oh-my-zsh/plugins
plugins=( git-open z zsh-syntax-highlighting )

# Load oh-my-zsh.
source $ZSH/oh-my-zsh.sh

# Add Homebrew's "sbin" directory to PATH.
export PATH="/opt/homebrew/bin:$PATH"

# ZSH
alias editrc="code ~/.zshrc"
alias reloadrc="source ~/.zshrc"

# Navigate
alias ..="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."

# Git
alias ga="git add"
alias gp="git push -v"
alias gs="git status"
alias gl="git log --format='%C(green)%h%Creset %ad %C(cyan)%an%Creset - %s%C(red)%d%Creset' --date=format:'%b %d'"
alias gb="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset)) - %(authorname): %(color:red)%(objectname:short)%(color:reset) %(contents:subject)'"
alias gco="git switch"
alias gcl="git clone -v"
alias gf="git fetch && git merge --ff-only" # Fetch, then to a fast forward merge.
alias gm="git merge --no-ff"
alias gcbn="git branch | grep '^\*' | cut -d' ' -f2 | pbcopy" # Copy branch name to clipboard.

# npm
alias nrd="npm run dev"

# Git commit with a message.
# Usage: gc "A very detailed commit message"
function gc() {
  git commit -m "$1";
}

# Git commit ALL (including previously untracked files), with a message.
# Usage: gca "A very detailed commit message"
function gca() {
  git add -A; git commit -m "$1";
}

# Create a new branch off of the current branch.
# Usage: gcb feature/my-new-branch
function gcb() {
  git fetch; git merge --ff-only; git switch -c "$1"; git push -uv origin "$1";
}

# Git merge into <branch-name>. Merge the current branch into another branch.
# Usage: gmi staging
function gmi() {
  # If no branch name was provided
  if [ ! -n "$1" ]; then
    echo "$(tput setaf 1)⚠️   Please provide the name of the branch to merge into.$(tput sgr0)"
		return 1
  fi

  current_branch="$(git branch | grep \* | cut -d ' ' -f2)"
  destination_branch="$1"

  git pull origin "$current_branch"; git push origin "$current_branch"; git switch "$destination_branch"; git pull origin "$destination_branch"; git merge "$current_branch" --no-ff; git push origin "$destination_branch";
}

# Fuzzy-find an alias/function in your .zshrc file.
# Usage: finda whatever-part-you-remember
function finda() {
  grep -i -a1 $@ ~/.zshrc | grep -v '^s*$' ;
}
