library(sdalr)
context("Test File Renumbering")

test_that("Renaming script numbers", {
    expected <- "account_table_2017-07-17_001.RData"
    calculated <- renumber_file(file_name = 'account_table_2017-07-17_1.RData',
                                number_match_pattern = '\\d*\\.RData$',
                                pad_width = 3,
                                verbose = FALSE)
    expect_equal(calculated, expected)


    expected <- "001-my_script.R"
    calculated <- renumber_file(file_name = "1-my_script.R",
                                number_match_pattern = '^\\d*-',
                                pad_width = 3,
                                verbose = FALSE)
    expect_equal(calculated, expected)

})
