con_db <- function(db, user, pass, driver = 'PostgreSQL',
                   host = 'localhost', port = 5432, close_existing_cons = TRUE) {
    if (driver == 'PostgreSQL') {
        con_db_postgresql(db, user, pass, host, port, close_existing_cons)
    } else{
        stop("Unknown driver")
    }

}

con_db_postgresql <- function(db, user, pass, host, port, close_existing_cons){
    if (require(RPostgreSQL)) {
        drv <- RPostgreSQL::dbDriver("PostgreSQL")

        if (close_existing_cons) {
            all_cons <- RPostgreSQL::dbListConnections(drv)
            for (con in all_cons) {RPostgreSQL::dbDisconnect(con)}
        }

        con <- RPostgreSQL::dbConnect(drv, dbname = db,
                                      host = host, port = port,
                                      user = user, password = pass)
        return(con)
    } else {
        stop('You need to install the "RPostgreSQL" library')
    }
}
