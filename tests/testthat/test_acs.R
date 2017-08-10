library(sdalr)
library(acs)
context("ACS")

test_that("ACS package is working", {

    test_func <- function() {
        arlington <- geo.make(state = "VA",
                              county = "Arlington",
                              tract = "*",
                              block.group = "*")

        Population_Total <- acs.fetch(geo = arlington,
                                      endyear = 2015,
                                      table.number = "B01003")

    }
    expect_error(test_func(), NA)
})
