test_that("get_orgdb_genomeinfodbdata works", {
    
    ### It takes a long time to load GenomeInfoDb
    ### and even longer to load GenomeInfoDbData
    # Run on GHA but skip on local tests
    if (is_gha() && Sys.info()["sysname"]=="Linux"){
        db <- orthogene:::get_orgdb_genomeinfodbdata()
        testthat::expect_true(methods::is(db,"data.table"))
        testthat::expect_gte(nrow(db),2e6)    
    } else {
        testthat::skip()
    } 
    
})
