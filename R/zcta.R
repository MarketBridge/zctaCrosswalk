# What a horrible world we live in, where code like this is necessary.
# See https://community.rstudio.com/t/how-to-solve-no-visible-binding-for-global-variable-note/28887
globalVariables("zcta_crosswalk")

#' Returns a ZCTA crosswalk as a tibble
#'
#' Returns the Census Bureau's 2020 ZCTA Country Relationship file
#' as a tibble. This function is included so that users can see how the crosswalk
#' was generated. It is not intended for use by end users.
#' @seealso All 2020 ZIP Code Tabulation Area 5-Digit (ZCTA5) Relationship Files: https://rb.gy/h0l5cs
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
#' Given a vector of counties, return the ZIP Code Tabulation Areas (ZCTAs)
#' in those counties
#'
#' @param counties A vector of Counties as FIPS codes. Must be 5-digits as characters - see examples.
#' @examples
#' # 06075 is San Francisco County, California
#' get_zctas_by_county("06075")
#'
#' # "36059" is Nassau County, New York
#' get_zctas_by_county(c("06075", "36059"))
#' @importFrom utils data
#' @importFrom dplyr pull filter
#' @export
get_zctas_by_county = function(counties) {
  data("zcta_crosswalk", package = "zctaCrosswalk", envir = environment())

  if (all(tolower(counties) %in% zcta_crosswalk$county_name)) {
    col = "county_name"
    counties = tolower(counties)
  } else if (all(counties %in% zcta_crosswalk$county_fips)) {
    col = "county_fips"
  } else if (all(counties %in% zcta_crosswalk$county_fips_numeric)) {
    col = "county_fips_numeric"
  } else {
    stop("User supplied bad data! Type 'get_zctas_by_county' to understand how this function works.")
  }

  zcta_crosswalk |>
    filter(!!sym(col) %in% counties) |>
    pull(.data$zcta) |>
    unique()
}

#' Return the ZCTAs in a vector of states
#'
#' Given a vector of states, return the ZIP Code Tabulation Areas (ZCTAs)
#' in those states.
#'
#' @param states A vector of States. Can be FIPS Codes (either character or numeric), names or USPS abbreviations.
#'
#' @examples
#' # Not case sensitive when using state names
#' ca_zctas = get_zctas_by_state("CaLiFoRNia")
#' length(ca_zctas)
#' head(ca_zctas)
#'
#' # "06" is the FIPS code for California
#' ca_zctas = get_zctas_by_state("06")
#' length(ca_zctas)
#' head(ca_zctas)
#'
#' # 6 is OK too - sometimes people use numbers for FIPS codes
#' ca_zctas = get_zctas_by_state(6)
#' length(ca_zctas)
#' head(ca_zctas)
#'
#' # USPS state abbreviations are also OK
#' ca_zctas = get_zctas_by_state("CA")
#' length(ca_zctas)
#' head(ca_zctas)
#'
#' # Multiple states at the same time are also OK
#' ca_ny_zctas = get_zctas_by_state(c("CA", "NY"))
#' length(ca_ny_zctas)
#' head(ca_ny_zctas)
#'
#' \dontrun{
#' # But you can't mix types in a single request
#' ny_ca_zctas = get_zctas_in_state(c("06", "NY"))
#' }
#' @export
#' @importFrom dplyr filter pull sym
get_zctas_by_state = function(states) {
  data("zcta_crosswalk", package = "zctaCrosswalk", envir = environment())

  if (all(tolower(states) %in% zcta_crosswalk$state_name)) {
    col = "state_name"
    states = tolower(states)
  } else if (all(states %in% zcta_crosswalk$state_usps)) {
    col = "state_usps"
  } else if (all(states %in% zcta_crosswalk$state_fips)) {
    col = "state_fips"
  } else if (all(states %in% zcta_crosswalk$state_fips_numeric)) {
    col = "state_fips_numeric"
  } else {
    stop("User supplied bad data! Type 'get_zctas_by_state' to understand how this function works.")
  }

  print(paste("Using column", col))
  zcta_crosswalk |>
    filter(!!sym(col) %in% states) |>
    pull(.data$zcta) |>
    unique()
}

#' Return metadata on a ZCTA
#'
#' Given a vector of ZIP Code Tabulation Areas (ZCTAs), return what
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
