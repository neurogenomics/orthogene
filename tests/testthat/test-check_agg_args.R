test_that("check_agg_args returns args list when aggregation requested", {

    data("exp_mouse")
    mat <- as.matrix(exp_mouse)

    ## Happy path: aggregation requested with valid args
    out <- orthogene:::check_agg_args(
        gene_df = mat,
        agg_fun = "sum",
        gene_input = "rownames",
        gene_output = "rownames",
        drop_nonorths = TRUE,
        return_args = TRUE,
        verbose = FALSE
    )
    testthat::expect_identical(out$agg_fun, "sum")
    testthat::expect_identical(out$gene_input, "rownames")
    testthat::expect_identical(out$gene_output, "rownames")
    testthat::expect_true(out$drop_nonorths)
})

test_that("check_agg_args clears agg_fun when gene_df is non-matrix", {

    df <- data.frame(x = 1:5, y = letters[1:5])

    ## A data.frame triggers the class_check failure → agg_fun set to NULL
    out <- orthogene:::check_agg_args(
        gene_df = df,
        agg_fun = "sum",
        gene_input = "rownames",
        gene_output = "rownames",
        drop_nonorths = TRUE,
        return_args = TRUE,
        verbose = FALSE
    )
    testthat::expect_null(out$agg_fun)
})

test_that("check_agg_args clears agg_fun when gene_input is not 'rownames'", {

    data("exp_mouse")
    mat <- as.matrix(exp_mouse)

    out <- orthogene:::check_agg_args(
        gene_df = mat,
        agg_fun = "sum",
        gene_input = "colnames",
        gene_output = "rownames",
        drop_nonorths = TRUE,
        return_args = TRUE,
        verbose = FALSE
    )
    testthat::expect_null(out$agg_fun)
})

test_that("check_agg_args coerces gene_output to 'rownames' when it isn't", {

    data("exp_mouse")
    mat <- as.matrix(exp_mouse)

    out <- orthogene:::check_agg_args(
        gene_df = mat,
        agg_fun = "sum",
        gene_input = "rownames",
        gene_output = "columns",
        drop_nonorths = TRUE,
        return_args = TRUE,
        verbose = FALSE
    )
    ## When all other constraints are met but gene_output != 'rownames',
    ## the function rewrites gene_output to 'rownames' and keeps agg_fun.
    testthat::expect_identical(out$gene_output, "rownames")
    testthat::expect_identical(out$agg_fun, "sum")
})

test_that("check_agg_args returns FALSE/list when no aggregation requested", {

    data("exp_mouse")
    mat <- as.matrix(exp_mouse)

    ## return_args=FALSE → bare logical
    flag <- orthogene:::check_agg_args(
        gene_df = mat,
        agg_fun = NULL,
        gene_input = "rownames",
        gene_output = "rownames",
        drop_nonorths = TRUE,
        return_args = FALSE,
        verbose = FALSE
    )
    testthat::expect_false(flag)

    ## return_args=TRUE → list with original args
    out <- orthogene:::check_agg_args(
        gene_df = mat,
        agg_fun = NULL,
        gene_input = "rownames",
        gene_output = "rownames",
        drop_nonorths = TRUE,
        return_args = TRUE,
        verbose = FALSE
    )
    testthat::expect_null(out$agg_fun)
    testthat::expect_identical(out$gene_input, "rownames")
})

test_that("check_agg_args returns all_clear logical when return_args=FALSE and aggregation valid", {

    data("exp_mouse")
    mat <- as.matrix(exp_mouse)

    flag <- orthogene:::check_agg_args(
        gene_df = mat,
        agg_fun = "sum",
        gene_input = "rownames",
        gene_output = "rownames",
        drop_nonorths = TRUE,
        return_args = FALSE,
        verbose = FALSE
    )
    testthat::expect_true(flag)
})
