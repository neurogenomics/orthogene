is_gha <-function (var = "GITHUB_ACTION", verbose = TRUE) 
{
    gha <- Sys.getenv(var)
    if (gha != "") {
        messager("Currently running on GITHUB_ACTION:", 
                 paste(gha, 
                       collapse = ","), v = verbose)
        return(TRUE)
    }
    else {
        return(FALSE)
    }
}