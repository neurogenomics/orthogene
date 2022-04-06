test_that("convert_orthologs works", {
    
    data("exp_mouse")
    method <- "homologene"
    #### Prepare different formats ####
    exp_mouse_smat <- exp_mouse
    exp_mouse_dmat <- as.matrix(exp_mouse)
    exp_mouse_df <- data.frame(as.matrix(exp_mouse),
        check.rows = FALSE
    )
    exp_mouse_da <- orthogene:::as_delayed_array(exp = exp_mouse_smat)
    #### Define check function ####
    has_gene_cols <- function(dat) {
        sum(c(
            "input_gene",
            "input_gene_standard",
            "ortholog_gene"
        ) %in% colnames(dat))
    }
    ##### Run conversions ####
    # sparse matrix ==> sparse matrix: as rownames
    gene_smat1 <- convert_orthologs(
        gene_df = exp_mouse_smat,
        input_species = "mouse",
        gene_input = "rownames",
        gene_output = "rownames",
        as_sparse = TRUE,
        method = method
    )
    testthat::expect_equal(methods::is(gene_smat1, "sparseMatrix"), TRUE)
    testthat::expect_equal(has_gene_cols(gene_smat1), 0)
    # dense matrix ==> dense matrix: as rownames
    gene_dmat1 <- convert_orthologs(
        gene_df = exp_mouse_dmat,
        input_species = "mouse",
        gene_input = "rownames",
        gene_output = "rownames",
        method = method
    )
    testthat::expect_equal(methods::is(gene_dmat1, "matrix"), TRUE)
    testthat::expect_equal(has_gene_cols(gene_dmat1), 0)
    # dense matrix ==> data.frame: as columns
    gene_dmatc1 <- convert_orthologs(
        gene_df = exp_mouse_dmat,
        input_species = "mouse",
        gene_input = "rownames",
        gene_output = "columns",
        method = method
    )
    testthat::expect_equal(methods::is(gene_dmatc1, "data.frame"), TRUE)
    testthat::expect_equal(has_gene_cols(gene_dmatc1), 2)
    # data.frame ==> data.frame: as columns
    gene_df1 <- convert_orthologs(
        gene_df = exp_mouse_df,
        input_species = "mouse",
        gene_input = "rownames",
        gene_output = "columns",
        method = method
    )
    testthat::expect_equal(methods::is(gene_df1, "data.frame"), TRUE)
    testthat::expect_equal(has_gene_cols(gene_df1), 2)

    # data.frame ==> data.frame: as typo
    testthat::expect_error(
        gene_dfTYPO1 <- convert_orthologs(
            gene_df = exp_mouse_df,
            input_species = "mouse",
            gene_input = "rownamesTYPO",
            gene_output = "columns",
            method = method
        )
    )
    
    #### Test gene standardisation and sort rows ####
    gene_df_std <- convert_orthologs(
        gene_df = exp_mouse_df,
        input_species = "mouse",
        gene_input = "rownames",
        gene_output = "columns",
        standardise_genes = TRUE,
        sort_rows = TRUE,
        drop_nonorths = FALSE,
        non121_strategy = "kbs",
        method = method
    )
    testthat::expect_equal(methods::is(gene_df_std, "data.frame"), TRUE)
    testthat::expect_equal(has_gene_cols(gene_df_std), 3)


    #### Test when gene_df is already converted
    gene_df_converted <- convert_orthologs(
        gene_df = gene_df_std,
        input_species = "mouse",
        gene_input = "input_gene",
        gene_output = "columns",
        method = method
    )
    testthat::expect_equal(methods::is(gene_df_converted, "data.frame"), TRUE)
    testthat::expect_equal(has_gene_cols(gene_df_converted), 3)

    #### Test returning as dict ####
    # tabular input
    gene_dict <- convert_orthologs(
        gene_df = exp_mouse_df,
        input_species = "mouse",
        gene_output = "dict",
        method = method
    )
    testthat::expect_equal(methods::is(gene_dict, "character"), TRUE)
    testthat::expect_equal(methods::is(names(gene_dict), "character"), TRUE)
    testthat::expect_equal(methods::is(unname(gene_dict), "character"), TRUE)
    testthat::expect_equal(methods::is(gene_dict, "vector"), TRUE)
    # vector input
    gene_dict_rev <- convert_orthologs(
        gene_df = rownames(exp_mouse_df)[seq(1, 100)],
        input_species = "mouse",
        gene_output = "dict_rev",
        method = method
    )
    testthat::expect_equal(methods::is(gene_dict_rev, "character"), TRUE)
    testthat::expect_equal(methods::is(names(gene_dict_rev), "character"), TRUE)
    testthat::expect_equal(methods::is(unname(gene_dict_rev), "character"), TRUE)
    testthat::expect_equal(methods::is(gene_dict_rev, "vector"), TRUE)
    
    # vector input - dataframe rownames output
    gene_vec2rn<- convert_orthologs(
        gene_df = rownames(exp_mouse_df)[seq(1, 100)],
        input_species = "mouse",
        gene_output = "rownames",
        method = method
    )
    testthat::expect_true(methods::is(gene_vec2rn, "data.frame"))
    testthat::expect_true(methods::is(rownames(gene_vec2rn), "character")) 
    testthat::expect_true(methods::is(gene_vec2rn$input_gene, "vector"))
    testthat::expect_true(any(rownames(gene_vec2rn)!=gene_vec2rn$input_gene))
    
    # vector input - dataframe column output
    gene_vec2col<- convert_orthologs(
        gene_df = rownames(exp_mouse_df)[seq(1, 100)],
        input_species = "mouse",
        gene_output = "columns",
        method = method
    )
    testthat::expect_true(methods::is(gene_vec2col, "data.frame"))
    testthat::expect_true(methods::is(rownames(gene_vec2col), "character")) 
    testthat::expect_true(methods::is(gene_vec2col$input_gene, "vector"))
    testthat::expect_true(methods::is(gene_vec2col$ortholog_gene, "vector"))
    testthat::expect_true(
        any(rownames(gene_vec2col)!=gene_vec2col$ortholog_gene))
    testthat::expect_true(all(rownames(gene_vec2col)==gene_vec2col$input_gene))

    #### Aggregate #####
    # sparse matrix ==> sparse matrix: as rownames
    gene_smat_sum <- convert_orthologs(
        gene_df = exp_mouse_smat,
        input_species = "mouse",
        gene_input = "rownames",
        gene_output = "rownames",
        non121_strategy = "sum",
        as_sparse = TRUE,
        method = method
    )
    testthat::expect_equal(methods::is(gene_smat_sum, "sparseMatrix"), TRUE)
    testthat::expect_equal(has_gene_cols(gene_smat_sum), 0)

    #### gprofiler ####
    gene_gprof <- convert_orthologs(
        gene_df = exp_mouse_smat,
        input_species = "mouse",
        gene_input = "rownames",
        gene_output = "rownames",
        method = "gprofiler"
    )
    testthat::expect_equal(methods::is(gene_gprof, "sparseMatrix"), TRUE)
    testthat::expect_equal(has_gene_cols(gene_gprof), 0)
    testthat::expect_gte(nrow(gene_gprof), 12000)
    
        
    #### babelgene ####
    gene_babel <- convert_orthologs(
        gene_df = exp_mouse_smat,
        input_species = "mouse",
        gene_input = "rownames",
        gene_output = "rownames",
        method = "babelgene"
    )
    testthat::expect_equal(methods::is(gene_babel, "sparseMatrix"), TRUE)
    testthat::expect_equal(has_gene_cols(gene_babel), 0)
    testthat::expect_gte(nrow(gene_babel), 11000)
    
    #### same species ####
    gene_mat_same <- convert_orthologs(
        gene_df = exp_mouse_smat,
        input_species = "mouse", 
        output_species = "mouse",
        as_sparse = TRUE,
        method = method
    )
    testthat::expect_equal(methods::is(gene_mat_same, "sparseMatrix"), TRUE)
    testthat::expect_equal(has_gene_cols(gene_mat_same), 0)
    testthat::expect_gte(nrow(gene_mat_same), 13000)
    
    #### DelayedArray ####
    gene_mat_da <- convert_orthologs(
        gene_df = exp_mouse_da,
        input_species = "mouse", 
        output_species = "human", 
        method = method
    )
    testthat::expect_true(orthogene:::is_delayed_array(gene_mat_da))
    testthat::expect_equal(has_gene_cols(gene_mat_da), 0)
    testthat::expect_gte(nrow(gene_mat_da), 13000)
})

