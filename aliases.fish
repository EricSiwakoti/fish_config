# Useful Aliases and Functions

# Automatically creates any missing directories when using `mkdir`.
alias mkdir='mkdir -pv'

# Outputs the complete file path of a specified file.
alias showpath='readlink -e'

# Displays the size of a specified file or directory.
alias sizeof="du -hs"

# Removes directories but prompts for confirmation.
alias rmm='rm -rvI'

# Copies directories and prompts for confirmation.
alias cpdir='cp -R'

# Asks for confirmation before overwriting files.
alias cp='cp -i'

# Prompts for confirmation when overwriting files.
alias mv='mv -i'

# Adds the current directory to the user's path.
alias add-to-path='set -U fish_user_paths (pwd) $fish_user_paths'

# Outputs sizes in a human-readable format (e.g., MB, GB).
alias df='df -h'
alias du='du -ch'
alias free='free -m'

# Displays free space on physical drives while excluding certain filesystem types.
alias fs='df -h -x squashfs -x tmpfs -x devtmpfs'

# Lists all disks, clearly indicating which are temporarily mounted.
alias disks='lsblk -o HOTPLUG,NAME,SIZE,MODEL,TYPE | awk "NR == 1 || /disk/"'

# Lists all partitions while filtering out loop devices.
alias partitions='lsblk -o HOTPLUG,NAME,LABEL,MOUNTPOINT,SIZE,MODEL,PARTLABEL,TYPE,UUID | grep -v loop | cut -c1-$COLUMNS'

# Disables screen locking until the next reboot.
alias lockblock='killall xautolock; xset s off; xset -dpms; echo ok'

# Saves files using the provided name from the server response.
alias wget='wget --content-disposition'

# Removes an environment variable.
alias unset 'set --erase'

# Allows scrolling through long directory listings using less.
function ll --description "Scroll ll if there's more files that fit on screen"
    ls -l $argv --color=always | less -R -X -F
end

# Creates a new directory and changes into it immediately.
function mkcd --description "Create and cd to directory"
    mkdir $argv
    and cd $argv
end

# Mounts an archive and navigates to the last created directory in the mount point.
function amount --description "Mount archive"
    /usr/lib/gvfs/gvfsd-archive file=$argv &>/dev/null &
    sleep 1
    cd $XDG_RUNTIME_DIR/gvfs
    cd (ls -p | grep / | tail -1)
end

# Unmounts all mounted archives and GVFS locations.
function aumount --description "Unmount all mounted archive (and gvfs locations)"
    gvfs-mount --unmount $XDG_RUNTIME_DIR/gvfs/*
end

# Copies piped input or arguments to the clipboard.
function copy --description "Copy pipe or argument"
    if [ "$argv" = "" ]
        xclip -sel clip
    else
        printf "$argv" | xclip -sel clip
    end
end

# Copies the full path of a specified file to the clipboard.
function copypath --description "Copy full file path"
    readlink -e $argv | xclip -sel clip
    echo "copied to clipboard"
end

# Prints colored blocks based on hex color codes.
function color --description "Print color"
    echo (set_color (string trim -c '#' "$argv"))"██"
end

# Opens files in nano, prompting for root access if necessary.
function nano --description "Open file in nano editor with root permission if necessary"
    if not test -e "$argv"
        read -p "echo 'File $argv does not exist. Ctrl+C to cancel'" -l confirm
        touch "$argv" &>/dev/null
    end

    if test -w "$argv"
        /bin/nano -mui $argv
    else
        echo "Editing $argv requires root permission"
        sudo /bin/nano -mui $argv
    end
end

# Makes a file executable and then executes it.
function run --description "Make file executable, then run it"
    chmod +x "$argv"
    eval "./$argv"
end

# Starts GUI applications in the background, hiding their output.
function launch --description "Launch GUI program without blocking terminal output."
    eval "$argv >/dev/null 2>&1 &" & disown
end

# Opens files using their default applications without blocking terminal output.
function open --description "Open file by default application in new process."
    env XDG_CURRENT_DESKTOP=X-Generic xdg-open $argv >/dev/null & disown
end

# Allows running bash commands from within fish shell.
function b --description "Exec command in bash."
    bash -c "$argv"
end

# Replaces ssh with sssh2 if it's available on the system.
if type -q sssh2
    alias ssh=sssh2
end

# Uses plug for managing USB drives interactively when available.
if type -q plug
    alias unplug='plug -u'
    alias plug='cd (command plug)'
end
