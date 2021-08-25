check_rownames_args <- function(gene_output,
                                drop_nonorths,
                                non121_strategy,
                                verbose = TRUE) {
    # When gene_output="rownames",
    # check that other args are compatible
    if (tolower(gene_output) %in% gene_output_opts(rownames_opts = TRUE)) {
        if (drop_nonorths == FALSE) {
            messager("WARNING:",
                "In order to set gene_output='rownames'",
                "must set drop_nonorths=TRUE.\n",
                "Setting drop_nonorths=TRUE.",
                v = verbose
            )
            drop_nonorths <- TRUE
        }
        agg_opts <- unname(check_agg_opts())
        non121_strategy <- non121_strategy_opts(
            non121_strategy = non121_strategy)
        if (!(non121_strategy %in% c("dbs", "kp", agg_opts))) {
            messager("WARNING:",
                "In order to set gene_output='rownames'",
                "must ensure unqiue rownmaes by setting non121_strategy to:\n",
                "  'drop_both_species' or 'keep_popular'", "\n",
                "or an aggregation function:\n",
                "  ", paste0("'", agg_opts, "'", collapse = ","), ".\n",
                "Setting non121_strategy='drop_both_species'.",
                v = verbose
            )
            non121_strategy <- "dbs"
        }
    }
    return(list(
        gene_output = gene_output,
        drop_nonorths = drop_nonorths,
        non121_strategy = non121_strategy
    ))
}
