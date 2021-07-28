# 
# convert_orthologs_sce <- function(sce,
#                                   species,
#                                   gene_col="gene",
#                                   drop_nonhuman_genes=T,
#                                   one_to_one_only=T,
#                                   genes_as_rownames=T,
#                                   verbose=T){
#   sce$species <- species
#   rowDat <- data.frame(gene=row.names(rowData(sce)),
#                        row.names = row.names(rowData(sce)))
#   orths <-        convert_orthologs(gene_df = rowDat,
#                                     gene_col = gene_col,
#                                     input_species = species,
#                                     drop_nonhuman_genes = drop_nonhuman_genes,
#                                     one_to_one_only = one_to_one_only,
#                                     genes_as_rownames = genes_as_rownames,
#                                     verbose=verbose)
#   sce <- sce[orths$Gene_orig,] 
#   rowDat2 <- data.frame(Gene_orig=row.names(rowData(sce)),
#                         row.names = row.names(rowData(sce)))
#   rowDat_orths <- merge(rowDat2,
#                         orths,
#                         by="Gene_orig", sort=F)
#   row.names(rowDat_orths) <- rowDat_orths$Gene
#   if(sum(rowDat_orths$Gene_orig!=rowDat2$Gene_orig)>0) 
#    stop("Old gene names and new gene names do not match.")
#   rowData(sce) <- rowDat_orths
#   rownames(sce) <- rowDat_orths$Gene
#   return(sce)
# }