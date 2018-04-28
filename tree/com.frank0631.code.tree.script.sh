#!/bin/bash
# script to install tree
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

TREE_INSTALLED=false
command -v tree >/dev/null 2>&1 && TREE_INSTALLED=true

# no tree, install it
if [ ${TREE_INSTALLED} = false ]; then
  PACKAGES=${PACKAGES}" tree";
  TREE_INSTALLED=true
else
  echo "Tree is already installed"
  exit 0
fi

YUM_INSTALLED=false
APT_GET_INSTALLED=false
DNF_INSTALLED=false
ZYPPER_INSTALLED=false

command -v yum >/dev/null 2>&1 && YUM_INSTALLED=true
command -v apt-get >/dev/null 2>&1 && APT_GET_INSTALLED=true
command -v dnf >/dev/null 2>&1 && DNF_INSTALLED=true
command -v zypper >/dev/null 2>&1 && ZYPPER_INSTALLED=true


if [ ${YUM_INSTALLED} = true ]; then
  ${SUDO} yum install ${PACKAGES};

elif [ ${APT_GET_INSTALLED} = true ]; then
  ${SUDO} apt-get update;
  ${SUDO} apt-get -y install ${PACKAGES};

elif [ ${DNF_INSTALLED} = true ]; then
  ${SUDO} dnf -y install ${PACKAGES};

elif [ ${ZYPPER_INSTALLED} = true ]; then
  ${SUDO} zypper install -y ${PACKAGES};

else
    >&2 echo "Any of Yum, Apt-get, Dnf, Zypper package manager is not available"
    exit 1
fi

echo "Tree is installed successfully"