# To install source this file from your .zshrc file

# Change this to reflect your installation directory
export __GIT_PROMPT_DIR=~/.zsh/git-prompt

# Change to true if you are using a mac with the macport version of zsh
local isMac=true

# Initialize colors.
autoload -U colors
colors

# Allow for functions in the prompt.
setopt PROMPT_SUBST

if $isMac; then
    function preexec() {
        preexec_update_git_vars $@;
    }
    function precmd() {
        precmd_update_git_vars $@;
    }
    function chpwd() {
        chpwd_update_git_vars $@;
    }
else
    ## Enable auto-execution of functions.
    typeset -ga preexec_functions
    typeset -ga precmd_functions
    typeset -ga chpwd_functions

    # Append git functions needed for prompt.
    preexec_functions+='preexec_update_git_vars'
    precmd_functions+='precmd_update_git_vars'
    chpwd_functions+='chpwd_update_git_vars'
fi

## Function definitions
function preexec_update_git_vars() {
    case "$2" in
        git*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}

function precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ]; then
        update_current_git_vars
        unset __EXECUTED_GIT_COMMAND
    fi
}

function chpwd_update_git_vars() {
    update_current_git_vars
}

function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS

    local gitstatus="$__GIT_PROMPT_DIR/gitstatus.py"
    _GIT_STATUS=`${gitstatus}`
    __CURRENT_GIT_STATUS=("${(f)_GIT_STATUS}")
}

function prompt_git_info() {
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
        echo "(%{${fg[red]}%}$__CURRENT_GIT_STATUS[1]%{${fg[default]}%}$__CURRENT_GIT_STATUS[2]%{${fg[magenta]}%}$__CURRENT_GIT_STATUS[3]%{${fg[default]}%})"
    fi
}

# Set the prompt.
#PROMPT='%B%m%~%b$(prompt_git_info) %# '
# for a right prompt:
# RPROMPT='%b$(prompt_git_info)'
