report_gene_map <- function(gene_df2,
                            n_input_genes,
                            n_output_genes,
                            report_dropped = TRUE,
                            report_remaining = TRUE,
                            func_name = "convert_orthologs",
                            verbose = TRUE) {
    n_dropped <- n_input_genes - n_output_genes
    messager("\n=========== REPORT SUMMARY ===========\n")
    if (report_dropped) {
        messager("Total genes dropped after", func_name, ":\n  ",
            formatC(n_dropped, big.mark = ","), "/",
            formatC(n_input_genes, big.mark = ","),
            paste0("(", format(n_dropped / n_input_genes * 100,
                digits = 2
            ), "%)"),
            v = verbose
        )
    }
    if (report_remaining) {
        messager("Total genes remaining after", func_name, ":\n  ",
            formatC(n_output_genes, big.mark = ","), "/",
            formatC(n_input_genes, big.mark = ","),
            paste0(
                "(",
                format(n_output_genes / n_input_genes * 100,
                    digits = 2
                ), "%)"
            ),
            v = verbose
        )
    }
}
