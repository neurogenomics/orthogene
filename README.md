<img src='./inst/hex/orthogene.png' height='400'><br>
================
<h4>
Author: <i>Brian M. Schilder</i>
</h4>
<h4>
Most recent update: <i>Jul-28-2021</i>
</h4>

## R package for easy mapping of orthologous genes across a wide variety of species.

`orthogene` uses [homologene](https://github.com/oganm/homologene) to
pull up-to-date interspecies gene orthologs mappings across 20+ species.

# Installation

``` r
if(!"remotes" %in% rownames(installed.packages())) install.packages("remotes")

remotes::install_github("neurogenomics/orthogene")
```

# Quick example

## Map genes

``` r
library(orthogene)

data("cortex_mrna")
gene_df <- convert_orthologs(gene_df = cortex_mrna$exp,
                             gene_col="rownames", 
                             input_species = "mouse")
```

    ## Converting genes: mouse ===> human

    ## + Converting rownames to Gene col...

    ## + Searching for orthologs.

    ## + Dropping genes that don't have 1:1 gene mappings...

    ## Genes dropped during inter-species conversion:  4,248  /  19,972  ( 21.27 %)

## Check available organisms

``` r
taxa_id_dict(NULL)
```

    ##                  Mus musculus             Rattus norvegicus 
    ##                         10090                         10116 
    ##          Kluyveromyces lactis            Magnaporthe oryzae 
    ##                         28985                        318829 
    ##         Eremothecium gossypii          Arabidopsis thaliana 
    ##                         33169                          3702 
    ##                  Oryza sativa     Schizosaccharomyces pombe 
    ##                          4530                          4896 
    ##      Saccharomyces cerevisiae             Neurospora crassa 
    ##                          4932                          5141 
    ##        Caenorhabditis elegans             Anopheles gambiae 
    ##                          6239                          7165 
    ##       Drosophila melanogaster                   Danio rerio 
    ##                          7227                          7955 
    ## Xenopus (Silurana) tropicalis                 Gallus gallus 
    ##                          8364                          9031 
    ##                Macaca mulatta               Pan troglodytes 
    ##                          9544                          9598 
    ##                  Homo sapiens        Canis lupus familiaris 
    ##                          9606                          9615 
    ##                    Bos taurus                         human 
    ##                          9913                          9606 
    ##                         chimp                    chimpanzee 
    ##                          9598                          9598 
    ##                        monkey                       macaque 
    ##                          9544                          9544 
    ##                         mouse                           rat 
    ##                         10090                         10116 
    ##                           dog                           cow 
    ##                          9615                          9913 
    ##                       chicken                     zebrafish 
    ##                          9031                          7955 
    ##                          frog                           fly 
    ##                          8364                          7227 
    ##                          worm                          rice 
    ##                          6239                          4530

# Session Info

<details>

``` r
utils::sessionInfo()
```

    ## R version 4.1.0 (2021-05-18)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 20.04.2 LTS
    ## 
    ## Matrix products: default
    ## BLAS/LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.8.so
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=C             
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] orthogene_0.1.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] MatrixGenerics_1.4.0        Biobase_2.52.0             
    ##  [3] httr_1.4.2                  bit64_4.0.5                
    ##  [5] assertthat_0.2.1            stats4_4.1.0               
    ##  [7] BiocFileCache_2.0.0         blob_1.2.2                 
    ##  [9] GenomeInfoDbData_1.2.6      Rsamtools_2.8.0            
    ## [11] yaml_2.2.1                  progress_1.2.2             
    ## [13] pillar_1.6.1                RSQLite_2.2.7              
    ## [15] lattice_0.20-44             glue_1.4.2                 
    ## [17] limma_3.48.1                digest_0.6.27              
    ## [19] GenomicRanges_1.44.0        XVector_0.32.0             
    ## [21] htmltools_0.5.1.1           Matrix_1.3-4               
    ## [23] XML_3.99-0.6                pkgconfig_2.0.3            
    ## [25] biomaRt_2.48.2              zlibbioc_1.38.0            
    ## [27] purrr_0.3.4                 BiocParallel_1.26.1        
    ## [29] tibble_3.1.3                EnsDb.Hsapiens.v75_2.99.0  
    ## [31] KEGGREST_1.32.0             AnnotationFilter_1.16.0    
    ## [33] generics_0.1.0              IRanges_2.26.0             
    ## [35] ellipsis_0.3.2              cachem_1.0.5               
    ## [37] SummarizedExperiment_1.22.0 GenomicFeatures_1.44.0     
    ## [39] lazyeval_0.2.2              BiocGenerics_0.38.0        
    ## [41] magrittr_2.0.1              crayon_1.4.1               
    ## [43] memoise_2.0.0               evaluate_0.14              
    ## [45] fansi_0.5.0                 xml2_1.3.2                 
    ## [47] homologene_1.4.68.19.3.27   tools_4.1.0                
    ## [49] prettyunits_1.1.1           hms_1.1.0                  
    ## [51] BiocIO_1.2.0                lifecycle_1.0.0            
    ## [53] matrixStats_0.60.0          stringr_1.4.0              
    ## [55] S4Vectors_0.30.0            DelayedArray_0.18.0        
    ## [57] AnnotationDbi_1.54.1        ensembldb_2.16.3           
    ## [59] Biostrings_2.60.1           compiler_4.1.0             
    ## [61] GenomeInfoDb_1.28.1         rlang_0.4.11               
    ## [63] grid_4.1.0                  RCurl_1.98-1.3             
    ## [65] SingleCellExperiment_1.14.1 rappdirs_0.3.3             
    ## [67] rjson_0.2.20                bitops_1.0-7               
    ## [69] rmarkdown_2.9               restfulr_0.0.13            
    ## [71] curl_4.3.2                  DBI_1.1.1                  
    ## [73] R6_2.5.0                    GenomicAlignments_1.28.0   
    ## [75] knitr_1.33                  dplyr_1.0.7                
    ## [77] rtracklayer_1.52.0          fastmap_1.1.0              
    ## [79] bit_4.0.4                   utf8_1.2.2                 
    ## [81] filelock_1.0.2              ProtGenerics_1.24.0        
    ## [83] stringi_1.7.3               parallel_4.1.0             
    ## [85] Rcpp_1.0.7                  vctrs_0.3.8                
    ## [87] png_0.1-7                   tidyselect_1.1.1           
    ## [89] dbplyr_2.1.1                xfun_0.24

</details>
