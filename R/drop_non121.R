drop_non121 <- function(gene_map,
                        non121_strategy,
                        symbol_only = TRUE,
                        verbose = TRUE) {
    .SD <- NULL
    messager("Checking for genes without 1:1 orthologs.", v = verbose)
    #### Aggregate ####
    ## Aggregate the data so that we only consider duplicated 
    ## gene symbols as non-1:1
    if(isTRUE(symbol_only)){
        gene_map <- data.table::as.data.table(gene_map)
        if("support_n" %in% names(gene_map)){
            data.table::setorderv(gene_map,"support_n",-1)
        }
        gene_map <- gene_map[,.SD[1],by=c("input_gene","ortholog_gene")] 
    } 
    # Drop not just the extra rows (duplicates)
    # but ALL instances of genes that appear in more than 1 row.
    dup_input_genes <- unname(gene_map$input_gene)[
        duplicated(gene_map$input_gene)
    ]
    dup_ortholog_genes <- unname(gene_map$ortholog_gene)[
        duplicated(gene_map$ortholog_gene)
    ]
    #### Get strategy #####
    non121_strategy <- non121_strategy_opts(non121_strategy)
    agg_opts <- check_agg_opts()

    #### Drop input species non-1:1 orths ####
    if ((non121_strategy %in% c("dis", "dbs")) &&
        (length(dup_input_genes) > 0)) {
        messager("Dropping",
            formatC(length(dup_input_genes), big.mark = ","),
            "genes that have multiple input_gene per ortholog_gene (many:1).",
            v = verbose
        )
        gene_map <- gene_map[!gene_map$input_gene %in% dup_input_genes, ]
    }
    #### Drop output species non-1:1 orths ####
    if ((non121_strategy %in% c("dos", "dbs", agg_opts)) &&
        (length(dup_ortholog_genes) > 0)) {
        messager("Dropping",
            formatC(length(dup_ortholog_genes), big.mark = ","),
            "genes that have multiple ortholog_gene per input_gene (1:many).",
            v = verbose
        )
        gene_map <- gene_map[!gene_map$ortholog_gene %in% dup_ortholog_genes, ]
    }
    return(gene_map)
}
