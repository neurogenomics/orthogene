#' Create gene background
#' 
#' Create a gene background as the union/intersect of 
#' all orthologs between input species (\code{species1} and \code{species2}), 
#' and the \code{output_species}. 
#' This can be useful when generating random lists of background genes 
#' to test against in analyses with data from multiple species
#'  (e.g. enrichment of mouse cell-type markers gene sets in
#'   human GWAS-derived gene sets).
#' 
#' @param species1 First species.
#' @param species2 Second species.
#' @param output_species Species to convert all genes from 
#' \code{species1} and \code{species2} to first.
#'  \code{Default="human"}, but can be to either any species
#'   supported by \pkg{orthogene}, including 
#'  \code{species1} or \code{species2}.
#' @param as_output_species Return background gene list as 
#' \code{output_species} orthologs, instead of the
#'  gene names of the original input species.
#' @param use_intersect When \code{species1} and \code{species2} are both
#'  different from \code{output_species}, this argument will determine whether 
#'  to use the intersect (\code{TRUE}) or union (\code{FALSE}) of all genes
#'  from \code{species1} and \code{species2}.
#' @param bg User supplied background list that will be returned to the 
#' user after removing duplicate genes.
#' @param gene_map User-supplied \code{gene_map} data table from
#' \link[orthogene]{map_orthologs} or \link[orthogene]{map_genes}.
#' @inheritParams convert_orthologs
#' 
#' @returns Background gene list.
#' 
#' @export
#' @examples 
#' bg <- orthogene::create_background(species1 = "mouse", 
#'                                    species2 = "rat",
#'                                    output_species = "human")
create_background <- function(species1,
                              species2,
                              output_species = "human", 
                              as_output_species = TRUE,
                              use_intersect = TRUE,
                              bg = NULL,
                              gene_map = NULL,
                              method = "homologene",
                              non121_strategy = "drop_both_species",
                              verbose = TRUE) { 
    species_list <- c(species1,species2)
    gene_var <- if(as_output_species) "ortholog_gene" else "input_gene"
    if(all(species_list==output_species)){
        if(is.null(bg)){
            #### If all species are the same, just use all_genes ####
            gene_map <- all_genes(species = output_species, 
                                  method = method,
                                  verbose = verbose)
            bg <- gene_map$Gene.Symbol
            messager("Returning",formatC(length(bg), big.mark = ","),
                     "unique genes from entire",output_species,"genome.",
                     v=verbose)
        } else {
            bg <- unique(bg) 
            messager("Returning",formatC(length(bg), big.mark = ","),
                     "unique genes from the user-supplied bg.",v=verbose)
        }
        return(bg)
    }
    if (is.null(bg)) {
        messager("Generating gene background for",
                 paste0(species1," x ",species2," ==>"),
                 output_species,
                 v=verbose)
        #### Species 1 ####
        gene_map1 <- report_orthologs(
            target_species = species1,
            reference_species = output_species, 
            method_all_genes = method,
            method_convert_orthologs = method,
            non121_strategy = non121_strategy,
            return_report = FALSE,
            verbose = verbose
        )   
        #### Species 2 ####
        if(species1==species2){
            gene_map2 <- gene_map1
        } else {
            gene_map2 <- report_orthologs(
                target_species = species2,
                reference_species = output_species, 
                method_all_genes = method,
                method_convert_orthologs = method,
                non121_strategy = non121_strategy,
                return_report = FALSE,
                verbose = verbose
            ) 
        } 
        #### Use intersect/union ####
        if(use_intersect){
            bg <- intersect(gene_map1[[gene_var]],
                            gene_map2[[gene_var]])
            messager(formatC(length(bg), big.mark = ","),
                     "intersect background genes used.",v=verbose) 
        } else {
            bg <- union(gene_map1[[gene_var]],
                        gene_map2[[gene_var]])
            messager(formatC(length(bg), big.mark = ","),
                     "union background genes used.",v=verbose)
        } 
        bg <- unique(bg)
    } else {
        bg <- unique(bg) 
        messager("Returning",formatC(length(bg), big.mark = ","),
                 "unique genes from the user-supplied bg.",v=verbose)
    }
    return(bg)
}
