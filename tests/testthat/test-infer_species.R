test_that("infer_species works", {
    
    set.seed(1234)
    data("exp_mouse")
    exp1 <- exp_mouse[seq(1,200),]
    test <- function(matches,
                     target_species){
        testthat::expect_true(matches$top_match %in% target_species)
        testthat::expect_true(methods::is(matches$data,"data.frame"))
        testthat::expect_true(methods::is(matches$plot,"gg"))
    }
    run_tests <- function(method=NULL,
                          verbose=TRUE){  
        #### Mouse matrix ####
        orthogene:::messager("===== mouse tests =====",v=verbose)
        matches <- orthogene::infer_species(
            gene_df = exp1,
            method = method,
            show_plot = FALSE,
            verbose = verbose)
        test(matches = matches, 
             target_species = c("mouse","Mus musculus"))
        #### Mouse list ####
        orthogene:::messager("===== mouse tests2 =====",v=verbose)
        matches <- orthogene::infer_species(
            gene_df = rownames(exp1), 
            method = method,
            show_plot = FALSE,
            verbose = verbose)
        test(matches = matches, 
             target_species = c("mouse","Mus musculus"))
        #### Human list ####
        exp2 <- orthogene::convert_orthologs(gene_df = exp1, 
                                             input_species = "mouse", 
                                             output_species = "human",
                                             verbose = FALSE)
        orthogene:::messager("===== human tests =====",v=verbose)
        matches <- orthogene::infer_species(
            gene_df = rownames(exp2[seq(1,100),]),
            method = method, 
            show_plot = FALSE,
            verbose = verbose)
        test(matches = matches, 
             target_species =  c("human","Homo sapiens"))
    } 
    run_tests(method = "homologene") ## Fastest
    # run_tests(method = "gprofiler") ## Slowest
    # run_tests(method = "babelgene") ## Slow-ish
})
