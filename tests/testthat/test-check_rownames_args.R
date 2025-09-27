test_that("check_rownames_args works", {
    out <- orthogene:::check_rownames_args(
        gene_output = "rownames",
        drop_nonorths = TRUE,
        non121_strategy = "dbs",
        as_sparse = FALSE
    )
    testthat::expect_equal(length(out), 4)

    out <- orthogene::: check_rownames_args(
        gene_output = "rownames",
        drop_nonorths = FALSE,
        non121_strategy = "dbs",
        as_sparse = FALSE
    )
    testthat::expect_equal(out$as_sparse, TRUE)

    out <- orthogene:::check_rownames_args(
        gene_output = "rownames",
        drop_nonorths = TRUE,
        non121_strategy = "kbs",
        as_sparse = FALSE
    )
    testthat::expect_equal(out$as_sparse, FALSE)

    testthat::expect_error(
        out <- orthogene:::check_rownames_args(
            gene_output = "rownames",
            drop_nonorths = TRUE,
            non121_strategy = "dbsTYPO",
            as_sparse = FALSE
        )
    )
})
