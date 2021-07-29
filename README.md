<img src='./inst/hex/orthogene.png' height='400'><br>
================
<h4>
Author: <i>Brian M. Schilder</i>
</h4>
<h4>
Most recent update: <i>Jul-29-2021</i>
</h4>

## Interspecies gene mapping

`orthogene` is an R package for easy mapping of orthologous genes across
hundreds of species.

It pulls up-to-date interspecies gene ortholog mappings across 700+
organisms.

It also provides various utility functions to map common objects
(e.g. data.frames, gene expression matrices, lists) onto 1:1 gene
orthologs from any other species.

# Installation

``` r
if(!"remotes" %in% rownames(installed.packages())) install.packages("remotes")

remotes::install_github("neurogenomics/orthogene")
```

``` r
library(orthogene)
```

# Quick example

## Convert orthologs

`convert_orthologs` can take a data.frame/data.table/tibble, (sparse)
matrix, or list/vector containing genes.

Genes will be recognised in most formats (e.g. HGNC, Ensembl, UCSC) and
can even be a mixture of different formats.

All genes will be mapped to gene symbols, unless specified otherwise
with the `...` arguments.

``` r
data("exp_mouse")
gene_df <- convert_orthologs(gene_df = exp_mouse,
                             gene_col = "rownames", 
                             input_species = "mouse", 
                             genes_as_rownames = TRUE) 
```

    ## 
    ## Converting genes: mouse ===> human

    ## Preparing gene_df.

    ## Loading required package: Matrix

    ## Extracting genes from rownames.

    ## Converting mouse ==> human orthologs using homologene

    ## Mapping species name: mouse

    ## Common name mapping found for mouse

    ## 1 organism identified from search: Mus musculus

    ## Mapping species name: human

    ## Common name mapping found for human

    ## 1 organism identified from search: Homo sapiens

    ## Checking for genes without orthologs in human.

    ## Checking for genes without 1:1 orthologs.

    ## + Dropping 46 genes that have multiple input_gene per ortholog_gene.

    ## + Dropping 56 genes that have multiple ortholog_gene per input_gene.

    ## + Setting ortholog_gene col as rownames...

    ## WARNING: genes_as_rownames must be TRUE when gene_df is a matrix. Setting accordingly.

    ## Setting ortholog_gene to rownames.

    ## Genes dropped during inter-species conversion:  2,016 / 15,259 (13%)

``` r
print(head(gene_df))
```

    ## 6 x 7 sparse Matrix of class "dgCMatrix"
    ##          astrocytes_ependymal endothelial-mural interneurons  microglia
    ## TSPAN12           0.330357100        0.58723400    0.6413793 0.14285710
    ## TSHZ1             0.428571430        0.44680851    1.1551724 0.43877551
    ## ADAMTS15          0.008928571        0.09787234    0.2206897 .         
    ## CLDN12            0.223214290        0.11489362    0.5517241 0.05102041
    ## RXFP1             .                  0.01276596    0.2551724 .         
    ## SEMA3C            0.196428600        0.99574470    8.6379310 0.20408160
    ##          oligodendrocytes pyramidal CA1 pyramidal SS
    ## TSPAN12        0.12073170    0.28647500   0.14536340
    ## TSHZ1          0.36219512    0.06922258   0.83208020
    ## ADAMTS15       0.02317073    0.01171459   0.03759399
    ## CLDN12         0.26097561    0.43769968   0.68421053
    ## RXFP1          0.01585366    0.05111821   0.07518797
    ## SEMA3C         0.18536590    0.16080940   0.22807020

## Map species

`map_species` lets you standardise species names from a wide variety of
identifiers (e.g. common name, taxonomy ID, Latin name, partial match).

All exposed `orthogene` functions (including `convert_orthologs`) use
`map_species` under the hood, so you don’t have to worry about getting
species names exactly right.

``` r
species <- map_species(species = c("human",9544,"mus musculus","fruit fly","Celegans"), 
                       output_format = "scientific_name")
```

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

`ortholog_report` generates a report that tells you this information
genome-wide.

