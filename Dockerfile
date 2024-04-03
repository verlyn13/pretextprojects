# Use a more LaTeX-focused base image
FROM texlive/texlive:latest

# Install Python, pip, build essentials, gosu (for user switching), and PreTeXt dependencies
# in one RUN command to reduce layers and improve build efficiency
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    git \
    build-essential \
    gfortran \
    xsltproc \
    libxml2-utils \
    libxslt1-dev \
    gosu \
    net-tools \
    iproute2 \
    lsof \
    procps && \  
    rm -rf /var/lib/apt/lists/*

# Create a virtual environment and activate it
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Uninstall pretextbook and install the latest version of pretext
RUN pip uninstall -y pretextbook && \
    pip install --upgrade pretext

# Install Jupyter and other Python packages
# PreTeXt is already installed in the previous step, so it's omitted here
RUN pip install jupyter==1.0.0 jupyter-client==6.1.12 numpy pandas matplotlib ipywidgets notebook

# Update TeX Live package database to ensure all packages are recognized
RUN mktexlsr

# Create a 'jupyter' user with a home directory
RUN useradd -m -s /bin/bash jupyter

# Set the working directory to the 'jupyter' user's home directory
WORKDIR /home/jupyter

# Copy the entrypoint script into the container and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 8888 for Jupyter Notebook
EXPOSE 8888

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command to run when starting the container
CMD ["--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
