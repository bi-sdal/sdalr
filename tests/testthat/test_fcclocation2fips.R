library(sdalr)
context("FCClocation2FIPS")

test_that("FCC Location 2 FIPS is working", {
    expected <- data.table::data.table(place_id = "VTRC",
                                       state_name = "Virginia",
                                       state_fips = "51",
                                       county_name = "Arlington",
                                       county_fips = "51013",
                                       block_fips = "510131014011007")
    calculated <- FCClocation2FIPS("VTRC", lat = 38.880807, lon = -77.11577)
    expect_equal(calculated, expected)
})

test_that("Multiple FCC Locations 2 FIPS is working", {
    expected <- data.table::data.table(
        place_id = c("VTRC", "VT-NVC"),
        state_name = c("Virginia", "Virginia"),
        state_fips = c("51", "51"),
        county_name = c("Arlington", "Fairfax"),
        county_fips = c("51013", "51059"),
        block_fips = c("510131014011007", "510594710001040"))
    calculated <- FCClocations2FIPS(
        place_idCol = c("VTRC", "VT-NVC"),
        latCol = c(38.880807, 38.8968325),
        lonCol = c(-77.11577, -77.1894815))
    expect_equal(calculated, expected)
})
