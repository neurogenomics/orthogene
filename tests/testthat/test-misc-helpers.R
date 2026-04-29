## Misc small helpers without dedicated test files.

test_that("is_gha detects GITHUB_ACTION env var", {
    ## Save current state and restore
    old <- Sys.getenv("GITHUB_ACTION", unset = NA)
    on.exit({
        if (is.na(old)) Sys.unsetenv("GITHUB_ACTION")
        else Sys.setenv(GITHUB_ACTION = old)
    }, add = TRUE)

    Sys.unsetenv("GITHUB_ACTION")
    testthat::expect_false(orthogene:::is_gha(verbose = FALSE))

    Sys.setenv(GITHUB_ACTION = "fake-action")
    testthat::expect_true(orthogene:::is_gha(verbose = FALSE))
})

test_that("load_rda loads a local .rda file", {
    foo <- list(a = 1, b = 2)
    f <- tempfile(fileext = ".rda")
    save(foo, file = f)
    on.exit(unlink(f), add = TRUE)

    out <- orthogene:::load_rda(f, verbose = FALSE)
    testthat::expect_identical(out, foo)
})

test_that("rotate_clades rotates a node by clade tip set", {
    testthat::skip_if_not_installed("ape")
    testthat::skip_if_not_installed("phytools")

    nwk <- "((A:1,B:1):2,(C:1,D:1):2);"
    tr <- ape::read.tree(text = nwk)
    rotated <- orthogene:::rotate_clades(tr, clades = list(c("A","B")))
    testthat::expect_true(methods::is(rotated, "phylo"))
    testthat::expect_setequal(rotated$tip.label, tr$tip.label)
})

test_that("rotate_clades is a no-op when clade tips don't match the tree", {
    testthat::skip_if_not_installed("ape")
    testthat::skip_if_not_installed("phytools")

    nwk <- "((A:1,B:1):2,(C:1,D:1):2);"
    tr <- ape::read.tree(text = nwk)
    rotated <- orthogene:::rotate_clades(tr, clades = list(c("X","Y")))
    testthat::expect_identical(rotated$tip.label, tr$tip.label)
})

test_that("aggregate_rows_monocle3 supports 'mean' and 'count' aggregation", {
    testthat::skip_if_not_installed("Matrix")

    set.seed(1)
    m <- Matrix::Matrix(matrix(c(1,2,3, 4,5,6, 7,8,9, 10,11,12),
                               nrow = 4, byrow = TRUE), sparse = TRUE)
    rownames(m) <- c("g1","g2","g1","g2")  # duplicates → mean over 2 rows each
    colnames(m) <- paste0("c", 1:3)
    groupings <- rownames(m)

    ## mean: should equal (sum / count) per group. Result is a Matrix; coerce
    ## to a plain vector for comparison.
    res_mean <- orthogene:::aggregate_rows_monocle3(
        x = m, groupings = groupings, fun = "mean"
    )
    testthat::expect_equal(as.vector(as.matrix(res_mean["g1", , drop = FALSE])),
                           c((1+7)/2, (2+8)/2, (3+9)/2))
    testthat::expect_equal(as.vector(as.matrix(res_mean["g2", , drop = FALSE])),
                           c((4+10)/2, (5+11)/2, (6+12)/2))

    ## count: zero entries are 0, non-zero are 1, then summed
    m_sparse <- Matrix::Matrix(matrix(c(1,0,3, 0,5,0, 7,0,9, 0,11,0),
                               nrow = 4, byrow = TRUE), sparse = TRUE)
    rownames(m_sparse) <- c("g1","g2","g1","g2")
    colnames(m_sparse) <- paste0("c", 1:3)
    res_cnt <- orthogene:::aggregate_rows_monocle3(
        x = m_sparse, groupings = rownames(m_sparse), fun = "count"
    )
    testthat::expect_equal(as.vector(as.matrix(res_cnt["g1", , drop = FALSE])),
                           c(2, 0, 2))
    testthat::expect_equal(as.vector(as.matrix(res_cnt["g2", , drop = FALSE])),
                           c(0, 2, 0))
})

