# Path to oh-my-zsh installation.
export ZSH="/Users/kellen.mace/.oh-my-zsh"

# Remove "kellen@Kellens-MacBook-Pro" from command prompt.
DEFAULT_USER=$USER

# ZSH theme. Path: ~/.oh-my-zsh/themes
ZSH_THEME="agnoster"

# Ignore these "Insecure completion-dependent directories" errors:
# https://github.com/ohmyzsh/ohmyzsh/issues/9262
ZSH_DISABLE_COMPFIX=true

# ZSH plugins. Path: ~/.oh-my-zsh/plugins
plugins=( git-open z zsh-syntax-highlighting )
# Maybe add this, if it's not too laggy: https://github.com/zsh-users/zsh-autosuggestions

# Load oh-my-zsh.
source $ZSH/oh-my-zsh.sh

# Add Homebrew's "sbin" directory to PATH.
export PATH="/usr/local/sbin:$PATH"

# Add Homebrew's version of PHP to PATH.
export PATH=/usr/local/bin/php:$PATH
export PATH=/usr/local/sbin/php:$PATH

# fzf settings. See https://github.com/junegunn/fzf.
source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended" # Use fzf's extended regex matchers
export FZF_DEFAULT_COMMAND="fd --type f" # Use fd for searches, which respects .gitignore.
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ZSH
alias editrc="code ~/.zshrc"
alias reloadrc="source ~/.zshrc"

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
# Defaults to 3 levels deep. Show more with `t 5` or `t 1`
function t() {
  tree -I '.git|node_modules|bower_components|.DS_Store' --dirsfirst --filelimit 15 -L ${1:-3} -aC $2
}

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

# Create a new branch off of main.
# Usage: gcbm feature/my-new-branch
function gcbm() {
  git switch main; git fetch; git merge --ff-only; git switch -c "$1"; git push -uv origin "$1";
}

# Check out a branch fuzzily using fzf.
# Usage: gcob, then search for & select the branch.
function gcob() {
	local branches branch
	branches=$(git branch -a) &&
	branch=$(echo "$branches" | fzf +s +m -e) &&
	cmd=$(echo "$branch" | sed "s:.* remotes/origin/::" | sed "s:.* ::")
	git switch "$cmd"
}

# Get a branch's parent branch.
function gpb() {
	git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
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

# Create a tarball (.tar.gz) whose name matches the source dir.
# usage: tarball some-directory
function tarball() {
  tar -zcvf "$1".tar.gz "$1"
}

# Un-archive and decompress a tarball (.tar.gz).
# usage: decompress_tarball compressed-files.tar.gz
function untarball() {
  tar -zxvf "$1"
}

# Open a webpage in Chrome
# Usage: chrome https://kellenmace.com
function chrome() {
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome "$1"
}

# Open a webpage in Arc
# Usage: arc https://kellenmace.com
function arc() {
  /usr/bin/open -a Arc "$1"
}

# Convert a stereo QuickTime recording to mono.
# Usage: qtmono name-of-file.mov
function qtmono() {
  basename=$(basename "$1")
  filename="${basename%.*}"
  extension="${basename##*.}"

  ffmpeg -i $1 -codec:v copy -af pan="mono: c0=FL" $filename-mono.$extension
}

# Download song using youtube-dl and put it in Dropbox
# usage: dl_song https://www.youtube.com/watch?v=hajBdDM2qdg
function dl_song() {
  cd ~/Dropbox/Downloaded\ Music/
  yt-dlp -f 'ba' -x --audio-format m4a --embed-thumbnail --embed-metadata "$1"
  cd $OLDPWD
}
