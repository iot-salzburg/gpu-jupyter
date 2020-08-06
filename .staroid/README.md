## gpu-jupyter on staroid

This directory contains files to deploy gpu-jupyter project on [staroid](https://staroid.com).

[![Run](https://staroid.com/api/run/button.svg)](https://staroid.com/api/run)


## Development

Run locally with [skaffold](https://skaffold.dev) command.

```
$ git clone https://github.com/iot-salzburg/gpu-jupyter.git
$ cd gpu-jupyter
$ skaffold dev -f .staroid/skaffold.yaml --port-forward -p minikube
```

and browse `http://localhost:8888`
