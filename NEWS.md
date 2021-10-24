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

* License switched to GPL3 (>=3).

BUG FIXES

* `GenomeInfoDbData` now required.


# orthogene  0.1.0

NEW FEATURES

* `orthogene` released to Bioconductor.

