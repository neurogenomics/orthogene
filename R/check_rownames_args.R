check_rownames_args <- function(gene_output,
                                drop_nonorths,
                                non121_strategy,
                                verbose=TRUE){
  # When gene_output="rownames", 
  # check that other args are compatible
  if(tolower(gene_output) %in% gene_output_opts(rownames_opts = TRUE)){
    if(drop_nonorths==FALSE){
      messager("WARNING:",
               "In order to set gene_output='rownames'",
               "must set drop_nonorths=TRUE.\n",
               "Setting drop_nonorths=TRUE.",
               v=verbose)
      drop_nonorths <- TRUE
    }
    if(!(non121_strategy_opts(non121_strategy = non121_strategy)=="dbs")){
      messager("WARNING:",
               "In order to set gene_output='rownames'",
               "must set non121_strategy='drop_both_species'.\n",
               "Setting non121_strategy='drop_both_species'.",
               v=verbose)
      non121_strategy <- "dbs"
    }
  } 
  return(list(gene_output=gene_output,
              drop_nonorths=drop_nonorths,
              non121_strategy=non121_strategy
              ))
}