#' Run benchmark tests
#' 
#' Runs benchmarks tests on \link[orthogene]{all_genes} and
#'  \link[orthogene]{convert_orthologs} across multiple species, 
#'  using multiple methods ("homologene", and "gprofiler").
#'  
#' @return \code{data.table} with benchmark results
#' @param species_mapped Species names.
#' @param benchmark_homologene Benchmark method "homologene".
#' @param benchmark_gprofiler Benchmark method "gprofiler".
#' @param run_convert_orthologs Benchmark 
#'  \link[orthogene]{convert_orthologs} function.
#' @param remove_failed_times In instances where 
#' no genes were returned, set time to \code{NA}.
#' @param save_path Path to save results to.
#' @param mc.cores Number of cores to parallelise species across.
#' @param verbose Print messages.
#' 
#' @importFrom utils write.csv
#' @importFrom data.table rbindlist
#' @importFrom parallel mclapply 
#' @keywords internal
run_benchmark <- function(species_mapped,
                          benchmark_homologene=TRUE,
                          benchmark_gprofiler=TRUE,
                          run_convert_orthologs=TRUE,
                          remove_failed_times=FALSE,
                          save_path=tempfile(fileext=".csv"),
                          mc_cores=1,
                          verbose=TRUE){ 
  
  # Avoid confusing Biocheck 
  genes <- time <- NULL;
  
  #' Send messages to console even from within parallel processes
  #' @return A message
  #' @keywords internal 
  message_parallel <- function(...){
    system(sprintf('echo "%s"', paste0(..., collapse="")))
  }
  
  
  messager <- function(..., v=TRUE){
    msg <- paste(...)
    if(v){message(msg)}
  }
  
  is_human <- function(species){
    tolower(species) %in% c("hsapiens","human",
                            "h sapiens","homo sapiens")
  }
  
  run_benchmark_once <- function(species,
                                 method,
                                 run_convert_orthologs=TRUE,
                                 ensure_filter_nas=TRUE, 
                                 verbose=TRUE){ 
    
    #### all_genes benchmark #### 
    messager("Benchmarking all_genes()",v=verbose)
    start1 <- Sys.time()
    gene_map1 <- tryCatch({
      all_genes(species = species,
                method = method,
                ensure_filter_nas = ensure_filter_nas,
                verbose = verbose)  
    }, error=function(e){message(e);NA}) 
    time1 <-  as.numeric(difftime(Sys.time(), start1, units = "secs") )
    n_genes1 <- if(all(is.na(gene_map1))) 0 else length(unique(gene_map1$Gene.Symbol)) 
    
    res1 <- data.frame(method=method, 
                       test="all_genes()", 
                       time=time1, 
                       genes=n_genes1)
    
    #### convert_orthologs benchmark ####
    if(run_convert_orthologs){
      messager("Benchmarking convert_orthologs()",v=verbose)
      start2 <- Sys.time()
      gene_map2 <- tryCatch({
        convert_orthologs(gene_df = gene_map1, 
                          gene_input = "Gene.Symbol", 
                          gene_output = "columns",
                          input_species = species, 
                          output_species = "human",
                          non121_strategy = if(is_human(species)) "kbs" else "dbs",
                          # drop_nonorths = !is_human(species),
                          method = method,
                          verbose = verbose) 
      }, error=function(e){message(e);NA})  
      time2 <-  as.numeric(difftime(Sys.time(), start2, units = "secs") )
      n_genes2 <- if(all(is.na(gene_map2))) 0 else length(unique(gene_map2$ortholog_gene)) 
      
      res2 <- data.frame(method=method, 
                         test="convert_orthologs()", 
                         time=time2, 
                         genes=n_genes2)
      #### Gather results ####
      res <- rbind(res1, res2) 
    } else { res <- res1} 
    return(res)
  } 
  
  bench_res <- parallel::mclapply(species_mapped, 
                                  function(spec,
                                           .benchmark_homologene=benchmark_homologene,
                                           .benchmark_gprofiler=benchmark_gprofiler,
                                           .run_convert_orthologs=run_convert_orthologs,
                                           .verbose=verbose){ 
                                    
    #### Ensure 1 species ####
    spec <- spec[1]
    #### Record total time per species ####                                
    timeA <- Sys.time()
    message_parallel("\n==== ",spec," ====\n") 
    #### Initialize results data.frame ####
    res <- c()
    
    #### homologene ####
    if(.benchmark_homologene){
      message_parallel("------- Benchmarking homologene -------\n")
      homologene_res <- run_benchmark_once(species = spec,  
                                           run_convert_orthologs = .run_convert_orthologs,
                                           method = "homologene",
                                           verbose=.verbose)
      res <- rbind(res, homologene_res)
    }
    if(.benchmark_gprofiler){
      message(" ")
      #### gprofiler ####
      message_parallel("------- Benchmarking gprofiler -------\n")
      gprofiler_res <- run_benchmark_once(species = spec, 
                                          run_convert_orthologs = .run_convert_orthologs,
                                          method = "gprofiler",
                                          verbose=.verbose)
      res <- rbind(res, gprofiler_res)
   }
    
    #### Report time ####
    message_parallel("Finished",spec,"in",
                     round(difftime(Sys.time(),timeA, units="mins"),3),
                     "minutes.") 
    return(res)
  }, mc.cores=mc_cores) %>% 
    `names<-`(species_mapped) %>%
    data.table::rbindlist(idcol = "species")
  
  #### Remove time that failed entirely ####
  if(remove_failed_times){
    bench_res <- dplyr::mutate(bench_res, 
                               time=ifelse(genes==0,NA,time))
  } 
  messager("Saving benchmarking results ==>",save_path)
  write.csv(bench_res, save_path)
  return(bench_res)
}
