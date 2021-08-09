<img src='./inst/hex/orthogene.png' height='400'><br>
================
<h4>
Author: <i>Brian M. Schilder</i>
</h4>
<h4>
Most recent update: <i>Aug-09-2021</i>
</h4>

<!-- badges: start -->
<!-- badger::badge_codecov() -->
<!-- copied from MungeSumstats README.Rmd -->
<!-- badger::badge_lifecycle("stable", "green") -->
<!-- badger::badge_last_commit()  -->
<!-- badger::badge_license() -->

[![](https://codecov.io/gh/neurogenomics/orthogene/branch/main/graph/badge.svg)](https://codecov.io/gh/neurogenomics/orthogene)
[![R-CMD-check](https://github.com/neurogenomics/MungeSumstats/workflows/R-full/badge.svg)](https://github.com/neurogenomics/MungeSumstats/actions)
[![](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![](https://img.shields.io/github/last-commit/neurogenomics/orthogene.svg)](https://github.com/neurogenomics/orthogene/commits/main)
[![License:
Artistic-2.0](https://img.shields.io/badge/license-Artistic--2.0-blue.svg)](https://cran.r-project.org/web/licenses/Artistic-2.0)
<!-- badges: end -->

## `orthogene`: Interspecies gene mapping

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
-   [**`map_species`** names onto standard taxonomic
    ontologies](https://github.com/neurogenomics/orthogene#map-species)  
-   [**`report_orthologs`** between any two
    species](https://github.com/neurogenomics/orthogene#report-orthologs)
-   [**`map_genes`** onto standard
    ontologies](https://github.com/neurogenomics/orthogene#map-genes)
-   [**`aggregate_mapped_genes`** in a
    matrix.](https://github.com/neurogenomics/orthogene#aggregate-mapped-genes)  
-   [get **`all_genes`** from any
    species](https://github.com/neurogenomics/orthogene#get-all-genes)

## [Documentation website](https://neurogenomics.github.io/orthogene/)

# Installation

``` r
if(!"remotes" %in% rownames(installed.packages())) install.packages("remotes")

remotes::install_github("neurogenomics/orthogene")
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

# Quick examples

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
of these genes tends to be less conserved and less translatable. Users
can address this using different strategies via `non121_strategy=`:

1.  `"drop_both_species"` : Drop genes that have duplicate mappings in
    either the input\_species or output\_species, (*DEFAULT*).
2.  `"drop_input_species"` : Only drop genes that have duplicate
    mappings in `input_species`.  
3.  `"drop_output_species"` : Only drop genes that have duplicate
    mappings in the `output_species`.
4.  `"keep_both_species"` : Keep all genes regardless of whether they
    have duplicate mappings in either species.  
5.  `"keep_popular"` : Return only the most “popular” interspecies
    ortholog mappings. This procedure tends to yield a greater number of
    returned genes but at the cost of many of them not being true
    biological 1:1 orthologs.
6.  `"sum"`,`"mean"`,`"median"`,`"min"` or `"max"`: When `gene_df` is a
    matrix and `gene_output="rownames"`, these options will aggregate
    many-to-one gene mappings (`input_species`-to-`output_species`)
    after dropping any duplicate genes in the `output_species`.

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

``` r
knitr::kable(head(orth_zeb$map))
```

|     | HID | Gene.ID | Gene.Symbol | Taxonomy | input\_gene | ortholog\_gene |
|:----|----:|--------:|:------------|---------:|:------------|:---------------|
| 8   |   3 |  406283 | acadm       |     7955 | acadm       | ACADM          |
| 20  |   5 |  573723 | acadvl      |     7955 | acadvl      | ACADVL         |
| 32  |   6 |  445290 | acat1       |     7955 | acat1       | ACAT1          |
| 55  |   7 |   30615 | acvr1l      |     7955 | acvr1l      | ACVR1          |
| 74  |  12 |  334431 | adsl        |     7955 | adsl        | ADSL           |
| 92  |  13 |  566517 | aga         |     7955 | aga         | AGA            |

``` r
knitr::kable(orth_zeb$report)
```

| target\_species | target\_total\_genes | reference\_species | reference\_total\_genes | one2one\_orthologs | target\_percent | reference\_percent |
|:----------------|---------------------:|:-------------------|------------------------:|-------------------:|----------------:|-------------------:|
| zebrafish       |                20895 | human              |                   19129 |              10556 |           50.52 |              55.18 |

## Map genes

[`map_genes`](https://neurogenomics.github.io/orthogene/reference/map_genes.html)
finds matching *within-species* synonyms across a wide variety of gene
naming conventions (HGNC, Ensembl, RefSeq, UniProt, etc.) and returns a
table with standardised gene symbols (or whatever output format you
prefer).

``` r
genes <-  c("Klf4", "Sox2", "TSPAN12","NM_173007","Q8BKT6",9999,
             "ENSMUSG00000012396","ENSMUSG00000074637")
mapped_genes <- map_genes(genes = genes,
                          species = "mouse", 
                          drop_na = FALSE)
```

    ## Using stored `gprofiler_orgs`.

    ## Mapping species name: mouse

    ## Common name mapping found for mouse

    ## 1 organism identified from search: mmusculus

    ## 8 / 8 (100%) genes mapped.

``` r
knitr::kable(head(mapped_genes))
```

| input\_number | input      | target\_number | target             | name    | description                                                              | namespace                              |
|--------------:|:-----------|:---------------|:-------------------|:--------|:-------------------------------------------------------------------------|:---------------------------------------|
|             1 | Klf4       | 1.1            | ENSMUSG00000003032 | Klf4    | Kruppel-like factor 4 (gut) \[Source:MGI Symbol;Acc:MGI:1342287\]        | ENTREZGENE,MGI,UNIPROT\_GN,WIKIGENE    |
|             2 | Sox2       | 2.1            | ENSMUSG00000074637 | Sox2    | SRY (sex determining region Y)-box 2 \[Source:MGI Symbol;Acc:MGI:98364\] | ENTREZGENE,MGI,UNIPROT\_GN,WIKIGENE    |
|             3 | TSPAN12    | 3.1            | ENSMUSG00000029669 | Tspan12 | tetraspanin 12 \[Source:MGI Symbol;Acc:MGI:1889818\]                     | ENTREZGENE,MGI,UNIPROT\_GN,WIKIGENE    |
|             4 | NM\_173007 | 4.1            | ENSMUSG00000029669 | Tspan12 | tetraspanin 12 \[Source:MGI Symbol;Acc:MGI:1889818\]                     | REFSEQ\_MRNA\_ACC                      |
|             5 | Q8BKT6     | 5.1            | ENSMUSG00000029669 | Tspan12 | tetraspanin 12 \[Source:MGI Symbol;Acc:MGI:1889818\]                     | UNIPROTSWISSPROT\_ACC,UNIPROT\_GN\_ACC |
|             6 | 9999       | 6.1            | nan                | nan     | nan                                                                      |                                        |

## Aggregate genes

`aggregate_mapped_genes` does the following:

1.  Uses `map_genes` to identify *within-species* many-to-one gene
    mappings (e.g. Ensembl transcript IDs ==&gt; gene symbols). Can also
    map *across species* if output from `map_orthologs` is supplied to
    `gene_map` argument (and `gene_map_col="ortholog_gene"`).  
2.  Drops all non-mappable genes.  
3.  Aggregates the values of matrix `X` using
    `"sum"`,`"mean"`,`"median"`,`"min"` or `"max"`.

Note, this only works when the input data (`X`) is a sparse or dense
matrix, and the genes are row names.

``` r
data("exp_mouse_enst")
knitr::kable(tail(as.matrix(exp_mouse_enst)))
```

|                    | astrocytes\_ependymal | endothelial-mural | interneurons | microglia | oligodendrocytes | pyramidal CA1 | pyramidal SS |
|:-------------------|----------------------:|------------------:|-------------:|----------:|-----------------:|--------------:|-------------:|
| ENSMUST00000102875 |             2.8258910 |         0.4041560 |    1.3171987 | 0.3774840 |        1.3426606 |     1.0403481 |    1.0876508 |
| ENSMUST00000133343 |             2.8259032 |         0.4042189 |    1.3171312 | 0.3774038 |        1.3425772 |     1.0403432 |    1.0876385 |
| ENSMUST00000143890 |             2.8258554 |         0.4041963 |    1.3171145 | 0.3774192 |        1.3426119 |     1.0403496 |    1.0876334 |
| ENSMUST00000005053 |             0.4597978 |         0.3403299 |    0.9067953 | 0.2958589 |        0.7254482 |     0.4813420 |    0.7418000 |
| ENSMUST00000185896 |             0.4596631 |         0.3403637 |    0.9067538 | 0.2958896 |        0.7255006 |     0.4812783 |    0.7417918 |
| ENSMUST00000188282 |             0.4597399 |         0.3403441 |    0.9067727 | 0.2957819 |        0.7255681 |     0.4811978 |    0.7417924 |

``` r
exp_agg <- aggregate_mapped_genes(gene_df=exp_mouse_enst,
                                  species="mouse",
                                  FUN = "sum")
```

    ## Using stored `gprofiler_orgs`.

    ## Mapping species name: mouse

    ## Common name mapping found for mouse

    ## 1 organism identified from search: mmusculus

    ## 482 / 482 (100%) genes mapped.

    ## Aggregating rows using: monocle3

    ## Matrix aggregated:
    ##   - Input: 482 x 7 
    ##   - Output: 92 x 7

``` r
knitr::kable(tail(as.matrix(exp_agg)))
```

|         | astrocytes\_ependymal | endothelial-mural | interneurons | microglia | oligodendrocytes | pyramidal CA1 | pyramidal SS |
|:--------|----------------------:|------------------:|-------------:|----------:|-----------------:|--------------:|-------------:|
| Tshz1   |              1.713936 |         1.7869498 |     4.620366 | 1.7545487 |        1.4483505 |     0.2764327 |    3.3280256 |
| Tspan12 |              1.981594 |         3.5228954 |     3.847706 | 0.8565873 |        0.7237384 |     1.7184690 |    0.8716624 |
| Ugp2    |             11.303434 |         1.6167531 |     5.268556 | 1.5096830 |        5.3705113 |     4.1614945 |    4.3505804 |
| Usp28   |              1.561545 |         1.4885072 |    12.481956 | 0.9176950 |        1.0237324 |     5.5261972 |    6.4652509 |
| Vat1l   |              0.178117 |         0.0337314 |     1.199619 | 0.0812187 |        0.1165772 |     0.2339571 |    0.4006268 |
| Wtap    |              2.691383 |         2.4118074 |    12.289111 | 3.5809075 |        3.2808114 |     9.3443456 |    8.6384533 |

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
    ## [13] highr_0.9                 pillar_1.6.2             
    ## [15] rlang_0.4.11              lazyeval_0.2.2           
    ## [17] curl_4.3.2                readxl_1.3.1             
    ## [19] data.table_1.14.0         car_3.0-11               
    ## [21] Matrix_1.3-4              grr_0.9.5                
    ## [23] rmarkdown_2.9             stringr_1.4.0            
    ## [25] foreign_0.8-81            htmlwidgets_1.5.3        
    ## [27] RCurl_1.98-1.3            munsell_0.5.0            
    ## [29] broom_0.7.9               compiler_4.1.0           
    ## [31] gprofiler2_0.2.0          xfun_0.24                
    ## [33] pkgconfig_2.0.3           htmltools_0.5.1.1        
    ## [35] tidyselect_1.1.1          tibble_3.1.3             
    ## [37] rio_0.5.27                fansi_0.5.0              
    ## [39] viridisLite_0.4.0         crayon_1.4.1             
    ## [41] dplyr_1.0.7               ggpubr_0.4.0             
    ## [43] Matrix.utils_0.9.8        bitops_1.0-7             
    ## [45] grid_4.1.0                jsonlite_1.7.2           
    ## [47] gtable_0.3.0              lifecycle_1.0.0          
    ## [49] DBI_1.1.1                 magrittr_2.0.1           
    ## [51] scales_1.1.1              zip_2.2.0                
    ## [53] stringi_1.7.3             carData_3.0-4            
    ## [55] ggsignif_0.6.2            ellipsis_0.3.2           
    ## [57] generics_0.1.0            vctrs_0.3.8              
    ## [59] openxlsx_4.2.4            tools_4.1.0              
    ## [61] forcats_0.5.1             homologene_1.4.68.19.3.27
    ## [63] glue_1.4.2                purrr_0.3.4              
    ## [65] hms_1.1.0                 abind_1.4-5              
    ## [67] parallel_4.1.0            yaml_2.2.1               
    ## [69] colorspace_2.0-2          rstatix_0.7.0            
    ## [71] plotly_4.9.4.9000         knitr_1.33               
    ## [73] haven_2.4.3               patchwork_1.1.1

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
