context("Fetch Census Bureau's 2020 ZCTA Country Relationship file as a tibble")

test_that("standard get_zcta_crosswalk()", {
  fetch_data <- get_zcta_crosswalk()
  
  expect_equal(nrow(fetch_data), 46960)
  expect_equal(ncol(fetch_data), 4)
  expect_equal(colnames(fetch_data), c("zcta", "county_fips", "county_name", "state_fips"))
})