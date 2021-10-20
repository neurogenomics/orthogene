test_that("report_orthologs works", {
    n_genes <- function(dat) {
        length(unique(dat$map$Gene.Symbol))
    }

    run_tests <- function(method,
                          ...) {
        orth_mus <- report_orthologs(
            target_species = "mouse",
            reference_species = "human",
            method_all_genes = method,
            method_convert_orthologs = method,
            ...
        )
        orth_zeb <- report_orthologs(
            target_species = "zebrafish",
            reference_species = "human",
            method_all_genes = method,
            method_convert_orthologs = method,
            ...
        )
        orth_fly <- report_orthologs(
            target_species = "fly",
            reference_species = "human",
            method_all_genes = method,
            method_convert_orthologs = method,
            ...
        )
        orth_mus <- report_orthologs(
            target_species = "human",
            reference_species = "human",
            method_all_genes = method,
            method_convert_orthologs = method,
            ...
        )
        #### Tests ####
        expected_mouse <- if (method == "gprofiler") 16000 else 15000
        observed_mouse <- n_genes(orth_mus)
        testthat::expect_gte(observed_mouse, expected_mouse)

        expected_zeb <- if (method == "gprofiler") 7500 else 8000
        observed_zeb <- n_genes(orth_zeb)
        testthat::expect_gte(observed_zeb, expected_zeb)

        expected_fly <- if (method == "gprofiler") 550 else 500
        observed_fly <- n_genes(orth_fly)
        testthat::expect_gte(observed_fly, expected_fly)

        res <- data.frame(rbind(
            c(species = "mouse", expected = expected_mouse, observed = observed_mouse),
            c(species = "zebrafish", expected = expected_zeb, observed = observed_zeb),
            c(species = "fly", expected = expected_fly, observed = observed_fly)
        ))
        res <- cbind(method = method, res)
        return(res)
    }

    #### gprofiler tests ####
    # Takes a long time currently (hacky)
    # g_res <- run_tests(method="gprofiler")
    # mthreshold selects the most popular N ortholog mappings.
    # This helps reduce duplicates (and thus dropped non-1:1 genes),
    # resulting in higher observed gene yield.
    # But is this really an accurate reflection of the biology?...
    # g_res_m1 <- run_tests(method="gprofiler", mthreshold=1)
    # g_res_m3 <- run_tests(method="gprofiler", mthreshold=3)

    #### homologene tests ####
    h_res <- run_tests(method = "homologene")
})
