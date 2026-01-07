#' Run benchmark tests
#'
#' Runs benchmarks tests on \link[orthogene]{all_genes} and
#'  \link[orthogene]{convert_orthologs} across multiple species,
#'  using multiple methods ("homologene", and "gprofiler").
#'
#' @return \code{data.table} with benchmark results
#' @param species Species names.
#' @param method_list A list of ortholog conversion methods to benchmark.
#' @param run_convert_orthologs Benchmark
#'  \link[orthogene]{convert_orthologs} function.
#' @param remove_failed_times In instances where
#' no genes were returned, set time to \code{NA}.
#' @param save_path Path to save results to.
#' @param force Force regeneration of files even if cached files exist.
#' Set to TRUE or 1 to just force regenerating the \code{convert_orthologs} step.
#' Set to 2 to force regenerating both the \code{convert_orthologs} and 
#' \code{all_genes} steps.
#' @param mc.cores Number of cores to parallelise species across.
#' @param verbose Print messages.
#'
#' @importFrom utils write.csv
#' @importFrom data.table rbindlist
#' @importFrom parallel mclapply
#' @keywords internal
run_benchmark <- function(species,
                          method_list = c("homologene",
                                          "gprofiler",
                                          "babelgene"),
                          run_convert_orthologs = TRUE,
                          remove_failed_times = FALSE,
                          save_path = tempfile(fileext = ".csv"),
                          mc.cores = 1,
                          force = FALSE,
                          verbose = TRUE) {


    # Avoid confusing Biocheck
    genes <- time <- NULL

    bench_res <- parallel::mclapply(species, function(spec) {  
            #### Record total time per species ####
            timeA <- Sys.time()
            message_parallel("\n==== ", spec, " ====\n")
            res <- lapply(method_list, function(m){
                message_parallel("\n------- Benchmarking ",m," -------\n")
                run_benchmark_once(
                    species = spec,
                    run_convert_orthologs = run_convert_orthologs,
                    method = m,
                    force = force,
                    verbose = verbose
                )
            })  |> data.table::rbindlist()
            #### Report time ####
            message_parallel(
                paste(
                    "Finished", spec, "in",
                    round(difftime(Sys.time(), timeA, units = "mins"), 3),
                    "minutes."
                )
            )
            return(res)
        },
        mc.cores = mc.cores
    ) |> `names<-`(species) |>
        data.table::rbindlist(idcol = "species")

    #### Remove time that failed entirely ####
    if (remove_failed_times) {
        bench_res <- dplyr::mutate(bench_res,
            time = ifelse(genes == 0, NA, time)
        )
    }
    messager("Saving benchmarking results ==>", save_path)
    write.csv(bench_res, save_path)
    return(bench_res)
}
