test_that("run_benchmark works", {
     
    ### Extract methods ####
    # args <- formals(orthogene:::run_benchmark)
    # method_list <- eval(args$method_list)
    method_list <- c("homologene",
                     "gprofiler",
                     "babelgene")
    bench_res <- orthogene:::run_benchmark(
        species = "fruit fly",
        method_list = method_list,
        run_convert_orthologs = TRUE,
        force = 2,
        mc.cores = 1
    )
     
    testthat::expect_equal(unique(bench_res$method),method_list)
    testthat::expect_equal(nrow(bench_res), length(method_list)*2)
    testthat::expect_equal(ncol(bench_res), 5)
    testthat::expect_gte(mean(bench_res$genes), 4000)
    testthat::expect_lte(mean(bench_res$time), 60)
})
