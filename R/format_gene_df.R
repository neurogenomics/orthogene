format_gene_df <- function(gene_df,
                           gene_map, 
                           genes,
                           genes_as_rownames,
                           standardise_genes,
                           sort_rows,
                           as_sparse,
                           verbose=TRUE){ 
  
  #### Subset to mapped genes only ####
  gene_df2 <- gene_df[genes %in% gene_map$input_gene,]
  genes2 <- genes[genes %in% gene_map$input_gene]
  orth_dict <- stats::setNames(gene_map$ortholog_gene, gene_map$input_gene)
  if(methods::is(gene_df2,"sparseMatrix")|
     methods::is(gene_df2,"matrix")|
     methods::is(gene_df2,"Matrix")){
    messager("WARNING: genes_as_rownames must be TRUE",
             "when gene_df is a matrix. Setting accordingly.",v=verbose)
    genes_as_rownames <- TRUE
  }
  
  if(genes_as_rownames){
    messager("Setting ortholog_gene to rownames.",v=verbose) 
    rownames(gene_df2) <- orth_dict[genes2]
  }  else {
    #### Add input_gene_standard col ####
    if(standardise_genes){
      messager("Adding input_gene_standard col to gene_df.",v=verbose)
      std_dict <- stats::setNames(gene_map$ortholog_gene, gene_map$input_gene_standard)
      gene_df2$input_gene_standard <- std_dict[genes2]
    }
    #### Add ortholog_gene col ####
    messager("Adding ortholog_gene col to gene_df.",v=verbose)
    gene_df2$ortholog_gene <- orth_dict[genes2] 
  } 
  #### Sort rows ####
  if(sort_rows && genes_as_rownames){
    messager("Sorting rownames alphanumerically.",v=verbose)
    gene_df2 <- gene_df2[sort(rownames(gene_df2)),]
  }
  #### Convert to sparse matrix ####
  if(as_sparse){
    messager("Converting obj to sparseMatrix.",v=verbose)
    if(!methods::is(gene_df2,"sparseMatrix")){
      gene_df2 <- methods::as(as.matrix(gene_df2), "sparseMatrix")
    } 
  }  
  return(list(gene_df2=gene_df2,
              genes2=genes2))
}