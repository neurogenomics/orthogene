# orthogene  1.3.1

## New features

* `plot_orthotree`: Pass up `tree_source` arg.  

# orthogene  1.3.0

## New features  

* `aggregate_mapped_genes`: 
    - Pass up additional args from `map_genes`. 
     - Add `map_orthologs` as a way to create `gene_map` automatically,
    when `gene_map=NULL` and `input_species!=output_species`.  
    - Split `species` into `input_species` and `output_species` args.
    - Change `method` --> `agg_method`, and use `method` 
    to pass to `map_orthologs` instead. 
    - Pass up additional args from `map_orthologs`. 
    - Add link to detailed explanation of matrix aggregation/expansion
    in `many2many_rows` docs. 
    - Automatically pick best method for many:1 or many:many mapping. 
    - `as_integers`: new arg that uses `floor`.
    - Rename `FUN` to `agg_fun`.
* Add new *data* `gprofiler_namespace`. Used to validate `target=` arg 
in `gprofiler2` functions. 
* Upgraded `aggregate_mapped_genes`:
    - Can now used `gene_map` made by `map_orthologs` or `map_genes`. 
    - Can now handle many:many relationships. 
    - Will automatically pick the best method to perform aggregation and/or 
    expansion. 
* Removed internal function `aggregate_mapped_genes_twice`
* Extracted aggregation args from `non121_strategy`
and placed them in their own new own (`agg_fun`) since these options are
no longer mutually exclusive due to many:many expansion/aggregation. 
* Pass up `as_DelayedArray` 
* Bump to v1.3.0 and R >=4.2 now that we're developing on Bioc 3.16. 
* Add *ISSUE_TEMPLATE*. 
* `prepare_tree`:
    * Add `tree_source` options: path / URL / OmaDB / UCSC / timetree

## Bug fixes 

* `map_genes`: Fix report at completion.  
* Add safeguards against using aggregation when `gene_df` isn't a matrix.
* Removed `DelayedMatrixStats` *Import* (no longer needed).  
* Fix all unit tests and examples after making all updates. 
* Recognize sparse/dense matrix or delayedarray in `check_agg_args`. 

# orthogene  1.1.5

## Bug fixes

* `map_orthologs_babelgene`
    + Add "Bad credentials" check for `piggyback`. 
    + Add `use_old` as an optional arg so I can switch to more recent versions 
    of `babelgene::orthologs_df` if need be.  
    + Use updated built-in `babelgene::orthologs_df` by default.
    + Throw error if trying to map between two non-human species. 
    + Filter support==NA mappings by default, not but support>=2 
    like `babelgene` does by default (even when `babelgene::orthologs(min_support = 1)`). 
    + See here for discussion of discrepancies with babelgene maintainer: https://github.com/igordot/babelgene/issues/2 
    
## New features  

* Removed `aggregate_rows_delayedarray` as it wasn't being used and was far less efficient than the other methods anyway (which are also compatible with DelayedArray matrices anyway). * New unit tests:
    + `load_data`  
    + `aggregate_mapped_genes(method='stat')`  
    + `sparsity`  
    + `infer_species`


# orthogene  1.1.4

## Bug fixes

- Remove `source_all` as it included a `library` call. 

# orthogene  1.1.3

## New features  

* Update GHA

## Bug fixes

* Fix failing benchmarking tests.

# orthogene  1.1.2

## Bug fixes  

* `convert_orthologs(method="babelgene")` now gets gene mappings
from `all_genes_babelgene` instead `babelgene::orthologs` (which doesn't seem to work very well, despite being dedicated for this purpose).   
* `map_species`: 
    + Avoid running this function redundantly when nested in multiple layers of other functions. 
    + `common_species_names_dict` now return "scientific_name" by default, instead of "taxonomy_id" 
    + Match `map_species` method to whatever method is being used in the function it's wrapped within, to avoid dropping species due to naming differences.  
    + Add "id" column (e.g. "celegans") to all org databases to enhance their searchability. 
    + Add `map_species_check_args`. 
* Ensure proper method-specific `output_format` when passing species to other functions. 
    
## New features    

* `plot_orthotree`: Automated plotting of phylogenetic trees with 1:1 ortholog report annotations. Includes several subfunctions: 
    + `prepare_tree` (exported): Read, prune and  standardise a phylogenetic tree. 
    + `gather_images` (internal): More robust way to find and import valid phylopic silhouettes. Will make PR requests to `rphylopic` and `ggimage`/`ggtree` to include this functionality. 
* Added unit tests for `report_orthologs`, especially when `method="babelgene"`.  
* GitHub Actions: 
    + Merge both GHA workflows into one, as implemented in [`templateR`](https://github.com/neurogenomics/templateR).  
* Added citation info to README. 
* Save `all_genes_babelgene` ortholog data to orthogene-specific cache instead of tempdir to avoid re-downloading every R session. 


# orthogene  1.1.1

## Bug fixes  

* Made GHA less dependent on hard-coded R/bioc versions. 

# orthogene  1.1.0

## New features    

* Now on [Bioconductor release 3.14](https://bioconductor.org/packages/devel/bioc/html/orthogene.html).  
* Docker containers automatically built and pushed to [DockerHub](https://hub.docker.com/repository/docker/bschilder/orthogene) via 
[GitHub Actions](https://github.com/neurogenomics/orthogene/blob/main/.github/workflows/dockerhub.yml).  
* [Dockerfile](https://github.com/neurogenomics/orthogene/blob/ad0b5e015805d1f154ec4ef93dd33821e68e580a/Dockerfile) 
provided to build and check any R package efficiently with [AnVil](https://bioconductor.org/packages/release/bioc/html/AnVIL.html).  
* CRAN checks and Bioc checks run via [GitHub Actions](https://github.com/neurogenomics/orthogene/blob/main/.github/workflows/check-bioc-docker.yml).  
* Added documentation on using Docker container to README.  
* Documentation website now automatically built via [GitHub Actions](https://github.com/neurogenomics/orthogene/blob/main/.github/workflows/check-bioc-docker.yml).   
* Code coverage tests now automatically run and uploaded via [GitHub Actions](https://github.com/neurogenomics/orthogene/blob/main/.github/workflows/check-bioc-docker.yml).   

# orthogene  0.99.9

## New features    

* Replaced R-CMD GHA with bioc-check GHA.
* Added new badges.

## Bug fixes  

* Adjusted vignette yamls to make resulting htmls smaller.  

# orthogene  0.99.8

## New features    

* `orthogene` now supports `DelayedArray` objects as `gene_df` input.  
* `create_background` now uses `all_genes` when all 3 species are the same.  

# orthogene  0.99.7

## New features    

* Added new function `create_background`.  
* Added new function `infer_species`.  
* `report_orthologs` and `convert_orthologs` can now handle cases where
`input_species` is the same as `output_species`. 
* Add internal function `get_all_orgs` to easily list all organisms from 
different packages.  
* Added `all_genes` method "babelgene". 

## Bug fixes

* `report_orthologs` no longer throws error due to not finding `tar_genes`.

# orthogene  0.99.6

## Bug fixes

* Allow all messages to be suppressed in `report_orthologs`.  

# orthogene  0.99.3

## New features  

* License switched to GPL-3 (to be compliant with Bioc).  
* New method "babelgene" added to `convert_orthologs`.

# orthogene  0.99.2

## New features    

* License switched to GPL3 (>=3).

## Bug fixes

* `GenomeInfoDbData` now required.

# orthogene  0.1.0

## New features  

* `orthogene` released to Bioconductor.

