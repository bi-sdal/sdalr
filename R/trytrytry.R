#' Try an expression n times before quitting
#'
#' @param x The expression to try.
#' @param n The number of times to try. Default is 3.
#' @export
tryTryTry <- function(x, n = 3L) {
    response <- "failed"
    attempt <- 1
    while (response == "failed" && attempt <= n) {
        print(sprintf("attempt: %s", attempt))
        attempt <- attempt + 1
        try({ response <- x }, silent = TRUE)
    }
    response
}
