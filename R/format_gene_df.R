format_gene_df <- function(gene_df,
                           gene_map,
                           genes,
                           gene_input,
                           gene_output,
                           drop_nonorths,
                           non121_strategy,
                           agg_fun,
                           standardise_genes,
                           sort_rows,
                           as_sparse,
                           as_DelayedArray,
                           verbose = TRUE) {

    #### Use only 1st gene_output item if is a list ####
    gene_input <- gene_input[1]
    gene_output <- gene_output[1]
    #### Subset to mapped genes only ####
    filter_gene_df_out <- filter_gene_df(
        gene_input = gene_input,
        gene_df = gene_df,
        genes = genes,
        gene_map = gene_map,
        verbose = verbose
    )
    gene_df2 <- filter_gene_df_out$gene_df2
    genes2 <- filter_gene_df_out$genes2
    ##### Return gene dictionary ####
    if (tolower(gene_output) %in% gene_output_opts(dict_opts = TRUE)) {
        dict <- as_dict(
            gene_output = gene_output,
            gene_map = gene_map,
            genes2 = genes2,
            verbose = verbose
        )
        #### Report ####
        report_gene_map(
            n_input_genes = length(unique(genes)),
            n_output_genes = length(unique(dict)),
            verbose = verbose
        )
        return(dict)
    } else {
        gene_df2 <- as_table(
            gene_input = gene_input,
            gene_output = gene_output,
            gene_df2 = gene_df2,
            genes2 = genes2,
            gene_map = gene_map,
            standardise_genes = standardise_genes,
            drop_nonorths = drop_nonorths,
            non121_strategy = non121_strategy,
            agg_fun = agg_fun,
            sort_rows = sort_rows,
            as_sparse = as_sparse,
            as_DelayedArray = as_DelayedArray,
            verbose = verbose
        )
        #### Report ####
        report_gene_map(
            n_input_genes = length(unique(genes)),
            n_output_genes = nrow(gene_df2),
            verbose = verbose
        )
        return(gene_df2)
    }
}
