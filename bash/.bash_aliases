GIT_PS1_SHOWDIRTYSTATE=true
export PS1="\[\033[36m\]\u\[\033[m\]:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'
alias l='ls'
eval $(thefuck --alias)

# Cheat Sheet
cheat(){
    curl cheat.sh/$1
}
alias cht=cheat

# Dir Helpers
alias ..='cd ..'
alias ...='cd ../..'
alias b='cd $OLDPWD'
alias reclaim='sudo chown -R $(whoami):$(whoami)'
alias dev="cd ~/Dev"
alias keebs="cd ~/Keyboards"
alias lanops="cd ~/Dev/lanops/"
alias xedi="cd ~/Dev/xedi/"
alias vup="vagrant up"
alias vssh="vagrant ssh"
alias vh="vagrant halt"
alias bckups="cd ~/Backups"
alias dank-hacks='ping amazon.co.uk'
alias mincli="export PS1='> '"
alias normcli="export PS1='\[\033[0;35m\]\h\[\033[0;33m\] \w\[\033[00m\]: '"

# Docker

alias dup="docker-compose up"
alias dupb="docker-compose up --build"
alias ddown="docker-compose down"
alias drma="docker rmi $(docker images -f dangling=true -q)"
alias dcomp="docker run --rm -v $(pwd):/app composer/composer install"
alias drmv="docker volume ls -qf dangling=true | xargs -r docker volume rm"
alias dlogs="screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty"

dip(){
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
}

dockssh(){
    docker exec -i -t $1 /bin/bash
}
alias dssh=dockssh

# quick jump back x amount of folders

function bk() {
    if [[ -z $1 ]]; then
        eval "cd ..";
    elif [[ ! -z $1 ]]; then
        for (( i=0; i < $1; i++))
        do
            eval "cd ..";
        done
    fi
}

function grp() {    
    grep -rsin --color "$1" .
}

function gfile() {    
    eval "find . -name "$'*$1*'" -type f "
}

extract (){     
    if [ -f $1 ] ; then         
        case $1 in             
            *.tar.bz2)   tar xjf $1        ;;            
            *.tar.gz)    tar xzf $1     ;;             
            *.bz2)       bunzip2 $1       ;;             
            *.rar)       rar x $1     ;;             
            *.gz)        gunzip $1     ;;             
            *.tar)       tar xf $1        ;;             
            *.tbz2)      tar xjf $1      ;;             
            *.tgz)       tar xzf $1       ;;             
            *.zip)       unzip $1     ;;             
            *.Z)         uncompress $1  ;;             
            *.7z)        7z x $1    ;;             
        *)           echo "'$1' cannot be extracted via extract()" ;;         esac     else         echo "'$1' is not a valid file"     
    fi
}

function _makefile_targets {
    local curr_arg;
    local targets;

    # Find makefile targets available in the current directory
    targets=''
    if [[ -e "$(pwd)/Makefile" ]]; then
        targets=$( \
            grep -oE '^[a-zA-Z0-9_-]+:' Makefile \
            | sed 's/://' \
            | tr '\n' ' ' \
        )
    fi

    # Filter targets based on user input to the bash completion
    curr_arg=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "${targets[@]}" -- $curr_arg ) );
}
complete -F _makefile_targets make


if [ -f ~/.bash_tunnels ]; then
    . ~/.bash_tunnels
fi

if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
    . /usr/local/git/contrib/completion/git-completion.bash
fi
