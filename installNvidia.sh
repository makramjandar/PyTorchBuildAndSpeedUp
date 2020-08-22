#!/bin/bash

YB=$(tput setaf 2)$(tput bold)
PB=$(tput setaf 4)$(tput bold)
N=$(tput sgr0)

VERSION="418.87"
OS="ubuntu1804"
TYPE="tesla"
NAME="nvidia-driver-local-repo-${OS}-${VERSION}.00_1.0-1_amd64.deb"
KEY="7fa2af80.pub"



# What GPU do we have?
printf "\\n%s<<< What GPU do we have? >>> %s \\n" "${PB}" "${N}"
lspci | grep -i NVIDIA
sleep 3
printf "%s<<< Done 0/6 >>> %s \\n" "${PB}" "${N}"

# 1 - Clean the system
printf "\\n%s<<< Clean the system >>> %s \\n" "${PB}" "${N}"
# Clean the system of other Nvidia drivers
sudo apt-get purge nvidia*
# Note this might remove your cuda installation as well
# sudo apt-get autoremove
printf "%s<<< Done 1/6 >>> %s \\n" "${PB}" "${N}"

# 2 - Prepare the System for the Installation
printf "\\n%s<<< Prepare the System >>> %s \\n" "${PB}" "${N}"
# Before we proceed to the next step, we need to install screen and
# login into it, to make sure that our installation is not interrupted
# by network fluctuations that might close our SSH session.
# https://doc.ubuntu-fr.org/screen
# sudo apt-get install screen -y && screen && yes " "
printf "%s<<< Done 2/6 >>> %s \\n" "${PB}" "${N}"

# 3 - Get the Latest Driver Version >> https://www.nvidia.com/Download/index.aspx
printf "\\n%s<<< Get the Latest Driver >>> %s \\n" "${PB}" "${N}"
wget http://us.download.nvidia.com/"${TYPE}"/"${VERSION}"/"${NAME}"
printf "%s<<< Done 3/6 >>> %s \\n" "${PB}" "${N}"

# 4 - Add the Nvidia Graphic Card Local PPA
printf "\\n%s<<< Update Nvidia Graphic Card Local PPA >>> %s \\n" "${PB}" "${N}"
sudo dpkg -i "${NAME}"
sudo apt-key add /var/nvidia-driver-local-repo-${VERSION}.00/${KEY}
sudo apt-get update
printf "%s<<< Done 4/6 >>> %s \\n" "${PB}" "${N}"

# 5 - Install the Cuda Drivers
printf "\\n%s<<< Install the Cuda Drivers >>> %s \\n" "${PB}" "${N}"
sudo DEBIAN_FRONTEND=noninteractive apt-get install cuda-drivers -y
printf "%s<<< Done 5/6 >>> %s \\n" "${PB}" "${N}"

# 6 - Install the Cuda >> https://developer.nvidia.com/cuda-downloads
printf "\\n%s<<< Install the Cuda >>> %s \\n" "${PB}" "${N}"
wget https://developer.download.nvidia.com/compute/cuda/repos/${OS}/x86_64/cuda-${OS}.pin
sudo mv cuda-${OS}.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/${OS}/x86_64/${KEY}
sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/${OS}/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda
printf "%s<<< Done 6/6 >>> %s \\n" "${PB}" "${N}"

# Test that it's working !!
printf "\\n%s<<< Test that it's working !! >>> %s \\n" "${PB}" "${N}"
#sudo reboot
nvidia-smi
printf "%s<<< Finished !! >>> %s \\n" "${PB}" "${N}"

# AutoClean !!
rm "${NAME}"


# Quick Install:
# wget -O - -q "https://raw.githubusercontent.com/makramjandar/AwesomeScripts/master/handyDandy/install/nvidia.sh" | bash

# Ref:
# https://www.mvps.net/docs/install-nvidia-drivers-ubuntu-18-04-lts-bionic-beaver-linux/
# https://askubuntu.com/questions/1077061/how-do-i-install-nvidia-and-cuda-drivers-into-ubuntu
# https://hackernoon.com/up-and-running-with-ubuntu-nvidia-cuda-cudnn-tensorflow-and-pytorch-a54ec2ec907d
