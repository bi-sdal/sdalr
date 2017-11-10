library(secret)

#' Create the default sdal vault
#'
#' mainly useful for testing or after deleting the vault
#' @export
create_vault_sdal <- function(vault = '/home/sdal/projects/sdal/vault/') {
    create_vault(vault)
}
