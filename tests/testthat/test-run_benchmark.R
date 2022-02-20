test_that("run_benchmark works", {
    
    bench_res <- orthogene:::run_benchmark(
        species = "fruit fly",
        run_convert_orthologs = TRUE,
        mc.cores = 1
    )
    # args <- formals(orthogene:::run_benchmark)
    testthat::expect_equal(nrow(bench_res), 6)
    testthat::expect_equal(ncol(bench_res), 5)
    testthat::expect_gte(mean(bench_res$genes), 4000)
    testthat::expect_lte(mean(bench_res$time), 30)
})
