test_that("report_orthologs works", {
    
    n_genes <- function(dat) {
        cols <- c("input_gene","Gene.Symbol")
        col <- cols[cols %in% names(dat$map)]
        length(unique(dat$map[[col]]))
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
        orth_hum <- report_orthologs(
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
        
        expected_zeb <- if (method %in% c("gprofiler","babelgene")) 7500 else 10000
        observed_zeb <- n_genes(orth_zeb)
        testthat::expect_gte(observed_zeb, expected_zeb)
        
        expected_fly <- if (method == "gprofiler") {
            600
        } else if(method == "homologene") {
            4000
        } else if(method == "babelgene") {
            3200
        }
        observed_fly <- n_genes(orth_fly)
        testthat::expect_gte(observed_fly, expected_fly)
        
        expected_hum <- if (method == "gprofiler") {
            39000
        } else if(method == "homologene") {
            19000
        } else if(method == "babelgene") {
            20000
        }
        observed_hum <- n_genes(orth_hum)
        testthat::expect_gte(observed_hum, expected_hum)
        
        res <- data.frame(rbind(
            c(species = "mouse", expected = expected_mouse, observed = observed_mouse),
            c(species = "zebrafish", expected = expected_zeb, observed = observed_zeb),
            c(species = "fly", expected = expected_fly, observed = observed_fly),
            c(species = "human", expected = expected_hum, observed = observed_hum)
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
    #### babelgene tests ####
    b_res <- run_tests(method = "babelgene")
    #### grprofiler tests ####
    ## Takes too long to run in tests
    # g_res <- run_tests(method = "gprofiler")
    
    #### Test recursion ####
    multi_species <- c("mouse","monkey")
    orth_multi <- report_orthologs(
        target_species = multi_species,
        reference_species = "human",
        method_all_genes = "homologene")
    testthat::expect_true(methods::is(orth_multi$map,"data.frame"))
    testthat::expect_true(methods::is(orth_multi$report,"data.frame"))
    testthat::expect_equal(nrow(orth_multi$report), length(multi_species))
})