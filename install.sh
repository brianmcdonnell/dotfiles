#!/usr/bin/env bash

txtred='\e[00;31m' # Red
txtgrn='\e[00;32m' # Green
txtylw='\e[00;33m' # Yellow
txtpur='\e[0;35m'  # Purple
txtrst='\e[00m'    # Text Reset
function success() {
    echo -e ${txtgrn}$1${txtrst};
}
function info() {
    echo -e ${txtylw}$1${txtrst};
}
function warn() {
    echo -e ${txtpur}$1${txtrst};
}
function error() {
    echo -e ${txtred}$1${txtrst};
}

# Make a guess at the os
os_name=`uname -s`
if [ "Linux" == $os_name ]; then
    os_name="LINUX"
elif [ "CYGWIN" == ${os_name:0:6} ]; then
    os_name="CYGWIN"
else
    os_name="MAC_OS"
fi
info "$os_name detected"

# Determine where the dotfiles should be deployed.
if [ $os_name == "CYGWIN" ] ; then
    homedir=${USERPROFILE}
else
    homedir=${HOME}
fi

# Checks if the argument exists as a command in the PATH
function command_exists() {
    if type "$1" &> /dev/null; then
        return 0
    fi
    return 1
}

# Checks if each item in a list of command dependencies exist
function dependencies_exist() {
    local __result=0
    for req in $@
    do
        echo -n $req;
        command_exists $req
        if [ "$?" == 0 ]; then
            success "\t[OK]" ;
        else
            __result=1
            error "\t[NOT FOUND]"
        fi
    done
    return $__result
}

# Creates a native OS symbolic link
function link_file {
    local real_file="$1"
    local link="$2"

    if [ $os_name == "CYGWIN" ] ; then
        # This will be executed from within a bash context
        # We need to use the command.com mklink to create
        # a valid windows symlink
        local win_real=`cygpath -w "$real_file"`
        local win_link=`cygpath -w "$link"`
        info "Linking: $win_link --> $win_real"
        if [ -d $real_file ]; then
            cmd /c mklink /D "$win_link" "$win_real"
        else
            cmd /c mklink "$win_link" "$win_real"
        fi
    else
        info "Linking: $link --> $real_file"
        # ln TARGET LINK_NAME
        ln -sf ${real_file} ${link}
    fi
}

# Performs an operation on each file/dir beginning with an underscore in the dotfiles dir.
# First argument specifies teh operation to be performed.
function underscore_files()
{
    for i in _*
    do
        local real_file="$i"
        local link="$i"
        # '.vim' directory is called 'vimfiles' on windows
        if [ "CYGWIN" == $os_name ] && [ "_vim" == $real_file ]; then
            link="vimfiles"
        fi

        if [ $1 == "backup" ]; then
            # If the link exists as a symlink, directory or file, move it to the bkp dir
            local bkp_file="$homedir/${link/_/.}"
            if [ -e "$bkp_file" ] || [ -d "$bkp_file" ] || [ -f "$bkp_file" ] ; then
                local bkp_file="$homedir/${link/_/.}"
                info "Backing up: $bkp_file"
                mv $bkp_file $bkp_dir
            fi
        elif [ $1 == "link" ]; then
            # Attach links
            real_path=${PWD}/$real_file
            link_file "${real_path}" "$homedir/${link/_/.}"
        else
            error "underscore_files: Invalid argument"
        fi
    done
}

# This script needs the following tools to be available in the system path.
script_reqs=(   "grep"
                "sed"
                "tail"
                "sort"
                "date"
                "git"
                );
info "Install script requires the following programs"
req_list=`echo ${script_reqs[@]}`
dependencies_exist $req_list
if [ "$?" != 0 ]; then
    error "Please install the missing dependencies."
    exit 1
fi

# Check for presence of vim and/or gvim
info "Checking for vim and gvim"
vim_exists=false
gvim_exists=false
if $(command_exists "vim"); then
    echo -n "vim"
    success "\t[OK]"
    vim_exists=true
fi
if $(command_exists "gvim"); then
    echo -n "gvim"
    success "\t[OK]"
    gvim_exists=true
fi

# Bail out if neither vim nor gvim are available
if [ $vim_exists == false ] && [ $gvim_exists == false ]; then
    error "At least one of vim or gvim must be installed"
    exit 1
fi

# The following programs are required by the installed bundles
plugin_reqs=(   "ack"       # Used by vim Ack plugin
                "pydoc"     # Used by vim Pydoc plugin
                "pep8"      # Used by PEP8 plugin
                "ag"        # Used by vim ctrl-p plugin
                );

# Check that all external programs needed by the bundles are available in the system path.
info "Checking bundle dependencies"
req_list=`echo ${plugin_reqs[@]}`
dependencies_exist $req_list
if [ "$?" != 0 ]; then
    error "Please install the missing dependencies."
    exit 1
fi

# Update all bundle submodules
info "Updating all submodules bundles"
git submodule sync
if [ "$?" != 0 ]; then
    error "git submodule sync failed."
    exit 1
fi
git submodule update --init --recursive
if [ "$?" != 0 ]; then
    error "git submodule update failed."
    exit 1
fi

# Backup any existing files to dated directory
bkp_time=`date +"%Y-%b-%d-%H:%M:%S.%N"`
bkp_dir="$homedir/.dotfiles-bkp/$bkp_time"
info "Creating backup directory"
mkdir -p "$bkp_dir"
if [ "$?" == 0 ]; then
    success "Created backup directory: $bkp_dir"
else
    error "Failed to create backup directory: $bkp_dir"
    exit 1
fi

# Create a .file symlink to each _file conterpart
info "Backing up existing files"
underscore_files 'backup'
info "Creating symlinks to all relevant dotfiles."
underscore_files 'link'

# Report success
success "Done!"

# TODO: Accept arguments to this script to modify behaviour
