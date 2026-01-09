# Guide for the installation


## Installation of NVIDIA drivers and CUDA

```bash
# add Keyring to allow automatic updates in the system
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update

# install CUDA 12.9, see https://endoflife.date/nvidia.
sudo apt update
sudo apt install nvidia-driver-580-open
apt policy cuda  # check available versions of cuda
sudo apt-get install cuda-toolkit=12.9.*
apt policy nvidia-gds  # check available versions of nvidia-gds
sudo apt install nvidia-gds=12.9.*

# deactivate automatic updates        
sudo apt-mark hold cuda-toolkit
sudo apt-mark hold nvidia-gds

# test GPU drivers, the shown CUDA version is the maximal supported one of the NVIDIA-driver:        
nvidia-smi

# install NVIDIA CUDA toolkit (optional for nvcc)
sudo apt install nvidia-cuda-toolkit
sudo reboot


# install NVIDIA Container Toolkit, for the virtualization of the GPU in Docker
sudo apt install nvidia-container-toolkit
```

## Installation of Docker


```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce  # to check the installation candidate
sudo apt install docker-ce
sudo systemctl status docker  # check the systemctl status of the docker-service
sudo systemctl enable docker  # enable autostart of the docker-service
docker  # help for docker
sudo docker run hello-world  # check if pulling and running works
```

```bash
sudo usermod -aG docker ${USER}
su - ${USER}
groups  # check if docker is listed
sudo usermod -aG docker ${USER}
```

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version  # check the version
```