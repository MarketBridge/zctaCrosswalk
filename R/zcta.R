#' Returns a ZCTA Crosswalk as a tibble
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

#
# get_zctas_in_county = function(counties) {
#   stopifnot(all(counties %in% zcta_crosswalk$county_fips))
#
#   zcta_crosswalk |>
#     filter(county_fips %in% counties) |>
#     pull(zcta)
# }
#
# get_zctas_in_county("06075") # San Francisco
#
# get_zctas_in_state = function(state_fips  = NULL,
#                               state_names = NULL,
#                               state_abbs  = NULL) {
#
#   # User is required to supply exactly one of these parameters
#   num_params = sum(!is.null(state_fips),
#                    !is.null(state_names),
#                    !is.null(state_abbs))
#   stopifnot(num_params == 1)
#
#   if (!is.null(state_names)) {
#     state_fips = get_state_fips_from_state_names(state_names)
#   } else if (!is.null(state_abbs)) {
#     state_fips = get_state_fips_from_state_abbs(state_abbs)
#   }
#
#   # The {{ }} ("embrace") means "use the variable, not the column name"
#   zcta_crosswalk |>
#     filter(state_fips %in% {{state_fips}}) |>
#     pull(zcta)
# }
#
# get_state_fips_from_state_names = function(state_names) {
#
#   stopifnot(all(state_names %in% fips_state_table$name))
#
#   fips_state_table |>
#     filter(name %in% state_names) |>
#     pull(fips)
# }
#
# get_state_fips_from_state_abbs = function(state_abbs) {
#
#   stopifnot(all(state_abbs %in% fips_state_table$abb))
#
#   fips_state_table |>
#     filter(abb %in% state_abbs) |>
#     pull(fips)
# }
#
#
# # TODO: Use tidy_census::fips_codes instead of this. It also i
# # TODO: Maybe I should copy from the this site instead?
# # https://www.bls.gov/respondents/mwr/electronic-data-interchange/appendix-d-usps-state-abbreviations-and-fips-codes.htm
#
#
# # Taken from https://github.com/walkerke/tidycensus/blob/3be2e7e30f6168f403902f89e4d87eab6402853a/R/zzz.r#L8
# fips_state_table <- structure(list(
#   abb = c("ak", "al", "ar", "as", "az", "ca", "co",
#           "ct", "dc", "de", "fl", "ga", "gu", "hi", "ia", "id", "il", "in",
#           "ks", "ky", "la", "ma", "md", "me", "mi", "mn", "mo", "ms", "mt",
#           "nc", "nd", "ne", "nh", "nj", "nm", "nv", "ny", "oh", "ok", "or",
#           "pa", "pr", "ri", "sc", "sd", "tn", "tx", "ut", "va", "vi", "vt",
#           "wa", "wi", "wv", "wy", "mp"),
#   fips = c("02", "01", "05", "60", "04",
#            "06", "08", "09", "11", "10", "12", "13", "66", "15", "19", "16",
#            "17", "18", "20", "21", "22", "25", "24", "23", "26", "27", "29",
#            "28", "30", "37", "38", "31", "33", "34", "35", "32", "36", "39",
#            "40", "41", "42", "72", "44", "45", "46", "47", "48", "49", "51",
#            "78", "50", "53", "55", "54", "56", "69"),
#   name = c("alaska", "alabama",
#            "arkansas", "american samoa", "arizona", "california", "colorado",
#            "connecticut", "district of columbia", "delaware", "florida",
#            "georgia", "guam", "hawaii", "iowa", "idaho", "illinois", "indiana",
#            "kansas", "kentucky", "louisiana", "massachusetts", "maryland",
#            "maine", "michigan", "minnesota", "missouri", "mississippi",
#            "montana", "north carolina", "north dakota", "nebraska", "new hampshire",
#            "new jersey", "new mexico", "nevada", "new york", "ohio", "oklahoma",
#            "oregon", "pennsylvania", "puerto rico", "rhode island", "south carolina",
#            "south dakota", "tennessee", "texas", "utah", "virginia", "virgin islands",
#            "vermont", "washington", "wisconsin", "west virginia", "wyoming", "northern mariana islands")),
#   .Names = c("abb", "fips", "name"),
#   row.names = c(NA, -56L),
#   class = "data.frame")
# fips_state_table = as_tibble(fips_state_table)
