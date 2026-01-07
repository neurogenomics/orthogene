run_benchmark_once <- function(species,
                               method,
                               run_convert_orthologs = TRUE,
                               ensure_filter_nas = TRUE,
                               force = FALSE,
                               verbose = TRUE) {

    #### all_genes benchmark ####
    messager("Benchmarking all_genes()", v = verbose)
    
    ### Check for cached file ###
    save_path <- get_cache_save_path(fn="run_benchmark_once",
                                     species=species,
                                     method=method)
    if (file.exists(save_path) && isFALSE(force)){
        messager("Using cached file:",save_path)
        res <- data.table::fread(save_path) 
        return (res)
    } 
    
    
    gene_map1 <- tryCatch(
        {
            all_genes(
                species = species,
                method = method,
                ensure_filter_nas = ensure_filter_nas,
                force = force > 1,
                verbose = verbose
            ) 
        },
        error = function(e) {
            message(e) 
            NA
        }
    ) 
    if (is.data.frame(gene_map1)){
        time1 <- gene_map1$time[1]
    } else {
        time1 <- NA
    }
    
    n_genes1 <- if (all(is.na(gene_map1))) {
        NA
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
        
        if (is.data.frame(gene_map2)){
            time2 <- as.numeric(difftime(Sys.time(), start2, units = "secs")) 
        } else {
            time2 <- NA
        }
        
        ### Fill missing values ###
        n_genes2 <- if (all(is.na(gene_map2))) {
            NA
        } else if (!"ortholog_gene" %in% colnames(gene_map2)) {
            ## Used when input species is the same as output species 
            length(unique(gene_map2$Gene.Symbol))
        } else {
            length(unique(gene_map2$ortholog_gene))
        }

        res2 <- data.frame(
            method = method,
            test = "convert_orthologs()",
            time = if(!is.null(time2)) time2 else NA,
            genes = n_genes2
        )
        #### Gather results ####
        res <- rbind(res1, res2)
    } else {
        res <- res1
    }
    
    
    ### Cache file ###
    if(nrow(res)>0){
        messager("Caching file -->",save_path, v=verbose) 
        data.table::fwrite(res, file = save_path, sep=",")    
    } else{
        messager("Results contained zero rows. Skipping caching as this is likely an error.")
    } 
    
    return(res)
}
