check_agg_args <- function(gene_df, 
                           non121_strategy,
                           gene_input,
                           gene_output,
                           drop_nonorths,
                           return_args=FALSE,
                           verbose=TRUE){
  
  #### Detect whether aggregation is being used ####
  opt_check <- tolower(non121_strategy)[1] %in% check_agg_opts()
  #### If so, check that all other args are compatible ####
  if(opt_check){
    ##### Check class ####
    class_check <- (methods::is(gene_df,"sparseMatrix") | 
                      methods::is(gene_df,"matrix") | 
                      methods::is(gene_df,"Matrix")) 
    if(!class_check) messager("WARNING: To aggregate gene_df,",
                              "gene_df must be a sparse or dense matrix.",
                              v=verbose)
    #### Check gene_input ####
    gene_input_check <- gene_input %in% gene_input_opts(rownames_opts = TRUE)
    if(!gene_input_check) messager("WARNING: To aggregate gene_df,",
                                   "gene_input must be 'rownames'.",
                                   v=verbose)
    #### Check gene_output ####
    gene_output_check <- gene_output %in% gene_output_opts(rownames_opts = TRUE)
    if(!gene_output_check) {
      messager("WARNING: To aggregate gene_df,",
               "gene_output must be 'rownames'.",
               "Setting gene_output='rownames'.",
               v=verbose)
      gene_output <- "rownames"
    }
    if(!drop_nonorths){
      messager("WARNING: To aggregate gene_df,",
               "drop_nonorths must be TRUE.",
               "Setting drop_nonorths=TRUE.",
               v=verbose)
      drop_nonorths <- TRUE
    }
    
    if(return_args){
      #### Return list of args ####
      return(list(non121_strategy=non121_strategy,
                  gene_input=gene_input,
                  gene_output=gene_output,
                  drop_nonorths=drop_nonorths
      ))
    }else {
      #### Check that all conditions met ####
      all_clear <- all(opt_check,class_check,
                       gene_input_check, gene_output_check)
      return(all_clear)
    }
  #### No need to assess other args if aggregation not being used ####
  } else {
    if(return_args){
      return(list(non121_strategy=non121_strategy,
                  gene_input=gene_input,
                  gene_output=gene_output,
                  drop_nonorths=drop_nonorths
                  ))
    } else {
      return(FALSE)
    } 
  } 
}