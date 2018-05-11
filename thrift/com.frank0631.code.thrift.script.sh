#!/bin/bash
# script to install thrift
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
unset PACKAGES
unset THRIFT_DEPS
(ldconfig -p | grep libboost >/dev/null 2>&1) || { THRIFT_DEPS=${THRIFT_DEPS}" libboost-all-dev"; }
(command -v bison) || { THRIFT_DEPS=${THRIFT_DEPS}" bison"; }
(command -v flex) || { THRIFT_DEPS=${THRIFT_DEPS}" flex"; }
CMAKE_INSTALLED=$(command -v cmake)

if [ "$CMAKE_INSTALLED" -ne 0 ]; then
    echo Dependency CMake not installed
    exit 1
fi

THRIFT_INSTALLED=false
command -v thrift >/dev/null 2>&1 && THRIFT_INSTALLED=true

# no thrift, install it
if [ ${THRIFT_INSTALLED} = false ]; then
  echo "Installing Thrift"
else
  echo "Thrift is already installed"
  exit 0
fi

YUM_INSTALLED=false
APT_GET_INSTALLED=false
DNF_INSTALLED=false
ZYPPER_INSTALLED=false



if [ -z "$THRIFT_DEPS" ]
then
    echo all THRIFT_DEPS found
else
    echo installing THRIFT_DEPS $THRIFT_DEPS
    
    command -v yum >/dev/null 2>&1 && YUM_INSTALLED=true
    command -v apt-get >/dev/null 2>&1 && APT_GET_INSTALLED=true
    command -v dnf >/dev/null 2>&1 && DNF_INSTALLED=true
    command -v zypper >/dev/null 2>&1 && ZYPPER_INSTALLED=true
    
    if [ ${YUM_INSTALLED} = true ]; then
      ${SUDO} yum install ${PACKAGES};
    
    elif [ ${APT_GET_INSTALLED} = true ]; then
      ${SUDO} apt-get update;
      ${SUDO} apt-get -y install ${THRIFT_DEPS};
    
    elif [ ${DNF_INSTALLED} = true ]; then
      ${SUDO} dnf -y install ${THRIFT_DEPS};
    
    elif [ ${ZYPPER_INSTALLED} = true ]; then
      ${SUDO} zypper install -y ${THRIFT_DEPS};
    else
        >&2 echo "Any of Yum, Apt-get, Dnf, Zypper package manager is not available"
        exit 1
    fi        
fi

#Download and make thrift

wget -q -nc http://mirrors.sonic.net/apache/thrift/0.11.0/thrift-0.11.0.tar.gz
tar -xzf thrift-0.11.0.tar.gz
cd thrift-0.11.0
./configure
${SUDO} cmake -DBUILD_TESTING=OFF -DBUILD_TESTING=OFF -DBUILD_TUTORIALS=OFF .
${SUDO} make install .

rm -rf ./thrift-0.11.0 thrift-0.11.0.tar.gz
command -v thrift >/dev/null 2>&1 && THRIFT_INSTALLED=true

if $THRIFT_INSTALLED; then
   echo "Thrift is installed successfully"
else
   echo "Thrift install failed"
   exit 1
fi

