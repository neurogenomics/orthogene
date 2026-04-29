test_that("run_benchmark_once skips convert_orthologs when run_convert_orthologs=FALSE", {

    res <- orthogene:::run_benchmark_once(
        species = "fruit fly",
        method = "homologene",
        run_convert_orthologs = FALSE,
        force = 2,
        verbose = FALSE
    )
    testthat::expect_true(is.data.frame(res))
    testthat::expect_equal(nrow(res), 1L)
    testthat::expect_identical(res$test, "all_genes()")
})

test_that("run_benchmark_once returns a cached result when one exists", {

    ## Run once with force=FALSE to ensure cache is built. The first call may
    ## still write the cache (force is not strictly required — get_cache_save_path
    ## just looks for an existing file).
    res1 <- orthogene:::run_benchmark_once(
        species = "fruit fly",
        method = "homologene",
        run_convert_orthologs = FALSE,
        force = 2,
        verbose = FALSE
    )
    testthat::expect_true(is.data.frame(res1))

    ## Second call — cache hit path: file.exists(save_path) && isFALSE(force)
    res2 <- orthogene:::run_benchmark_once(
        species = "fruit fly",
        method = "homologene",
        run_convert_orthologs = FALSE,
        force = FALSE,
        verbose = FALSE
    )
    testthat::expect_true(is.data.frame(res2))
    ## Both returns describe the same all_genes() benchmark; assert
    ## structurally identical, ignoring any numeric jitter in `time`.
    testthat::expect_equal(res2$method, res1$method)
    testthat::expect_equal(res2$test, res1$test)
})

test_that("run_benchmark_once handles human species (within-species path)", {

    ## When species is human, non121_strategy is forced to "kbs" inside
    ## run_benchmark_once; this exercises the is_human(species) branch (line 73).
    res <- orthogene:::run_benchmark_once(
        species = "human",
        method = "homologene",
        run_convert_orthologs = TRUE,
        force = 2,
        verbose = FALSE
    )
    testthat::expect_true(is.data.frame(res))
    testthat::expect_equal(nrow(res), 2L)
    ## n_genes2 path: when input==output, gene_map2 may not have ortholog_gene,
    ## so the benchmark falls back to length(unique(gene_map2$Gene.Symbol)).
    testthat::expect_true(all(c("all_genes()", "convert_orthologs()") %in%
                              res$test))
})
