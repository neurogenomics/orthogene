## Tests for small utility helpers — checking branches we don't otherwise hit.

test_that("check_keep_popular forces gprofiler + mthreshold=1 when 'kp' is requested", {
    out <- orthogene:::check_keep_popular(
        one2one_strategy = "kp",
        method = "homologene",
        mthreshold = 5,
        verbose = FALSE
    )
    testthat::expect_identical(out$method, "gprofiler")
    testthat::expect_equal(out$mthreshold, 1)
})

test_that("check_keep_popular passes through args when strategy is not 'kp'", {
    out <- orthogene:::check_keep_popular(
        one2one_strategy = "dbs",
        method = "homologene",
        mthreshold = 5,
        verbose = FALSE
    )
    testthat::expect_identical(out$method, "homologene")
    testthat::expect_equal(out$mthreshold, 5)
})

test_that("check_sparseMatrix coerces gene_output for sparse + 'columns'", {
    sm <- Matrix::Matrix(matrix(0, 3, 3), sparse = TRUE)
    rownames(sm) <- c("a","b","c")

    ## sparse matrix + gene_output="columns" → gene_output coerced to gene_input
    out <- orthogene:::check_sparseMatrix(
        gene_df2 = sm,
        gene_input = "rownames",
        gene_output = "columns",
        verbose = FALSE
    )
    testthat::expect_identical(out, "rownames")
})

test_that("check_sparseMatrix is a no-op for non-sparse / non-'columns'", {
    mat <- matrix(0, 3, 3)
    out <- orthogene:::check_sparseMatrix(
        gene_df2 = mat,
        gene_input = "rownames",
        gene_output = "columns",
        verbose = FALSE
    )
    testthat::expect_identical(out, "columns")

    sm <- Matrix::Matrix(matrix(0, 3, 3), sparse = TRUE)
    out2 <- orthogene:::check_sparseMatrix(
        gene_df2 = sm,
        gene_input = "rownames",
        gene_output = "rownames",
        verbose = FALSE
    )
    testthat::expect_identical(out2, "rownames")
})

test_that("non121_strategy_opts returns the full dict when called with no arg", {
    all_opts <- orthogene:::non121_strategy_opts()
    testthat::expect_true(is.character(all_opts))
    testthat::expect_true("dbs" %in% names(all_opts))
    testthat::expect_true("kp" %in% names(all_opts))
})

test_that("non121_strategy_opts canonicalises common synonyms", {
    testthat::expect_identical(
        unname(orthogene:::non121_strategy_opts("drop_both_species")),
        "dbs"
    )
    testthat::expect_identical(
        unname(orthogene:::non121_strategy_opts("Drop Both Species")),
        "dbs"
    )
    testthat::expect_identical(
        unname(orthogene:::non121_strategy_opts(1)),
        "dbs"
    )
    testthat::expect_identical(
        unname(orthogene:::non121_strategy_opts("kp")),
        "kp"
    )
})

test_that("non121_strategy_opts errors clearly on unknown values", {
    testthat::expect_error(
        orthogene:::non121_strategy_opts("some_garbage"),
        regexp = "non121_strategy must be one of"
    )
})

test_that("non121_strategy_opts include_agg=TRUE adds aggregation opts to dict", {
    base_opts <- orthogene:::non121_strategy_opts(include_agg = FALSE)
    agg_opts  <- orthogene:::non121_strategy_opts(include_agg = TRUE)
    testthat::expect_gt(length(agg_opts), length(base_opts))
})

test_that("is_human handles common aliases", {
    testthat::expect_true(orthogene:::is_human("human"))
    testthat::expect_true(orthogene:::is_human("Homo sapiens"))
    testthat::expect_true(orthogene:::is_human("homo sapiens"))
    testthat::expect_true(orthogene:::is_human("9606"))
    testthat::expect_false(orthogene:::is_human("mouse"))
    testthat::expect_false(orthogene:::is_human("Mus musculus"))
})

