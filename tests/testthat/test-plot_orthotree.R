test_that("plot_orthotree works", {
  
  species <- c("human","monkey","mouse")
  ### homologene ####
  orthotree_hg <- plot_orthotree(species = species, 
                                 method = "homologene")
  ### babelgene ####
  orthotree_bg <- plot_orthotree(species = species, 
                                 # save_paths = c("~/Desktop/ggtree.pdf",
                                 #                "~/Desktop/ggtree.png")
                                 method = "babelgene")
  #### gprofiler ####
  ## Omitting this test because it takes a verrrry long time
  # orthotree_gp <- orthogene::plot_orthotree(species = species,
  #                                           method = "gprofiler")
  
  for(orthotree in list(orthotree_hg, orthotree_bg)){ 
    testthat::expect_true(
      all(c("plot","tree","orth_report","metadata") %in% names(orthotree))
    )
    testthat::expect_true(methods::is(orthotree$plot,"gg"))
    testthat::expect_true(methods::is(orthotree$tree,"phylo"))
    testthat::expect_true(methods::is(orthotree$orth_report,"data.frame"))
    testthat::expect_true(methods::is(orthotree$metadata,"data.frame"))
    testthat::expect_true(methods::is(orthotree$clades,"data.frame"))
    testthat::expect_equal(length(species), length(orthotree$tree$tip.label))
    testthat::expect_equal(sort(unname(orthotree$tree$tip.label)),
                           sort(c("homo sapiens","macaca mulatta","mus musculus")))
  } 
})
