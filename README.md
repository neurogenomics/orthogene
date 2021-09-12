`orthogene`: Interspecies gene mapping
================
<img src='https://github.com/neurogenomics/orthogene/raw/main/inst/hex/orthogene.png' height='400'>
<h4>
Author: <i>Brian M. Schilder</i>
</h4>
<h4>
Most recent update: <i>Sep-12-2021</i>
</h4>

<!-- badges: start -->
<!-- badger::badge_codecov() -->
<!-- copied from MungeSumstats README.Rmd -->
<!-- badger::badge_lifecycle("stable", "green") -->
<!-- badger::badge_last_commit()  -->
<!-- badger::badge_license() -->

[![](https://codecov.io/gh/neurogenomics/orthogene/branch/main/graph/badge.svg)](https://codecov.io/gh/neurogenomics/orthogene)
[![R-CMD-check](https://github.com/neurogenomics/orthogene/workflows/R-full/badge.svg)](https://github.com/neurogenomics/orthogene/actions)
[![](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![](https://img.shields.io/github/last-commit/neurogenomics/orthogene.svg)](https://github.com/neurogenomics/orthogene/commits/main)
[![License: GPL (&gt;=
3)](https://img.shields.io/badge/license-GPL%20(%3E=%203)-blue.svg)](https://cran.r-project.org/web/licenses/GPL%20(%3E=%203))
<!-- badges: end -->

# Intro

`orthogene` is an R package for easy mapping of orthologous genes across
hundreds of species.  
It pulls up-to-date interspecies gene ortholog mappings across 700+
organisms.

It also provides various utility functions to map common objects
(e.g. data.frames, gene expression matrices, lists) onto 1:1 gene
orthologs from any other species.

In brief, `orthogene` lets you easily:

-   [**`convert_orthologs`** between any two
    species](https://neurogenomics.github.io/orthogene/articles/orthogene#convert-orthologs)
-   [**`map_species`** names onto standard taxonomic
    ontologies](https://neurogenomics.github.io/orthogene/articles/orthogene#map-species)  
-   [**`report_orthologs`** between any two
    species](https://neurogenomics.github.io/orthogene/articles/orthogene#report-orthologs)
-   [**`map_genes`** onto standard
    ontologies](https://neurogenomics.github.io/orthogene/articles/orthogene#map-genes)
-   [**`aggregate_mapped_genes`** in a
    matrix.](https://neurogenomics.github.io/orthogene/articles/orthogene#aggregate-mapped-genes)  
-   [get **`all_genes`** from any
    species](https://neurogenomics.github.io/orthogene/articles/orthogene#get-all-genes)

## [Documentation website](https://neurogenomics.github.io/orthogene/)

# Installation

``` r
if (!requireNamespace("BiocManager", quietly = TRUE))
     install.packages("BiocManager")

BiocManager::install("orthogene")
```

``` r
library(orthogene)

data("exp_mouse")
# Setting to "homologene" for the purposes of quick demonstration.
# We generally recommend using method="gprofiler" (default).
method <- "homologene"  
```

# Methods

For most functions, `orthogene` lets users choose between two different
methods, each with complementary strengths and weaknesses: `"gprofiler"`
and `"homologene"`

In general, we recommend you use `"gprofiler"` when possible, as it
tends to be more comprehensive.

It’s also worth noting that for smaller gene sets, the speed difference
between these methods becomes negligible.

|                     | gprofiler                     | homologene         |
|:--------------------|:------------------------------|:-------------------|
| Reference organisms | 700+                          | 20+                |
| Gene mappings       | More comprehensive            | Less comprehensive |
| Updates             | Frequent                      | Less frequent      |
| Orthology databases | Ensembl, HomoloGene, WormBase | HomoloGene         |
| Data location       | Remote                        | Local              |
| Internet connection | Required                      | Not required       |
| Speed               | Slower                        | Faster             |

# Quick example

## Convert orthologs

[`convert_orthologs`](https://neurogenomics.github.io/orthogene/reference/convert_orthologs.html)
is very flexible with what users can supply as `gene_df`, and can take a
`data.frame`/`data.table`/`tibble`, (sparse) `matrix`, or
`list`/`vector` containing genes.

Genes, transcripts, proteins, SNPs, or genomic ranges will be recognised
in most formats (HGNC, Ensembl, RefSeq, UniProt, etc.) and can even be a
mixture of different formats.

All genes will be mapped to gene symbols, unless specified otherwise
with the `...` arguments (see `?orthogene::convert_orthologs` or
[here](https://neurogenomics.github.io/orthogene/reference/convert_orthologs.html)
for details).

### Note on non-1:1 orthologs

A key feature of
[`convert_orthologs`](https://neurogenomics.github.io/orthogene/reference/convert_orthologs.html)
is that it handles the issue of genes with many-to-many mappings across
species. This can occur due to evolutionary divergence, and the function
of these genes tend to be less conserved and less translatable. Users
can address this using different strategies via `non121_strategy=`.

``` r
gene_df <- convert_orthologs(gene_df = exp_mouse,
                             gene_input = "rownames", 
                             gene_output = "rownames", 
                             input_species = "mouse",
                             output_species = "human",
                             non121_strategy = "drop_both_species",
                             method = method) 
```

    ## Preparing gene_df.

    ## sparseMatrix format detected.

    ## Extracting genes from rownames.

    ## Converting mouse ==> human orthologs using: homologene

    ## Using stored `gprofiler_orgs`.

    ## Mapping species name: mouse

    ## Common name mapping found for mouse

    ## 1 organism identified from search: 10090

    ## Using stored `gprofiler_orgs`.

    ## Mapping species name: human

    ## Common name mapping found for human

    ## 1 organism identified from search: 9606

    ## Checking for genes without orthologs in human.

    ## Extracting genes from input_gene.

    ## Extracting genes from ortholog_gene.

    ## Checking for genes without 1:1 orthologs.

    ## Dropping 46 genes that have multiple input_gene per ortholog_gene.

    ## Dropping 56 genes that have multiple ortholog_gene per input_gene.

    ## Filtering gene_df with gene_map

    ## Setting ortholog_gene to rownames.

    ## 
    ## =========== REPORT SUMMARY ===========

    ## Total genes dropped after convert_orthologs :
    ##    2,016 / 15,259 (13%)

    ## Total genes remaining after convert_orthologs :
    ##    13,243 / 15,259 (87%)

``` r
knitr::kable(as.matrix(head(gene_df)))
```

|          | astrocytes\_ependymal | endothelial-mural | interneurons | microglia | oligodendrocytes | pyramidal CA1 | pyramidal SS |
|:---------|----------------------:|------------------:|-------------:|----------:|-----------------:|--------------:|-------------:|
| TSPAN12  |             0.3303571 |         0.5872340 |    0.6413793 | 0.1428571 |        0.1207317 |     0.2864750 |    0.1453634 |
| TSHZ1    |             0.4285714 |         0.4468085 |    1.1551724 | 0.4387755 |        0.3621951 |     0.0692226 |    0.8320802 |
| ADAMTS15 |             0.0089286 |         0.0978723 |    0.2206897 | 0.0000000 |        0.0231707 |     0.0117146 |    0.0375940 |
| CLDN12   |             0.2232143 |         0.1148936 |    0.5517241 | 0.0510204 |        0.2609756 |     0.4376997 |    0.6842105 |
| RXFP1    |             0.0000000 |         0.0127660 |    0.2551724 | 0.0000000 |        0.0158537 |     0.0511182 |    0.0751880 |
| SEMA3C   |             0.1964286 |         0.9957447 |    8.6379310 | 0.2040816 |        0.1853659 |     0.1608094 |    0.2280702 |

`convert_orthologs` is just one of the many useful functions in
`orthogene`. Please see the [documentation
website](https://neurogenomics.github.io/orthogene/articles/orthogene)
for the full vignette.

## [Hex sticker creation](https://neurogenomics.github.io/orthogene/inst/hex/hexSticker.html)

## [Benchmarking methods](https://neurogenomics.github.io/orthogene/inst/benchmark/benchmarks.html)

# Session Info

<details>

``` r
utils::sessionInfo()
```

    ## R version 4.1.0 (2021-05-18)
    ## Platform: x86_64-apple-darwin17.0 (64-bit)
    ## Running under: macOS Big Sur 10.16
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRblas.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_GB.UTF-8/en_GB.UTF-8/en_GB.UTF-8/C/en_GB.UTF-8/en_GB.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] orthogene_0.99.2
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.7                lattice_0.20-44          
    ##  [3] tidyr_1.1.3               assertthat_0.2.1         
    ##  [5] digest_0.6.27             utf8_1.2.2               
    ##  [7] R6_2.5.1                  cellranger_1.1.0         
    ##  [9] backports_1.2.1           evaluate_0.14            
    ## [11] highr_0.9                 httr_1.4.2               
    ## [13] ggplot2_3.3.5             pillar_1.6.2             
    ## [15] rlang_0.4.11              lazyeval_0.2.2           
    ## [17] curl_4.3.2                readxl_1.3.1             
    ## [19] data.table_1.14.0         car_3.0-11               
    ## [21] Matrix_1.3-4              rmarkdown_2.10           
    ## [23] stringr_1.4.0             foreign_0.8-81           
    ## [25] htmlwidgets_1.5.3         munsell_0.5.0            
    ## [27] broom_0.7.9               compiler_4.1.0           
    ## [29] gprofiler2_0.2.1          xfun_0.25                
    ## [31] pkgconfig_2.0.3           htmltools_0.5.2          
    ## [33] tidyselect_1.1.1          tibble_3.1.4             
    ## [35] GenomeInfoDbData_1.2.6    rio_0.5.27               
    ## [37] fansi_0.5.0               viridisLite_0.4.0        
    ## [39] crayon_1.4.1              dplyr_1.0.7              
    ## [41] ggpubr_0.4.0              grid_4.1.0               
    ## [43] jsonlite_1.7.2            gtable_0.3.0             
    ## [45] lifecycle_1.0.0           DBI_1.1.1                
    ## [47] magrittr_2.0.1            scales_1.1.1             
    ## [49] zip_2.2.0                 stringi_1.7.4            
    ## [51] carData_3.0-4             ggsignif_0.6.2           
    ## [53] ellipsis_0.3.2            generics_0.1.0           
    ## [55] vctrs_0.3.8               openxlsx_4.2.4           
    ## [57] tools_4.1.0               forcats_0.5.1            
    ## [59] homologene_1.4.68.19.3.27 glue_1.4.2               
    ## [61] purrr_0.3.4               hms_1.1.0                
    ## [63] abind_1.4-5               parallel_4.1.0           
    ## [65] fastmap_1.1.0             yaml_2.2.1               
    ## [67] colorspace_2.0-2          rstatix_0.7.0            
    ## [69] plotly_4.9.4.1            knitr_1.33               
    ## [71] haven_2.4.3               patchwork_1.1.1

</details>

# Related projects

## Tools

-   [`homologene`](https://github.com/oganm/homologene): `orthogene`
    uses this package. Provides API access to NCBI
    [HomoloGene](https://www.ncbi.nlm.nih.gov/homologene) database.

-   [`gprofiler2`](https://cran.r-project.org/web/packages/gprofiler2/vignettes/gprofiler2.html):
    `orthogene` uses this package. `gprofiler2::gorth()` pulls from
    [many orthology mapping
    databases](https://biit.cs.ut.ee/gprofiler/page/organism-list).

-   [`annotationTools`](https://www.bioconductor.org/packages/release/bioc/html/annotationTools.html):
    For interspecies microarray data.

-   [`orthology`](https://www.leibniz-hki.de/en/orthology-r-package.html):
    R package for ortholog mapping (deprecated?).

-   [`hpgltools::load_biomart_orthologs()`](https://rdrr.io/github/elsayed-lab/hpgltools/man/load_biomart_orthologs.html):
    Helper function to get orthologs from biomart.

-   [`JustOrthologs`](https://github.com/ridgelab/JustOrthologs/):
    Ortholog inference from multi-species genomic sequences.

-   [`orthologr`](https://github.com/drostlab/orthologr): Ortholog
    inference from multi-species genomic sequences.

-   [`OrthoFinder`](https://github.com/davidemms/OrthoFinder): Gene
    duplication event inference from multi-species genomics.

## Databases

-   [HomoloGene](https://www.ncbi.nlm.nih.gov/homologene): NCBI database
    that the R package [homologene](https://github.com/oganm/homologene)
    pulls from.

-   [gProfiler](https://biit.cs.ut.ee/gprofiler): Web server for
    functional enrichment analysis and conversions of gene lists.

-   [OrtholoGene](http://orthologene.org/resources.html): Compiled list
    of gene orthology resources.
