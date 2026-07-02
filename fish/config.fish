# ~/.config/fish/config.fish
# ================================================================
#  Fish configuration converted from your Bash .bashrc
#  Revised to avoid sourcing Bash scripts directly and to fix
#  history configuration errors reported at startup.
# ================================================================

#### 0. Disable greeting ######################################################
set -U fish_greeting ""

#### 1. Core environment vars ##################################################
set -x EDITOR code

# Handy directory shortcuts (universal so they persist)
set -Ux docs      $HOME/Documents
set -Ux downloads $HOME/Downloads
set -Ux pics      $HOME/Pictures
set -Ux desk      $HOME/Desktop
set -Ux fishrc   $HOME/.config/fish/config.fish
#### 2. PATH management ########################################################
# Use fish_add_path to keep PATH clean and deduplicated.
fish_add_path /usr/sbin /usr/local/sbin /usr/local/bin /usr/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/share/coursier/bin
fish_add_path $HOME/.nvm/versions/node/v24.1.0/bin
fish_add_path /usr/local/go/bin
fish_add_path /opt/rocm-6.3.2/bin
source $HOME/.local/bin/env.fish

# Go workspace
set -Ux GOPATH $HOME/go
fish_add_path $GOPATH/bin

#### 3. Node Version Manager (NVM) ############################################
# Sourcing nvm.sh directly breaks under Fish because it is a Bash script.
# Recommended: install the pure‑Fish plugin instead:
#     fisher install jorgebucaran/nvm.fish
# If you still need legacy Bash nvm, install the `bass` wrapper:
#     fisher install edc/bass
# Then you could uncomment the following line:
#     bass source $NVM_DIR/nvm.sh --no-use
set -x NVM_DIR $HOME/.nvm

#### 4. Shell history settings #################################################
# Fish maintains its own history file automatically.  The variables Bash uses
# (HISTCONTROL, HISTSIZE, etc.) are not needed.  To increase the history limit:
set -U fish_history_limit 20000

#### 5. Colourful utils / LS aliases ###########################################
if type -q eza
    abbr -a ls    'eza -lah --icons --sort=modified --reverse'
    abbr -a ll    'eza -lah --icons --octal-permissions --group-directories-first --git'
    abbr -a la    'eza -a --icons --group-directories-first'
else
    abbr -a ls    'ls -lahrt --color=auto'
end
abbr -a dir   'dir --color=auto'
abbr -a vdir  'vdir --color=auto'
abbr -a grep  'grep --color=auto'
abbr -a fgrep 'fgrep --color=auto'
abbr -a egrep 'egrep --color=auto'

# GCC coloured diagnostics
set -x GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#### 6. Abbreviations (aliases) ################################################
# System maintenance
abbr -a update	'~/Documents/projects/updater/package_updater.sh'
abbr -a inst       'sudo pacman -S'
abbr -a gpucrashcheck 'sudo journalctl -f | grep -iE "amdgpu|drm"'

# Safer file ops
abbr -a rm 'rm -irf'
abbr -a mv 'mv -i'
abbr -a cp 'cp -iR'

# Networking shortcuts
abbr -a miami       'nordvpn c United_States Miami'
abbr -a utepconnect 'sudo openconnect --protocol=gp myvpn.utep.edu'

# Clipboard helpers
abbr -a clipit  'xclip -selection clipboard'
abbr -a pasteit 'xclip -o -selection clipboard'
abbr -a qrscan  'clipit -t image/png -o > /tmp/clipboard_image.png && zbarimg /tmp/clipboard_image.png | grep "QR-Code:" | sed "s/QR-Code://" | clipit'

# Archive helpers
abbr -a unpack  'tar -xvzf'
abbr -a tarinst 'tar -xz'

# Git helpers
abbr -a gadd  'git add -A'
abbr -a gpull 'git pull origin main'

# Python UV
abbr -a python 'uv run --python 3.13 python'
abbr -a python3 'uv run --python 3.13 python'
abbr -a pip 'uv tool'
abbr -a pip3 'uv tool'

# App launchers
abbr -a freecad   'nohup ~/Apps/FreeCAD.AppImage &'
abbr -a pcloud    'nohup ~/Apps/pcloud &'
abbr -a texstudio 'nohup ~/Apps/texstudio.AppImage &'
abbr -a aseprite  'nohup ~/Apps/aseprite/build/bin/aseprite &'
abbr -a bye       'sudo shutdown now'
abbr -a rbt       'sudo reboot now'
abbr -a storm     'curl wttr.in/El%20Paso?m'
abbr -a deepseek  'ollama run deepseek-r1:1.5b'

#### 7. Functions ##############################################################
function gcommit --description 'Add all & commit with interactive message'
    read --prompt-str "Commit message: " msg
    git add -A; and git commit -m "$msg"
end

function gpush --description 'Pull‑rebase, commit & push'
    read --prompt-str "Commit message: " msg
    git pull origin main --rebase
    git add -A; and git commit -m "$msg"; and git push origin main
end

function ccomp --description 'Compile C file with sane flags'
    set -l base (string replace -r '\\.c$' '' (basename $argv[1]))
    gcc -Wall -g -O3 $argv -o $base
end

function md2pdf --description 'Convert Markdown → PDF with pandoc'
    set -l base (string replace -r '\\.md$' '' (basename $argv[1]))
    pandoc $argv[1] -o "$base".pdf
end

# Clean up legacy lt abbreviation to allow the lt function to take precedence
abbr -q lt; and abbr -e lt

function lt --description 'List directory tree with eza, defaulting to full depth with dependency exclusions'
    if type -q eza
        set -l level ""
        set -l ignore_pattern ".git|node_modules|__pycache__|target|.venv|.cargo|cache"
        set -l pass_args
        set -l show_deps 0

        for arg in $argv
            if string match -r '^[0-9]+$' -- "$arg" >/dev/null
                set level "$arg"
            else if contains -- "$arg" -d --deps --show-deps --all-deps
                set show_deps 1
            else
                set -a pass_args "$arg"
            end
        end

        set -l eza_cmd eza --tree --icons
        if test -n "$level"
            set -a eza_cmd --level "$level"
        end

        if test "$show_deps" -eq 0
            set -a eza_cmd --ignore-glob "$ignore_pattern"
        end

        $eza_cmd $pass_args
    else if type -q tree
        set -l level ""
        set -l pass_args
        for arg in $argv
            if string match -r '^[0-9]+$' -- "$arg" >/dev/null
                set level "$arg"
            else
                set -a pass_args "$arg"
            end
        end

        set -l tree_cmd tree -a -I '.git|node_modules|__pycache__|target|.venv|.cargo|cache'
        if test -n "$level"
            set -a tree_cmd -L "$level"
        end
        $tree_cmd $pass_args
    else
        echo "Neither eza nor tree is installed."
        return 1
    end
end

#### 8. Zoxide (Replaced Autojump) #############################################
zoxide init fish | source

#### 9. Lesspipe integration ###################################################
if type -q lesspipe
    set -x LESSOPEN "| /usr/bin/lesspipe %s"
end

#### 10. Prompt / theme ########################################################
# Using Oh‑My‑Fish theme "zish".  Custom options:
# set -g theme_color_scheme dracula

#### 11. Extras / plugin recommendations ######################################
#   fisher install jorgebucaran/nvm.fish       # Pure Fish NVM
#   fisher install PatrickF1/fzf.fish           # FZF key‑bindings + completions
#   fisher install IlanCosman/tide@v5           # Async modern prompt
#   fisher install direnv/direnv.fish           # direnv integration per‑project

# ============================================================================
starship init fish | source
