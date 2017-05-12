#!/bin/bash

{
  CURRENT_DIR=$( cd "$( dirname "$0" )" && pwd )
  INSTALL_DIR="$HOME/.juliavm"

  juliavm_echo() {
    command printf %s\\n "$*" 2>/dev/null || {
      juliavm_echo() {
        # shellcheck disable=SC1001
        \printf %s\\n "$*" # on zsh, `command printf` sometimes fails
      }
      juliavm_echo "$@"
    }
  }

  juliavm_install(){
    juliavm_echo "Creating directories structure ..."
    juliavm_create_directories
    juliavm_echo "Moving files ..."
    juliavm_copy_files
    juliavm_set_platform
    juliavm_echo "Juliavm successfully installed!!"
    exec bash
  }

  juliavm_create_directories(){
    eval 'mkdir $INSTALL_DIR'
    eval 'mkdir $INSTALL_DIR/dists'
  }

  juliavm_copy_files(){
    eval 'cp $CURRENT_DIR/juliavm.sh $INSTALL_DIR/juliavm'
    echo "alias juliavm='$INSTALL_DIR/juliavm'" >> ~/.bashrc
    eval 'cp -r $CURRENT_DIR/.git $INSTALL_DIR'
  }

  juliavm_set_platform(){
    juliavm_echo "Choose a standard platform:"
    juliavm_echo "  1 - osx 64 bits"
    juliavm_echo "  2 - linux 64 bits"
    juliavm_echo "  3 - linux 32 bits"
    while [[ -z "$platform" || ("$platform" != 1 && "$platform" != 2 && "$platform" != 3) ]]
    do
      read platform
      if [[ "$platform" != 1 && "$platform" != 2 && "$platform" != 3 ]]; then
        juliavm_echo "Invalid option, try again!"
      fi
    done
    if [[ "$platform" == 1 ]]; then
      export JULIAVM_PLATFORM="-osx"
    elif [[ "$platform" == 2 ]]; then
      export JULIAVM_PLATFORM="-x64"
    elif [[ "$platform" == 3 ]]; then
      export JULIAVM_PLATFORM="-x86"
    fi

    juliavm_echo $JULIAVM_PLATFORM
  }

  juliavm_install
}
