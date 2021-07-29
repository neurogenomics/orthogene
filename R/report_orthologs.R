#' Identify the number of orthologous genes between two species
#' 
#' \code{ewceData::mouse_to_human_homologs()} provides 15,604 1:1 mouse:human orthologs.
#' \code{homologene}-based functions like \code{EWCE::convert_orthologs} 
#' provide an improved 16,766 1:1 mouse:human orthologs.  
#' 
#' @param target_species Target species.
#' @param reference_species Reference species. 
#' @param return_report Return just the ortholog mapping between two species (\code{FALSE}) 
#' or return both the ortholog mapping as well a dataframe of the report statistics (\code{TRUE}).
#' @param round_digits Number of digits to round to when printing percentages. 
#' @inheritParams convert_orthologs
#' 
#' @return List of ortholog report statistics 
#' @export
#' @importFrom dplyr n_distinct  
#' @examples
#' orth.fly <- report_orthologs(target_species = "fly",
#'                              reference_species="human")
#' orth.zeb <- report_orthologs(target_species = "zebrafish", 
#'                              reference_species="human")
#' orth.mus <- report_orthologs(target_species = "mouse", 
#'                              reference_species="human") 
report_orthologs <- function(target_species="mouse", 
                             reference_species="human", 
                             standardise_genes=FALSE,
                             method=c("homologene","gorth"),
                             drop_nonorths=TRUE, 
                             one_to_one_only=TRUE,  
                             round_digits=2, 
                             return_report=TRUE,
                             verbose=TRUE){ 
  
  #### Get full genomes for each species ####
  tar_genes <- all_genes(species = target_species, 
                         verbose = verbose)
  ref_genes <- all_genes(species = reference_species, 
                         verbose = verbose) 
  #### Map genes from target to references species ####
  gene_df <- convert_orthologs(gene_df = tar_genes,
                               gene_col = "Gene.Symbol",
                               standardise_genes = standardise_genes,
                               input_species = target_species,
                               output_species = reference_species,
                               method = method[1],
                               drop_nonorths = drop_nonorths, 
                               verbose = verbose)
  
  messager("\n\n=========== REPORT SUMMARY =========== \n")
  one2one_orthologs <- dplyr::n_distinct(gene_df$ortholog_gene)
  target_total_genes <- dplyr::n_distinct(tar_genes$Gene.Symbol)
  reference_total_genes <- dplyr::n_distinct(ref_genes$Gene.Symbol)
  target_percent <- round(one2one_orthologs/target_total_genes*100,digits = round_digits)
  reference_percent <- round(one2one_orthologs/reference_total_genes*100,digits = round_digits)
  messager(
    formatC(one2one_orthologs, big.mark = ","),"/",formatC(target_total_genes,big.mark = ","), 
    paste0("(",target_percent,"%)"),
    "target_species genes remain after ortholog conversion."
  )
  messager(
    formatC(one2one_orthologs,big.mark = ','),"/",formatC(reference_total_genes,big.mark = ","), 
    paste0( "(",reference_percent,"%)"),
    "reference_species genes remain after ortholog conversion."
  )
  if(return_report){
    list(map=gene_df,
         report=data.frame("target_species"=target_species,
                           "target_total_genes"=target_total_genes,
                           "reference_species"=reference_species,
                           "reference_total_genes"=reference_total_genes,
                           "one2one_orthologs"=one2one_orthologs,
                           "target_percent"=target_percent,
                           "reference_percent"=reference_percent))
  } else {return(gene_df)}
}
