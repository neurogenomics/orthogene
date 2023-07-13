#' Map genes: SMED
#' 
#' Map planarian (Schmmidt mediterrani) genes to/from the SMED format 
#' using data from the \href{https://planosphere.stowers.org}{planosphere}
#' database.
#' @param drop_duplicates Only output one row per input gene.
#' @inheritParams map_genes
#' @returns \link[data.table]{data.table}
#' @keywords internal
#' @import data.table
#' @source
#' \code{
#' genes <- c("dd_Smed_v6_10690_0","dd_Smed_v6_10691_0","dd_Smed_v6_10693_0")
#' gene_map <- map_genes_planosphere(genes=genes)
#' } 
map_genes_planosphere <- function(genes,
                                  output_format="SMESG_dd_Smes_v2",
                                  drop_duplicates=TRUE,
                                  save_dir = tools::R_user_dir("orthogene",
                                                               which="cache"),
                                  verbose = TRUE){
    
    gene_id <- transcript_id <- transcriptome_id <- NULL;
    #### Download mappings file ####
    messager("Mapping genes with Planosphere.",v=verbose)
    URL <- paste0(
        "https://planosphere.stowers.org/pub/analysis/rosetta/",
        "smed_20140614.mapping.rosettastone.2020/",
        "smed_20140614.mapping.rosettastone.2020.txt")
    f <- file.path(save_dir,basename(URL))
    if(!file.exists(f)){
        dir.create(save_dir,showWarnings = FALSE, recursive = TRUE)
        utils::download.file(url = URL, destfile = f)
    } 
    pmap <- data.table::fread(f, key = "seq_id") 
    #### Get mappings ####
    pmap2 <- merge(pmap[transcriptome_id==output_format,],
                   pmap[genes,-c("transcriptome_id")],
                   by="ref_id") |>
        data.table::setkeyv("seq_id.y")
    gene_map <- merge(data.table::data.table(id=genes),
                      pmap2,
                      all.x = TRUE,
                      by.x="id",
                      by.y="seq_id.y") |>
        data.table::data.table() |>
        data.table::setnames(c("ref_id","seq_id.x","transcriptome_id"),
                             c("smed_id","transcript_id","source"))
    #### Remove transcript suffix ####
    gene_map[,gene_id:=gsub("\\.[0-9]$","",transcript_id)]
    if(isTRUE(drop_duplicates)){ 
        gene_map <- gene_map[,.SD[1], keyby="id"]
    }
    #### Make colnames consistent with other functions ####
    data.table::setnames(gene_map, 
                         c("id","gene_id","transcript_id"),
                         c("input","name","target"))
    #### Return ####
    return(gene_map)
}