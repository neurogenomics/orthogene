
gather_images <- function(species,
                          options=c("namebankID","names","string"),
                          include_image_data=FALSE,
                          mc.cores = 1,
                          verbose = TRUE,
                           ...){ 
    # uids <- ggimage::phylopic_uid(name = tree$tip.label)
    # uids$input_species <- gsub("_"," ",uids$name)
    requireNamespace("rphylopic")
    string <- NULL;
    
    messager("Gathering phylopic silhouettes.",v=verbose)
    orig_names <- unique(species)
    species <- gsub("-|_|[(]|[)]"," ", orig_names)
    res <- parallel::mclapply(species, function(s){
        if(verbose) message_parallel(s) 
        tryCatch({
            uids <- rphylopic::name_search(text = s,
                                options = options)[[1]]
            uids <- subset(do.call("rbind", uids), string==s)[1,]
            #### Get image info ####
            x <- rphylopic::ubio_get(namebankID = uids$namebankID)
            z <- rphylopic::name_images(x$uid)
            d <- data.frame(uid=unlist(z),
                            name=names(unlist(z)))
            d <- d[seq(nrow(d),1),]
            img <- NA
            picid <- NA
            i <- 1 
            #### Iterate until viable image found ####
            while(is.na(img) & i<=nrow(d)){
                messager("try: ",i,v=verbose)
                picid <- d$uid[[i]]
                img <- tryCatch({
                    rphylopic::image_data(d$uid[[i]], size = "512")
                }, error = function(e) NA)
                i <- i + 1
            }  
            if(include_image_data){
                uids$img <- img 
            }
            uids$picid <- picid
            uids
        }, error=function(e) NULL)
    }, mc.cores = mc.cores)  
    #### rbindlist handles this more robustly thna rbind #####
    res <- res %>% `names<-`(orig_names) %>%
        data.table::rbindlist(use.names = TRUE,
                              idcol = "input_species",
                              fill = TRUE)
    res <- res %>% dplyr::rename(species=string)
    # res <- cbind(species=orig_names,
    #              do.call("rbind2",res))
    return(res)
}
