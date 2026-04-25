test_that("all_genes_gprofiler works", {

    genes <- tryCatch(
        orthogene:::all_genes_gprofiler(species = "dmelanogaster",
                                        force = TRUE),
        error = function(e) e
    )
    if (inherits(genes, "error")) {
        testthat::skip(paste("g:Profiler API unavailable:",
                             conditionMessage(genes)))
    }
    message(nrow(genes))
    testthat::expect_gte(nrow(genes), 4000)

    genes <- orthogene:::all_genes_gprofiler(species = "dmelanogaster",
                                             force = FALSE)
    message(nrow(genes))
    testthat::expect_gte(nrow(genes), 4000)
})
