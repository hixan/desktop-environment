# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
de="$HOME/.config/desktop-environment"

# Path to your oh-my-zsh installation.
export ZSH="/home/alexe/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

if [ -d "$HOME/.local/bin" ]; then
	export PATH=$HOME/.local/bin:$PATH
fi
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git aws)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

function todo_raw() {
	#dir=$([ $# -eq 0 ] && echo "$HOME/Documents" || echo "$1")
	find $([ $# -eq 0 ] && echo "$HOME/Documents" || echo "$1") -not -path '*/\.*' -name todo 2>/dev/null | sed -n 's_\(\.\?/\(.*\)/\(\([^/]*\)/\([^/]*\)\)\)/todo_\4 \5 \1_p' | sort -k 2 | head -n 10
}

function todo() {
	column <(todo_raw $1 | awk -v x='25' '{printf("%-"x"s", $1); print $2}')
}

function gotodo() {
	echo 'select item:'
	x=$(todo_raw $1)
	column <(echo $x | awk -v x='25' '{printf("%-"x"s", $1); print $2}' | nl -v 0 -s') ' -w1)
	echo -n '# '
	read -sk selection
	goingto=$(echo $x | awk -v n=$selection 'NR==n+1{print $3}' | sed 's_/todo__')
	echo 'changing directory to '"$goingto"
	cd "$goingto"
}

# alias see-git-objs='for ref in $(find .git/objects -type f | sed -n "s .git/objects/\(..\)/\(.*\) \1\2 p"); do echo $ref "{{{"; git cat-file -p $ref;echo "}}}"; done | nvim -c ":set fdm=marker"'
alias colors="$de/scripts/print_colors"
alias jsonv="nvim -c 'set filetype=json'"
function emg {
	[ -f $1 ] || touch $1
	emacsclient -c --alternate-editor '' $1 &
	disown
}
function jnvim {
	[ -f $1 ] || touch $1
	# if no jupyter-lab instances exist, spawn one.
	if [[ $(ps -C jupyter-lab | wc -l) -lt 2 ]]; then
		jupyter lab --browser "$de/scripts/jupyterlab-console %s" > /dev/null 2>&1 &
		disown
		echo 'waiting for jupyter-lab...'
		sleep 10
	fi
	nvim $1 -c "silent JupyterConnect"
}
function magit {
	# make a parent container
	i3-msg "split toggle" > /dev/null
	# make tabbed mode
	i3-msg "layout tabbed" > /dev/null
	# launch emacs (now hides terminal that called it)
	git rev-parse --is-inside-work-tree && emacsclient -e '(progn (magit-status) (delete-other-windows))' -c
	# after exits, move left to remove the parent container
	i3-msg "move left" > /dev/null
}
# sudoeditor to use neovim
export SUDO_EDITOR=/usr/bin/nvim
