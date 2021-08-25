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
                          benchmark_homologene = TRUE,
                          benchmark_gprofiler = TRUE,
                          run_convert_orthologs = TRUE,
                          remove_failed_times = FALSE,
                          save_path = tempfile(fileext = ".csv"),
                          mc.cores = 1,
                          verbose = TRUE) {


    # Avoid confusing Biocheck
    genes <- time <- NULL

    bench_res <- parallel::mclapply(species_mapped,
        function(spec,
                 .benchmark_homologene = benchmark_homologene,
                 .benchmark_gprofiler = benchmark_gprofiler,
                 .run_convert_orthologs = run_convert_orthologs,
                 .verbose = verbose) {

            #### Ensure 1 species ####
            spec <- spec[1]
            #### Record total time per species ####
            timeA <- Sys.time()
            message_parallel("\n==== ", spec, " ====\n")
            #### Initialize results data.frame ####
            res <- c()

            #### homologene ####
            if (.benchmark_homologene) {
                message_parallel("------- Benchmarking homologene -------\n")
                homologene_res <- run_benchmark_once(
                    species = spec,
                    run_convert_orthologs = .run_convert_orthologs,
                    method = "homologene",
                    verbose = .verbose
                )
                res <- rbind(res, homologene_res)
            }
            if (.benchmark_gprofiler) {
                message(" ")
                #### gprofiler ####
                message_parallel("------- Benchmarking gprofiler -------\n")
                gprofiler_res <- run_benchmark_once(
                    species = spec,
                    run_convert_orthologs = .run_convert_orthologs,
                    method = "gprofiler",
                    verbose = .verbose
                )
                res <- rbind(res, gprofiler_res)
            }

            #### Report time ####
            message_parallel(
                "Finished", spec, "in",
                round(difftime(Sys.time(), timeA, units = "mins"), 3),
                "minutes."
            )
            return(res)
        },
        mc.cores = mc.cores
    ) %>%
        `names<-`(species_mapped) %>%
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
