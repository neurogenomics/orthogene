#' Plot benchmark: bar
#'
#' Plot run time and # genes returned across species and
#' function tests.
#'
#' @param bench_res Results from
#' @param remove_failed_times In instances where
#' no genes were returned, set time to \code{NA}.
#' @param point_size Size of the shape above each bar.
#' @param show_plot Print plot.
#' @param point_mult Multiplier to place the point above the bar.
#'
#' @returns ggplot object
#' 
#' @importFrom dplyr mutate
#' @importFrom patchwork plot_annotation
#' @importFrom methods show
#' @keywords internal
plot_benchmark_bar <- function(bench_res,
                               remove_failed_times = TRUE,
                               point_size = 2,
                               point_mult = 1,
                               show_plot = TRUE) {
    # Avoid confusing Biocheck
    genes <- time <- species <- method <- test <- genes_point <- time_point <- 
        NULL;
    
    requireNamespace("ggplot2")
    
    if (remove_failed_times) {
        bench_res <- dplyr::mutate(bench_res,
                                   time = ifelse(genes == 0, NA, time)
        )
    }
    
    # Preserve ordering as it appears
    bench_res$species <- factor(bench_res$species, unique(bench_res$species), ordered = TRUE)
    bench_res$test    <- factor(bench_res$test,    unique(bench_res$test),    ordered = TRUE)
    
    fill_colors <- method_fill_colors()
    
    # Helper: compute an additive offset so even 0-valued bars get a point above them
    add_point_offsets <- function(df, y_col) {
        y <- df[[y_col]]
        ymax <- suppressWarnings(max(y, na.rm = TRUE))
        if (!is.finite(ymax) || is.na(ymax) || ymax == 0) {
            # fallback small constant when everything is 0/NA
            offset <- 1
        } else {
            # 3% of range; then apply the user multiplier on top
            offset <- 0.03 * ymax
        }
        df[[paste0(y_col, "_point")]] <- ifelse(is.na(y), NA, y * point_mult + offset)
        df
    }
    
    make_genes_plot <- function(df, title_suffix="Genes retrieved", show_x = FALSE) {
        ggplot2::ggplot(df, ggplot2::aes(x = species, y = genes, fill = method)) +
            ggplot2::scale_fill_manual(values = fill_colors, drop = FALSE) +
            ggplot2::scale_color_manual(values = fill_colors, drop = FALSE) +
            ggplot2::geom_bar(stat = "identity", position = "dodge", alpha = .7, show.legend = FALSE) +
            ggplot2::geom_point(
                ggplot2::aes(y = genes_point, color = method),
                position = ggplot2::position_dodge(width = .9),
                size = point_size,
                show.legend = FALSE
            ) +
            ggplot2::labs(title = as.character(title_suffix), x = NULL, y = "genes") +
            ggplot2::theme_bw() +
            ggplot2::theme(
                axis.text.x = if (isTRUE(show_x)) ggplot2::element_text(angle = 45, hjust = 1) else ggplot2::element_blank(),
                axis.ticks.x = if (isTRUE(show_x)) ggplot2::element_line() else ggplot2::element_blank(),
                strip.background = ggplot2::element_rect(fill = "white")
            ) +
            ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0, 0.12)))
    }
    
    make_time_plot <- function(df, title_suffix, show_x = TRUE) {
        ggplot2::ggplot(df, ggplot2::aes(x = species, y = time, fill = method)) +
            ggplot2::scale_fill_manual(values = fill_colors, drop = FALSE) +
            ggplot2::scale_color_manual(values = fill_colors, drop = FALSE) +
            ggplot2::geom_bar(stat = "identity", position = "dodge", alpha = .7) +
            ggplot2::geom_point(
                ggplot2::aes(y = time_point, color = method),
                position = ggplot2::position_dodge(width = .9),
                size = point_size,
                show.legend = FALSE
            ) +
            ggplot2::labs(title = as.character(title_suffix), x = NULL, y = "time (seconds)") +
            ggplot2::theme_bw() +
            ggplot2::theme(
                axis.text.x = if (isTRUE(show_x)) ggplot2::element_text(angle = 45, hjust = 1) else ggplot2::element_blank(),
                axis.ticks.x = if (isTRUE(show_x)) ggplot2::element_line() else ggplot2::element_blank(),
                strip.background = ggplot2::element_rect(fill = "white")
            ) +
            ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0, 0.12)))
    }
    
    tests <- levels(bench_res$test)
    if (length(tests) == 0) return(NULL)
    
    blocks <- vector("list", length(tests))
    for (i in seq_along(tests)) {
        tt <- tests[[i]]
        df_tt <- bench_res[bench_res$test == tt, , drop = FALSE]
        
        # compute offsets within-test
        df_tt <- add_point_offsets(df_tt, "genes")
        df_tt <- add_point_offsets(df_tt, "time")
        
        genes_p <- make_genes_plot(
            df_tt, 
            title_suffix = paste0(tt," : ","genes retrieved"), 
            show_x = FALSE)
        time_p  <- make_time_plot(
            df_tt, 
            title_suffix = paste0(tt," : ","time elapsed"), 
            show_x = TRUE)
        
        # genes on top, time on bottom
        blocks[[i]] <- genes_p / time_p
    }
    
    out <- patchwork::wrap_plots(blocks, ncol = 1) +
        patchwork::plot_layout(guides = "collect") &
        ggplot2::theme(legend.position = "bottom")
    
    out <- out + patchwork::plot_annotation(tag_levels = letters)
    
    if (show_plot) methods::show(out)
    out
}
