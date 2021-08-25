run_benchmark_once <- function(species,
                               method,
                               run_convert_orthologs = TRUE,
                               ensure_filter_nas = TRUE,
                               verbose = TRUE) {

    #### all_genes benchmark ####
    messager("Benchmarking all_genes()", v = verbose)
    start1 <- Sys.time()
    gene_map1 <- tryCatch(
        {
            all_genes(
                species = species,
                method = method,
                ensure_filter_nas = ensure_filter_nas,
                verbose = verbose
            )
        },
        error = function(e) {
            message(e)
            NA
        }
    )
    time1 <- as.numeric(difftime(Sys.time(), start1, units = "secs"))
    n_genes1 <- if (all(is.na(gene_map1))) {
        0
    } else {
        length(unique(gene_map1$Gene.Symbol))
    }

    res1 <- data.frame(
        method = method,
        test = "all_genes()",
        time = time1,
        genes = n_genes1
    )

    #### convert_orthologs benchmark ####
    if (run_convert_orthologs) {
        messager("Benchmarking convert_orthologs()", v = verbose)
        start2 <- Sys.time()
        gene_map2 <- tryCatch(
            {
                convert_orthologs(
                    gene_df = gene_map1,
                    gene_input = "Gene.Symbol",
                    gene_output = "columns",
                    input_species = species,
                    output_species = "human",
                    non121_strategy = if (is_human(species)) {
                        "kbs"
                    } else {
                        "dbs"
                    },
                    # drop_nonorths = !is_human(species),
                    method = method,
                    verbose = verbose
                )
            },
            error = function(e) {
                message(e)
                NA
            }
        )
        time2 <- as.numeric(difftime(Sys.time(), start2, units = "secs"))
        n_genes2 <- if (all(is.na(gene_map2))) {
            0
        } else {
            length(unique(gene_map2$ortholog_gene))
        }

        res2 <- data.frame(
            method = method,
            test = "convert_orthologs()",
            time = time2,
            genes = n_genes2
        )
        #### Gather results ####
        res <- rbind(res1, res2)
    } else {
        res <- res1
    }
    return(res)
}
