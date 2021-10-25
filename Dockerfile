FROM rocker/r-ver:4.1.0
RUN apt-get update && apt-get install -y  git-core libcurl4-openssl-dev libgit2-dev libicu-dev libssl-dev make pandoc pandoc-citeproc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = c(BioCsoft = 'https://bioconductor.org/packages/3.14/bioc', BioCann = 'https://bioconductor.org/packages/3.14/data/annotation', BioCexp = 'https://bioconductor.org/packages/3.14/data/experiment', BioCworkflows = 'https://bioconductor.org/packages/3.14/workflows', BioCbooks = 'https://bioconductor.org/packages/3.14/books', CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("jsonlite",upgrade="never", version = "1.7.2")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.3.5")'
RUN Rscript -e 'remotes::install_version("data.table",upgrade="never", version = "1.14.2")'
RUN Rscript -e 'remotes::install_version("knitr",upgrade="never", version = "1.36")'
RUN Rscript -e 'remotes::install_version("dplyr",upgrade="never", version = "1.0.7")'
RUN Rscript -e 'remotes::install_version("grr",upgrade="never", version = "0.9.5")'
RUN Rscript -e 'remotes::install_version("badger",upgrade="never", version = "0.1.0")'
RUN Rscript -e 'remotes::install_version("piggyback",upgrade="never", version = "0.1.1")'
RUN Rscript -e 'remotes::install_version("testthat",upgrade="never", version = "3.1.0")'
RUN Rscript -e 'remotes::install_version("here",upgrade="never", version = "1.0.1")'
RUN Rscript -e 'remotes::install_version("rmarkdown",upgrade="never", version = "2.11")'
RUN Rscript -e 'remotes::install_version("markdown",upgrade="never", version = "1.1")'
RUN Rscript -e 'remotes::install_version("covr",upgrade="never", version = "3.5.1")'
RUN Rscript -e 'remotes::install_version("BiocStyle",upgrade="never", version = "2.21.4")'
RUN Rscript -e 'remotes::install_version("remotes",upgrade="never", version = "2.4.1")'
RUN Rscript -e 'remotes::install_version("GenomeInfoDbData",upgrade="never", version = "1.2.7")'
RUN Rscript -e 'remotes::install_version("repmis",upgrade="never", version = "0.5")'
RUN Rscript -e 'remotes::install_version("Matrix.utils",upgrade="never", version = "0.9.8")'
RUN Rscript -e 'remotes::install_version("DelayedMatrixStats",upgrade="never", version = "1.15.4")'
RUN Rscript -e 'remotes::install_version("DelayedArray",upgrade="never", version = "0.19.4")'
RUN Rscript -e 'remotes::install_version("patchwork",upgrade="never", version = "1.1.1")'
RUN Rscript -e 'remotes::install_version("ggpubr",upgrade="never", version = "0.4.0")'
RUN Rscript -e 'remotes::install_version("babelgene",upgrade="never", version = "21.4")'
RUN Rscript -e 'remotes::install_version("gprofiler2",upgrade="never", version = "0.2.1")'
RUN Rscript -e 'remotes::install_version("homologene",upgrade="never", version = "1.4.68.19.3.27")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
