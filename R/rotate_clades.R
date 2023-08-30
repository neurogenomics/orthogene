rotate_clades <- function(tr,
                          clades){
    # clades <- list(c("homo sapiens","pan troglodytes"))
    requireNamespace("ape")
    requireNamespace("phytools")
    
    for(tips in clades){ 
        tips <- tips[tips %in% tr$tip.label]
        if(length(tips)>1){
            node <- phytools::findMRCA(tr,tips = tips)
            tr <- ape::rotate(tr, node = node)
        }   
    } 
    return(tr)
}