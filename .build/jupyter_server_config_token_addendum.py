
# Set static token
import os
if os.getenv("JUPYTER_TOKEN"):
    c.ServerApp.token = os.getenv("JUPYTER_TOKEN")
