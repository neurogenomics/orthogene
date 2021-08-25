all_genes_homologene <- function(species,
                                 verbose = TRUE) {

    ### Avoid confusing Biocheck
    Taxonomy <- NULL

    messager("Retrieving all genes using: homologene.", v = verbose)
    target_id <- map_species(
        species = species,
        output_format = "taxonomy_id",
        verbose = verbose
    )
    tar_genes <- subset(
        homologene::homologeneData,
        Taxonomy == target_id
    )
    messager("Gene table with", nrow(tar_genes), "rows retrieved.",
        v = verbose
    )
    return(tar_genes)
}