``` r
orth.zeb <- report_orthologs(target_species = "zebrafish",
                             reference_species="human") 
```

    ## Mapping species name: zebrafish

    ## Common name mapping found for zebrafish

    ## 1 organism identified from search: Danio rerio

    ## Returning all 20,897 genes from zebrafish.

    ## Mapping species name: human

    ## Common name mapping found for human

    ## 1 organism identified from search: Homo sapiens

    ## Returning all 19,129 genes from human.

    ## 
    ## Converting genes: zebrafish ===> human

    ## Preparing gene_df.

    ## Extracting genes from Gene.Symbol.

    ## Converting zebrafish ==> human orthologs using homologene

    ## Mapping species name: zebrafish

    ## Common name mapping found for zebrafish

    ## 1 organism identified from search: Danio rerio

    ## Mapping species name: human

    ## Common name mapping found for human

    ## 1 organism identified from search: Homo sapiens

    ## Checking for genes without orthologs in human.

    ## Checking for genes without 1:1 orthologs.

    ## + Dropping 47 genes that have multiple input_gene per ortholog_gene.

    ## + Dropping 2,708 genes that have multiple ortholog_gene per input_gene.

    ## Adding ortholog_gene col to gene_df.

    ## Genes dropped during inter-species conversion:  10,338 / 20,895 (49%)

    ## 
    ## 
    ## =========== REPORT SUMMARY ===========

    ## 10,556 / 20,895 (50.52%) target_species genes remain after ortholog conversion.

    ## 10,556 / 19,129 (55.18%) reference_species genes remain after ortholog conversion.

## Get all genes

You can also quickly get all known genes from the genome of a given
species.

``` r
genome_mouse <- all_genes(species="mouse")
```

    ## Mapping species name: mouse

    ## Common name mapping found for mouse

    ## 1 organism identified from search: Mus musculus

    ## Returning all 21,207 genes from mouse.

``` r
head(genome_mouse)
```

    ##    HID Gene.ID Gene.Symbol Taxonomy
    ## 6    3   11364       Acadm    10090
    ## 18   5   11370      Acadvl    10090
    ## 29   6  110446       Acat1    10090
    ## 52   7   11477       Acvr1    10090
    ## 64   9   20391        Sgca    10090
    ## 71  12   11564        Adsl    10090

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
    ## [1] Matrix_1.3-4    orthogene_0.1.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] pillar_1.6.1              compiler_4.1.0           
    ##  [3] tools_4.1.0               digest_0.6.27            
    ##  [5] lattice_0.20-44           viridisLite_0.4.0        
    ##  [7] jsonlite_1.7.2            evaluate_0.14            
    ##  [9] lifecycle_1.0.0           tibble_3.1.3             
    ## [11] gtable_0.3.0              pkgconfig_2.0.3          
    ## [13] rlang_0.4.11              DBI_1.1.1                
    ## [15] curl_4.3.2                yaml_2.2.1               
    ## [17] xfun_0.24                 httr_1.4.2               
    ## [19] dplyr_1.0.7               stringr_1.4.0            
    ## [21] knitr_1.33                htmlwidgets_1.5.3        
    ## [23] generics_0.1.0            vctrs_0.3.8              
    ## [25] grid_4.1.0                tidyselect_1.1.1         
    ## [27] glue_1.4.2                homologene_1.4.68.19.3.27
    ## [29] data.table_1.14.0         R6_2.5.0                 
    ## [31] fansi_0.5.0               plotly_4.9.4.9000        
    ## [33] rmarkdown_2.9             tidyr_1.1.3              
    ## [35] gprofiler2_0.2.0          purrr_0.3.4              
    ## [37] ggplot2_3.3.5             magrittr_2.0.1           
    ## [39] scales_1.1.1              ellipsis_0.3.2           
    ## [41] htmltools_0.5.1.1         assertthat_0.2.1         
    ## [43] colorspace_2.0-2          utf8_1.2.2               
    ## [45] stringi_1.7.3             lazyeval_0.2.2           
    ## [47] munsell_0.5.0             crayon_1.4.1

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
