# orthogene  1.1.2

BUG FIXES  

* `convert_orthologs(method="babelgene")` now gets gene mappings
from `all_genes_babelgene` instead `babelgene::orthologs` (which doesn't seem to work very well, despite being dedicated for this purpose).   
* `map_species`: 
    + Avoid running this function redundantly when nested in multiple layers of other functions. 
    + `common_species_names_dict` now return "scientific_name" by default, instead of "taxonomy_id" 
    + Match `map_species` method to whatever method is being used in the function it's wrapped within, to avoid dropping species due to naming differences.  
    + Add "id" column (e.g. "celegans") to all org databases to enhance their searchability. 
    + Add `map_species_check_args`. 
    
NEW FEATURES  

* `plot_orthotree`: Automated plotting of phylogenetic trees with 1:1 ortholog report annotations. Includes several subfunctions: 
    + `prepare_tree` (exported): Read, prune and  standardise a phylogenetic tree. 
    + `gather_images` (internal): More robust way to find and import valid phylopic silhouettes. Will make PR requests to `rphylopic` and `ggimage`/`ggtree` to include this functionality. 
* Added unit tests for `report_orthologs`, especially when `method="babelgene"`.  
* GitHub Actions: 
    + Merge both GHA workflows into one, as implemented in [`templateR`](https://github.com/neurogenomics/templateR).  


# orthogene  1.1.1

BUG FIXES  

* Made GHA less dependent on hard-coded R/bioc versions. 

# orthogene  1.1.0

NEW FEATURES  

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

NEW FEATURES  

* Replaced R-CMD GHA with bioc-check GHA.
* Added new badges.

BUG FIXES  

* Adjusted vignette yamls to make resulting htmls smaller.  

# orthogene  0.99.8

NEW FEATURES  

* `orthogene` now supports `DelayedArray` objects as `gene_df` input.  
* `create_background` now uses `all_genes` when all 3 species are the same.  

# orthogene  0.99.7

NEW FEATURES  

* Added new function `create_background`.  
* Added new function `infer_species`.  
* `report_orthologs` and `convert_orthologs` can now handle cases where
`input_species` is the same as `output_species`. 
* Add internal function `get_all_orgs` to easily list all organisms from 
different packages.  
* Added `all_genes` method "babelgene". 

BUG FIXES

* `report_orthologs` no longer throws error due to not finding `tar_genes`.

# orthogene  0.99.6

BUG FIXES

* Allow all messages to be suppressed in `report_orthologs`.  

# orthogene  0.99.3

NEW FEATURES

* License switched to GPL-3 (to be compliant with Bioc).  
* New method "babelgene" added to `convert_orthologs`.

# orthogene  0.99.2

NEW FEATURES  

* License switched to GPL3 (>=3).

BUG FIXES

* `GenomeInfoDbData` now required.

# orthogene  0.1.0

NEW FEATURES

* `orthogene` released to Bioconductor.

