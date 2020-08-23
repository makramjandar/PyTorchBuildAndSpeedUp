![PyTorch](https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/PyTorch_logo_white.svg/200px-PyTorch_logo_white.svg.png)
# PyTorch Build and SpeedUp
![License](https://img.shields.io/badge/license-Do%20WTF!%20You%20Want-green.svg)  
[![stars badge]][stars]
[![forks badge]][forks]
[![issues badge]][issues]
[![bug report badge]][bug report]
[![feature request badge]][feature request]
[![question badge]][question]
```
IMHO,
building PyTorch from source diminished training in a weird but noticeable way ?!
Approximately 12 seconds per epoch for an AlexNet-like with CUDA, and 30 seconds on CPU-only.
For those who might want to explore different avenues regarding this likely improvement, 
here after a step-by-step for both CUDA and CPU-only installs...
```
  
PyTorch is a Python package that provides two high-level features:
> Tensor computation (like NumPy) with strong GPU acceleration  
> Deep neural networks built on a tape-based autograd system  

- [Prerequisites](#Prerequisites)
  - Instantiate a GPU on GCE Nvidia enabled VM
  - Install Nvidia Driver 
  - Install Anaconda 
- [Build From Source](#Build-From-Source)
  - With Cuda 
  - CPU Only 
- [Verify installation](#Verify-installation)

## Prerequisites

#### <img src="https://raw.githubusercontent.com/data-scientifically-yours/resources/master/icones/gce.png" width="30" height="30" align="center"/> Instantiate a GPU on GCE Nvidia enabled VM
  For the previous step we will need a GCP account. It’s <b>[free](https://cloud.google.com/free/)</B>...  
  
  [![Open in Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/makramjandar/PyTorchSpeedUpAndOptimize&page=editor&open_in_editor=README.md)
```bash
  BASE_URL='https://raw.githubusercontent.com/makramjandar/PyTorchSpeedUpAndOptimize/master' \
  && URL="$BASE_URL/instantiateVM.sh" \
  && wget -O - -q "${URL}" | bash instantiateVM.sh
```

Once the VM has been deployed, in case it's not done automatically, we can login into it from Google Cloud Shell:
```bash
  gcloud compute --project $PROJECT_ID ssh --zone $ZONE $MACHINE_NAME
```

#### <img src="https://raw.githubusercontent.com/data-scientifically-yours/resources/master/icones/nvidia.png" width="40" height="40" align="center"/> Install Nvidia Driver
```bash
  BASE_URL='https://raw.githubusercontent.com/makramjandar/PyTorchSpeedUpAndOptimize/master' \
  && URL="$BASE_URL/installNvidia.sh" \
  && wget -O - -q "${URL}" | bash installNvidia.sh
```

#### <img src="https://raw.githubusercontent.com/data-scientifically-yours/resources/master/icones/anaconda.png" width="30" height="30" align="center"/> Install Anaconda

When building anything, it’s safer to do it in a conda environment to not pollute your system environment.
```bash
  BASE_URL='https://raw.githubusercontent.com/makramjandar/PyTorchSpeedUpAndOptimize/master' \
  && URL="$BASE_URL/installConda.sh" \
  && wget -O - -q  "${URL}" \
  && . conda.sh
```

## Build From Source

#### <img src="https://raw.githubusercontent.com/data-scientifically-yours/resources/master/icones/cudnn.png" width="30" height="30" align="center"/> With Cuda
```bash
  BASE_URL='https://raw.githubusercontent.com/makramjandar/PyTorchSpeedUpAndOptimize/master' \
  && URL="$BASE_URL/buildPyTorch.sh" \
  && wget -O - -q  "${URL}" | bash buildPyTorch.sh cuda
```
  
#### <img src="https://raw.githubusercontent.com/data-scientifically-yours/resources/master/icones/cpu.png" width="30" height="30" align="center"/> CPU Only
```bash
  BASE_URL='https://raw.githubusercontent.com/makramjandar/PyTorchSpeedUpAndOptimize/master' \
  && URL="$BASE_URL/buildPyTorch.sh" \
  && wget -O - -q  "${URL}" | bash buildPyTorch.sh
```

## Verify installation

Still under the pytorch-build environment, let’s run some examples to make sure your installation is correct.

Build the torchvision library from source.
```bash
cd ~ && git https://github.com/pytorch/vision.git && python ~/vision/setup.py install
```

Install tqdm (a dependency for downloading torchvision datasets) with pip in order to run the MNIST example. 
```bash
pip install tqdm
```

Now download the examples and run MNIST:
```bash
cd ~ && git clone https://github.com/pytorch/examples.git && python ~/examples/mnist/python/main.py
```

Voilà !!

## License
PyTorch is BSD-style licensed, as found in the LICENSE file.

[stars badge]:https://img.shields.io/github/stars/makramjandar/PyTorchBuildAndSpeedUp.svg
[forks badge]:https://img.shields.io/github/forks/makramjandar/PyTorchBuildAndSpeedUp.svg
[issues badge]:https://img.shields.io/github/issues/makramjandar/PyTorchBuildAndSpeedUp.svg
[bug report badge]:https://img.shields.io/github/issues/makramjandar/PyTorchBuildAndSpeedUp/Bug%20Report.svg
[feature request badge]:https://img.shields.io/github/issues/makramjandar/PyTorchBuildAndSpeedUp/Feature%20Request.svg
[question badge]:https://img.shields.io/github/issues/makramjandar/PyTorchBuildAndSpeedUp/Question.svg

[stars]:https://github.com/makramjandar/PyTorchBuildAndSpeedUp/stargazers
[forks]:https://github.com/makramjandar/PyTorchBuildAndSpeedUp/network
[issues]:https://github.com/makramjandar/PyTorchBuildAndSpeedUp/issues
[bug report]:https://github.com/makramjandar/PyTorchBuildAndSpeedUp/issues?q=is%3Aopen+is%3Aissue+label%3A%22Bug+Report%22
[feature request]:https://makramjandar/PyTorchBuildAndSpeedUp/issues?q=is%3Aopen+is%3Aissue+label%3A%22Feature+Request%22
[question]:https://github.com/makramjandar/PyTorchBuildAndSpeedUp/issues?q=is%3Aopen+is%3Aissue+label%3AQuestion
[stars]:https://github.com/makramjandar/DataScienceToolkit/stargazers
[forks]:https://github.com/makramjandar/DataScienceToolkit/network
[issues]:https://github.com/makramjandar/DataScienceToolkit/issues
[bug report]:https://github.com/makramjandar/DataScienceToolkit/issues?q=is%3Aopen+is%3Aissue+label%3A%22Bug+Report%22
[feature request]:https://makramjandar/DataScienceToolkit/issues?q=is%3Aopen+is%3Aissue+label%3A%22Feature+Request%22
[question]:https://github.com/makramjandar/DataScienceToolkit/issues?q=is%3Aopen+is%3Aissue+label%3AQuestion
