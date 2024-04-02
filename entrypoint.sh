#!/bin/bash
# Fix permissions for the Jupyter directories
chown -R jupyter:jupyter /home/jupyter/.local /home/jupyter/.ipython

# Start Jupyter Notebook
exec gosu jupyter jupyter notebook "$@"
