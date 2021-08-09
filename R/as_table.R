as_table <- function(gene_input,
                     gene_output,
                     gene_df2,
                     genes2,
                     gene_map,
                     standardise_genes,
                     drop_nonorths,
                     non121_strategy,
                     sort_rows,
                     as_sparse,
                     verbose=TRUE){ 
  
  #### Create input dictionary ####
  input_dict <- stats::setNames(gene_map$input_gene, 
                                gene_map$input_gene)
  #### Create ortholog dictionary ####
  orth_dict <- stats::setNames(gene_map$ortholog_gene, 
                               gene_map$input_gene)
  #### Check matrices ####
  # When gene_df2, try to keep as a sparseMatrix
  # bc making it a dense matrix/data.frame could lead to memory issues
  # if the data is large.
  if((is_sparse_matrix(gene_df2)) & 
     (c(gene_output =="columns")) ){
    messager("WARNING:",
             "Must set gene_output to 'rownames','colnames','dict' or 'dict_rev'",
             "when gene_df is a sparseMatrix.",
             "Setting gene_output to",paste0("'",gene_input,"'."),
             v=verbose)
    gene_output <- gene_input
  }
  # If the matrix is already dense, just convert to data.frame 
  if((methods::is(gene_df2,"matrix") | methods::is(gene_df2,"Matrix")) &
     (!is_sparse_matrix(gene_df2)) &
     (c(gene_output =="columns")) ){
    messager("WARNING:",
             "Will convert gene_df from dense matrix to data.frame",
             "when gene_output='columns'.",
             v=verbose)
    gene_df2 <- data.frame(gene_df2, 
                           check.names = FALSE, 
                           stringsAsFactors = FALSE)
  } 
  
  #### Aggregate matrix ####
  # You don't need to rename rownames if you aggregate 
  # bc this is done by aggregate_mapped_genes.
  if(check_agg_args(gene_df = gene_df2, 
                    non121_strategy = non121_strategy,
                    gene_input = gene_input,
                    gene_output = gene_output,
                    drop_nonorths = drop_nonorths,
                    verbose = verbose)){ 
    gene_df2 <- aggregate_mapped_genes(gene_df = gene_df2, 
                                       FUN = non121_strategy, 
                                       gene_map = gene_map,
                                       gene_map_col = "input_gene",
                                       verbose = verbose)  
     gene_df2 <- aggregate_mapped_genes(gene_df = gene_df2, 
                                       FUN = non121_strategy, 
                                       gene_map = gene_map,
                                       gene_map_col = "ortholog_gene",
                                       verbose = verbose)  
    gene_output <- "rownames"
  } else {
    #### Add genes as rownames ####
    if(gene_output %in% gene_output_opts(rownames_opts = TRUE)){
      messager("Setting ortholog_gene to rownames.",v=verbose) 
      rownames(gene_df2) <- orth_dict[genes2]
      gene_output <- "rownames"
    }
    #### Add genes as colnames ####
    if(tolower(gene_output)  %in% gene_output_opts(colnames_opts = TRUE)){
      messager("Setting ortholog_gene to colnames.",v=verbose) 
      colnames(gene_df2) <- orth_dict[genes2]
      gene_output <- "colnames"
    } 
  }
  
  #### Add  genes as columns ####
  if(tolower(gene_output) %in% gene_output_opts(columns_opts = TRUE)){
    gene_output <- "columns"
    #### Add ortholog_gene col ####
    messager("Adding input_gene col to gene_df.",v=verbose) 
    gene_df2$input_gene <- input_dict[genes2] 
    #### Add input_gene_standard col ####
    if(standardise_genes){
      messager("Adding input_gene_standard col to gene_df.",v=verbose)
      std_dict <- stats::setNames(gene_map$input_gene_standard, 
                                  gene_map$input_gene)
      gene_df2$input_gene_standard <- std_dict[genes2]
    }
    #### Add ortholog_gene col ####
    messager("Adding ortholog_gene col to gene_df.",v=verbose)
    gene_df2$ortholog_gene <- orth_dict[genes2] 
  }  
  
  #### Sort rows ####
  if(sort_rows){
    gene_df2 <- sort_rows_func(gene_df = gene_df2, 
                               verbose = verbose)
  }
  #### Convert to sparse matrix ####
  if(as_sparse){
    messager("Converting obj to sparseMatrix.",v=verbose)
    if(!is_sparse_matrix(gene_df2)){
      if(methods::is(gene_df2,"data.frame") | 
         methods::is(gene_df2,"data.table") |
         methods::is(gene_df2,"matrix") | 
         methods::is(gene_df2,"Matrix")){
        gene_df2 <- methods::as(as.matrix(gene_df2), "sparseMatrix")
      } 
    } 
  }  
  return(gene_df2)
}