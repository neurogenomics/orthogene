test_that("plot_benchmark_bar works", {
  bench_res <- read.csv(system.file(package = "orthogene","benchmark/bench_res_example.csv"))
  bench_barplot <- plot_benchmark_bar(bench_res = bench_res, 
                                      remove_failed_times = TRUE)
  testthat::expect_equal(methods::is(bench_barplot,"patchwork"),TRUE)
})
