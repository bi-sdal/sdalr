library(acs)
library(dplyr)
library(stringr)

#'Filter ACS zipcodes to the ones you want
#'
#'When you pull the ACS data table by zipcodes, it will provide zipcodes all over the
#'States. This function allows you to filer to the zipcodes you want.
#'This requires a ACS key installed for it to work. They function is api.key.install().
#'Below are the instructions to get ACS API Key.
#' 1. load and install the R package acs.
#' 2. Install an API key by going to the Census website here
#'    http://api.census.gov/data/key_signup.html
#'    Fill out the simple form and agree to the Terms of Service.
#' 3. Census will email you a key for your use only.
#' 4. Once you get your key from census, you can install it using api.key.install()

#' @param tablecode ACS tablecode. Refers to corresponding demographic variables such as total population. Eg. B01003: Population by Age and Sex
#' @param endyear The year of the ACS survey
#' @param ziplist A character vector of zipcodes to filter ACS variables by. Can be numeric vector if there are no leading zeros.
#' @return dataframe that returns 3 columns. First column is the zip code from ziplist. Second column is the variable estimate from the table code and end year. Thrid column is the standard error of the second column from the table code and end year.
#' @export
#' @examples
#' pop_age_group_2015 <- zip_matcher("B01003",2015, c("22030", "22031"))
#'
##########################################################################################

zip_matcher <- function(tablecode,endyear, ziplist){
    #Get data for all the zipcodes
    US_ACS_ZIP <- geo.make(zip.code = "*")
    #Fetch the particular table
    US.TP <- acs.fetch(geography=US_ACS_ZIP, endyear=endyear, table.number=tablecode, col.name="pretty")
    #Pulling out the Stats we want
    USStats <- data.frame(estimate(US.TP), round(standard.error(US.TP),0))
    #Establishing Zipcode from Rownames
    USStats$zipcode <- row.names(USStats)
    #Spliting the String part and the numeric part of Zipcode
    USStats$zipcode <- .zip_acs_processing(USStats$zipcode)
    #Importing and Processing the Master ZipCode File
    #For leading zero zip codes, you should have it formatted as character to begin with.
    ziplist <- .input_zip_processing(ziplist)
    ziplist$zipcode <- as.character(ziplist$zipcode)
    USStats$zipcode <- as.character(USStats$zipcode)
    #Joining the two tables by ZipCode
    US_Zip_Final <- ziplist %>% left_join(USStats, by = "zipcode")
    return (US_Zip_Final)
}

##########################################################################################
#zip_acs_processing: this helper function cleans the zipcodes from the ACS table. It takes in
#                    a list of zipcodes
##########################################################################################
.zip_acs_processing <- function(zipcode){
    zip_split <- str_split(zipcode, pattern = " ", n = 2)
    zipcode <- sapply(zip_split, function(x) x[2])
    return(zipcode)
}

##########################################################################################
#input_zip_processing: this helper function cleans the zipcodes that the user provides and
#                      formats it as well as takes care of edge cases like leading "00"
##########################################################################################
.input_zip_processing <- function(zipcode){
    zipcode <- as.data.frame(zipcode)
    colnames(zipcode) <- "zipcode"
    return (zipcode)
}

