# What a horrible world we live in, where code like this is necessary.
# See https://community.rstudio.com/t/how-to-solve-no-visible-binding-for-global-variable-note/28887
globalVariables("zcta_crosswalk")

#' Returns a ZCTA crosswalk as a tibble
#'
#' Returns the Census Bureau's 2020 ZCTA Country Relationship file
#' as a tibble. This function is included so that users can see how the crosswalk
#' was generated. It is not intended for use by end users.
#' @seealso All 2020 Zip Code Tabulation Area 5-Digit (ZCTA5) Relationship Files: https://rb.gy/h0l5cs
#' @importFrom readr read_delim
#' @importFrom dplyr rename select mutate filter
#' @importFrom rlang .data
#' @importFrom stringr str_sub
#' @export
get_zcta_crosswalk = function() {

  url = "https://www2.census.gov/geo/docs/maps-data/data/rel2020/zcta520/tab20_zcta520_county20_natl.txt"
  zcta_crosswalk = read_delim(file = url, delim = "|")

  # Select and rename columns
  zcta_crosswalk = zcta_crosswalk |>
    rename(zcta        = .data$GEOID_ZCTA5_20,
           county_fips = .data$GEOID_COUNTY_20,
           county_name = .data$NAMELSAD_COUNTY_20) |>
    select(.data$zcta, .data$county_fips, .data$county_name)

  # 1. The county FIPS is always 5 characters. And the first 2 characters always
  # indicate the state. See https://en.wikipedia.org/wiki/FIPS_county_code.
  # Breaking out the state allows for easier state selection later.
  # 2. This file has all counties, some of which do not have a ZCTA. Remove
  # those counties.
  zcta_crosswalk |>
    mutate(state_fips = str_sub(.data$county_fips, 1, 2)) |>
    filter(!is.na(.data$zcta))
}

#' Return the ZCTAs in a vector of counties
#'
#' Given a vector of counties, return the Zip Code Tabulation Areas (ZCTAs)
#' in those counties
#'
#' @param counties A vector of Counties as FIPS codes. Must be 5-digits as characters - see examples.
#' @examples
#' # 06075 is San Francisco County, California
#' get_zctas_in_county("06075")
#'
#' # "36059" is Nassau County, New York
#' get_zctas_in_county(c("06075", "36059"))
#' @importFrom utils data
#' @importFrom dplyr pull filter
#' @export
get_zctas_in_county = function(counties) {
  data("zcta_crosswalk", package = "zctaCrosswalk", envir = environment())

  stopifnot(all(counties %in% zcta_crosswalk$county_fips))

  zcta_crosswalk |>
    filter(.data$county_fips %in% counties) |>
    pull(.data$zcta)
}

#' Return the ZCTAs in a vector of states
#'
#' Given a vector of states, return the Zip Code Tabulation Areas (ZCTAs)
#' in those states
#'
#' @param state_fips A vector of Counties as FIPS codes. Must be 2-digits as characters - see examples.
#' @examples
#' # 06 is California
#' ca_zctas = get_zctas_in_state("06")
#' length(ca_zctas)
#' head(ca_zctas)
#'
#' # "36" is New York
#' ny_ca_zctas = get_zctas_in_state(c("36", "06"))
#' length(ny_ca_zctas)
#' head(ny_ca_zctas)
#' @export
#' @importFrom dplyr filter pull
get_zctas_in_state = function(state_fips) {
  data("zcta_crosswalk", package = "zctaCrosswalk", envir = environment())

  # The {{ }} ("embrace") means "use the variable, not the column name"
  zcta_crosswalk |>
    filter(.data$state_fips %in% {{state_fips}}) |>
    pull(.data$zcta)
}

#' Return metadata on a ZCTA
#'
#' Given a vector of Zip Code Tabulation Areas (ZCTAs), return what
#' state and county they are in. NOTE: A single ZCTA can span multiple
#' states and counties.
#'
#' @param zctas A vector of ZCTAs
#' @examples
#' get_zcta_metadata("90210")
#'
#' get_zcta_metadata("39573")
#' @export
#' @importFrom dplyr filter
get_zcta_metadata = function(zctas) {
  data("zcta_crosswalk", package = "zctaCrosswalk", envir = environment())

  stopifnot(all(zctas %in% zcta_crosswalk$zcta))

  zcta_crosswalk |>
    filter(.data$zcta %in% zctas)
}
