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

script_reqs=(   "grep"
                "sed"
                "tail"
                "sort"
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
# Run rake make
# Backup any existing files to dated directory
# Create a .file symlink to each _file conterpart.

