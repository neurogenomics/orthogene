test_that("plot_benchmark_scatter works", {
    bench_res <- read.csv(system.file(package = "orthogene", "benchmark/bench_res_example.csv"))
    bench_scatterplot <- plot_benchmark_scatter(
        bench_res = bench_res,
        remove_failed_times = TRUE
    )
    testthat::expect_equal(methods::is(bench_scatterplot, "gg"), TRUE)
})
