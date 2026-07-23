#!/usr/bin/env bash
echo

# Ubuntu
grep VERSION= /etc/os-release

# CUDA
nvcc --version || nvidia-smi

# Jupyter
jupyter --version

# Python
python --version

# R
if command -v R >/dev/null 2>&1; then
  R --version | head -n 1
else
  echo "R: not installed"
fi

# Julia
if command -v julia >/dev/null 2>&1; then
  julia --version
else
  echo "Julia: not installed"
fi

# NumPy
python - <<'EOF'
import numpy; print("NumPy:", numpy.__version__)
EOF

# PyTorch
python - <<'EOF'
import torch; print("PyTorch:", torch.__version__, "PyTorch's CUDA:", torch.version.cuda)
EOF

# TensorFlow
python - <<'EOF'
import os; os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'; import tensorflow as tf; print("TensorFlow:", tf.__version__)
EOF
