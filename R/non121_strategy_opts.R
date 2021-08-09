non121_strategy_opts <- function(non121_strategy=NULL,
                                 include_agg=TRUE){
  dbs_opts <- setNames(rep("dbs",3),
                       c("drop_both_species","dbs",1))
  dis_opts <- setNames(rep("dis",3),
                       c("drop_input_species","dis",2))
  dos_opts <- setNames(rep("dos",3),
                       c("drop_output_species","dos",3)) 
  kbs_opts <- setNames(rep("kbs",7),
                       c("keep_both_species","kbs",4,"keep",
                         as.character(NA),
                         as.character(FALSE),
                         as.character(tolower(FALSE))))
  kp_opts <- setNames(rep("kp",3), c("keep_popular","kp",5))
  #### Concat ####
  all_opts <- c(dbs_opts, dis_opts, dos_opts, kbs_opts, kp_opts)
  #### Aggregation options ####
  agg_opts <- check_agg_opts() 
  if(include_agg){
    all_opts <- c(all_opts, agg_opts)
  }
  #### Return all options ####
  if(is.null(non121_strategy)){
    return(all_opts)
  }else {
    #### Query dictionary ####
    non121_strategy <- gsub(" ","_",
                            tolower(as.character(non121_strategy))[1])
    if(non121_strategy  %in%  names(all_opts)){
      return(all_opts[non121_strategy])
    } else {
      stop_msg <- paste0("non121_strategy must be one of:\n",
                         "  - DIS OPTS: ",paste(names(dis_opts), 
                                                collapse = " / "),"\n",
                         "  - DOS OPTS: ",paste(names(dos_opts), 
                                                collapse = " / "),"\n",
                         "  - DBS OPTS: ",paste(names(dbs_opts), 
                                                collapse = " / "),"\n",
                         "  - KBS OPTS: ",paste(names(kbs_opts), 
                                                collapse = " / "),"\n",
                         "  - KP OPTS: ",paste(names(kp_opts), 
                                                collapse = " / "),"\n",
                         if(include_agg){
                           c("  - AGGREGATION OPTS:\n",paste("    -", names(agg_opts), 
                                                             collapse = "\n"),"\n")
                         } else {NULL}
                         )
      stop(stop_msg)
    }
  }
  
}
