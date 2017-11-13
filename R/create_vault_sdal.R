library(secret)

#' Create the default sdal vault
#'
#' mainly useful for testing or after deleting the vault
#' @param vault, string, location of the vault, defaults to /home/sdal/projects/sdal/vault
#' @export
create_vault_sdal <- function(vault = '/home/sdal/projects/sdal/vault/') {
    create_vault(vault)
}
