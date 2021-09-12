# aggregate_rows_benchmark <- function(){
#   #### Benchmark ####
#   data("exp_mouse")
#   X <- exp_mouse
#   gene_map <- map_genes(genes = rownames(X), 
#                         species = "mouse",  
#                         mthreshold = 1) 
#   groupings <- gene_map$name
#   
#   bench <- microbenchmark::microbenchmark( 
#     X_stats=orthogene:::aggregate_rows(X=X,
#                              groupings = groupings,
#                              method = "stats"),
#     X_monocle3=orthogene:::aggregate_rows(X=X,
#                                 groupings = groupings,
#                                 method="monocle3"), 
#     times = 100
#   )
#   
#   # bench$time[1]/bench$time[2]
#   
#   # library(ggplot2)
#   # library(dplyr)
#   gp <- ggplot(data = data.frame(bench) %>%
#            dplyr::rename(method="expr"), 
#          aes(x=method, y=time, fill=method)) +
#     geom_bar(stat="identity") +
#     theme_bw()
#   print(gp)
# }