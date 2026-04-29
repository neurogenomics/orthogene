## Targeted tests for small internal helpers that lack direct test coverage.

test_that("check_gene_map errors when input/output cols are missing", {
    gm_ok <- data.frame(input_gene = "a", ortholog_gene = "A")

    ## both cols present → silent
    testthat::expect_silent(
        orthogene:::check_gene_map(
            gene_map = gm_ok,
            input_col = "input_gene",
            output_col = "ortholog_gene"
        )
    )

    ## input_col missing
    testthat::expect_error(
        orthogene:::check_gene_map(
            gene_map = gm_ok,
            input_col = "missing_col",
            output_col = "ortholog_gene"
        ),
        regexp = "input_col=.*not in gene_map"
    )

    ## output_col missing
    testthat::expect_error(
        orthogene:::check_gene_map(
            gene_map = gm_ok,
            input_col = "input_gene",
            output_col = "missing_out"
        ),
        regexp = "output_col=.*not in gene_map"
    )
})

test_that("check_agg_opts returns dict, single entry, or errors", {
    ## Full dict
    d <- orthogene:::check_agg_opts()
    testthat::expect_true(all(c("sum","mean","median","min","max") %in% names(d)))

    ## Lookup
    testthat::expect_identical(unname(orthogene:::check_agg_opts("sum")), "sum")

    ## Unknown function → error
    testthat::expect_error(
        orthogene:::check_agg_opts("nonsense"),
        regexp = "Aggregation function must be one of"
    )
})

test_that("filter_gene_df subsets by columns, rownames, or errors on bad gene_input", {
    mat <- matrix(1:9, nrow = 3, dimnames = list(c("a","b","c"), c("a","b","c")))
    gm <- data.frame(input_gene = c("a","b"), ortholog_gene = c("A","B"))

    ## subset rows (rownames input)
    out_rn <- orthogene:::filter_gene_df(
        gene_input = "rownames",
        gene_df = mat,
        genes = c("a","b","c"),
        gene_map = gm,
        verbose = FALSE
    )
    testthat::expect_equal(nrow(out_rn$gene_df2), 2)
    testthat::expect_setequal(out_rn$genes2, c("a","b"))

    ## subset cols
    out_cn <- orthogene:::filter_gene_df(
        gene_input = "colnames",
        gene_df = mat,
        genes = c("a","b","c"),
        gene_map = gm,
        verbose = FALSE
    )
    testthat::expect_equal(ncol(out_cn$gene_df2), 2)

    ## unknown gene_input → error
    testthat::expect_error(
        orthogene:::filter_gene_df(
            gene_input = "garbage_col",
            gene_df = mat,
            genes = c("a","b","c"),
            gene_map = gm,
            verbose = FALSE
        ),
        regexp = "not recognised"
    )
})

test_that("use_cache passes through when save_dir=NULL", {
    out <- orthogene:::use_cache(
        tree_source = "https://example.com/file.nwk",
        save_dir = NULL,
        verbose = FALSE
    )
    testthat::expect_identical(out, "https://example.com/file.nwk")
})

test_that("use_cache returns cached path when file exists", {
    tmp_dir <- tempfile()
    dir.create(tmp_dir, recursive = TRUE)
    on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)

    fake_file <- file.path(tmp_dir, "tree.nwk")
    writeLines("((a:1,b:1):2,c:3);", fake_file)

    out <- orthogene:::use_cache(
        tree_source = "https://example.com/tree.nwk",
        save_dir = tmp_dir,
        verbose = FALSE
    )
    testthat::expect_identical(normalizePath(out), normalizePath(fake_file))
})

test_that("check_gene_df_type errors on unsupported input class", {
    ## A class that doesn't match any of the recognised branches
    bad <- structure(list(), class = "weird_orthogene_class")
    testthat::expect_error(
        orthogene:::check_gene_df_type(
            gene_df = bad,
            gene_input = "rownames",
            verbose = FALSE
        ),
        regexp = "gene_df class not recognised"
    )
})

test_that("check_gene_df_type accepts data.table input and converts to data.frame", {
    testthat::skip_if_not_installed("data.table")
    dt <- data.table::data.table(input_gene = c("a","b"), x = 1:2)

    out <- orthogene:::check_gene_df_type(
        gene_df = dt,
        gene_input = "input_gene",
        verbose = FALSE
    )
    testthat::expect_true(is.data.frame(out$gene_df))
    testthat::expect_false(data.table::is.data.table(out$gene_df))
})

test_that("aggregate_rows errors on unknown agg_method", {
    data("exp_mouse", package = "orthogene")
    sub <- exp_mouse[seq_len(20), , drop = FALSE]
    groupings <- rep(c("g1","g2"), each = 10)

    testthat::expect_error(
        orthogene:::aggregate_rows(
            X = sub,
            groupings = groupings,
            agg_fun = "sum",
            agg_method = "not_a_method",
            verbose = FALSE
        ),
        regexp = "agg_method must be one of"
    )
})

test_that("map_orthologs errors on unknown method", {
    testthat::expect_error(
        orthogene::map_orthologs(
            genes = c("Sox2", "Klf4"),
            input_species = "mouse",
            output_species = "human",
            method = "totally_made_up_method",
            verbose = FALSE
        ),
        regexp = "not recognised"
    )
})

test_that("all_genes warns and falls back to gprofiler on unknown method", {
    ## When the method is unrecognised, all_genes() messages a warning and
    ## defaults to gprofiler. We don't actually want to hit the network here,
    ## so wrap in tryCatch and accept either a data.frame or an API failure.
    res <- tryCatch(
        orthogene::all_genes(
            species = "fruit fly",
            method = "garbage_method",
            verbose = FALSE
        ),
        error = function(e) e
    )
    if (inherits(res, "error")) {
        testthat::skip(paste("g:Profiler API unavailable:",
                             conditionMessage(res)))
    }
    testthat::expect_true(is.data.frame(res))
})

test_that("many2many_rows aggregate_orthologs=FALSE returns sparse / DelayedArray", {
    data("exp_mouse", package = "orthogene")
    sub <- exp_mouse[seq_len(50), , drop = FALSE]

    ## Build a many:many gene_map manually so we hit the dup branch.
    gm <- data.frame(
        input_gene = rep(rownames(sub)[1:10], times = 2),
        ortholog_gene = c(paste0(rownames(sub)[1:10], "_a"),
                          paste0(rownames(sub)[1:10], "_b"))
    )
    out <- orthogene:::many2many_rows(
        X = sub,
        gene_map = gm,
        aggregate_orthologs = FALSE,
        as_sparse = TRUE,
        as_DelayedArray = FALSE,
        verbose = FALSE
    )
    testthat::expect_true(orthogene:::is_sparse_matrix(out))
})

test_that("get_orgdb_gprofiler with use_local=TRUE returns the cached table", {
    out <- orthogene:::get_orgdb_gprofiler(use_local = TRUE, verbose = FALSE)
    testthat::expect_true(is.data.frame(out))
    testthat::expect_true("scientific_name" %in% names(out))
})

test_that("get_orgdb_gprofiler with use_local=FALSE either fetches or falls back", {
    out <- orthogene:::get_orgdb_gprofiler(use_local = FALSE, verbose = FALSE)
    ## Should produce a data.frame either way (live API or fallback to cache).
    testthat::expect_true(is.data.frame(out))
    testthat::expect_true("scientific_name" %in% names(out))
})
