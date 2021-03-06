# .rawrusrc

### Source global definitions
export HAPMOJI=("¯\_(ツ)_/¯" "ʕᵔᴥᵔʔ" "ヽ(´ー｀)ノ" "☜(⌒▽⌒)☞" "( ͡° ͜ʖ ͡°)" "(づ￣ ³￣)づ" "◔_◔" "ԅ(≖‿≖ԅ)" "{•̃_•̃}" "(∩｀-´)⊃━☆ﾟ.*･｡ﾟ" "(っ▀¯▀)" "ヽ( •_)ᕗ")
export SADMOJI=("[¬º-°]¬" "(Ծ‸ Ծ)" "(҂◡_◡)" "ミ●﹏☉ミ" "(⊙_◎)" "(´･_･\`)" "(⊙.☉)7" "⊙﹏⊙" "ᕦ(ò_óˇ)ᕤ" "ε=ε=ε=┌(;*´Д\`)ﾉ" "ლ(｀ー´ლ)" "ʕ •\`ᴥ•´ʔ" "ʕノ•ᴥ•ʔノ ︵ ┻━┻")

# Add local ~/sbin to PATH if it exists
[[ -s "$HOME/sbin" ]] && export PATH="$PATH:~/sbin"

# Set git editor to vim where available
[[ -s "$(which vim)" && -s "$(which git)" ]] && export GIT_EDITOR=$(which vim)

# Pull in system bashrc if it exists
[[ -s "/etc/bashrc" ]] && . /etc/bashrc

# python3 -m venv $HOME/space/global_python3_venv
[[ -z "${VIRTUAL_ENV}"  ]] && \
  [[ -d "$HOME/space/global_python3_venv" ]] && \
    source $HOME/space/global_python3_venv/bin/activate

### PS1 Extensions
# PS1 shrug and table flip
export PS1='$(cur_python_venv) \w $(git_info)\n   |___ $(ps1_reacji_shrug) $ '

# PS1 bear and table flip
#export PS1=' \w $(git_info)\n   |___ $(ps1_reacji_bear) $ '

# Get git-branch and current HEAD
git_info() {
  OLDRETVAL=$?
  # Any string means this guy is a repo
  test -d $PWD/.git && \
    echo -en "${ORANGE}$(git_branch)${CLEAR}\n   |$(cur_git_commit)\n"
  exit ${OLDRETVAL}
}

# Grab current branch git branch if applicable
git_branch() {
  OLDRETVAL=$?
  BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' || echo '')
  if [ -d "${PWD}/.git" ]; then
    echo "${BRANCH}"
  fi
  exit ${OLDRETVAL}
}

# Grab current git commit
cur_git_commit() {
  OLDRETVAL=$?
  CUR_COMMIT="$(git log --pretty=format:'%h' -n 1 2> /dev/null || echo '')"
  test -z "${CUR_COMMIT}" && echo "" || echo -e "-[ Commit: ${ORANGE}${CUR_COMMIT}${CLEAR} ]"
  exit ${OLDRETVAL}
}

# Exit code reactions
ps1_reacji_shrug() {
  OLDRETVAL=$?
  test ${OLDRETVAL} -eq 0 && \
    echo -e "${BLUE}${HAPMOJI[$(((${RANDOM}%${#HAPMOJI[@]})))]}${CLEAR} (${OLDRETVAL})" || echo -e "${RED}${SADMOJI[$(((${RANDOM}%${#SADMOJI[@]})))]}${CLEAR} (${OLDRETVAL})"
  exit ${OLDRETVAL}
}

ps1_reacji_bear() {
  OLDRETVAL=$?
  test ${OLDRETVAL} -eq 0 && \
    echo -e "${BLUE}ʕ ㅇ ᴥ ㅇʔ${CLEAR} (${OLDRETVAL})" || echo -e "${RED}ʕノ•ᴥ•ʔノ ︵ ┻━┻${CLEAR} (${OLDRETVAL})"
}

cur_python_venv(){
    OLDRETVAL=$?
    if [ ! -z "${VIRTUAL_ENV}" ]; then
        venv_name=$( echo ${VIRTUAL_ENV} | awk -F '/' '{ print $NF }' )
        echo -en "(${ORANGE}${venv_name}${CLEAR})"
    fi
    exit ${OLDRETVAL}
}

# Proper umask
#umask 077

# [TMUX] If were in tmux set the window name to our host
if [ "$TERM" == "screen-256color" ] ||
   [ "$TERM" == "screen" ] ||
   [ "$TERM" == "tmux" ]; then

   printf "\033k$(hostname -s)\033\\"
fi

# Fun Bindings
bind '"\ea\ed"':"\"echo 'Auto Destruct Sequence Has Been Activated!!!'\C-m\""

### Aliases
# Remap clear to force shell stdin to the bottom
alias clear='clear; tput cup $LINES 0'

