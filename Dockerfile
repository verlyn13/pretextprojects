# Use a more LaTeX-focused base image
FROM texlive/texlive:latest

# Install Python and pip
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create a virtual environment and activate it
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Jupyter and jupyter-client in the virtual environment
RUN pip install jupyter jupyter-client

# Install dependencies for PreTeXt and other XML tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    xsltproc \
    libxml2-utils \
    libxslt1-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python libraries for scientific computing, interactivity, and PreTeXt in the virtual environment
RUN pip install numpy pandas matplotlib ipywidgets notebook pretextbook

# Install the PreTeXt CLI in the virtual environment
RUN pip install pretext

# Update TeX Live package database to ensure all packages are recognized
RUN mktexlsr

# TikZ and related packages should be included in the texlive/texlive:latest base image, so no need for separate installation
# If additional LaTeX packages are needed, they can be installed with tlmgr here

# Create a 'jupyter' user with a home directory
RUN useradd -m -s /bin/bash jupyter

# Set the working directory to the 'jupyter' user's home directory
WORKDIR /home/jupyter

# Grant the 'jupyter' user ownership over its home directory
RUN chown -R jupyter:jupyter /home/jupyter

# Switch to the 'jupyter' user
USER jupyter

# Expose port 8888 for Jupyter Notebook
EXPOSE 8888

# Start Jupyter Notebook with no token and no password, and allow access from any IP
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
