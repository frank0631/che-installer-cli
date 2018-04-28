#!/bin/bash
# script to install cmake
set -x

is_current_user_root() {
    test "$(id -u)" = 0
}

is_current_user_sudoer() {
    sudo -n true > /dev/null 2>&1
}

set_sudo_command() {
    if is_current_user_sudoer && ! is_current_user_root; then SUDO="sudo -E"; else unset SUDO; fi
}

set_sudo_command

WGET_INSTALLED=false
CMAKE_INSTALLED=false
command -v wget >/dev/null 2>&1 && WGET_INSTALLED=true
command -v cmake >/dev/null 2>&1 && CMAKE_INSTALLED=true

# no cmake, download and install it
if [ ${CMAKE_INSTALLED} = false ]; then    
  CMAKE_INSTALLED=true
else
  echo "CMake is already installed"
  exit 0
fi

${SUDO} wget -q -nc https://cmake.org/files/v3.11/cmake-3.11.1-Linux-x86_64.tar.gz
${SUDO} wget -q -nc https://cmake.org/files/v3.11/cmake-3.11.1-Linux-x86_64.sh
${SUDO} mkdir /opt/cmake
${SUDO} sh ./cmake-3.11.1-Linux-x86_64.sh --prefix=/opt/cmake --skip-license
${SUDO} ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
${SUDO} rm ./cmake-3.11.1-Linux-x86_64.sh cmake-3.11.1-Linux-x86_64.tar.gz
cmake -version

echo "CMake is installed successfully"