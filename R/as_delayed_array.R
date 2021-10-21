as_delayed_array <- function(exp,
                             as_DelayedArray = TRUE,
                             verbose = TRUE) {
    requireNamespace("DelayedArray")
    if (as_DelayedArray && (!is_delayed_array(exp))) {
        messager("Converting to DelayedArray.", v = verbose)
        if (!is_matrix(exp)) {
            exp <- as.matrix(exp)
        }
        exp <- DelayedArray::DelayedArray(exp)
    }
    return(exp)
}
