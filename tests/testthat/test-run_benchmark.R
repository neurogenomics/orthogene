test_that("run_benchmark works", {
    
    bench_res <- orthogene:::run_benchmark(
        species = "fruit fly",
        run_convert_orthologs = TRUE,
        mc.cores = 1
    )
    
    ### Extract methods ####
    args <- formals(orthogene:::run_benchmark)
    method_list <- eval(args$method_list)
    
    testthat::expect_equal(unique(bench_res$method),method_list)
    testthat::expect_equal(nrow(bench_res), length(method_list)*2)
    testthat::expect_equal(ncol(bench_res), 5)
    testthat::expect_gte(mean(bench_res$genes), 4000)
    testthat::expect_lte(mean(bench_res$time), 30)
})
