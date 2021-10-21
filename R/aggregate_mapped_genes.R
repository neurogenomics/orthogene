#' Aggregate a gene matrix by gene symbols
#'
#' Map matrix rownames to standardised gene symbols,
#' and then aggregate many-to-one rows into a new matrix.
#'
#' @param gene_df Input matrix where row names are genes.
#' @param FUN Aggregation function (\emph{DEFAULT:} \code{"sum"}).
#' @param method Aggregation method.
#' @param transpose Transpose \code{gene_df} before mapping genes.
#' @param gene_map A user-supplied \code{gene_map}.
#' If \code{NULL} (\emph{DEFAULT)}),
#' \link[orthogene]{map_genes} will be used to create a \code{gene_map}.
#' @param gene_map_col Column in \code{gene_map} to aggregate
#' \code{gene_df} by.
#' @param as_sparse Convert aggregated matrix to sparse matrix.
#' @param as_DelayedArray Convert aggregated matrix to
#' \link[DelayedArray]{DelayedArray}.
#' @param dropNA Drop genes assigned to \code{NA} in \code{groupings}.
#' @param sort_rows Sort \code{gene_df} rows alphanumerically.
#' @param verbose Print messages.
#'
#' @inheritParams map_genes
#' @inheritParams convert_orthologs
#'
#' @return Aggregated matrix
#' @export
#' @examples
#' data("exp_mouse")
#' X_agg <- aggregate_mapped_genes(gene_df = exp_mouse, species = "mouse")
aggregate_mapped_genes <- function(gene_df,
                                   species = "human",
                                   FUN = "sum",
                                   method = c(
                                       "monocle3", "stats",
                                       "delayedarray"
                                   ),
                                   transpose = FALSE,
                                   gene_map = NULL,
                                   gene_map_col = "name",
                                   non121_strategy = "drop_output_species",
                                   as_sparse = TRUE,
                                   as_DelayedArray = FALSE,
                                   dropNA = TRUE,
                                   sort_rows = FALSE,
                                   verbose = TRUE) {
    #### Transpose matrix first (optional) ####
    if (transpose) {
        gene_df <- Matrix::t(gene_df)
    }
    ### Map genes ####
    if (is.null(gene_map)) {
        gene_map <- map_genes(
            genes = rownames(gene_df),
            species = species,
            ## Important!:
            # 1 means gene can only appear once in input col.
            # Ensures that nrow(gene_map)==nrow(X)
            mthreshold = 1,
            drop_na = FALSE
        )
        gene_map_col <- "name"
    }
    #### Check gene_map_col ####
    if (!gene_map_col %in% colnames(gene_map)) {
        stop_msg <- paste(paste0("gene_map_col=",gene_map_col),
                          "not in gene_map.")
        stop(stop_msg)
    }
    #### Aggregate genes ####
    #### Pre-aggregation ####
    # gene_dict <- stats::setNames(gene_map[["input_gene"]],
    #                              gene_map[[gene_map_col]]) 
    if (nrow(gene_map) > nrow(gene_df)) {
        messager("nrow(gene_map) > nrow(gene_df)", v = verbose)
        non121_strategy <- non121_strategy_opts(
            non121_strategy = non121_strategy,
            include_agg = FALSE
        )
        gene_map <- drop_non121(
            gene_map = gene_map,
            non121_strategy = non121_strategy,
            verbose = verbose
        )
        gene_map <- remove_all_nas(
            dat = gene_map,
            col_name = "input_gene",
            verbose = verbose
        )
        gene_map <- remove_all_nas(
            dat = gene_map,
            col_name = gene_map_col,
            verbose = verbose
        )
        gene_df <- gene_df[gene_map$input_gene, ]
    }
    #### Check if old/new genes are equal ####
    if(length(unique(gene_map[[gene_map_col]])) == 
       length(unique(rownames(gene_df))) ){
        messager("gene_map has the same number of rows as gene_df, 
                 and thus there is nothing to aggregate.\n",
                 "Returning gene_df with gene names from gene_map instead",
                 v=verbose)
        rownames(gene_df) <- gene_map[[gene_map_col]]
        return(gene_df)
    }
    #### Main aggregation ####
    X_agg <- aggregate_rows(
        X = gene_df,
        groupings = gene_map[[gene_map_col]],
        FUN = FUN,
        method = method,
        as_sparse = as_sparse,
        as_DelayedArray = as_DelayedArray,
        dropNA = dropNA,
        verbose = verbose
    )

    if (sort_rows) {
        X_agg <- sort_rows_func(
            gene_df = X_agg,
            verbose = verbose
        )
    }
    messager("Matrix aggregated:\n",
        " - Input:", paste(formatC(dim(gene_df), big.mark = ","),
            collapse = " x "
        ), "\n",
        " - Output:", paste(formatC(dim(X_agg), big.mark = ","),
            collapse = " x "
        ),
        v = verbose
    )
    return(X_agg)
}
