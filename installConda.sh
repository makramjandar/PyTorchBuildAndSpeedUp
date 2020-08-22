#!/bin/bash

NAME="Anaconda3"
VER="2019.07"
OS="Linux-x86_64"

sudo apt-get update
mkdir $HOME/.conda
#mkdir ~/tmp && cd "$_"

wget https://repo.anaconda.com/archive/$NAME-$VER-$OS.sh -O $HOME/anaconda.sh
bash $HOME/anaconda.sh -b -p $HOME/$NAME && sudo rm $HOME/anaconda.sh

# Enable Conda for all users.
echo "export PATH=\$HOME/Anaconda3/bin:\$PATH" >> $HOME/.bashrc
sudo ln -s $HOME/$NAME/etc/profile.d/conda.sh /etc/profile.d/conda.sh
source .bashrc

# With this activated shell, you can then install conda’s shell functions for easier access in the future:
# conda init bash 
eval "$(conda shell.bash hook)"

# Deactivate conda’s base environment on startup:
conda config --set auto_activate_base false


# rm -- "$0"
# exec bash

# Quick Install:
# wget 'https://raw.githubusercontent.com/makramjandar/AwesomeScripts/master/handyDandy/install/conda.sh' && . conda.sh
# Ref:
# https://www.digitalocean.com/community/tutorials/how-to-install-the-anaconda-python-distribution-on-ubuntu-18-04
# https://github.com/ContinuumIO/anaconda-issues/issues/11154
# https://github.com/ContinuumIO/anaconda-issues/issues/11159
# https://medium.com/@chadlagore/conda-environments-with-docker-82cdc9d25754
# https://github.com/ContinuumIO/docker-images
# https://hub.docker.com/u/conda
