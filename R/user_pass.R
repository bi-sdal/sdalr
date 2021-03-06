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
#' @param secret_name: string, the name of the secret to be stored, defaults to your username
#'
#' @import secret
#' @import getPass
#'
#' @return NULL
#' @export
setup_user_pass <- function(username = unname(Sys.info()['user']),
                            password = NULL,
                            public_key = '~/.ssh/id_rsa.pub',
                            vault = '/home/sdal/projects/sdal/vault',
                            secret_name = unname(Sys.info()['user']),
                            verbose = FALSE) {
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
    secret_to_keep <- .secret_to_keep(user = username, pass = password)

    if (verbose) {
        print("setting up user pass")

        print('secret to keep:')
        print(secret_to_keep)
        print('secret_name:')
        print(secret_name)
        print('username:')
        print(username)
        print('vault:')
        print(vault)
    }

    add_secret(secret_name, secret_to_keep, users = username, vault = vault)

    if (verbose) {
        print('getting secrets from one just created')
        print(get_secret(secret_name, local_key() , vault))
        print(get_secret(secret_name, local_key() , vault)['username'])
        print(get_secret(secret_name, local_key() , vault)['password'])
    }
}

#' Update the username and password saved in the vault
#' Typically used after you change your LDAP password
#'
#' @param username, string, username to be updated, defaults to the current user
#' @param password, string, password to be updated, defaults to NULl which will prompt the user for a password
#' @param secret_name, string, location of the vault, defaults to the sdal vault
#' @return NULL
#' @export
update_user_pass <- function(username = unname(Sys.info()['user']),
                             password = NULL,
                             secret_name = unname(Sys.info()['user']),
                             vault = '/home/sdal/projects/sdal/vault') {
    secret_to_keep <- .secret_to_keep(username, password)

    update_secret(secret_name, secret_to_keep, key = local_key(), vault = vault)
}

#' Get the username of the current user
#'
#' @param secret_name, string, the secret to look up, defaults to the current username
#' @param key, string, location of the private key, defaults to local_key(), ~/.ssh/id_rsa
#' @param vault, string, location of the vault, defualts to /home/sdal/projects/sdal/vault
#'
#' @return character, the username
#' @export
get_my_username <- function(secret_name = unname(Sys.info()['user']),
                            key = local_key(),
                            vault = '/home/sdal/projects/sdal/vault',
                            verbose = FALSE) {
    if (verbose) {
        print('all secrets:')
        print(get_secret(secret_name, key , vault))
    }
    return(unname(get_secret(secret_name, key , vault)['username']))
}


#' Get the password of the current user
#'
#' @param secret_name, string, the secret to look up, defaults to the current username
#' @param key, string, location of the private key, defaults to local_key(), ~/.ssh/id_rsa
#' @param vault, string, location of the vault, defualts to /home/sdal/projects/sdal/vault
#'
#' @return character, the password
#' @export
get_my_password <- function(secret_name = unname(Sys.info()['user']),
                            key = local_key(),
                            vault = '/home/sdal/projects/sdal/vault') {
    return(unname(get_secret(secret_name, key , vault)['password']))
}
