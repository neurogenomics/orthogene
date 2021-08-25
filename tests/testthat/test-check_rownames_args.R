test_that("check_rownames_args works", {
    out <- check_rownames_args(
        gene_output = "rownames",
        drop_nonorths = TRUE,
        non121_strategy = "dbs"
    )
    testthat::expect_equal(length(out), 3)

    out <- check_rownames_args(
        gene_output = "rownames",
        drop_nonorths = FALSE,
        non121_strategy = "dbs"
    )
    testthat::expect_equal(out$drop_nonorths, TRUE)

    out <- check_rownames_args(
        gene_output = "rownames",
        drop_nonorths = TRUE,
        non121_strategy = "kbs"
    )
    testthat::expect_equal(out$drop_nonorths, TRUE)

    testthat::expect_error(
        out <- check_rownames_args(
            gene_output = "rownames",
            drop_nonorths = TRUE,
            non121_strategy = "dbsTYPO"
        )
    )
})
