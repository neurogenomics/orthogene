rotate_clades <- function(tr,
                          clades){
    
    requireNamespace("ape")
    requireNamespace("phytools")
    # clades <- list(c("homo sapiens","pan troglodytes"))
    for(tips in clades){ 
        tips <- tips[tips %in% tr$tip.label]
        if(length(tips)>1){
            node <- phytools::findMRCA(tr,tips = tips)
            tr <- ape::rotate(tr, node = node)
        }   
    } 
    return(tr)
}