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
                     verbose = TRUE) {

    #### Create input dictionary ####
    input_dict <- stats::setNames(
        gene_map$input_gene,
        gene_map$input_gene
    )
    #### Create ortholog dictionary ####
    orth_dict <- stats::setNames(
        gene_map$ortholog_gene,
        gene_map$input_gene
    )
    #### Check matrices ####
    # When gene_df2, try to keep as a sparseMatrix
    # bc making it a dense matrix/data.frame could lead to memory issues
    # if the data is large.
    gene_output <- check_sparseMatrix(
        gene_df2 = gene_df2,
        gene_input = gene_input,
        gene_output = gene_output,
        verbose = verbose
    )
    # If the matrix is already dense, just convert to data.frame
    gene_df2 <- check_matrix(
        gene_df2 = gene_df2,
        gene_output = gene_output,
        verbose = verbose
    )
    #### Aggregate matrix ####
    # You don't need to rename rownames if you aggregate
    # bc this is done by aggregate_mapped_genes.
    if (check_agg_args(
        gene_df = gene_df2,
        non121_strategy = non121_strategy,
        gene_input = gene_input,
        gene_output = gene_output,
        drop_nonorths = drop_nonorths,
        verbose = verbose
    )) {
        gene_df2 <- aggregate_mapped_genes_twice(
            gene_df2 = gene_df2,
            non121_strategy = non121_strategy,
            gene_map = gene_map,
            verbose = verbose
        )
        gene_output <- "rownames"
    } else {
        gene_df2 <- add_rowcol_names(
            gene_df2 = gene_df2,
            orth_dict = orth_dict,
            genes2 = genes2,
            gene_output = gene_output,
            verbose = verbose
        )
    }
    #### Add  genes as columns ####
    if (tolower(gene_output) %in% gene_output_opts(columns_opts = TRUE)) {
        gene_output <- "columns"
        gene_df2 <- add_columns(
            gene_df2 = gene_df2,
            input_dict = input_dict,
            orth_dict = orth_dict,
            genes2 = genes2,
            gene_map = gene_map,
            standardise_genes = standardise_genes,
            verbose = verbose
        )
    }
    #### Sort rows ####
    if (sort_rows) {
        gene_df2 <- sort_rows_func(
            gene_df = gene_df2,
            verbose = verbose
        )
    }
    #### Convert to sparse matrix ####
    if (as_sparse) {
        gene_df2 <- to_sparse(
            gene_df2 = gene_df2,
            verbose = verbose
        )
    }
    return(gene_df2)
}
