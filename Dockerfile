FROM rocker/r-base
LABEL maintainer="cansav09@gmail.com"

# Needed R packages
RUN Rscript -e  "options(warn = 2);install.packages( \
    c('tidyverse', \
      'rprojroot', \
      'spelling', \
      'ottrpal'), \
      repos = 'https://cloud.r-project.org/')"

COPY entrypoint.sh /entrypoint.sh
WORKDIR /github/workspace

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
