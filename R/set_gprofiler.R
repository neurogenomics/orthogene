#' Set gprofiler
#' 
#' Set the default URL for gprofiler API queries.
#' \itemize{
#' \item{default: }{http://biit.cs.ut.ee/gprofiler}
#' \item{bea: http://biit.cs.ut.ee/gprofiler_beta}
#' }
#' @inheritParams gprofiler2::set_base_url 
#' @returns Null
#' 
#' @keywords internal
#' @importFrom gprofiler2 set_base_url
set_gprofiler <- function(url = "http://biit.cs.ut.ee/gprofiler_beta"){
    # gprofiler2::get_base_url() 
    gprofiler2::set_base_url(url = url)
}