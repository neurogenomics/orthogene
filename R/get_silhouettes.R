#' Get silhouettes
#' 
#' Get silhouette images of each species from \href{phylopic.org}{phylopic}.
#' @param species A character vector of species names 
#' to query \href{phylopic.org}{phylopic} for.
#' @param which An integer vector of the same length as \code{species}. 
#' Lets you choose which image you want to use for each species 
#' (1st, 2nd 3rd, etc.).
#' @param run_format_species Standardise species names with 
#' \link[orthogene]{format_species} before querying 
#' \href{phylopic.org}{phylopic} (default: \code{TRUE}).
#' @param include_image_data Include the image data itself 
#' (not just the image UID) in the results.
#' @param mc.cores Accelerate multiple species queries by parallelising 
#' across multiple cores.
#' @param add_png Return URLs for both the SVG and PNG versions of the image.
#' @param remove_bg Remove image background.
#' @param verbose Print messages. 
#' @returns data.frame with:
#' \describe{
#' \item{input_species : }{Species name (input).}
#' \item{species : }{Species name (standardised).}
#' \item{uid : }{Species UID.} 
#' \item{url : }{Image URL.} 
#' }
#' @source 
#' \href{https://github.com/GuangchuangYu/ggimage/blob/master/R/geom_phylopic.R}{
#' Related function: \code{ggimage::geom_phylopic}}
#' @source \href{https://github.com/palaeoverse-community/rphylopic/issues/39}{
#' phylopic/rphylopic API changes}
#' @source \href{https://github.com/GuangchuangYu/ggimage/issues/40}{
#' ggimage: Issue with finding valid PNGs}
#' 
#' @export 
#' @examples  
#' species <- c("Mus_musculus","Pan_troglodytes","Homo_sapiens")
#' uids <- get_silhouettes(species = species)
get_silhouettes <- function(species,
                            which = rep(1,length(species)),
                            run_format_species = TRUE,
                            include_image_data=FALSE,
                            mc.cores = 1,
                            add_png = FALSE,
                            remove_bg = FALSE,
                            verbose = TRUE){ 
    # devoptera::args2vars(get_silhouettes, reassign = TRUE)
    # uids <- ggimage::phylopic_uid(name = tree$tip.label)
    # uids$input_species <- gsub("_"," ",uids$name)
    requireNamespace("rphylopic")
    requireNamespace("data.table")
    requireNamespace("parallel")
    
    if(isTRUE(remove_bg)){
        requireNamespace("magick") 
    }
    if(length(which)!=length(species)){
        stp <- "`which` must be the same length as `species`."
        stop(stp)
    }
    messager("Gathering phylopic silhouettes.",v=verbose)
    #### Standardise names ####
    orig_names <- unique(species) 
    if(isTRUE(run_format_species)){
        species <- format_species(species = species, 
                                  standardise_scientific = TRUE)
    }   
    names(which) <- species 
    uids <- parallel::mclapply(stats::setNames(species,
                                               orig_names),
                              function(s){
        if(verbose) message_parallel("+ ",s) 
        tryCatch({
            #### SVG info #### 
            URL <- rphylopic::get_uuid(name = s,
                                       n = which[s],
                                       url = TRUE)[which[s]] 
            
            uid_i <- data.frame(species = s,
                                which = which[s],
                                svg = unname(URL),
                                svg_uid = names(URL))
            if(isTRUE(add_png)){
                tryCatch({
                    png_data <- rphylopic::get_phylopic(uuid = names(URL),
                                                        format = "512")
                    # rphylopic::save_phylopic(img = img, path)
                    uid_i <- cbind(uid_i,
                                   png = attr(png_data,"url"),
                                   png_uid = attr(png_data,"uuid"))
                    if(isTRUE(include_image_data)){
                        uid_i$png_data <- png_data
                    }
                    #### Remove white background ####
                    if(isTRUE(remove_bg)){
                        img_res <- remove_image_bg(path = URL)
                        png_local <- img_res$save_path
                        uid_i <- cbind(uid_i,
                                       png_local = png_local) 
                    }  
                }, error=function(e){messager(e);NULL}) 
            } 
            return(uid_i)
        }, error=function(e){messager(e);NULL})
    }, mc.cores = mc.cores) |>
        data.table::rbindlist(use.names = TRUE,
                              idcol = "input_species",
                              fill = TRUE) 
    return(uids)
}
