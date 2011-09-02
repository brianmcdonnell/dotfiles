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

function link_file {
    source="$1"
    target="$2"
    # If the target exists as a symlink, directory or file, move it to the bkp dir
    if [ -e "${target}" ] || [ -d "${target}" ] || [ -f "${target}" ] ; then
        mv $target $bkp_dir
    fi

    ln -sf ${source} ${target}
}

script_reqs=(   "grep"
                "sed"
                "tail"
                "sort"
                "date"
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
                "ruby"      # Used by vim Command-T plugin
                "rake"      # Used by vim Command-T plugin
                );

# If ruby is in the requirements we need to check the
# version of ruby that vim is compiled against.
ruby_required=false
for i in ${plugin_reqs[@]}; do
    if [[ $i == "ruby" ]] ; then
        ruby_required=true;
    fi;
done


function compare_ruby_versions() {
    vim_ruby_ver=`$2 --version | grep -io "ruby[0-9\.]*" | sort | tail -n 1`
    if [ $vim_ruby_ver ]; then
        echo -n "$2 requires:   "
        info "\t$vim_ruby_ver"
    else
        error "$2 not compiled for ruby."
        return 2
    fi

    if [ $1 == $vim_ruby_ver ]; then
        echo -n "$2 ruby"
        success " [OK]"
        return 0
    fi
    return 1
}

if [ $ruby_required == true ] ; then
    info "Checking ruby availability"
    ruby_ver=`ruby --version | grep -o "\bruby [0-9\.]*" | sed "s/ruby /ruby/"`
    if [ $ruby_ver ]; then
        echo -n "ruby available: "
        info "\t$ruby_ver"
    else
        error "Ruby is required but unavailable"
        exit 1
    fi

    # Find out which (if any) version of ruby vim/gvim are compiled against
    if $vim_exists; then
        compare_ruby_versions $ruby_ver 'vim'
        vim_ruby_ok=$?
    fi
    if $gvim_exists; then
        compare_ruby_versions $ruby_ver 'gvim'
        gvim_ruby_ok=$?
    fi

    if [ vim_ruby_ok == 2 ] && [ gvim_ruby_ok == 2 ]; then
        error "Neither vim nor gvim are compiled with ruby support."
    fi

    if [ vim_ruby_ok != 0 ] || [ gvim_ruby_ok != 0 ]; then
        warn "Inexact match. vim/gvim plugins relying on ruby may not work correctly."
    fi
else
    info "Skipping ruby validation as it's not required by bundle plugins."
fi

info "Checking bundle dependencies"
req_list=`echo ${plugin_reqs[@]}`
dependencies_exist $req_list
if [ "$?" != 0 ]; then
    error "Please install the missing dependencies."
    exit 1
fi

# Update all submodules
info "Updating all submodules bundles"
git submodule sync
git submodule update --init --recursive

# Check that ruby-dev / ruby-dev-kit is installed.
info "Checking for ruby-dev / ruby-dev-kit"
ruby -e "require 'mkmf'"
if [ "$?" == 0 ]; then
    success "ruby-dev is available"
else
    if [ $os_name == "CYGWIN" ]; then
        error "Please install ruby dev kit: http://rubyinstaller.org/add-ons/devkit/"
    else
        error "Please install ruby dev: apt-get install $ruby_ver-dev"
    fi
    exit 1
fi


#Build command-t ruby extensions
info "Building command-t ruby C extensions"
start_dir=`pwd`
cd _vim/bundle/command-t
rake make
if [ "$?" == 0 ]; then
    success "Command-T ruby c extension built"
else
    error "Building Command-T ruby c extension failed"
    exit 1
fi
cd $start_dir

# Backup any existing files to dated directory
bkp_time=`date +"%Y-%b-%d-%H:%M:%S.%N"`
bkp_dir="${HOME}/.dotfiles-bkp/$bkp_time"
info "Creating backup directory"
mkdir -p "$bkp_dir"
if [ "$?" == 0 ]; then
    success "Created backup directory: $bkp_dir"
else
    error "Failed to create backup directory: $bkp_dir"
    exit 1
fi

# Create a .file symlink to each _file conterpart
info "Creating symlinks to all relevant dotfiles."
info "Any existing files will be backed up."
for i in _*
do
    s="$i"
    t="$i"
    # .vim directory is called .vimfiles on windows
    if [ os_name == "CYGWIN" ] && [ "_vim" == $s ]; then
        t="_vimfiles"
    fi
    link_file "${PWD}/$s" "${HOME}/${t/_/.}"
done
success "Done!"

# Accept arguments to this script to modify behaviour
