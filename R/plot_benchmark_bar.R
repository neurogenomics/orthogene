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
#' @return ggplot object
#' @import ggplot2
#' @importFrom dplyr mutate
#' @importFrom patchwork plot_annotation
#' @keywords internal
plot_benchmark_bar <- function(bench_res,
                               remove_failed_times = FALSE,
                               show_plot = TRUE) {

    # Avoid confusing Biocheck
    genes <- time <- species <- method <- test <- NULL

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
    fill_colors <- c(gprofiler = "orange", homologene = "darkslateblue")

    time_plot <- ggplot(
        bench_res,
        aes(
            x = species, y = time,
            fill = method, shape = test
        )
    ) +
        scale_fill_manual(values = fill_colors, drop = FALSE) +
        scale_color_manual(values = fill_colors, drop = FALSE) +
        geom_bar(stat = "identity", position = "dodge", alpha = .7) +
        geom_point(aes(color = method),
            position = position_dodge(width = .9),
            size = 3, show.legend = FALSE
        ) +
        facet_grid(facets = test ~ ., scales = "free") +
        labs(title = "Run time by method", x = NULL, y = "time (seconds)") +
        theme_bw() +
        theme(
            axis.text.x = element_text(angle = 45, hjust = 1),
            strip.background = element_rect(fill = "white"),
            legend.position = "bottom"
        )

    genes_plot <- ggplot(
        bench_res,
        aes(
            x = species, y = genes,
            fill = method, shape = test
        )
    ) +
        scale_fill_manual(values = fill_colors, drop = FALSE) +
        scale_color_manual(values = fill_colors, drop = FALSE) +
        geom_bar(
            stat = "identity", position = "dodge", alpha = .7,
            show.legend = FALSE
        ) +
        geom_point(aes(color = method),
            position = position_dodge(width = .9),
            size = 3, show.legend = FALSE
        ) +
        facet_grid(facets = test ~ ., scales = "free") +
        labs(title = "Genes retrieved by method") +
        theme_bw() +
        theme(
            axis.text.x = element_text(angle = 45, hjust = 1),
            strip.background = element_rect(fill = "white")
        )

    all_genes_plots <- (time_plot / genes_plot) +
        patchwork::plot_annotation(tag_levels = letters)
    if (show_plot) print(all_genes_plots)
    return(all_genes_plots)
}
