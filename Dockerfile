FROM rocker/r-base
LABEL maintainer="cansav09@gmail.com"

# Install apt-getable packages to start
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils dialog
RUN apt-get install -y --no-install-recommends \
    libxt6 \
    libpoppler-cpp-dev \
    vim \
    libglpk40 \
    curl \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev

# Needed R packages
RUN Rscript -e  "options(warn = 2);install.packages( \
    c('tidyverse', \
      'rprojroot', \
      'spelling', \
      'ottrpal', \
      'optparse'), \
      repos = 'https://cloud.r-project.org/')"

# Install svn to copy folder from github
RUN apt-get update && apt-get install -y --no-install-recommends subversion

COPY main.sh ./main.sh
RUN chmod +x ./main.sh

WORKDIR /github/workspace

ARG CHECK_TYPE
ENV CHECK_TYPE=${INPUT_CHECK_TYPE}

ENTRYPOINT ["/bin/bash", "/ottr_report_scripts/main.sh"]
