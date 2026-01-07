
##' Set gprofiler
##' 
##' Set the default URL for gprofiler API queries.
##' \describe{
##' \item{default}{http://biit.cs.ut.ee/gprofiler}
##' \item{bea|}{http://biit.cs.ut.ee/gprofiler_beta}
##' }
##' @inheritParams gprofiler2::set_base_url 
##' @returns Null
##' 
##' @keywords internal
##' @importFrom gprofiler2 set_base_url
#set_gprofiler <- function(url = "http://biit.cs.ut.ee/gprofiler_beta"){
#    # gprofiler2::get_base_url() 
#    gprofiler2::set_base_url(url = url)
#    
#    # ns <- asNamespace("gprofiler2")
#    # gp <- get("gp_globals", envir = ns)
#    # 
#    # gp$rcurl_opts <- RCurl::curlOptions(
#    #     useragent  = gp$rcurl_opts$useragent,
#    #     sslversion = gp$rcurl_opts$sslversion,
#    #     
#    #     connecttimeout = 30,
#    #     timeout        = 600,   # allow longer server compute
#    #     
#    #     # stall detection: tolerate long pauses
#    #     low.speed.limit = 10,   # bytes/sec (still tiny)
#    #     low.speed.time  = 300,  # seconds (5 minutes)
#    #     
#    #     fresh.connect = TRUE,
#    #     forbid.reuse  = TRUE,
#    #     http.version  = 1
#    # )
#    
#}
#