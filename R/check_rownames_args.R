check_rownames_args <- function(gene_output,
                                drop_nonorths,
                                non121_strategy,
                                as_sparse,
                                verbose = TRUE) {
    # When gene_output="rownames",
    # check that other args are compatible
    if (tolower(gene_output) %in% gene_output_opts(rownames_opts = TRUE)) {
        if (isFALSE(as_sparse) && isFALSE(drop_nonorths)) {
            messager("WARNING:",
                "In order to set gene_output='rownames'",
                "while drop_nonorths=FALSE,",
                "must convert gene_df into a sparse matrix.",
                "Setting as_sparse=TRUE.",
                v = verbose
            )
            as_sparse <- TRUE
        }
        agg_opts <- unname(check_agg_opts())
        non121_strategy <- non121_strategy_opts(
            non121_strategy = non121_strategy
        )
        if (isFALSE(as_sparse) &&
            (!non121_strategy %in% c("dbs", "kp", agg_opts))
            ) {
            messager("WARNING:",
                "In order to set gene_output='rownames'",
                paste0("while non121_strategy='",non121_strategy,"',"),
                "must convert gene_df into a sparse matrix.",
                "Setting as_sparse=TRUE.",
                v = verbose
            )
            as_sparse <- TRUE
        }
    }
    return(list(
        gene_output = gene_output,
        drop_nonorths = drop_nonorths,
        non121_strategy = non121_strategy,
        as_sparse = as_sparse
    ))
}
