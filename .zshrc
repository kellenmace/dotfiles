# The brew command below makes PHP 7.2 available on the command line.
export PATH="$(brew --prefix php)/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin"

# Path to oh-my-zsh installation.
export ZSH=/Users/Kellen/.oh-my-zsh

# Set default user.
# Will remove from prompt if matches current user
DEFAULT_USER=Kellen

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

# Git
alias ga="git add"
alias gaa="ga -A"
alias gp="git push -v"
alias gs="git status"
alias gl="git log --format='%C(green)%h%Creset %ad %C(cyan)%an%Creset - %s%C(red)%d%Creset' --date=format:'%b %d'"
alias gd="git diff --stat –color"
alias gdc="git diff –-cached"
alias gb="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset)) - %(authorname): %(color:red)%(objectname:short)%(color:reset) %(contents:subject)'"
alias gco="git checkout"
alias gra="git remote add"
alias groa="git remote origin add"
alias grr="git remote rm"
alias gpu="git pull -v"
alias gcl="git clone -v"
alias gam="git add -u"
alias gcam="git commit --amend"
alias gcama="git commit -a --amend -C HEAD"
alias gf="git fetch –all"
alias gff="git fetch; git merge --ff-only" # fetch, then to a fast forward merge.
alias gfb="git branch --all | grep -i " # Find branch. Usage: gfb part-of-branch-name
alias grm="git branch -D"
alias gdo="git push origin :"
alias gfo="git fetch origin"
alias gfp="git fetch prune"
alias gm="git merge --no-ff"
alias gp="git push"
alias gpo="git push origin"
alias gs="git status"
alias gshow="git show"
alias gd="git diff"
alias gdc="git diff --cached"
alias grf="git reset --force"
alias grs="git reset --soft"
alias gu="git update-index --assume-unchanged" #untrack files
alias arch="git arch" # File is located in /usr/local/bin/git-arch

# Git branch specific
alias gcd="git checkout develop"
alias gcf="git checkout feature/"
alias gcm="git checkout master"
alias gmd="git merge --no-ff develop; git push origin;"
alias gms="git merge --no-ff staging; git push origin;"
alias gmm="git merge --no-ff master; git push origin;"
alias gpod="git pull origin develop -v; git push origin develop -v;"
alias gpsd="git pull origin develop -v; git push origin develop -v; git push staging develop -v;"
alias gpom="git pull origin master -v; git push origin master -v;"
# Copy branch name to clipboard
alias cbn="git branch | grep '^\*' | cut -d' ' -f2 | pbcopy"
# If you're brave
alias gppm="git pull origin master -v; git push origin master -v; git push production master -v;"

# Check out a branch fuzzily.
function gcob {
	local branches branch
	branches=$(git branch -a) &&
	branch=$(echo "$branches" | fzf +s +m -e) &&
	cmd=$(echo "$branch" | sed "s:.* remotes/origin/::" | sed "s:.* ::")
	git checkout "$cmd"
}

###
 # Get a branch's parent branch.
 ##
function gpb {
	git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
}

# MAKING COMMITS

function gc () {
  # git commit what you've already staged, with a message
  # usage: gc "A very detailed commit message here!"
  git commit -m "$1";
}

function gca() {
  # git commit and stage ALL (including previously untracked files), with a message.
  # usage: gca "A very detailed commit message here!"
  git add -A; git commit -m "$1";
}

# CREATING A BRANCH

# git checkout branch from the current branch
function gcb () {
  # git branch from curent local branch, checkout a new branch, and push it up to origin
  # usage: gcb feature/BRANCH-NAME or gcb qa/BRANCH-NAME

  git fetch; git merge --ff-only; git checkout -b "$1"; git push -uv origin "$1";
}

# git checkout branch from master
function gcbm () {
  # git branch from local master, checkout a new branch, and push it up to origin
  # usage: gcbm feature/BRANCH-NAME or gcbm qa/BRANCH-NAME

  # If the branch name provided contains a slash, use that whole thing as the new branch name (ex: qa/branch-name)
  # else, default to using feature/branch-name
  # if [[ "$1" == *"/"* ]]; then
  #   branch_name="$1"
  # else
  #   branch_name=feature/"$1"
  # fi

  git checkout master; git fetch; git merge --ff-only; git checkout -b "$1"; git push -uv origin "$1";
}

# git checkout branch from develop
function gcbd () {
  # git branch from local develop, checkout a new branch, and push it up to origin
  # usage: gcbd feature/BRANCH-NAME or gcbd qa/BRANCH-NAME

  # If the branch name provided contains a slash, use that whole thing as the new branch name (ex: qa/branch-name)
  # else, default to using feature/branch-name
  # if [[ "$1" == *"/"* ]]; then
  #   branch_name="$1"
  # else
  #   branch_name=feature/"$1"
  # fi

  git checkout develop; git fetch; git merge --ff-only; git checkout -b "$1"; git push -uv origin "$1";
}

# git checkout branch from origin master (if multiple remotes are in use)
function gcbom () {
  # git branch from origin/master, checkout a new master branch, feature branch, and push it up to origin
  # usage: gcbom feature/BRANCH-NAME or gcbom qa/BRANCH-NAME
  git branch -D master; git fetch origin; git checkout master; git pull origin master; git checkout -b "$1"; git push -uv origin "$1";
}

# PUSHING NEW FEATURE

