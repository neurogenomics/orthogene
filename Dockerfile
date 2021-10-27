FROM bioconductor/bioconductor_docker:devel
RUN apt-get update && apt-get install -y  git-core libcurl4-openssl-dev libgit2-dev libicu-dev libssl-dev make pandoc pandoc-citeproc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = c(BioCsoft = 'https://bioconductor.org/packages/devel/bioc',\
                            BioCann = 'https://bioconductor.org/packages/devel/data/annotation',\
                            BioCexp = 'https://bioconductor.org/packages/devel/data/experiment',\
                            BioCworkflows = 'https://bioconductor.org/packages/devel/workflows',
                            BioCbooks = 'https://bioconductor.org/packages/devel/books',\
                            CRAN = 'https://cran.rstudio.com/'),\
                            download.file.method = 'libcurl', Ncpus = 4)" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages(c("remotes","devtools"))'
# install the R package and all its imports/depends/suggests
RUN R -e | "devtools::install_dev_deps(dependencies = TRUE, upgrade = 'never')"
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
# Run R CMD check - will fail with any errors or warnings
Run Rscript -e 'devtools::check()'
# Install R package from source
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
