<img src='./inst/hex/orthogene.png' height='400'><br>
================
<h4>
Author: <i>Brian M. Schilder</i>
</h4>
<h4>
Most recent update: <i>Jul-31-2021</i>
</h4>

<!-- badges: start -->

<row> <!-- badger::badge_codecov() -->
[![](https://codecov.io/gh/neurogenomics/orthogene/branch/main/graph/badge.svg)](https://codecov.io/gh/neurogenomics/orthogene)

<!-- badger::badge_cran_checks() -->

[![CRAN
checks](https://cranchecks.info/badges/summary/orthogene)](https://cran.r-project.org/web/checks/check_results_orthogene.html)

<!-- badger::badge_lifecycle("stable", "green") -->

[![](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)

<!-- badger::badge_license() -->

[![License:
Artistic-2.0](https://img.shields.io/badge/license-Artistic--2.0-blue.svg)](https://cran.r-project.org/web/licenses/Artistic-2.0)

<!-- badger::badge_last_commit()  -->

[![](https://img.shields.io/github/last-commit/neurogenomics/orthogene.svg)](https://github.com/neurogenomics/orthogene/commits/main)

</row> <!-- badges: end -->

## Interspecies gene mapping

`orthogene` is an R package for easy mapping of orthologous genes across
hundreds of species.  
It pulls up-to-date interspecies gene ortholog mappings across 700+
organisms.

It also provides various utility functions to map common objects
(e.g. data.frames, gene expression matrices, lists) onto 1:1 gene
orthologs from any other species.

In brief, `orthogene` lets you easily:

-   [**`convert_orthologs`** between any two
    species](https://github.com/neurogenomics/orthogene#convert-orthologs)
-   [**`map_species`** onto standard
    ontologies](https://github.com/neurogenomics/orthogene#map-species)  
-   [**`report_orthologs`** between any two
    species](https://github.com/neurogenomics/orthogene#report-orthologs)
-   [**`map_genes`** onto standard ontologies]()
-   [get **`all_genes`** from any species](all_genes)

## [Documentation website](https://neurogenomics.github.io/orthogene/)

# Installation

``` r
if(!"remotes" %in% rownames(installed.packages())) install.packages("remotes")

remotes::install_github("neurogenomics/orthogene")
```

``` r
library(orthogene)

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

# Quick examples

## Convert orthologs

[`convert_orthologs`](https://neurogenomics.github.io/orthogene/reference/convert_orthologs.html)
is very flexible with what users can supply as `gene_df`, and can take a
`data.frame`/`data.table`/`tibble`, (sparse) `matrix`, or
`list`/`vector` containing genes.

Genes will be recognised in most formats (e.g. HGNC, Ensembl, UCSC) and
can even be a mixture of different formats.

All genes will be mapped to gene symbols, unless specified otherwise
with the `...` arguments (see `?orthogene::convert_orthologs` or
[here](https://neurogenomics.github.io/orthogene/reference/convert_orthologs.html)
for details).

``` r
data("exp_mouse")
gene_df <- convert_orthologs(gene_df = exp_mouse,
                             gene_input = "rownames", 
                             gene_output = "rownames", 
                             input_species = "mouse",
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

## Map species

[`map_species`](https://neurogenomics.github.io/orthogene/reference/map_species.html)
lets you standardise species names from a wide variety of identifiers
(e.g. common name, taxonomy ID, Latin name, partial match).

All exposed `orthogene` functions (including
[`convert_orthologs`](https://neurogenomics.github.io/orthogene/reference/convert_orthologs.html))
use `map_species` under the hood, so you don’t have to worry about
getting species names exactly right.

You can check the full list of available species by simply running
`map_species()` with no arguments, or checking
[here](https://biit.cs.ut.ee/gprofiler/page/organism-list).

``` r
species <- map_species(species = c("human",9544,"mus musculus",
                                   "fruit fly","Celegans"), 
                       output_format = "scientific_name")
```

    ## Using stored `gprofiler_orgs`.

    ## Mapping species name: human

    ## Common name mapping found for human

    ## 1 organism identified from search: Homo sapiens

    ## Mapping species name: 9544

    ## 1 organism identified from search: Macaca mulatta

    ## Mapping species name: mus musculus

    ## 1 organism identified from search: Mus musculus

    ## Mapping species name: fruit fly

    ## Common name mapping found for fruit fly

    ## 1 organism identified from search: Drosophila melanogaster

    ## Mapping species name: Celegans

    ## 1 organism identified from search: Caenorhabditis elegans

``` r
print(species)
```

    ##                     human                      9544              mus musculus 
    ##            "Homo sapiens"          "Macaca mulatta"            "Mus musculus" 
    ##                 fruit fly                  Celegans 
    ## "Drosophila melanogaster"  "Caenorhabditis elegans"

## Report orthologs

It may be helpful to know the maximum expected number of orthologous
gene mappings from one species to another.

[`ortholog_report`](https://neurogenomics.github.io/orthogene/reference/report_orthologs.html)
generates a report that tells you this information genome-wide.

``` r
orth_zeb <- report_orthologs(target_species = "zebrafish",
                             reference_species = "human",
                             method_all_genes = method,
                             method_convert_orthologs = method) 
```

    ## Retrieving all genes using: homologene.

    ## Using stored `gprofiler_orgs`.

    ## Mapping species name: zebrafish

    ## Common name mapping found for zebrafish

    ## 1 organism identified from search: 7955

    ## Gene table with 20897 rows retrieved.

    ## Extracting genes from Gene.Symbol.

    ## Returning all 20,897 genes from zebrafish.

    ## Retrieving all genes using: homologene.

    ## Using stored `gprofiler_orgs`.

    ## Mapping species name: human

    ## Common name mapping found for human

    ## 1 organism identified from search: 9606

    ## Gene table with 19129 rows retrieved.

    ## Extracting genes from Gene.Symbol.

    ## Returning all 19,129 genes from human.

    ## Preparing gene_df.

    ## data.frame format detected.

    ## Extracting genes from Gene.Symbol.

    ## Converting zebrafish ==> human orthologs using: homologene

    ## Using stored `gprofiler_orgs`.

    ## Mapping species name: zebrafish

    ## Common name mapping found for zebrafish

    ## 1 organism identified from search: 7955

    ## Using stored `gprofiler_orgs`.

    ## Mapping species name: human

    ## Common name mapping found for human

    ## 1 organism identified from search: 9606

    ## Checking for genes without orthologs in human.

    ## Extracting genes from input_gene.

    ## Extracting genes from ortholog_gene.

    ## Checking for genes without 1:1 orthologs.

    ## Dropping 47 genes that have multiple input_gene per ortholog_gene.

    ## Dropping 2,708 genes that have multiple ortholog_gene per input_gene.

    ## Filtering gene_df with gene_map

    ## Adding input_gene col to gene_df.

    ## Adding ortholog_gene col to gene_df.

    ## 
    ## =========== REPORT SUMMARY ===========

    ## Total genes dropped after convert_orthologs :
    ##    10,338 / 20,895 (49%)

    ## Total genes remaining after convert_orthologs :
    ##    10,557 / 20,895 (51%)

    ## 
    ## =========== REPORT SUMMARY ===========

    ## 10,556 / 20,895 (50.52%) target_species genes remain after ortholog conversion.

    ## 10,556 / 19,129 (55.18%) reference_species genes remain after ortholog conversion.

## Map genes

[`map_genes`](https://neurogenomics.github.io/orthogene/reference/map_genes.html)
finds matching *within-species* synonyms across a wide variety of gene
naming conventions (e.g. HGNC symbols, ENSEMBL IDs, UCSC) and returns a
table with standardised gene symbols (or whatever output format you
prefer).

``` r
mapped_genes <- map_genes(genes=rownames(exp_mouse),
                          species="mouse")
```

    ## Using stored `gprofiler_orgs`.

    ## Mapping species name: mouse

    ## Common name mapping found for mouse

    ## 1 organism identified from search: mmusculus

    ## 15,259 / 15,397 (100.9%) genes mapped.

## Get all genes

You can also quickly get all known genes from the genome of a given
species with
[`all_genes`](https://neurogenomics.github.io/orthogene/reference/all_genes.html).

``` r
genome_mouse <- all_genes(species = "mouse", 
                          method = method)
```

    ## Retrieving all genes using: homologene.

    ## Using stored `gprofiler_orgs`.

    ## Mapping species name: mouse

    ## Common name mapping found for mouse

    ## 1 organism identified from search: 10090

    ## Gene table with 21207 rows retrieved.

    ## Extracting genes from Gene.Symbol.

    ## Returning all 21,207 genes from mouse.

``` r
knitr::kable(head(genome_mouse))
```

|     | HID | Gene.ID | Gene.Symbol | Taxonomy |
|:----|----:|--------:|:------------|---------:|
| 6   |   3 |   11364 | Acadm       |    10090 |
| 18  |   5 |   11370 | Acadvl      |    10090 |
| 29  |   6 |  110446 | Acat1       |    10090 |
| 52  |   7 |   11477 | Acvr1       |    10090 |
| 64  |   9 |   20391 | Sgca        |    10090 |
| 71  |  12 |   11564 | Adsl        |    10090 |

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
    ##  [1] Rcpp_1.0.7                lattice_0.20-44          
    ##  [3] tidyr_1.1.3               assertthat_0.2.1         
    ##  [5] digest_0.6.27             utf8_1.2.2               
    ##  [7] R6_2.5.0                  cellranger_1.1.0         
    ##  [9] backports_1.2.1           evaluate_0.14            
    ## [11] httr_1.4.2                ggplot2_3.3.5            
    ## [13] highr_0.9                 pillar_1.6.1             
    ## [15] rlang_0.4.11              lazyeval_0.2.2           
    ## [17] curl_4.3.2                readxl_1.3.1             
    ## [19] data.table_1.14.0         car_3.0-11               
    ## [21] Matrix_1.3-4              rmarkdown_2.9            
    ## [23] stringr_1.4.0             foreign_0.8-81           
    ## [25] htmlwidgets_1.5.3         RCurl_1.98-1.3           
    ## [27] munsell_0.5.0             broom_0.7.8              
    ## [29] compiler_4.1.0            gprofiler2_0.2.0         
    ## [31] xfun_0.24                 pkgconfig_2.0.3          
    ## [33] htmltools_0.5.1.1         tidyselect_1.1.1         
    ## [35] tibble_3.1.3              rio_0.5.27               
    ## [37] fansi_0.5.0               viridisLite_0.4.0        
    ## [39] crayon_1.4.1              dplyr_1.0.7              
    ## [41] ggpubr_0.4.0              bitops_1.0-7             
    ## [43] grid_4.1.0                jsonlite_1.7.2           
    ## [45] gtable_0.3.0              lifecycle_1.0.0          
    ## [47] DBI_1.1.1                 magrittr_2.0.1           
    ## [49] scales_1.1.1              zip_2.2.0                
    ## [51] stringi_1.7.3             carData_3.0-4            
    ## [53] ggsignif_0.6.2            ellipsis_0.3.2           
    ## [55] generics_0.1.0            vctrs_0.3.8              
    ## [57] openxlsx_4.2.4            tools_4.1.0              
    ## [59] forcats_0.5.1             homologene_1.4.68.19.3.27
    ## [61] glue_1.4.2                purrr_0.3.4              
    ## [63] hms_1.1.0                 abind_1.4-5              
    ## [65] parallel_4.1.0            yaml_2.2.1               
    ## [67] colorspace_2.0-2          rstatix_0.7.0            
    ## [69] plotly_4.9.4.9000         knitr_1.33               
    ## [71] haven_2.4.1               patchwork_1.1.1

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
