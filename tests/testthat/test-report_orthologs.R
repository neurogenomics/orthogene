test_that("report_orthologs works", { 
  
  n_genes <- function(dat){
    length(unique(dat$map$Gene.Symbol))
  }
  run_tests <- function(method){
    orth_mus <- report_orthologs(target_species = "mouse",
                                 reference_species="human",
                                 method_all_genes = method,
                                 method_convert_orthologs = method)
    orth_zeb <- report_orthologs(target_species = "zebrafish",
                                 reference_species="human",
                                 method_all_genes = method,
                                 method_convert_orthologs = method)
    orth_fly <- report_orthologs(target_species = "fly",
                                 reference_species="human",
                                 method_all_genes = method,
                                 method_convert_orthologs = method) 
    #### Tests ####
    expected_mouse <- if(method=="gprofiler") 16000 else 15000
    testthat::expect_gte(n_genes(orth_mus), expected_mouse)
    
    expected_zeb <- if(method=="gprofiler") 7500 else 8000
    testthat::expect_gte(n_genes(orth_zeb), expected_zeb)
    
    expected_fly <- if(method=="gprofiler") 550 else 500
    testthat::expect_gte(n_genes(orth_fly), expected_fly)
  }
  
  #### gprofler teste ####
  # run_tests(method="gprofiler") # Takes a long time currently (hacky) 
  #### homologene teste ####
  run_tests(method="homologene")
})
