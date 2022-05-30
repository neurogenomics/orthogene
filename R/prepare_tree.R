#' Prepare a phylogenetic tree
#' 
#' Import a phylogenetic tree  and then conduct 
#' a series of optional standardisation steps.
#' Optionally, if \code{output_format} is not \code{NULL}, species names from 
#'  both the tree and the \code{species} argument will first be standardised
#'  using \link[orthogene]{map_species}. 
#' 
#' @param tree_source Can be one of the following:
#' \itemize{
#' \item{"timetree":\cr}{Import and prune the
#' \href{http://www.timetree.org/public/data/TimetreeOfLife2015.nwk}{
#' TimeTree >50k species} phylogenetic tree.}
#' \item{"OmaDB":\cr}{Construct a tree from \href{omabrowser.org}{OMA} 
#' (Orthologous Matrix browser) via the \link[OmaDB]{getTaxonomy} function.
#' \emph{NOTE: } Does not contain branch lengths,
#'  and therefore may have limited utility.}
#' \item{"UCSC":\cr}{Import and prune the 
#' \href{https://hgdownload.soe.ucsc.edu/goldenPath/hg38/multiz100way/}{
#' UCSC 100-way alignment} phylogenetic tree (hg38 version).}
#' \item{"<path>":\cr}{Read a tree from a newick text file 
#' from a local or remote URL using \link[ape]{read.tree}.}  
#' } 
#' @param species Species names to subset the tree by 
#' (after \code{standardise_species} step). 
#' @param run_map_species Whether to first standardise species names with 
#' \link[orthogene]{map_species}.  
#' @param force_ultrametric Whether to force the tree to be ultrametric 
#' (i.e. make all tips the same date) using \link[phytools]{force.ultrametric}. 
#' @param age_max Rescale the edges of the tree into units of 
#' millions of years (MY) instead than evolutionary rates (e.g. dN/dS ratios).
#' Only used if \code{age_max}, the max number , is numeric. Times are computed using
#' \link[ape]{makeChronosCalib} and \link[ape]{chronos}. 
#' @param show_plot Show a basic plot of the resulting tree. 
#' @param ... Additional arguments passed to \link[ape]{makeChronosCalib}. 
#' @inheritParams map_species
#' 
#' @returns A filtered tree of class "phylo" (with standardised species names).  
#' 
#' @export
#' @examples 
#' species <- c("human","chimp","mouse")
#' tr <- orthogene::prepare_tree(species = species)
prepare_tree <- function(tree_source = "timetree", 
                         species = NULL,
                         output_format = "scientific_name",
                         run_map_species = c(TRUE, TRUE),
                         method = c(
                             "homologene",
                             "gprofiler", 
                             "babelgene"
                         ),
                         force_ultrametric = TRUE,
                         age_max = NULL,
                         show_plot = TRUE,
                         verbose = TRUE,
                         ...){ 
    requireNamespace("ape")
    requireNamespace("phytools")
    requireNamespace("TreeTools")
    
    method <- tolower(method)[1]
    if(tolower(tree_source) %in% c("omadb","oma")){
        requireNamespace("OmaDB")
        messager("Importing tree from: OMA",v=verbose)
        txt <- OmaDB::getTaxonomy(members=paste(species,collapse = ","))$newick
        tr <- OmaDB::getTree(newick = txt) 
      
    } else if(tolower(tree_source)=="ucsc"){
        messager("Importing tree from: UCSC",v=verbose)
        tree_source <- paste(
            "http://hgdownload.soe.ucsc.edu/goldenPath",
            "hg38/multiz100way",
            "hg38.100way.scientificNames.nh",sep="/"
            )
        tr <- ape::read.tree(file = tree_source)
    } else if(tolower(tree_source) %in% c("timetree")){
        messager("Importing tree from: TimeTree",v=verbose)
        #### >50k species #####
        tree_source <- paste("http://www.timetree.org/public/data",
                             "TimetreeOfLife2015.nwk",sep="/")
        tr <- ape::read.tree(file = tree_source)
        ## Filter early, bc mapping all 50k species would take too long.
        species <- map_species(species = species,
                               output_format = "scientific_name",
                               method = method,
                               verbose = FALSE)
        species_ <- gsub(" +","_",species)
        unmapped <- !tr$tip.label %in% species_
        tr <- ape::drop.tip(
            phy = tr, 
            tip = tr$tip.label[unmapped]) 
    } else {
        messager("Importing tree from:",tree_source,v=verbose)
        # if(any(endsWith(tree_source,c("nh","nhx")))){
        #     requireNamespace("treeio")
        #     tr <- treeio::read.nhx(file = tree_source) 
        # } else {
        tr <- ape::read.tree(file = tree_source)
        # } 
    } 
    if(!force_ultrametric){
        tr <- phytools::force.ultrametric(tr)
    } 
    #### Find which species are in both homologene and 100-way tree ####
    if(!is.null(output_format)){
        #### Selected species ####
        if(!is.null(species) && isTRUE(run_map_species[1])){
            messager("Mapping",length(species),"species from `species`.",
                     v=verbose)
            species <- map_species(species = species,
                                   output_format = output_format,
                                   method = method,
                                   verbose = FALSE)
        } 
        #### Tree species #### 
        if((length(run_map_species)>1 && isTRUE(run_map_species[2])) |
           (length(run_map_species)==1 && isTRUE(run_map_species[1]))){
            messager("Mapping",length(tr$tip.label),"species from tree.",
                     v=verbose)
            tip_species <- map_species(species = tr$tip.label,
                                       output_format = output_format,
                                       method = method, 
                                       verbose = FALSE)
            messager("--",v=verbose)
            unmapped <- unname(is.na(tip_species[tr$tip.label]))
            if(length(unmapped)>0 && all(!is.na(unmapped))){
                messager(paste0(
                    sum(unmapped),"/",length(tr$tip.label),
                    " (",round(sum(unmapped)/length(tr$tip.label),2)*100,"%)"
                ),
                "tips dropped from tree due to inability to",
                "standardise names with `map_species`.",
                v=verbose)
            } 
            tr <- ape::drop.tip(
                phy = tr, 
                tip = tr$tip.label[unmapped])
            tr$tip.label <- tip_species[tr$tip.label] 
        } 
    }   
    messager("--",v=verbose)
    #### Subset species ####   
    if(!is.null(species)){
        dropped <- !tr$tip.label %in% species 
       if(length(dropped)>0 && all(!is.na(dropped))){
           messager(paste0(sum(dropped),"/",length(tr$tip.label),
                           " (",round(sum(dropped)/
                                          length(tr$tip.label),2)*100,"%)"),
                    "tips dropped from tree",
                    "according to overlap with selected `species`.",
                    v=verbose)
       }
        tr <- ape::drop.tip(
            phy = tr, 
            tip = tr$tip.label[dropped]) 
    } 
    #### Get root node #### 
    root_node <- TreeTools::RootNode(tr)
    #### Convert from dN/dS ratios to Millions of Years (MY) #### 
    if(is.numeric(age_max)){  
        cal <- ape::makeChronosCalib(tr,
                                     node = root_node,
                                     age.max = age_max,
                                     ...)
        ctree <- ape::chronos(tr, calibration = cal)
        tr$edge.length <- ctree$edge.length
        messager("--",v=verbose)
    }
    #### Add back node labels ####
    tr <- ape::makeNodeLabel(tr) 
    # phytools::findMRCA(tr, tips = c("Homo sapiens","Danio rerio"))
    if(show_plot){
        plot(tr, show.tip.label = TRUE, show.node.label = TRUE)
    }
    return(tr)
}