test_that("get_cache_save_path constructs a unique path per fn/species/method", {
    p1 <- orthogene:::get_cache_save_path(
        fn = "all_genes", species = "human", method = "homologene"
    )
    p2 <- orthogene:::get_cache_save_path(
        fn = "all_genes", species = "mouse",  method = "homologene"
    )
    p3 <- orthogene:::get_cache_save_path(
        fn = "all_genes", species = "human", method = "babelgene"
    )
    testthat::expect_true(grepl("human", p1))
    testthat::expect_true(grepl("mouse", p2))
    testthat::expect_true(p1 != p2)
    testthat::expect_true(p1 != p3)
})

test_that("cache_dir creates and returns the package cache dir", {
    p <- orthogene:::cache_dir()
    testthat::expect_true(dir.exists(p))
    testthat::expect_true(grepl("orthogene", p))
})

test_that("messager respects v=FALSE", {
    out <- testthat::capture_messages(orthogene:::messager("hello", v = FALSE))
    testthat::expect_length(out, 0)

    out2 <- testthat::capture_messages(orthogene:::messager("hello", v = TRUE))
    testthat::expect_match(out2, "hello", all = FALSE)
})

test_that("format_species standardises common species names", {
    out <- orthogene::format_species(
        species = c("Homo sapiens", "Mus musculus"),
        replace_char = "_"
    )
    testthat::expect_true(any(grepl("homo_sapiens|Homo_sapiens", out,
                                    ignore.case = TRUE)))
})

test_that("all_species returns a non-empty data.frame for at least one method", {
    a <- tryCatch(orthogene::all_species(method = "homologene"),
                  error = function(e) e)
    if (inherits(a, "error")) {
        testthat::skip(paste("all_species failed:", conditionMessage(a)))
    }
    testthat::expect_true(is.data.frame(a))
    testthat::expect_gt(nrow(a), 0)
})

test_that("check_gene_output errors on unsupported value", {
    testthat::expect_silent(orthogene:::check_gene_output("rownames"))
    testthat::expect_silent(orthogene:::check_gene_output("dict"))
    testthat::expect_silent(orthogene:::check_gene_output("columns"))
    testthat::expect_error(
        orthogene:::check_gene_output("garbage_target"),
        regexp = "gene_output must be one of"
    )
})

test_that("gconvert_target_opts validates target for known species", {
    ## Returns target uppercase when species isn't in the namespace dict
    out <- orthogene:::gconvert_target_opts(target = "ENSG", species = "yeti")
    testthat::expect_identical(out, "ENSG")

    ## When species is in the dict, validates target
    out2 <- orthogene:::gconvert_target_opts(target = "ENSG", species = "human")
    testthat::expect_identical(out2, "ENSG")

    ## Invalid target for human → error
    testthat::expect_error(
        orthogene:::gconvert_target_opts(target = "NOT_A_TARGET", species = "human"),
        regexp = "target must be one of"
    )
})

test_that("add_rowcol_names sets rownames or colnames using an orth_dict", {
    ## add_rowcol_names(gene_df2, orth_dict, genes2, gene_output, ...)
    m <- matrix(1:6, nrow = 2,
                dimnames = list(c("Sox2","Klf4"), c("s1","s2","s3")))
    orth_dict <- c(Sox2 = "SOX2", Klf4 = "KLF4")

    out_rn <- orthogene:::add_rowcol_names(
        gene_df2 = m,
        orth_dict = orth_dict,
        genes2 = c("Sox2","Klf4"),
        gene_output = "rownames",
        verbose = FALSE
    )
    ## rownames(<-)(orth_dict[genes2]) keeps the names attribute, so the
    ## resulting rownames is a named character vector. Compare unnamed.
    testthat::expect_identical(unname(rownames(out_rn)), c("SOX2","KLF4"))

    ## colnames branch — pass a 3-col matrix so colnames have the right length
    m2 <- matrix(1:6, nrow = 2,
                 dimnames = list(c("r1","r2"), c("Sox2","Klf4","Pou5f1")))
    orth_dict2 <- c(Sox2 = "SOX2", Klf4 = "KLF4", Pou5f1 = "POU5F1")
    out_cn <- orthogene:::add_rowcol_names(
        gene_df2 = m2,
        orth_dict = orth_dict2,
        genes2 = c("Sox2","Klf4","Pou5f1"),
        gene_output = "colnames",
        verbose = FALSE
    )
    testthat::expect_identical(unname(colnames(out_cn)), c("SOX2","KLF4","POU5F1"))
})
