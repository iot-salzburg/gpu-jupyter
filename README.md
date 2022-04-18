# FiftyOne with Jupyter Lab

### Installation
Use `generate-Dockerfile.sh` to configure `.build/Dockerfile`
```bash
./generate-Dockerfile.sh --help
```

In my case:
```bash
./generate-Dockerfile.sh --pw mypassword --python-only
```

After that `.build/Dockerfile` will generated.

### Build Docker Image
```bash
docker build -t user/fiftyone:latest .build/
```

### Run Docker Compose
Run code below to running container with docker compose:
```bash
docker-compose up -d
```
Or on Azure Virtual Machine with:
```bash
docker compose up -d
```

### SSH Tunneling for Azure VM
You can access JupyterLab and FiftyOne by SSH Tunneling:
```bash
# Access JupyterLab
ssh -N -L 5252:localhost:5252 azureuser@your-ip

# Access FiftyOne
ssh -N -L 5151:localhost:5151 azureuser@your-ip
```