# git merge and push to master
function gmp () {
  # git push up feature branch, merge to master branch, and push master branch to origin.
  # assumptions: use of feature branches, with 'master' as the stage branch
  # usage: gmp or gmp feature/branch-name
  # With FF MERGE: git pull origin feature/"$1"; git push origin feature/"$1"; git checkout master; git fetch; git merge --ff-only; git merge feature/"$1" --no-ff; git push origin master;
  # With 'feature/' hardcoded: git pull origin feature/"$1"; git push origin feature/"$1"; git checkout master; git pull origin master; git merge feature/"$1" --no-ff; git push origin master;

  # If a branch name was passed in, use that. Otherwise, use the name of the current branch.
  if [[ -n "$1" ]]; then
    branch_name="$1"
  else
    branch_name="$(git branch | grep \* | cut -d ' ' -f2)"
  fi

  git pull origin "$branch_name"; git push origin "$branch_name"; git checkout master; git pull origin master; git merge "$branch_name" --no-ff; git push origin master;
}

# git merge and push to develop
function gmpd () {
  # git push up feature branch, merge to develop branch, and push develop branch to origin.
  # usage: gmpd or gmpd feature/branch-name

  # If a branch name was passed in, use that. Otherwise, use the name of the current branch.
  if [[ -n "$1" ]]; then
    branch_name="$1"
  else
    branch_name="$(git branch | grep \* | cut -d ' ' -f2)"
  fi

  git pull origin "$branch_name"; git push origin "$branch_name"; git checkout develop; git pull origin develop; git merge "$branch_name" --no-ff; git push origin develop;
}

# git merge and push to prod
function gmpp () {
  # git push up feature branch, merge to develop branch, and push develop branch to origin.
  # usage: gmpp or gmpp feature/branch-name

  # If a branch name was passed in, use that. Otherwise, use the name of the current branch.
  if [[ -n "$1" ]]; then
    branch_name="$1"
  else
    branch_name="$(git branch | grep \* | cut -d ' ' -f2)"
  fi

  git pull origin "$branch_name"; git push origin "$branch_name"; git checkout prod; git pull origin prod; git merge "$branch_name" --no-ff; git push origin prod;
}

# Merge the current branch into another branch (GMI = "git merge into...")
# usage: gmi staging
function gmi () {
  # If no branch name was provided
  if [ ! -n "$1" ]; then
    echo "$(tput setaf 1)⚠️   Please provide the name of the branch to merge into.$(tput sgr0)"
		return 1
  fi

  current_branch="$(git branch | grep \* | cut -d ' ' -f2)"
  destination_branch="$1"

  git pull origin "$current_branch"; git push origin "$current_branch"; git checkout "$destination_branch"; git pull origin "$destination_branch"; git merge "$current_branch" --no-ff; git push origin "$destination_branch";
}

# Amend (fix) the last git commit message
# then force push the change to the remote
# usage: gamend "New commit message"
function gamend() {
  git commit --amend -m "$@"
  git push --force-with-lease # This aborts the push if there are any upstream changes.
}

# Navigate
alias remove="rm -rf"
alias delete="rm -rf"
alias back="cd $OLDPWD"
alias ..="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."

# Print tree view of directories and files.
function t() {
  # Defaults to 3 levels deep, do more with `t 5` or `t 1`
  # pass additional args after
  tree -I '.git|node_modules|bower_components|.DS_Store' --dirsfirst --filelimit 15 -L ${1:-3} -aC $2
}

# Remove all non alphanumeric characters and change spaces into dashes.
# Usage: git checkout master -b qa/$(sanitize_title "<PASTE>")
sanitize_title() {
	echo "$1" | sed -e 's/[^a-zA-Z0-9 ]//g' | sed -e 's/ /-/g' | tr '[:upper:]' '[:lower:]'
}

# Find file or directory by name in the current dir.
function ff () {
  find . -maxdepth 1 -name "*$1*";
}

# Find file or directory by name in the current dir, recursively.
function ffr () {
  find . -name "*$1*";
}

# Open a webpage in Chrome
# Usage: chrome https://kellenmace.com
chrome() {
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome "$1"
}

# Give a user a role on every site in a WordPress multisite network.
# Usage: add_user_to_all_network_sites kellen administrator
add_user_to_all_network_sites() {
  for SITE_URL in $(wp site list --field=url);
    do wp user set-role "$1" "$2" --url="$SITE_URL";
  done
}

# Usage: set_screenshot_format jpg, or set_screenshot_format png
set_screenshot_format() {
  defaults write com.apple.screencapture type "$1" && killall SystemUIServer;
}

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -delete"

# ZSH
alias editrc="code ~/.zshrc"
alias reloadrc="source ~/.zshrc"

# Vagrant
alias vu="vagrant up"
alias vh="vagrant halt"
alias vs="vagrant status"
alias vgs="vagrant global status"
alias vss="vagrant ssh"

# Sublime
alias sub="subl"

# Convert a stereo QuickTime recording to mono
#
# Usage: qtmono name-of-file.mov
function qtmono {
  basename=$(basename "$1")
  filename="${basename%.*}"
  extension="${basename##*.}"

  ffmpeg -i $1 -codec:v copy -af pan="mono: c0=FL" $filename-mono.$extension
}

# if you think you know the acronym, but you're not sure
# usage: finda WHATEVER-PART-YOU-REMEMBER
function finda () {
  grep -i -a1 $@ ~/.zshrc | grep -v '^s*$' ;
}

# Plugins can be found in ~/.oh-my-zsh/plugins/*
# Add custom plugins to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
# Add these in the future: git-extras github gitignore wp-cli
plugins=(brew composer zsh-syntax-highlighting zsh-autosuggestions z)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# WP-CLI Tab Completion
autoload bashcompinit
bashcompinit
source /usr/local/bin/wp-completion.bash

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
