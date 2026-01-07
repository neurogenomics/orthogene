#' Map orthologs: gprofiler
#'
#' Map orthologs from one species to another using \link[gprofiler2]{gorth}.
#'
#' @param genes Gene list.
#' @param input_species Input species.
#' @param output_species Output species. Default "human".
#' @param filter_na Logical indicating whether to filter out results without a corresponding target name.
#' @param mthreshold Maximum number of ortholog names per gene to show.
#' @param verbose Logical; print progress.
#' @param ... Additional arguments passed to \link[gprofiler2]{gorth}.
#'
#' @param chunked Logical; if TRUE, query g:Profiler in chunks and rbind results.
#' @param chunk_size Integer; number of genes per chunk when chunked=TRUE.
#' @param retry Integer; number of attempts per chunk (>=1). Only used when chunked=TRUE.
#' @param retry_backoff Numeric; base backoff (seconds). Sleep = retry_backoff * attempt.
#'
#' @return Ortholog map \code{data.frame}
#' @importFrom gprofiler2 gorth
#' @importFrom dplyr rename
#' @importFrom utils getFromNamespace setTxtProgressBar
#' @keywords internal
map_orthologs_gprofiler <- function(genes,
                                    input_species,
                                    output_species = "human",
                                    filter_na = FALSE,
                                    mthreshold = Inf,
                                    verbose = TRUE,
                                    ...,
                                    chunked = TRUE,
                                    chunk_size = 20000,
                                    retry = 3,
                                    retry_backoff = 1,
                                    n_cores = 1) {
    ## Avoid confusing Biocheck
    input <- ortholog_name <- NULL
    
    # Normalize genes early
    if (is.null(genes) || length(genes) == 0) return(NULL)
    genes <- unique(as.character(genes[!is.na(genes)]))
    if (length(genes) == 0) return(NULL)
    
    source_organism <- map_species(
        species = input_species,
        method = "gprofiler",
        output_format = "id",
        verbose = verbose
    )
    target_organism <- map_species(
        species = output_species,
        method = "gprofiler",
        output_format = "id",
        verbose = verbose
    )
    if (source_organism == target_organism) return(NULL)
    
    extra_args <- list(...)
    
    call_gorth_once <- function(q) {
        do.call(
            gprofiler2::gorth,
            c(list(
                query = q,
                source_organism = source_organism,
                target_organism = target_organism,
                mthreshold = mthreshold,
                filter_na = filter_na
            ), extra_args)
        )
    }
    
    # Non-chunked mode: preserve existing behavior
    if (!isTRUE(chunked)) {
        gene_map <- call_gorth_once(genes)
        if (is.null(gene_map) || nrow(gene_map) == 0) return(gene_map)
        
        gene_map <- dplyr::rename(gene_map,
                                  input_gene = input,
                                  ortholog_gene = ortholog_name
        )
        return(gene_map)
    }
    
    # Chunked mode
    chunk_size <- as.integer(chunk_size)
    if (is.na(chunk_size) || chunk_size <= 0) stop("chunk_size must be a single positive integer.")
    chunks <- split(genes, ceiling(seq_along(genes) / chunk_size))
    n_chunks <- length(chunks)
    if (n_chunks == 0) return(NULL)
    
    # Worker function (self-contained for PSOCK workers)
    worker_fun <- function(q, source_organism, target_organism, mthreshold, filter_na,
                           extra_args, retry, retry_backoff) {
        tries <- max(1L, as.integer(retry))
        last_err <- NULL
        
        for (i in seq_len(tries)) {
            res <- try(
                do.call(
                    gprofiler2::gorth,
                    c(list(
                        query = q,
                        source_organism = source_organism,
                        target_organism = target_organism,
                        mthreshold = mthreshold,
                        filter_na = filter_na
                    ), extra_args)
                ),
                silent = TRUE
            )
            
            if (!inherits(res, "try-error")) return(res)
            
            last_err <- res
            if (i < tries) Sys.sleep(retry_backoff * i)
        }
        
        # Return the error object so the master can decide what to do
        last_err
    }
    
    # Progress bar (base; reliable in RStudio)
    pb <- NULL
    if (isTRUE(verbose)) {
        pb <- utils::txtProgressBar(min = 0, max = n_chunks, style = 3)
        on.exit(try(close(pb), silent = TRUE), add = TRUE)
    }
    
    # Serial chunked path
    if (is.null(n_cores) || n_cores <= 1L) {
        res_list <- vector("list", n_chunks)
        for (k in seq_along(chunks)) {
            res_list[[k]] <- worker_fun(
                q = chunks[[k]],
                source_organism = source_organism,
                target_organism = target_organism,
                mthreshold = mthreshold,
                filter_na = filter_na,
                extra_args = extra_args,
                retry = retry,
                retry_backoff = retry_backoff
            )
            if (isTRUE(verbose)) utils::setTxtProgressBar(pb, k)
        }
        
    } else {
        # Parallel path (cross-platform PSOCK cluster, with “recvOneResult” progress)
        n_cores <- as.integer(n_cores)
        n_workers <- min(n_cores, n_chunks)
        
        cl <- parallel::makeCluster(n_workers)
        on.exit(try(parallel::stopCluster(cl), silent = TRUE), add = TRUE) 
        
        # Export the worker function and needed objects
        parallel::clusterExport(
            cl,
            varlist = c("worker_fun"),
            envir = environment()
        )
        
        # Submit jobs
        # Use internal send/recv for incremental progress updates
        # (this is a standard pattern for progress with base 'parallel')
        sendCall <- utils::getFromNamespace("sendCall","parallel")
        recvOneResult <- utils::getFromNamespace("recvOneResult","parallel")
        
        for (i in seq_along(chunks)) {
            sendCall(
                cl[[((i - 1L) %% n_workers) + 1L]],
                fun = worker_fun,
                args = list(
                    q = chunks[[i]],
                    source_organism = source_organism,
                    target_organism = target_organism,
                    mthreshold = mthreshold,
                    filter_na = filter_na,
                    extra_args = extra_args,
                    retry = retry,
                    retry_backoff = retry_backoff
                ),
                tag = i
            )
        }
        
        res_list <- vector("list", n_chunks)
        completed <- 0L
        while (completed < n_chunks) {
            ans <- recvOneResult(cl)
            idx <- ans$tag
            res_list[[idx]] <- ans$value
            
            completed <- completed + 1L
            if (isTRUE(verbose)) utils::setTxtProgressBar(pb, completed)
        }
    }
    
    # Handle errors: stop with the first error encountered (but after we’ve collected results)
    is_err <- vapply(res_list, inherits, logical(1), what = "try-error")
    if (any(is_err)) {
        # Show the first error message (keeps behavior strict/predictable)
        stop(res_list[[which(is_err)[1]]])
    }
    
    # Combine results
    res_list <- Filter(Negate(is.null), res_list)
    if (length(res_list) == 0) return(NULL)
    
    gene_map <- do.call(rbind, res_list)
    rownames(gene_map) <- NULL
    
    if (nrow(gene_map) == 0) return(gene_map)
    
    # Rename to match other mapping methods
    gene_map <- dplyr::rename(gene_map,
                              input_gene = input,
                              ortholog_gene = ortholog_name
    )
    gene_map
}
