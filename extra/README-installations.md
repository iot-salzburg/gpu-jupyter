# Guide for the installation


## Installation of NVIDIA drivers and CUDA

```bash
# add Keyring to allow automatic updates in the system
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update

# install CUDA 13.0, see https://endoflife.date/nvidia.
sudo apt update
sudo apt install nvidia-driver-580-open
apt policy cuda  # check available versions of cuda
sudo apt-get install cuda-toolkit=13.0.*
apt policy nvidia-gds  # check available versions of nvidia-gds
sudo apt install nvidia-gds=13.0.*

# deactivate automatic updates        
sudo apt-mark hold cuda-toolkit
sudo apt-mark hold nvidia-gds

# test GPU drivers, the shown CUDA version is the maximal supported one of the NVIDIA-driver:        
nvidia-smi
sudo reboot


# install NVIDIA Container Toolkit, for the virtualization of the GPU in Docker
sudo apt install nvidia-container-toolkit
```

## Installation of Docker


```bash
sudo apt update
sudo apt install ca-certificates curl

# add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# add the repository to Apt sources, using the host's own Ubuntu codename
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# docker-compose-plugin provides the "docker compose" subcommand (Compose V2)
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
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
docker compose version  # check the version
```