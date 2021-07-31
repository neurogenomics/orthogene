test_that("run_benchmark works", {
  bench_res <- run_benchmark(species_mapped ="dmelanogaster", 
                             run_convert_orthologs = TRUE, 
                             mc_cores = 1) 
  testthat::expect_equal(nrow(bench_res), 4)
  testthat::expect_equal(ncol(bench_res), 5)
  testthat::expect_gte(mean(bench_res$genes), 4000)
  testthat::expect_lte(mean(bench_res$time), 30)
})
