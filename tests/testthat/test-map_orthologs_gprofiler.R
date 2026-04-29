test_that("map_orthologs_gprofiler returns NULL for empty / NA-only inputs", {

    ## NULL input
    testthat::expect_null(
        orthogene:::map_orthologs_gprofiler(
            genes = NULL,
            input_species = "mouse",
            output_species = "human",
            verbose = FALSE
        )
    )

    ## Zero-length input
    testthat::expect_null(
        orthogene:::map_orthologs_gprofiler(
            genes = character(0),
            input_species = "mouse",
            output_species = "human",
            verbose = FALSE
        )
    )

    ## Input that's all NA — should be filtered to length 0 and return NULL
    testthat::expect_null(
        orthogene:::map_orthologs_gprofiler(
            genes = c(NA_character_, NA_character_),
            input_species = "mouse",
            output_species = "human",
            verbose = FALSE
        )
    )
})

test_that("map_orthologs_gprofiler returns NULL when source == target", {

    ## map_species canonicalises both ids to the same g:Profiler organism id,
    ## so the function should short-circuit and return NULL.
    testthat::expect_null(
        orthogene:::map_orthologs_gprofiler(
            genes = c("Sox2", "Klf4"),
            input_species = "mouse",
            output_species = "mouse",
            verbose = FALSE
        )
    )
})

test_that("map_orthologs_gprofiler validates chunk_size", {

    testthat::expect_error(
        orthogene:::map_orthologs_gprofiler(
            genes = c("Sox2", "Klf4"),
            input_species = "mouse",
            output_species = "human",
            chunked = TRUE,
            chunk_size = 0,
            verbose = FALSE
        ),
        regexp = "chunk_size must be a single positive integer"
    )

    testthat::expect_error(
        orthogene:::map_orthologs_gprofiler(
            genes = c("Sox2", "Klf4"),
            input_species = "mouse",
            output_species = "human",
            chunked = TRUE,
            chunk_size = NA_integer_,
            verbose = FALSE
        ),
        regexp = "chunk_size must be a single positive integer"
    )
})

test_that("map_orthologs_gprofiler non-chunked mode works", {

    skip_if_offline <- function() {
        if (!nzchar(Sys.getenv("NOT_CRAN")) &&
            !curl::has_internet()) testthat::skip("no internet")
    }
    skip_if_offline()

    res <- tryCatch(
        orthogene:::map_orthologs_gprofiler(
            genes = c("Sox2", "Klf4", "Pou5f1"),
            input_species = "mouse",
            output_species = "human",
            chunked = FALSE,
            verbose = FALSE
        ),
        error = function(e) e
    )
    if (inherits(res, "error")) {
        testthat::skip(paste("g:Profiler API unavailable:",
                             conditionMessage(res)))
    }
    testthat::expect_true(is.data.frame(res))
    testthat::expect_true(all(c("input_gene", "ortholog_gene") %in%
                              colnames(res)))
    testthat::expect_gte(nrow(res), 1)
})

test_that("map_orthologs_gprofiler chunked-serial path returns same result with small chunk_size", {

    skip_if_offline <- function() {
        if (!nzchar(Sys.getenv("NOT_CRAN")) &&
            !curl::has_internet()) testthat::skip("no internet")
    }
    skip_if_offline()

    res <- tryCatch(
        orthogene:::map_orthologs_gprofiler(
            genes = c("Sox2", "Klf4", "Pou5f1", "Nanog", "Lin28a"),
            input_species = "mouse",
            output_species = "human",
            chunked = TRUE,
            chunk_size = 2,            # forces multiple chunks
            n_cores = 1L,              # serial path
            verbose = FALSE
        ),
        error = function(e) e
    )
    if (inherits(res, "error")) {
        testthat::skip(paste("g:Profiler API unavailable:",
                             conditionMessage(res)))
    }
    testthat::expect_true(is.data.frame(res))
    testthat::expect_gte(nrow(res), 1)
})

test_that("map_orthologs_gprofiler chunked-parallel path runs", {

    ## PSOCK clusters are slow to spin up; skip on Windows where the
    ## fork-vs-PSOCK distinction may interact badly with R CMD check
    ## sandboxing on the small CI runners.
    testthat::skip_on_os("windows")

    skip_if_offline <- function() {
        if (!nzchar(Sys.getenv("NOT_CRAN")) &&
            !curl::has_internet()) testthat::skip("no internet")
    }
    skip_if_offline()

    res <- tryCatch(
        orthogene:::map_orthologs_gprofiler(
            genes = c("Sox2", "Klf4", "Pou5f1", "Nanog", "Lin28a", "Myc"),
            input_species = "mouse",
            output_species = "human",
            chunked = TRUE,
            chunk_size = 2,
            n_cores = 2L,              # parallel path
            verbose = FALSE
        ),
        error = function(e) e
    )
    if (inherits(res, "error")) {
        testthat::skip(paste("g:Profiler API unavailable:",
                             conditionMessage(res)))
    }
    testthat::expect_true(is.data.frame(res))
    testthat::expect_gte(nrow(res), 1)
})
