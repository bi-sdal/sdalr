library(secret)
library(getPass)

#' Convenience function to create the username and password vector for the vault.
#'
#' Most likely you should not be calling this funciton
#'
#' @param user: string, the username to be added to the vault
#' @param pass: string, the password associated with the username
#'
#' @return vector of 'password' and 'username' values
.secret_to_keep <- function(user, pass) {
    if (is.null(pass)) {
        pass <- getPass("LDAP Password (the one you use to login to Lightfoot and RStudio):")
    }
    secret_to_keep <- c(password = pass,
                        username = user)
    return(secret_to_keep)
}

#' Initial setup of secret vault with username and password secrets
#'
#' If you need to update a username/password please see: `update_user_pass``
#'
#' @param username: string, the username, defaults to the user of the current R session
#' @param password: string, defaults to NULL which will prompt you for your password
#' @param public_key: string, the location of the public key, defaults to '~/.ssh/id_rsa.pub'
#' @param vault: string, location of the vault, defaults to '/home/sdal/projects/sdal/vault'
#' @param secret_name: string, the name of the secret to be stored, defaults to 'ldap'
#'
#' @return NULL
#' @export
setup_user_pass <- function(username = Sys.info()['user'],
                            password = NULL,
                            public_key = '~/.ssh/id_rsa.pub',
                            vault = '/home/sdal/projects/sdal/vault',
                            secret_name = Sys.info()['user']) {
    if (!file.exists('~/.ssh/id_rsa.pub')) {
        stop(
            cat(
                sprintf(
                    paste('Unable to find public key in %s',
                          'You can create a public key by running the following commad in the terminal in Lightfoot:',
                          'ssh-keygen',
                          'You can then press enter through all the user prompts to use the default settings.',
                          sep = '\n'
                    ),
                    public_key
                )
            )
        )
    }
    add_user(username, public_key, vault)
    secret_to_keep <- .secret_to_keep(username, password)
    add_secret(secret_name, secret_to_keep, users = username, vault = vault)
}

#' Update the username and password saved in the vault
#' Typically used after you change your LDAP password
#'
#' @param username, string, username to be updated, defaults to the current user
#' @param password, string, password to be updated, defaults to NULl which will prompt the user for a password
#' @param secret_name, string, location of the vault, defaults to the sdal vault
#' @return NULL
#' @export
update_user_pass <- function(username = Sys.info()['user'],
                             password = NULL,
                             secret_name = Sys.info()['user'],
                             vault = '/home/sdal/projects/sdal/vault') {
    secret_to_keep <- .secret_to_keep(username, password)

    update_secret(secret_name, secret_to_keep, key = local_key(), vault = vault)
}

#' Get the username of the current user
#' @export
get_my_username <- function(secret_name = Sys.info()['user'],
                            key = local_key(),
                            vault = '/home/sdal/projects/sdal/vault') {
    return(get_secret(secret_name, key , vault)['username'])
}

#' Get the password of the current user
#' @export
get_my_password <- function(secret_name = Sys.info()['user'],
                            key = local_key(),
                            vault = '/home/sdal/projects/sdal/vault') {
    return(get_secret(secret_name, key , vault)['password'])
}
