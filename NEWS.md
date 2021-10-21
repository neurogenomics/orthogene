## CHANGES IN VERSION  0.99.7

### New Features

* `orthogene` now supports `DelayedArray` objects as `gene_df` input.

## CHANGES IN VERSION  0.99.7

### New Features

* Added new function `create_background`.  
* Added new function `infer_species`.  
* `report_orthologs` and `convert_orthologs` can now handle cases where
`input_species` is the same as `output_species`. 
* Add internal function `get_all_orgs` to easily list all organisms from 
different packages.  
* Added `all_genes` method "babelgene". 

### Fixes

* `report_orthologs` no longer throws error due to not finding `tar_genes`.


## CHANGES IN VERSION  0.99.6

### Fixes

* Allow all messages to be suppressed in `report_orthologs`.  


## CHANGES IN VERSION  0.99.3

### New Features

* License switched to GPL-3 (to be compliant with Bioc).  
* New method "babelgene" added to `convert_orthologs`.


## CHANGES IN VERSION  0.99.2

* License switched to GPL3 (>=3).

### Fixes

* `GenomeInfoDbData` now required.


## CHANGES IN VERSION  0.1.0

### New Features

* `orthogene` released to Bioconductor.

