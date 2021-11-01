#' Infer species from gene names
#' 
#' Infers which species the genes within \code{gene_df} is from.
#' Iteratively test the percentage of \code{gene_df} genes that match with 
#' the genes from each \code{test_species}. 
#' 
#' @param test_species Which species to test for matches with.
#' If set to \code{NULL}, will default to a list of humans and
#'  5 common model organisms.
#'  If \code{test_species} is set to one of the following options, 
#'  it will automatically pull all species from that respective package and 
#'  test against each of them:  
#'  \itemize{
#'  \item{"homologene"}{20+ species (default)}
#'  \item{"gprofiler"}{700+ species}
#'  \item{"babelgene"}{19 species}
#'  }  
#' @param make_plot Make a plot of the results.
#' @param show_plot Print the plot of the results.
#' @inheritParams convert_orthologs
#' 
#' @return An ordered dataframe of \code{test_species} 
#' from best to worst matches.
#' 
#' @export
#' @importFrom dplyr %>% arrange desc
#' @importFrom data.table data.table rbindlist
#' @importFrom utils capture.output
#' @examples  
#' data("exp_mouse") 
#' matches <- infer_species(gene_df = exp_mouse[1:200,])
infer_species <- function(gene_df,
                          gene_input = "rownames",
                          test_species = c("human",
                                           "monkey",
                                           "rat",
                                           "mouse",
                                           "zebrafish",
                                           "fly"),
                           method = c("homologene",
                                      "gprofiler",
                                      "babelgene"),
                           make_plot = TRUE,
                           show_plot = TRUE,
                           verbose = TRUE){
    percent_match <- NULL;
    
    method <- tolower(method[1])
    #### Get some species ####
    if(all(is.null(test_species))){
        test_species <- c("human",
                          "monkey",
                          "rat",
                          "mouse",
                          "zebrafish",
                          "fly")
        messager("Using default test_species:\n",
                paste("-",test_species,collapse = "\n "))
    }
    #### Get all species ####
    if(tolower(test_species[1]) %in% c(methods_opts(homologene_opts = TRUE,
                                                    gprofiler_opts = TRUE,
                                                    babelgene_opts = TRUE),
                                       "genomeinfodb") ){
        orgs <- get_all_orgs(method = test_species, 
                             verbose = verbose)
        test_species <- orgs$scientific_name
    }
    check_gene_df_type_out <- check_gene_df_type(gene_df = gene_df,
                                                 gene_input = gene_input,
                                                 verbose = verbose)
    gene_df <- check_gene_df_type_out$gene_df
    gene_input <- check_gene_df_type_out$gene_input
    genes <- extract_gene_list(gene_df = gene_df, 
                               gene_input = gene_input, 
                               verbose = verbose)
    res <- lapply(test_species, function(species){
        messager("Testing for gene overlap with:",species,v=verbose)
        genome <- tryCatch(expr = {
            all_genes(species = species,
                      method = method, 
                      verbose = verbose)
        }, error = function(e){
            data.frame(Gene.Symbol=NA)
        })
        data.table::data.table(
            species = species,  
            genome = length(unique(genome$Gene.Symbol)),
            gene_list = length(unique(genes)),
            intersect = sum(unique(genes) %in% genome$Gene.Symbol)
            ) 
    }) %>% data.table::rbindlist()
    res <- dplyr::arrange(res, dplyr::desc(intersect))
    res$species <- factor(res$species,
                          rev(unique(res$species)),
                          ordered = TRUE)
    res$percent_match <- round(res$intersect / res$gene_list, 2)*100
    #### Report ####
    #### Check that no other matches are equally good ####
    top_matches <- res[res$percent_match==max(percent_match,na.rm = TRUE),]
    if(nrow(top_matches)>1){
        top_match <- top_matches$species
        messager("WARNING: Multiple species matched equally well.",v=verbose) 
        messager(paste0(utils::capture.output(top_matches),collapse = "\n"),
                 v=verbose)
    } else {
        top_match <- as.character(res[1,]$species)
        messager("Top match:\n",
                 " - species:",top_match,"\n",
                 " - percent_match:",paste0(res[1,]$percent_match,"%"),
                 v=verbose)
    } 
    #### Plot ####
    if(make_plot){
       gg <- tryCatch(expr = {infer_species_plot(matches = res, 
                                          show_plot = show_plot)}, 
                      error =function(e){NULL}) 
    } else {
        gg <- NULL
    }
    #### Return results ####
    return(list(top_match=top_match,
                data=res,
                plot=gg))
}
