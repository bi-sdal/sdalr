#' Get the current IP address
#'
#' An example use cause is
#' getting the IP address within a docker container
#' for the user to SSH into in order to run an R script in the background
#'
#' @param cmd system call that gets the IP address. Defaults to `ip address`
#' @param ip_pattern regex pattern that matches an ip address
#' @param con_pattern regex pattern for the device. Defaults to 'eth0'
#' @param verbose whether or not to print statments during parsing. Defaults to FALSE
#' @return string
#' @export
#' @examples
#' get_ip_address()
get_ip_address <- function(cmd = 'ip address',
                           ip_pattern = '(\\d{1,3}\\.){3}\\d{1,3}',
                           con_pattern = 'eth0',
                           verbose = FALSE) {
    output <- system(cmd, intern = TRUE)
    if (verbose) {print(output)}

    ipd <- stringr::str_detect(output, con_pattern)
    if (verbose) {print(ipd)}

    ipl <- output[ipd]
    if (verbose) {print(ipl)}

    ip <- stringr::str_extract(ipl, ip_pattern)
    if (verbose) {print(ip)}

    ip <- ip[!is.na(ip)]

    if (verbose) {print(sprintf('Your IP address is: %s', ip))}

    return(ip)
}
