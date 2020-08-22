#!/bin/bash

PB=$(tput setaf 3)$(tput bold)
N=$(tput sgr0)

ENV="pytorch"
CONDA_VER="Anaconda3"
PYTHON_VER="3.7.3"
NUMPY_VER="1.16.3"
CUDA=0
CUDNN=0
MKLDNN=1

# Install the prerequisite packages.
printf "\\n%s... Create Conda's env. ... %s \\n" "${PB}" "${N}"
conda update -y -n base -c defaults conda
conda create -y -n ${ENV} python=${PYTHON_VER} numpy=${NUMPY_VER}
eval "$(conda shell.bash hook)"
conda activate ${ENV}
conda install -y numpy pyyaml mkl mkl-include setuptools cmake cffi typing
printf "\\n%s... Done !! Conda's env. created ... %s \\n" "${PB}" "${N}" && sleep 2

# 1 - Specify build with Cuda instead of CPU.
printf "\\n%s... Install  Magma Cuda 100 ... %s \\n" "${PB}" "${N}"
if [ "$1" == "cuda" ]; then 
  CUDA=1
  CUDNN=1
  conda install -y -c pytorch magma-cuda100
fi
printf "\\n%s... Done !! Magma Cuda 100 installed ... %s \\n" "${PB}" "${N}" && sleep 2

# 2 - Install OpenMP, a library for better CPU Multi-Threading.
printf "\\n%s... Install OpenMP ... %s \\n" "${PB}" "${N}"
sudo apt-get install -y libomp-dev
printf "\\n%s... Done !! OpenMP installed ... %s \\n" "${PB}" "${N}" && sleep 2

# 3 - Pytorch fork with extended librairies.
printf "\\n%s... Clone PyTorch ... %s \\n" "${PB}" "${N}"
cd ~ && git clone --recursive https://github.com/data-scientifically-yours/pytorch.git
printf "\\n%s... Done !! PyTorch cloned ... %s \\n" "${PB}" "${N}" && sleep 2

# 4 - Build & Install the library with the following steps:
printf "\\n%s... Build PyTorch ... %s \\n" "${PB}" "${N}"
# For CMake (building tool) where to put the resulting files.
export CMAKE_PREFIX_PATH="$HOME/$CONDA_VER/envs/$ENV"
# Temporarily rename Anaconda compatibility linker for avoiding older symlinks mistakes. 
mv ~/$CONDA_VER/envs/$ENV/compiler_compat/ld ~/$CONDA_VER/envs/$ENV/compiler_compat/ld-old
# Start the building process.
export USE_CUDA=$CUDA USE_CUDNN=$CUDNN USE_MKLDNN=$MKLDNN
python ~/pytorch/setup.py install
# Rename back the Anaconda compiler linker.
mv ~/$CONDA_VER/envs/$ENV/compiler_compat/ld-old ~/$CONDA_VER/envs/$ENV/compiler_compat/ld
printf "\\n%s... Et voilà !! ... %s \\n" "${PB}" "${N}"

# 5 - CleanUp:
sudo rm -r ~/pytorch
rm -- "$0"

# Quick Install:
# With Cuda >> wget -O - -q "https://raw.githubusercontent.com/makramjandar/AwesomeScripts/master/handyDandy/build/pytorch/build.sh" && bash build.sh cuda 
# CPU Only  >> wget -O - -q "https://raw.githubusercontent.com/makramjandar/AwesomeScripts/master/handyDandy/build/pytorch/build.sh" && bash build.sh

# Ref:
# https://github.com/conda/conda/issues/7980