alias ..='cd ..'
alias ll='ls -alF'
alias la='ls -A'
alias le='less'
alias l='ls -lisaG'

# Quick HTTP Server
alias pyserv='python -c "import SimpleHTTPServer, SocketServer, BaseHTTPServer; SimpleHTTPServer.test(SimpleHTTPServer.SimpleHTTPRequestHandler, type('"'"'Server'"'"', (BaseHTTPServer.HTTPServer, SocketServer.ThreadingMixIn, object), {}))" 9090'

# Quick CLI Pasting
alias dsnip="curl -F 'paste=<-' http://s.drk.sc"
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"


### Application aliases

# SSH / i2ssh aliases
if [ -s "$(which ssh)" ]; then
  alias s=$(which ssh)
fi

if [ -s "$(which i2ssh)" ]; then
  alias i=$(which i2ssh)
fi

# APT shorties
if [ -s "$(which apt-get)" ]; then
  alias agu='sudo apt-get update; sudo apt-get upgrade -y'
  alias agi='sudo apt-get install'
  alias acs='sudo apt-cache search'
  alias acp='sudo apt-cache policy'
fi

# Git aliases
if [ -s "$(which git)" ]; then
  alias gpr='git pull --rebase'
  alias gb='git branch'
  alias gp='git push'
  alias gct='git checkout'
  alias gcm='git commit'
  alias gd='git diff'
  alias gds='git diff --staged'
  alias gs='git status'
  alias gsu='git status -uno'
  alias gg='git grep'
  alias glo='git log --oneline'
  alias gc='git checkout master ; git pull --rebase upstream master ; git push origin master'
  alias gscpp="git stash ; git checkout master ; git pull --rebase upstream master ; git push origin master"
  alias gcpp="git checkout master ; git pull --rebase upstream master ; git push origin master"
  alias gdsnip='git diff | dsnip'
fi

# Vagrant aliases
VAGRANT="$(which vagrant)"
if [ -s "${VAGRANT}" ]; then

  # Vagrant status / Vagrant ssh
  vs() {
    if [ $# -gt 0 ]; then
      ${VAGRANT} ssh ${*}
    else
      ${VAGRANT} status
    fi
  }

  alias v="${VAGRANT}"
  alias vu="${VAGRANT} up"
  alias vup="${VAGRANT} up --provision"
  alias vp="${VAGRANT} provision"
fi

# Test-kitchen aliases
TEST_KITCHEN="$(which kitchen)"
if [ -s "${TEST_KITCHEN}" ]; then

  # Kitchen login/list
  kl() {
    if [ $# -gt 0 ]; then
      ${TEST_KITCHEN} login ${*}
    else
      kitchen list
    fi
  }

  alias kt="${TEST_KITCHEN} test"
  alias kv="${TEST_KITCHEN} verify"
  alias kc="${TEST_KITCHEN} converge"
  alias kd="${TEST_KITCHEN} destroy"
fi

# VirtualBox aliasing
VBOXMAN="$(which VBoxManage)"
if [ -s "${VBOXMAX}" ]; then
  echo "Enabling vboxmanage"
  alias vbm="${VBOXMAN}"
  alias vbmm="${VBOXMAN} modifyvm"
  alias vbmc="${VBOXMAN} controlvm"
  alias vbms="${VBOXMAN} startvm"
fi


### Arbitrary functions

# Alert for long running cmds. Usage: sleep 1; alert
if [ -s "$(which say)" ]; then
  alias alert="say $*"
else
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1| sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

alias ialert='i3-nagbar -m "[$?] Job Completed ($( echo -n $( history | tail -n2 | head -n1 | cut -d\  -f 4- ) )")'

# build single csv string from \n delimited file
csv() {
  if [ $# -eq 1 ]; then
    while read line; do
      echo "'${line}'"
    done < $1 | tr '\n' ','
  fi
}


# Break elfs into opcodes
disas() {
  GCC="$(which gcc)"
  if [ -s "${GCC}" ]; then
	   ${GCC} -pipe -S -o - -O -g $* | as -aldh -o /dev/null
  else
     echo "GCC is not installed"
  fi
}

# Create Directory and Change Into It
cmkdir() {
	mkdir -p $*
	cd $*
}

# Create Executable File
te() {
	touch $*
	chmod 700 $*
}

# Quickly Generate Password of given length, defaults to 10 characters
genpass() {
  test -z "$1" && LENGTH=10 || LENGTH=$1
  python -c "from random import choice; import string; print ''.join( [ choice( string.printable.split( '\"')[0] ) for x in range( $LENGTH ) ] );"
}


### Text Color
RED="\033[31m"
DARK_YELLOW="\033[33m"
CYAN="\e[123m"
BLUE="\033[34m"
MAGENTA="\033[35m"
ORANGE="\033[91m"
CLEAR="\033[0m"
