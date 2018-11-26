# The brew command below makes PHP 7.2 available on the command line.
export PATH="$(brew --prefix php)/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin"

# Add Yarn to path.
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

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
alias gcl="git clone -v"
alias gcam="git commit --amend"
alias gf="git fetch; git merge --ff-only" # Fetch, then to a fast forward merge.
alias gfb="git branch --all | grep -i " # Find branch. Usage: gfb part-of-branch-name.
alias gbd="git branch -d" # Delete local branch.
alias gm="git merge --no-ff"
alias gp="git push"
alias gsho="git show"
alias garch="git arch" # Archive a branch. Shell script file  is located here: /usr/local/bin/git-arch.

# Copy branch name to clipboard
alias cbn="git branch | grep '^\*' | cut -d' ' -f2 | pbcopy"

# Check out a branch fuzzily using fzf - https://github.com/junegunn/fzf
function gcob() {
	local branches branch
	branches=$(git branch -a) &&
	branch=$(echo "$branches" | fzf +s +m -e) &&
	cmd=$(echo "$branch" | sed "s:.* remotes/origin/::" | sed "s:.* ::")
	git checkout "$cmd"
}

# Get a branch's parent branch.
function gpb() {
	git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
}

# Commit what you've already staged, with a message.
# usage: gc "A very detailed commit message here!"
function gc() {
  git commit -m "$1";
}

# Commit and stage ALL (including previously untracked files), with a message.
# usage: gca "A very detailed commit message here!"
function gca() {
  git add -A; git commit -m "$1";
}

# Create a new branch off of the current branch.
# usage: gcb feature/BRANCH-NAME
function gcb() {
  git fetch; git merge --ff-only; git checkout -b "$1"; git push -uv origin "$1";
}

# Create a new branch off of master.
# usage: gcbm feature/BRANCH-NAME
function gcbm() {
  git checkout master; git fetch; git merge --ff-only; git checkout -b "$1"; git push -uv origin "$1";
}

# Create a new branch off of develop.
# usage: gcbm feature/BRANCH-NAME
function gcbd() {
  git checkout develop; git fetch; git merge --ff-only; git checkout -b "$1"; git push -uv origin "$1";
}

# Merge the current branch into another branch (GMI = "git merge into...")
# usage: gmi staging
function gmi() {
  # If no branch name was provided
  if [ ! -n "$1" ]; then
    echo "$(tput setaf 1)⚠️   Please provide the name of the branch to merge into.$(tput sgr0)"
		return 1
  fi

  current_branch="$(git branch | grep \* | cut -d ' ' -f2)"
  destination_branch="$1"

  git pull origin "$current_branch"; git push origin "$current_branch"; git checkout "$destination_branch"; git pull origin "$destination_branch"; git merge "$current_branch" --no-ff; git push origin "$destination_branch";
}

# Amend (fix) the last git commit message, then force push the change to the remote
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
# usage: git checkout master -b qa/$(sanitize_title "<PASTE>")
function sanitize_title() {
	echo "$1" | sed -e 's/[^a-zA-Z0-9 ]//g' | sed -e 's/ /-/g' | tr '[:upper:]' '[:lower:]'
}

# Open a webpage in Chrome
# usage: chrome https://kellenmace.com
function chrome() {
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome "$1"
}

# Give a user a role on every site in a WordPress multisite network.
# usage: add_user_to_network kellen administrator
function add_user_to_network() {
  for SITE_URL in $(wp site list --field=url);
    do wp user set-role "$1" "$2" --url="$SITE_URL";
  done
}

# Usage: set_screenshot_format jpg, or set_screenshot_format png
function set_screenshot_format() {
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
# usage: qtmono name-of-file.mov
function qtmono() {
  basename=$(basename "$1")
  filename="${basename%.*}"
  extension="${basename##*.}"

  ffmpeg -i $1 -codec:v copy -af pan="mono: c0=FL" $filename-mono.$extension
}

# Fuzzy-find an alias/function in your .zshrc file.
# usage: finda WHATEVER-PART-YOU-REMEMBER
function finda() {
  grep -i -a1 $@ ~/.zshrc | grep -v '^s*$' ;
}

# ZSH plugins can be found in ~/.oh-my-zsh/plugins/*
# Add custom plugins to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
# Look into adding these: git-extras github gitignore wp-cli
plugins=(brew composer zsh-syntax-highlighting zsh-autosuggestions z)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# WP-CLI Tab Completion
autoload bashcompinit
bashcompinit
source /usr/local/bin/wp-completion.bash
