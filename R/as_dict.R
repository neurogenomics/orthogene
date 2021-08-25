as_dict <- function(gene_output,
                    gene_map,
                    genes2,
                    verbose = TRUE) {
    messager("Returning gene_map as dictionary", v = verbose)
    gene_map2 <- gene_map[gene_map$input_gene %in% genes2, ]
    dict <- setNames(gene_map2$ortholog_gene, gene_map2$input_gene)
    if (tolower(gene_output) == "dict_rev") {
        dict <- invert_dictionary(dict)
    }
    return(dict)
}
