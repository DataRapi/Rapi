FROM rocker/r-ver:latest

ENV _R_CHECK_TESTS_NLINES_=0

WORKDIR /src/Rapi 

COPY ./ /src/Rapi 

RUN apt-get update && apt-get install -y \
    pandoc \
    qpdf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

    
RUN Rscript -e "install.packages(c('crayon', 'digest', 'dplyr', 'glue'), repos = 'https://cloud.r-project.org')"

RUN R CMD check Rapi 

