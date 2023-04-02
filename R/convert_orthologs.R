#' Map genes from one species to another
#'
#' Currently supports ortholog mapping between any
#' pair of 700+ species. \cr
#' Use \link[orthogene]{map_species} to
#' return a full list of available organisms.
#'
#' @param gene_df Data object containing the genes
#' (see \code{gene_input} for options on how
#' the genes can be stored within the object).\cr
#' Can be one of the following formats:\cr
#' \itemize{
#' \item{\code{matrix} : \cr}{A sparse or dense matrix.}
#' \item{\code{data.frame} : \cr}{A \code{data.frame},
#'  \code{data.table}. or \code{tibble}.}
#' \item{code{list} : \cr}{A \code{list} or character \code{vector}.}
#' }
#' Genes, transcripts, proteins, SNPs, or genomic ranges
#'  can be provided in any format
#' (HGNC, Ensembl, RefSeq, UniProt, etc.) and will be
#' automatically converted to gene symbols unless
#' specified otherwise with the \code{...} arguments.\cr
#' \emph{Note}: If you set \code{method="homologene"}, you
#' must either supply genes in gene symbol format (e.g. "Sox2")
#'  OR set \code{standardise_genes=TRUE}.
#'
#' @param gene_input Which aspect of \code{gene_df} to
#' get gene names from:\cr
#' \itemize{
#' \item{\code{"rownames"} : \cr}{From row names of data.frame/matrix.}
#' \item{\code{"colnames"} : \cr}{From column names of data.frame/matrix.}
#' \item{\code{<column name>} : \cr}{From a column in \code{gene_df},
#'  e.g. \code{"gene_names"}.}
#' }
#'
#' @param gene_output How to return genes.
#' Options include:\cr
#' \itemize{
#' \item{\code{"rownames"} : \cr}{As row names of \code{gene_df}.}
#' \item{\code{"colnames"} : \cr}{As column names of \code{gene_df}.}
#' \item{\code{"columns"} : \cr}{As new columns "input_gene", "ortholog_gene"
#' (and "input_gene_standard" if \code{standardise_genes=TRUE})
#' in \code{gene_df}.}
#' \item{\code{"dict"} : \cr}{As a dictionary (named list) where the names
#' are input_gene and the values are ortholog_gene}.
#' \item{\code{"dict_rev"} : \cr}{As a reversed dictionary (named list)
#' where the names are ortholog_gene and the values are input_gene}.
#' }
#'
#' @param standardise_genes If \code{TRUE} AND
#' \code{gene_output="columns"}, a new column "input_gene_standard"
#' will be added to \code{gene_df} containing standardised HGNC symbols
#' identified by \link[gprofiler2]{gorth}.
#'
#' @param input_species Name of the input species (e.g., "mouse","fly").
#' Use \link[orthogene]{map_species} to return a full list
#' of available species.
#'
#' @param output_species Name of the output species (e.g. "human","chicken").
#' Use \link[orthogene]{map_species} to return a full list
#'  of available species.
#'
#' @param drop_nonorths Drop genes that don't have an ortholog
#'  in the \code{output_species}.
#'
#' @param non121_strategy How to handle genes that don't have
#' 1:1 mappings between \code{input_species}:\code{output_species}.
#' Options include:\cr
#' \itemize{
#' \item{\code{"drop_both_species" or "dbs" or 1} : \cr}{
#' Drop genes that have duplicate
#' mappings in either the \code{input_species} or \code{output_species} \cr
#' (\emph{DEFAULT}).}
#' \item{\code{"drop_input_species" or "dis" or 2} : \cr}{
#' Only drop genes that have duplicate
#' mappings in the \code{input_species}.}
#' \item{\code{"drop_output_species" or "dos" or 3} : \cr}{
#' Only drop genes that have duplicate
#' mappings in the \code{output_species}.}
#' \item{\code{"keep_both_species" or "kbs" or 4} : \cr}{
#' Keep all genes regardless of whether
#' they have duplicate mappings in either species.}
#' \item{\code{"keep_popular" or "kp" or 5} : \cr}{
#' Return only the most "popular" interspecies ortholog mappings.
#'  This procedure tends to yield a greater number of returned genes
#'  but at the cost of many of them not being true biological 1:1 orthologs.}
#'  \item{\code{"sum","mean","median","min" or "max"} : \cr}{
#'  When \code{gene_df} is a matrix and \code{gene_output="rownames"},
#'   these options will aggregate many-to-one gene mappings
#'   (\code{input_species}-to-\code{output_species})
#'   after dropping any duplicate genes in the \code{output_species}.
#'  }
#' }
#'
#' @param agg_fun Aggregation function passed to 
#'  \link[orthogene]{aggregate_mapped_genes}. 
#' Set to \code{NULL} to skip aggregation step (default). 
#' @param mthreshold Maximum number of ortholog names per gene to show.
#' Passed to \link[gprofiler2]{gorth}.
#' Only used when \code{method="gprofiler"} (\emph{DEFAULT : }\code{Inf}).
#'
#' @param method R package to use for gene mapping:
#' \itemize{
#' \item{\code{"gprofiler"} : Slower but more species and genes.}
#' \item{\code{"homologene"} : Faster but fewer species and genes.}
#' \item{\code{"babelgene"} : Faster but fewer species and genes.
#' Also gives consensus scores for each gene mapping based on a
#'  several different data sources.}
#' }
#' 
#' @param as_sparse Convert \code{gene_df} to a sparse matrix.
#' Only works if \code{gene_df} is one of the following classes:\cr
#' \itemize{
#' \item{\code{matrix}}
#' \item{\code{Matrix}}
#' \item{\code{data.frame}}
#' \item{\code{data.table}}
#' \item{\code{tibble}}
#' }
#' If \code{gene_df} is a sparse matrix to begin with,
#' it will be returned as a sparse matrix
#'  (so long as \code{gene_output=} \code{"rownames"} or \code{"colnames"}).
#'
#' @param sort_rows Sort \code{gene_df} rows alphanumerically.
#'
#' @param verbose Print messages.
#'
#' @param ... Additional arguments to be passed to
#' \link[gprofiler2]{gorth} or \link[homologene]{homologene}.\cr\cr
#' \emph{NOTE}: To return only the most "popular"
#' interspecies ortholog mappings,
#' supply \code{mthreshold=1} here AND set \code{method="gprofiler"} above.
#' This procedure tends to yield a greater number of returned genes but at
#'  the cost of many of them not being true biological 1:1 orthologs.\cr\cr
#'  For more details, please see
#' \href{https://cran.r-project.org/web/packages/gprofiler2/vignettes/gprofiler2.html}{
#'  here}.
#' @inheritParams aggregate_mapped_genes
#'
#' @return \code{gene_df} with  orthologs converted to the
#' \code{output_species}.\cr
#' Instead returned as a dictionary (named list) if
#' \code{gene_output="dict"} or \code{"dict_rev"}.
#'
#' @export
#' @import homologene
#' @import Matrix
#' @importFrom dplyr select rename all_of
#' @importFrom stats setNames complete.cases
#' @importFrom methods as
#' @importFrom data.table as.data.table
#' @examples
#' data("exp_mouse")
#' gene_df <- convert_orthologs(
#'     gene_df = exp_mouse,
#'     input_species = "mouse"
#' )
convert_orthologs <- function(gene_df,
                              gene_input = "rownames",
                              gene_output = "rownames",
                              standardise_genes = FALSE,
                              input_species,
                              output_species = "human",
                              method = c(
                                  "gprofiler",
                                  "homologene",
                                  "babelgene"
                              ),
                              drop_nonorths = TRUE,
                              non121_strategy = "drop_both_species",
                              agg_fun = NULL,
                              mthreshold = Inf,
                              as_sparse = FALSE,
                              as_DelayedArray = FALSE,
                              sort_rows = FALSE,
                              verbose = TRUE,
                              ...) {
    # devoptera::args2vars(convert_orthologs)

    #### Check gene_output ####
    check_gene_output(gene_output = gene_output)
    #### Check one2one_strategy is a valid option ####
    one2one_strategy <- non121_strategy_opts(
        non121_strategy = non121_strategy
    )
    #### Check other args are compatible with non121_strategy="kp" ####
    check_keep_popular_out <- check_keep_popular(
        one2one_strategy = one2one_strategy,
        method = method,
        mthreshold = mthreshold
    )
    method <- check_keep_popular_out$method
    mthreshold <- check_keep_popular_out$mthreshold
    #### Check other args are compatible with aggregation ####
    check_agg_args_out <- check_agg_args(
        gene_df = gene_df,
        agg_fun = agg_fun,
        gene_input = gene_input,
        gene_output = gene_output,
        drop_nonorths = drop_nonorths,
        return_args = TRUE,
        verbose = verbose
    )
    agg_fun <- check_agg_args_out$agg_fun
    gene_input <- check_agg_args_out$gene_input
    gene_output <- check_agg_args_out$gene_output
    drop_nonorths <- check_agg_args_out$drop_nonorths
    ### Check other args are compatible with gene_output='rownames' ####
    check_rownames_args_out <- check_rownames_args(
        gene_output = gene_output,
        drop_nonorths = drop_nonorths,
        non121_strategy = non121_strategy,
        as_sparse = as_sparse,
        verbose = verbose
    )
    gene_output <- check_rownames_args_out$gene_output
    drop_nonorths <- check_rownames_args_out$drop_nonorths
    non121_strategy <- check_rownames_args_out$non121_strategy
    as_sparse <- check_rownames_args_out$as_sparse
    #### Standardise input data ####
    check_gene_df_type_out <- check_gene_df_type(
        gene_df = gene_df,
        gene_input = gene_input,
        verbose = verbose
    )
    gene_df <- check_gene_df_type_out$gene_df
    gene_input <- check_gene_df_type_out$gene_input 
    #### Check if previously converted ####
    # If so, skip ahead.
    if (!is_converted(gene_df, verbose = verbose)) {
        #### Check gene_input ####
        genes <- extract_gene_list(
            gene_df = gene_df,
            gene_input = gene_input,
            verbose = verbose
        )
        #### Map orthologs ####
        gene_map <- map_orthologs(
            genes = genes,
            input_species = input_species,
            output_species = output_species,
            standardise_genes = standardise_genes,
            method = method,
            mthreshold = mthreshold,
            verbose = verbose,
            ...
        )
    } else {
        messager(
            "Detected that gene_df was previously converted to orthologs.\n",
            "Skipping map_orthologs step.",
            v = verbose
        )
        genes <- gene_df$input_gene
        gene_map <- gene_df
    }

    #### Drop non-orthologs ####
    if (drop_nonorths) {
        gene_map <- drop_nonorth_genes(
            gene_map = gene_map,
            output_species = output_species,
            verbose = verbose
        )
    }
    #### Drop non-1:1 genes ####
    gene_map <- drop_non121(
        gene_map = gene_map,
        non121_strategy = non121_strategy,
        verbose = verbose
    )
    ##### Subset and add new genes cols/rownames ####
    gene_dat <- format_gene_df(
        gene_df = gene_df,
        gene_map = gene_map,
        genes = genes,
        gene_input = gene_input,
        gene_output = gene_output,
        drop_nonorths = drop_nonorths,
        non121_strategy = non121_strategy,
        agg_fun = agg_fun,
        as_sparse = as_sparse,
        as_DelayedArray = as_DelayedArray,
        sort_rows = sort_rows,
        standardise_genes = standardise_genes,
        verbose = verbose
    ) 
    #### Return ####
    return(gene_dat)
}
