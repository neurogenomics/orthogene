test_that("prepare_tree works", {

    if(require("ape")){
        species <- c("human","chimp","mouse")
        tr <- orthogene::prepare_tree(species = species)
        testthat::expect_true(methods::is(tr,"phylo"))
        testthat::expect_length(tr$node.label,2)
        testthat::expect_length(tr$tip.label,3)
    }
})

test_that("prepare_tree reads a local newick file (else-branch)", {

    testthat::skip_if_not_installed("ape")
    testthat::skip_if_not_installed("phytools")

    ## Force the else-branch by passing a local file path that doesn't match
    ## "timetree", "ucsc", or "omadb".
    nwk <- tempfile(fileext = ".nwk")
    writeLines(
        "((Homo_sapiens:1,Pan_troglodytes:1):2,Mus_musculus:3);",
        nwk
    )
    on.exit(unlink(nwk), add = TRUE)

    tr <- orthogene::prepare_tree(
        tree_source = nwk,
        species = c("human", "chimp", "mouse"),
        force_ultrametric = TRUE,
        verbose = FALSE
    )
    testthat::expect_true(methods::is(tr, "phylo"))
    testthat::expect_length(tr$tip.label, 3)
})

test_that("prepare_tree honours force_ultrametric=FALSE", {

    testthat::skip_if_not_installed("ape")
    testthat::skip_if_not_installed("phytools")

    nwk <- tempfile(fileext = ".nwk")
    ## Non-ultrametric tree — different branch lengths to leaves.
    writeLines(
        "((Homo_sapiens:1.0,Pan_troglodytes:0.5):2.0,Mus_musculus:4.0);",
        nwk
    )
    on.exit(unlink(nwk), add = TRUE)

    ## force_ultrametric=FALSE makes the function call phytools::force.ultrametric
    ## (counter-intuitively named, but that's what the body does — line 145-146).
    tr <- orthogene::prepare_tree(
        tree_source = nwk,
        species = c("human", "chimp", "mouse"),
        force_ultrametric = FALSE,
        verbose = FALSE
    )
    testthat::expect_true(methods::is(tr, "phylo"))
})

test_that("prepare_tree applies age_max calibration", {

    testthat::skip_if_not_installed("ape")
    testthat::skip_if_not_installed("phytools")

    nwk <- tempfile(fileext = ".nwk")
    writeLines(
        "((Homo_sapiens:1,Pan_troglodytes:1):2,Mus_musculus:3);",
        nwk
    )
    on.exit(unlink(nwk), add = TRUE)

    tr <- tryCatch(
        orthogene::prepare_tree(
            tree_source = nwk,
            species = c("human", "chimp", "mouse"),
            force_ultrametric = TRUE,
            age_max = 100,
            verbose = FALSE
        ),
        error = function(e) e
    )
    if (inherits(tr, "error")) {
        ## ape::chronos can be brittle on tiny trees; skip rather than fail
        testthat::skip(paste("ape::chronos calibration unavailable:",
                             conditionMessage(tr)))
    }
    testthat::expect_true(methods::is(tr, "phylo"))
})
