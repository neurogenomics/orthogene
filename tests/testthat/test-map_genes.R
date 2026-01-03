test_that("map_genes works", {
    ## Map genes doesn't do any NA removal in the "name" col,
    ## it just returns everything.
    genes <- c(
        "Klf4", "Sox2", "TSPAN12", "NM_173007", "Q8BKT6",
        9999, "wejfvhebvdhubfhdbfv", ### 2 fake genes
        "ENSMUSG00000012396", "ENSMUSG00000074637"
    )
    total_genes <- length(genes) - 2

    mapped_human <- map_genes(
        genes = genes,
        species = "human",
        drop_na = TRUE
    )
    mapped_mouse <- map_genes(
        genes = genes,
        species = "mouse",
        drop_na = TRUE
    )
    mapped_zebrafish <- map_genes(
        genes = genes,
        species = "zebrafish",
        drop_na = TRUE
    )
    # mapped_fly <- map_genes(
    #     genes = genes,
    #     species = "fly",
    #     drop_na = TRUE
    # )
    data("exp_mouse")
    mapped_fly2 <- map_genes(
        genes = rownames(exp_mouse)[seq(1, 1000)],
        species = "fly",
        drop_na = TRUE
    )
    
    #### Planarians ####
    genes <- c("dd_Smed_v6_10690_0","dd_Smed_v6_10691_0","dd_Smed_v6_10693_0")
 
    mapped_planarian <- tryCatch({
        map_genes(
            genes = genes,
            species = "Schmidtea mediterranea",
            drop_na = TRUE
        )
    },
    error=function(e){
        message(e)
        NULL
        }
    )
    if(!is.null(mapped_planarian)){
        testthat::expect_gte(nrow(mapped_planarian), 2) 
    } 
 
    ##### Tests ####
    testthat::expect_gte(nrow(mapped_human), 3)
    testthat::expect_gte(nrow(mapped_mouse), total_genes)
    testthat::expect_gte(nrow(mapped_zebrafish), 3)
    
    #### Test where genes aren't found in species ####
    #should return NULL not fail
    genes <- c("a",'list','of','fake','genes')
    spec_hits <- map_genes(
      genes = genes,
      species = 'yeast',
      drop_na = TRUE,
      verbose = FALSE)$name
    testthat::expect_null(spec_hits)
})
