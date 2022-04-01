#' Plot benchmark: scatter
#'
#' Plot run time vs. # genes returned across species and
#' function tests.
#'
#' @param bench_res Results from
#' @param remove_failed_times In instances where
#' no genes were returned, set time to \code{NA}.
#' @param show_plot Print plot.
#' 
#' @returns ggplot object
#' 
#' @importFrom dplyr mutate
#' @importFrom ggpubr stat_cor
#' @importFrom methods show
#' @keywords internal
plot_benchmark_scatter <- function(bench_res,
                                   remove_failed_times = FALSE,
                                   show_plot = TRUE) {
    
    # Avoid confusing Biocheck
    genes <- time <- method <- NULL
    
    requireNamespace("ggplot2")
    if (remove_failed_times) {
        bench_res <- dplyr::mutate(bench_res,
            time = ifelse(genes == 0, NA, time)
        )
    }
    fill_colors <- method_fill_colors()
    point_plot <- ggplot2::ggplot(
        bench_res,
        ggplot2::aes(x = genes, y = time, color = method, fill = method)
    ) +
        ggplot2::geom_point() +
        ggplot2::geom_smooth(method = "lm") +
        ggpubr::stat_cor(
            label.x.npc = "right", label.y.npc = "bottom",
            hjust = 1
        ) +
        ggplot2::scale_fill_manual(values = fill_colors, drop = FALSE) +
        ggplot2::scale_color_manual(values = fill_colors, drop = FALSE) +
        ggplot2::facet_grid(
            facets = method ~ test,
            scales = "free"
        ) +
        ggplot2::labs(y = "time (seconds)") +
        ggplot2::theme_bw() +
        ggplot2::theme(strip.background = ggplot2::element_rect(fill = "white"))
    if (show_plot) methods::show(point_plot)
    return(point_plot)
}
