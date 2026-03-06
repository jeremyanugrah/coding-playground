# 1. Enable Colors & Version Control (Git) Systems
autoload -U colors && colors
autoload -Uz vcs_info

# 2. Configure Git Branch Display
precmd() { vcs_info }
# Format: (branch-name) in yellow using %F{color}
zstyle ':vcs_info:git:*' formats '(%F{yellow}%b%f) '

# 3. Left Side Prompt
# %n=user, %m=host, %~=directory
# %F{cyan} = Cyan User
# %F{green} = Green Host
# %F{blue} = Blue Directory
PROMPT="%F{cyan}%n%f@%F{green}%m%f %F{blue}%~%f "
# Add the git info we configured above
PROMPT+='${vcs_info_msg_0_}'
# Add the prompt symbol (%)
PROMPT+='%# '

# 4. Right Side Prompt (Time + Success/Fail Icon)
# %(?.GreenCheck.RedCross) WhiteTime
RPROMPT="%(?.%F{green}✔.%F{red}✘) %F{white}%D{%H:%M:%S}%f"

# 5. History Settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt prompt_subst

# 6. Wayland Clipboard Fixes
export WAYLAND_DISPLAY=wayland-0
wl-paste > /dev/null 2>&1 &
alias fixclip='wl-paste > /dev/null'

# 7. Your Custom Aliases
alias v='nvim'
# I tweaked this to include -Wall (warnings) for better C++ practice
alias gcp='g++ -std=c++17 -g -Wall main.cpp -o main && ./main'
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias ...='cd ../..'

# 8. Syntax Highlighting (Must be loaded last)
if [ -f ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# 9. Your C++ Project Creator Function
mkcpp() {
    mkdir -p "$1" && cd "$1"
    echo '#include <iostream>

int main() {
    std::cout << "Hello from '$1'!" << std::endl;
    return 0;
}' > main.cpp
    echo "bin/" > .gitignore
    nvim main.cpp
}

# Enable advanced auto-completion
autoload -Uz compinit && compinit

# Make auto-completion case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Alias for VS codium
alias code='codium'

# Alias for autocolor while using grep
alias grep='grep --color=auto'
export PATH=$HOME/bin:$PATH
