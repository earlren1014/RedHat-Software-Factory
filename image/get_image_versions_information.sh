#!/bin/bash

dir=$1

if [ -z "${dir}" ] || [ ! -d "${dir}" ]; then
    echo "usage: $0 install-directory"
    exit 1
fi

sudo mount -t proc none ${dir}/proc

echo "#"
echo "# Edeploy version"
sudo chroot ${dir} edeploy version
echo
echo "# RPM packages versions"
sudo chroot ${dir} rpm -qa | sort | while read pkg; do echo "rpm: ${pkg}"; done
echo
echo "# PIP packages versions"
sudo chroot ${dir} pip freeze | sort | while read pkg; do echo "pip: ${pkg}"; done
echo
echo "# Gem packages versions"
sudo chroot ${dir} gem list | grep '^[a-z]' | sort | while read pkg; do echo "gem: ${pkg}"; done

# Nodejs package listing disable because npm stuck when system is not running
#echo
#echo "# Node packages verions"
#sudo chroot ${dir} npm list -g --depth 1 | while read pkg; do echo "npm: ${pkg}"; done

sudo umount ${dir}/proc
