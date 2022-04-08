test_that("load_data works", {
  
    #### RDS ####
    rds <- tempfile(fileext = ".rds")    
    saveRDS(mtcars,file = rds)
    dat <- orthogene:::load_data(filename = rds)
    testthat::expect_equal(dat,mtcars)
    #### RDA ####
    rda <- tempfile(fileext = ".rda")    
    save(mtcars,file = rda)
    dat <- orthogene:::load_data(filename = rda)
    testthat::expect_equal(dat,mtcars)
})
