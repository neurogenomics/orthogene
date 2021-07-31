#' Plot benchmark: scatter
#' 
#' Plot run time vs. # genes returned across species and 
#' function tests.
#' 
#' @param bench_res Results from 
#' @param remove_failed_times In instances where 
#' no genes were returned, set time to \code{NA}.
#' @param show_plot Print plot.
#' @return ggplot object
#' @import ggplot2
#' @importFrom dplyr mutate
#' @importFrom ggpubr stat_cor
#' @keywords internal
plot_benchmark_scatter <- function(bench_res,
                                   remove_failed_times=FALSE,
                                   show_plot=TRUE){
  
  # Avoid confusing Biocheck
  genes <- time <- method <- NULL;
  
  if(remove_failed_times){
    bench_res <- dplyr::mutate(bench_res, 
                               time=ifelse(genes==0,NA,time))
  } 
  fill_colors <- c(gprofiler="orange",homologene="darkslateblue")
  point_plot <- ggplot(bench_res, aes(x=genes, y=time, color=method, fill=method)) + 
    geom_point() +
    geom_smooth(method="lm") + 
    ggpubr::stat_cor(label.x.npc="right", label.y.npc="bottom", hjust=1) + 
    scale_fill_manual(values = fill_colors, drop=FALSE) +
    scale_color_manual(values = fill_colors, drop=FALSE) + 
    facet_grid(facets = method~test, 
               scales = "free") +
    theme_bw() +
    theme(strip.background = element_rect(fill = "white"))
  if(show_plot) print(point_plot)
  return(point_plot)
}