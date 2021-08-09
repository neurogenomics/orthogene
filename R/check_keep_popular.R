check_keep_popular <- function(one2one_strategy,
                               method,
                               mthreshold,
                               verbose=TRUE){
  if(one2one_strategy=="kp"){
    messager(paste0("one2one_strategy='keep_popular' selected.\n",
                    "Setting method='gprofiler' and 'mthreshold=1."),
             v=verbose)
    method <- "gprofiler"
    mthreshold <- 1
  }  
  return(list(mthreshold=mthreshold,
              method=method)) 
}