test_that("is_matrix and is_sparse_matrix discriminate correctly", {
    sm <- Matrix::Matrix(matrix(0, 3, 3), sparse = TRUE)
    dm <- matrix(0, 3, 3)
    df <- data.frame(x = 1:3)

    testthat::expect_true(orthogene:::is_sparse_matrix(sm))
    testthat::expect_false(orthogene:::is_sparse_matrix(dm))
    testthat::expect_false(orthogene:::is_sparse_matrix(df))

    testthat::expect_true(orthogene:::is_matrix(dm))
    testthat::expect_false(orthogene:::is_matrix(df))
})

test_that("is_converted recognises a previously-converted gene_df", {
    not_yet <- data.frame(x = 1:3)
    converted <- data.frame(input_gene = letters[1:3],
                            ortholog_gene = LETTERS[1:3])
    testthat::expect_false(orthogene:::is_converted(not_yet, verbose = FALSE))
    testthat::expect_true(orthogene:::is_converted(converted, verbose = FALSE))
})

test_that("check_bool_args throws when any arg is non-logical", {
    ## valid call: all booleans
    testthat::expect_silent(
        orthogene:::check_bool_args(
            standardise_genes = TRUE,
            drop_nonorths = TRUE,
            as_sparse = FALSE,
            as_DelayedArray = FALSE,
            sort_rows = FALSE
        )
    )
    ## one non-logical → error, with a per-arg message
    testthat::expect_error(
        orthogene:::check_bool_args(
            standardise_genes = 1,
            drop_nonorths = TRUE,
            as_sparse = FALSE,
            as_DelayedArray = FALSE,
            sort_rows = FALSE
        ),
        regexp = "standardise_genes must be a boolean"
    )
    testthat::expect_error(
        orthogene:::check_bool_args(
            standardise_genes = TRUE,
            drop_nonorths = "yes",
            as_sparse = FALSE,
            as_DelayedArray = FALSE,
            sort_rows = FALSE
        ),
        regexp = "drop_nonorths must be a boolean"
    )
    testthat::expect_error(
        orthogene:::check_bool_args(
            standardise_genes = TRUE,
            drop_nonorths = TRUE,
            as_sparse = "no",
            as_DelayedArray = FALSE,
            sort_rows = FALSE
        ),
        regexp = "as_sparse must be a boolean"
    )
    testthat::expect_error(
        orthogene:::check_bool_args(
            standardise_genes = TRUE,
            drop_nonorths = TRUE,
            as_sparse = FALSE,
            as_DelayedArray = "no",
            sort_rows = FALSE
        ),
        regexp = "as_DelayedArray must be a boolean"
    )
    testthat::expect_error(
        orthogene:::check_bool_args(
            standardise_genes = TRUE,
            drop_nonorths = TRUE,
            as_sparse = FALSE,
            as_DelayedArray = FALSE,
            sort_rows = "no"
        ),
        regexp = "sort_rows must be a boolean"
    )
})

test_that("invert_dictionary swaps names and values", {
    d <- c(a = "x", b = "y", c = "z")
    inv <- orthogene:::invert_dictionary(d)
    testthat::expect_identical(unname(inv), c("a", "b", "c"))
    testthat::expect_identical(names(inv), c("x", "y", "z"))
})

test_that("methods_opts returns expected option groups", {
    gp <- orthogene:::methods_opts(gprofiler_opts = TRUE)
    hg <- orthogene:::methods_opts(homologene_opts = TRUE)
    bg <- orthogene:::methods_opts(babelgene_opts = TRUE)
    testthat::expect_true("gprofiler" %in% gp)
    testthat::expect_true("homologene" %in% hg)
    testthat::expect_true("babelgene" %in% bg)
})

test_that("gene_input_opts and gene_output_opts return expected option groups", {
    rn <- orthogene:::gene_input_opts(rownames_opts = TRUE)
    testthat::expect_true("rownames" %in% rn)
    out_rn <- orthogene:::gene_output_opts(rownames_opts = TRUE)
    testthat::expect_true("rownames" %in% out_rn)
})

test_that("check_agg_opts returns a non-empty character vector of aggregator names", {
    opts <- orthogene:::check_agg_opts()
    testthat::expect_true(is.character(opts))
    testthat::expect_true(length(opts) > 0)
    testthat::expect_true(any(c("sum","mean","median") %in% names(opts) |
                              c("sum","mean","median") %in% opts))
})
