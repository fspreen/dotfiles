# .bashrc

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

##### HISTORY SETTINGS #####

# No duplicate entries or lines starting with space.
# See bash(1) for mroe options
HISTCONTROL=ignoreboth
# History length
# See bash(1) for details
HISTSIZE=1000
HISTFILESIZE=2000

##### MISC OPTIONS #####

# append to the history file, don't overwrite
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
# One use case is viewing compressed files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

##### COMMAND NOT FOUND #####
# Some distros use a helper utility in the system-wide bashrc file.
# In particular, Ubuntu-based distros call a Python script to announce if the
# command is available in the repositories.  This is kind of slow.  Remove it.
function command_not_found_handle {
    printf "%s: command not found\n" "$1" >&2
    return 127
}

##### COLORS #####

# Detect color capability
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
    screen-256color*) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

##### PROMPT #####

if [ "$color_prompt" = yes ]; then
    # user@host:~/dir$ _
    #    Non-printing char escapes
    #    VV           VV     VV     VV VV           VV  VV     VV
    #      Color code escapes
    #      VVVVVVVVVVV         VVVVV     VVVVVVVVVVV      VVVVV
    PS1="\[\e[38;5;10m\]\u@\h\[\e[0m\]:\[\e[38;5;12m\]\w\[\e[0m\]\$ "
else
    # user@host:~/dir$ _
    PS1="\u@\h:\w\$ "
fi

# User specific aliases and functions
alias vi='vim'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# For certain terminals, set the title bar to user@host:dir
case "$TERM" in
    xterm*|rxvt*|screen*|st*)
        #    Non-printing char escapes
        #    VV                 VV
        #      Titlebar escapes
        #      VVVVV        VVVV
        PS1="\[\e]0;\u@\h:\w\007\]$PS1"
        ;;
esac

# For GNU Screen, set the tab name to the hostname
# https://www.gnu.org/software/screen/manual/screen.html#Naming-Windows
case "$TERM" in
    screen*)
        #    Non-printing char escapes
        #    VV           VV
        #      Scren window title escapes
        #      VVV  VVVVVV
        PS1="\[\ek\h\e\134\]$PS1"
        ;;
esac

# Extended color support for 'ls'
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Explicitly spell out default location for freedesktop.org's
# XDG Base Directory Specification.  These variables are necessary for some
# Cygwin installations, otherwise e.g. mc will make hidden directories all over
# the working directory.
#
#export XDG_CACHE_HOME=/home/$USER/.cache
#export XDG_CONFIG_HOME=/home/$USER/.config
#export XDG_DATA_HOME=/home/$USER/.local/share

# Use colors for man pages
source ~/lesscolors

##### FZF #####
# use Bash keybindings and completions, if installed
# Arch
if [ -f /usr/share/fzf/key-bindings.bash ] ; then
    source /usr/share/fzf/completion.bash
    source /usr/share/fzf/key-bindings.bash
# Debian/Ubuntu
elif [ -f /usr/share/doc/fzf/examples/key-bindings.bash ] ; then
    source /usr/share/bash-completion/completions/fzf
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi
