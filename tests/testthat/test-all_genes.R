test_that("all_genes works", {
  n_genes <- function(dat){
    length(unique(dat$Gene.Symbol))
  }
  ##### Test function ####
  run_tests <- function(method){ 
    genome_human <- all_genes(species="human",
                               method = method)
    genome_mouse <- all_genes(species="mouse",
                               method = method)
    genome_zebrafish <- all_genes(species="zebrafish",
                                   method = method)
    genome_fly <- all_genes(species="fly",
                            method = method)
    #### Test human ####
    expected_human <- if(method=="gprofiler") 35000 else 19000
    testthat::expect_gte(n_genes(genome_human),
                         expected_human)
    #### Test mouse ####
    expected_mouse <- if(method=="gprofiler") 50000 else 21000
    testthat::expect_gte(n_genes(genome_mouse),
                         expected_mouse)
    #### Test zebrafish ####
    expected_zebrafish <- if(method=="gprofiler") 25000 else 20000
    testthat::expect_gte(n_genes(genome_zebrafish),
                         expected_zebrafish)
    #### Test fly ####
    expected_fly <- if(method=="gprofiler") 4000 else 8000
    testthat::expect_gte(n_genes(genome_fly),
                         expected_fly) 
  }
  
  # Fly is the only species tested here that gprofiler
  # does worse on.
  ##### gprofiler tests ####
  # run_tests(method = "gprofiler") # Takes a long time currently (hacky)
  ##### homologene tests ####
  run_tests(method = "homologene")
})
