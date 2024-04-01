# Use rocker/verse as the base image
FROM rocker/verse:latest

# Install Python and pip
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Jupyter and jupyter-client
RUN pip3 install jupyter jupyter-client

# Install dependencies for LaTeX, PreTeXt, and other XML tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    xsltproc \
    libxml2-utils \
    libxslt1-dev \
    sagemath \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    texlive-latex-extra \
    texlive-science \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install Python libraries for scientific computing, interactivity, and PreTeXt
RUN pip3 install numpy pandas matplotlib ipywidgets notebook pretextbook

# Install additional LaTeX packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-pictures \
    && rm -rf /var/lib/apt/lists/*


# Install the PreTeXt CLI
RUN pip3 install pretext

# Install IRkernel
RUN R -e "install.packages('IRkernel', repos='http://cran.us.r-project.org')"

# Configure IRkernel
RUN R -e "IRkernel::installspec(user = FALSE)"

# Diagnose R environment and package installations
RUN R -e "installed.packages()[,c('Package', 'Version')]"
RUN R -e ".libPaths()"

# Create a 'jupyter' user with a home directory
RUN useradd -m -s /bin/bash jupyter

# Set the working directory to the 'jupyter' user's home directory
WORKDIR /home/jupyter

# Switch to the 'jupyter' user
USER jupyter

# Expose port 8888 for Jupyter Notebook
EXPOSE 8888

# Start Jupyter Notebook with no token and no password, and allow access from any IP
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
