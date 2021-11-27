#!/usr/bin/env bash

# Stop script on NZEC
set -e
# Stop script if unbound variable found (use ${var:-} if intentional)
set -u
# By default cmd1 | cmd2 returns exit code of cmd2 regardless of cmd1 success
# This is causing it to fail
set -o pipefail

#Script parameters

#Debug for this
verbose=true

filedata=metadata.json

appfile=/tmp/app.deb


exec 3>&1




if [ -r $filedata ]; then
   echo ""
else
   echo "data file not non-existent !! "
   exit 1
fi



invocation='say_verbose "Calling: ${yellow:-}${FUNCNAME[0]} ${green:-}$*${normal:-}"'


if [ -t 1 ] && command -v tput >/dev/null; then
    # see if it supports colors
    ncolors=$(tput colors)
    if [ -n "$ncolors" ] && [ $ncolors -ge 8 ]; then
        bold="$(tput bold || echo)"
        normal="$(tput sgr0 || echo)"
        black="$(tput setaf 0 || echo)"
        red="$(tput setaf 1 || echo)"
        green="$(tput setaf 2 || echo)"
        yellow="$(tput setaf 3 || echo)"
        blue="$(tput setaf 4 || echo)"
        magenta="$(tput setaf 5 || echo)"
        cyan="$(tput setaf 6 || echo)"
        white="$(tput setaf 7 || echo)"
    fi
fi


say_warning() {
    printf "%b\n" "${yellow:-}install: Warning: $1${normal:-}" >&3
}

say_err() {
    printf "%b\n" "${red:-}install: Error: $1${normal:-}" >&2
}

say() {
    printf "%b\n" "${cyan:-}install:${normal:-} $1" >&3
}

say_verbose() {
    if [ "$verbose" = true ]; then
        say "$1"
    fi
}

#get_filedata_value tagname
get_filedata_value() {
    eval $invocation
    local tag_name="$1" 

    cat $filedata |  grep "$tag_name" |   sed -E 's/.*"([^"]+)".*/\1/' 
}

get_machine_architecture() {
    eval $invocation

    if command -v uname > /dev/null; then
        CPUName=$(uname -m)
        case $CPUName in
        armv*l)
            echo "arm"
            return 0
            ;;
        aarch64|arm64)
            echo "arm64"
            return 0
            ;;
        esac
    fi

    # Always default to 'x64'
    echo "amd64"
    return 0
}

#  download  url  file
downloadcurl() {
    eval $invocation

        
    unset http_code
    unset download_error_msg
    local remote_path="$1"
    local out_path="${2:-}"

    local curl_options="--retry 20 --retry-delay 2 --connect-timeout 15 -sSL -f --create-dirs "
    local failed=false

    say_verbose "curl $curl_options -o $out_path   $remote_path "

    curl $curl_options -o $out_path $remote_path || failed=true


    if [ "$failed" = true ]; then
        download_error_msg="Unable to download $remote_path."
        say_verbose " $download_error_msg"
        return 1
    fi

    return 0
}


#Download file
downloadfile() {
    eval $invocation
    
    local failed=false

    say "Download file"

    download_link="$(get_filedata_value  "$(get_machine_architecture)"  )"
    
    say_verbose "Downloading link :$download_link"

    downloadcurl $download_link $appfile  || failed=true

    if [ "$failed" = true ]; then
        say_verbose "Download failed: $url";
        return 1
    fi
    return 0
    
}

#install  filepath
install(){

    eval $invocation

    local failed=false

    say "Install App"
    say_verbose "Install file : $appfile"

    if [ -e $appfile ];  then

        export DEBIAN_FRONTEND=noninteractive;
        apt-get install --yes   $appfile   || failed=true
        
        rm -f $appfile 


    else
        say_verbose "Install file not found : $appfile"
        failed=true
    fi

       
    if [ "$failed" = true ]; then
        say_verbose "install failed"
        return 1
    fi
    return 0
}


runall() {
    
    downloadfile

    install

}




runall