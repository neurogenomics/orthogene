#' Plot benchmark: bar
#'
#' Plot run time and # genes returned across species and
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
#' @importFrom patchwork plot_annotation
#' @importFrom methods show
#' @keywords internal
plot_benchmark_bar <- function(bench_res,
                               remove_failed_times = FALSE,
                               show_plot = TRUE) {

    # Avoid confusing Biocheck
    genes <- time <- species <- method <- test <- NULL
    requireNamespace("ggplot2")
    #### Remove time that failed entirely ####
    if (remove_failed_times) {
        bench_res <- dplyr::mutate(bench_res,
            time = ifelse(genes == 0, NA, time)
        )
    }
    #### Factorise to keep order ####
    bench_res$species <- factor(bench_res$species,
        unique(bench_res$species),
        ordered = TRUE
    )
    fill_colors <- method_fill_colors()

    time_plot <- ggplot2::ggplot(
        bench_res,
        ggplot2::aes(
            x = species, y = time,
            fill = method, shape = test
        )
    ) +
        ggplot2::scale_fill_manual(values = fill_colors, drop = FALSE) +
        ggplot2::scale_color_manual(values = fill_colors, drop = FALSE) +
        ggplot2::geom_bar(stat = "identity", position = "dodge", alpha = .7) +
        ggplot2::geom_point(ggplot2::aes(color = method),
            position = ggplot2::position_dodge(width = .9),
            size = 3, show.legend = FALSE
        ) +
        ggplot2::facet_grid(rows =  ggplot2::vars(test), 
                            scales = "free") +
        ggplot2::labs(title = "Run time by method", x = NULL, y = "time (seconds)") +
        ggplot2::theme_bw() +
        ggplot2::theme(
            axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
            strip.background = ggplot2::element_rect(fill = "white"),
            legend.position = "bottom"
        )

    genes_plot <- ggplot2::ggplot(
        bench_res,
        ggplot2::aes(
            x = species, y = genes,
            fill = method, shape = test
        )
    ) +
        ggplot2::scale_fill_manual(values = fill_colors, drop = FALSE) +
        ggplot2::scale_color_manual(values = fill_colors, drop = FALSE) +
        ggplot2::geom_bar(
            stat = "identity", position = "dodge", alpha = .7,
            show.legend = FALSE
        ) +
        ggplot2::geom_point(ggplot2::aes(color = method),
            position = ggplot2::position_dodge(width = .9),
            size = 3, show.legend = FALSE
        ) +
        ggplot2::facet_grid(rows = ggplot2::vars(test), 
                            scales = "free") +
        ggplot2::labs(title = "Genes retrieved by method") +
        ggplot2::theme_bw() +
        ggplot2::theme(
            axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
            strip.background = ggplot2::element_rect(fill = "white")
        )

    all_genes_plots <- (time_plot / genes_plot) +
        patchwork::plot_annotation(tag_levels = letters)
    if (show_plot) methods::show(all_genes_plots)
    return(all_genes_plots)
}
