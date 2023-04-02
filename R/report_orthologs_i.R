report_orthologs_i <- function(target_species = "mouse",
                               reference_species = "human",
                               standardise_genes = FALSE,
                               method_all_genes = c(
                                   "homologene",
                                   "gprofiler", 
                                   "babelgene"
                               ),
                               method_convert_orthologs = method_all_genes,
                               drop_nonorths = TRUE,
                               non121_strategy = "drop_both_species",
                               round_digits = 2,
                               return_report = TRUE,
                               ref_genes = NULL,
                               mc.cores = 1,
                               verbose = TRUE,
                               ...){
    #### Standardise args ####
    method_convert_orthologs <- tolower(method_convert_orthologs[1])
    method_all_genes <- tolower(method_all_genes[1])
    #### Save original target_species name ####
    input_species <- target_species 
    #### Check species here to see if they're synonymous ####
    species1 <- map_species(species = target_species,
                            method = method_all_genes,
                            output_format = "scientific_name_formatted",
                            verbose = FALSE) |> unname() 
    species2 <- map_species(species = reference_species,
                            method = method_all_genes,
                            output_format = "scientific_name_formatted",
                            verbose = FALSE) |> unname() 
    #### Species are the same #### 
    if(species1==species2){
        gene_df <- all_genes(species = reference_species, 
                             method = method_all_genes,
                             run_map_species = TRUE,
                             verbose = verbose)
        gene_df$ortholog_gene <- gene_df$Gene.Symbol
        tar_genes <- ref_genes <- gene_df
        message("--")
    } else {
        #### Species are different ####
        #### Get full genomes for each species #### 
        tar_genes <- all_genes(
            species = target_species,
            method = method_all_genes,
            run_map_species = TRUE,
            verbose = verbose
        ) 
        message("--")
        if(is.null(ref_genes)){
            ref_genes <- all_genes(
                species = reference_species,
                method = method_all_genes,
                run_map_species = TRUE,
                verbose = verbose
            )
        } 
        message("--")
        #### Map genes from target to references species ####
        gene_df <- convert_orthologs(
            gene_df = tar_genes,
            gene_input = "Gene.Symbol",
            gene_output = "columns",
            agg_fun = NULL,
            standardise_genes = standardise_genes,
            input_species = target_species,
            output_species = reference_species,
            method = method_convert_orthologs,
            drop_nonorths = drop_nonorths,
            non121_strategy = non121_strategy,
            verbose = verbose,
            ...
        )
        #### Add input/target species columns to be beginning #### 
        gene_df <- data.table::as.data.table(gene_df)
        gene_df$input_species <- input_species
        gene_df$target_species <- species1
        gene_df$reference_species <- species2
        data.table::setcolorder(gene_df,c("input_species",
                                          "target_species",
                                          "reference_species"))
        message("--")
    }
    messager("\n=========== REPORT SUMMARY ===========\n",v=verbose)
    one2one_orthologs <- dplyr::n_distinct(gene_df$ortholog_gene)
    target_total_genes <- dplyr::n_distinct(tar_genes$Gene.Symbol)
    reference_total_genes <- dplyr::n_distinct(ref_genes$Gene.Symbol)
    target_percent <- round(one2one_orthologs / target_total_genes * 100,
                            digits = round_digits
    )
    reference_percent <- round(one2one_orthologs / reference_total_genes * 100,
                               digits = round_digits
    )
    messager(
        formatC(one2one_orthologs, big.mark = ","), "/",
        formatC(target_total_genes, big.mark = ","),
        paste0("(", target_percent, "%)"),
        "target_species genes remain after ortholog conversion.",
        v=verbose
    )
    messager(
        formatC(one2one_orthologs, big.mark = ","), "/",
        formatC(reference_total_genes, big.mark = ","),
        paste0("(", reference_percent, "%)"),
        "reference_species genes remain after ortholog conversion.",
        v=verbose
    )
    if (isTRUE(return_report)) {
        list(
            map = gene_df,
            report = data.table::data.table(
                "input_species" = input_species, ## Original input species name
                "target_species" = species1, ## Standardised species name 
                "target_total_genes" = target_total_genes,
                "reference_species" = species2,
                "reference_total_genes" = reference_total_genes,
                "one2one_orthologs" = one2one_orthologs,
                "target_percent" = target_percent,
                "reference_percent" = reference_percent
            )
        )
    } else {
        return(gene_df)
    }
}