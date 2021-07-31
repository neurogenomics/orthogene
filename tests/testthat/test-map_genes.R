test_that("map_genes works", {
  ## Map genes doesn't do any NA removal in the "name" col,
  ## it just returns everything. 
  data("exp_mouse")
  mapped_human <- map_genes(genes=rownames(exp_mouse)[seq(1,100)],
                            species="human",
                            filter_na=TRUE)
  mapped_mouse <- map_genes(genes=rownames(exp_mouse)[seq(1,100)],
                            species="mouse",
                            filter_na=TRUE)
  mapped_zebrafish <- map_genes(genes=rownames(exp_mouse)[seq(1,100)],
                                species="zebrafish",
                                filter_na=TRUE)
  mapped_fly <- map_genes(genes=rownames(exp_mouse)[seq(1,100)],
                          species="fly", 
                          filter_na=TRUE)
  
  
  testthat::expect_gte(nrow(mapped_human), 100)
  testthat::expect_gte(nrow(mapped_mouse), 100)
  testthat::expect_gte(nrow(mapped_zebrafish), 100)
  testthat::expect_gte(nrow(mapped_fly), 100) 
})
