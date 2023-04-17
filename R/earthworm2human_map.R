#' Earthworm to human map
#' 
#' Orthologous gene mapping between earthworm (Eisenia andrei) and
#' human (Homo sapiens) genes. 
#' 
#' These mappings were generated using 
#' \href{https://blast.ncbi.nlm.nih.gov/Blast.cgi}{BLAST} 
#' (a protein sequence tool) implemented within 
#' \href{https://elifesciences.org/articles/66747}{SAMap}.
#' This mapping data was provided upon request by the authors of  
#' \href{https://doi.org/10.1093/nar/gkac633}{Wang et al. 2022}.
#' Column names were collected from 
#' \href{https://www.metagenomics.wiki/tools/blast/blastn-output-format-6}{
#' Metagenomics Wiki}.
#' @param evalue_threshold Only include mappings with an E-value
#'  below a set threshold. 
#'  See \href{https://www.metagenomics.wiki/tools/blast/evalue}{here} 
#'  for further guidance.
#' @param save_dir Directory to save mapping file to.
#' @returns \link[data.table]{data.table} 
#' containing earthworm-to-human gene orthologs.
#' 
#' @keywords internal
#' @import data.table
#' @importFrom tools R_user_dir
earthworm2human_map <- function(evalue_threshold = 1e-10,
                                save_dir = tools::R_user_dir("orthogene",
                                                             which="cache")){  
    evalue <- NULL;
    requireNamespace("piggyback")
    
    file <- "ea_to_hu.csv.gz"
    dir.create(save_dir,showWarnings = FALSE, recursive = TRUE)
    tmp <- file.path(save_dir,file) 
    piggyback::pb_download(file = file,
                           repo = "neurogenomics/orthogene",
                           dest = save_dir)
    get_data_check(tmp = tmp) 
    gene_map <- data.table::fread(tmp)
    #### Filter evalue #### 
    if(!is.null(evalue_threshold)){
        gene_map <- gene_map[evalue<evalue_threshold]
    }
    return(gene_map)
}