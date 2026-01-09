echo 

# Ubuntu
cat /etc/os-release | grep VERSION= 

# CUDA
nvcc --version || nvidia-smi

# Jupyter
jupyter --version

# Python
python --version

# R
R --version | head -n 1

# Julia
julia --version

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
import os; os.environ['TF_CPP_MIN_LOG_LEVEL'] = '10'; import tensorflow as tf; print("TensorFlow:", tf.__version__)
EOF
