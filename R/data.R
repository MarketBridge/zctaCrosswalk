#' 2020 Crosswalk of ZIP Code Tabulation Areas (ZCTAs)
#'
#' The primary data was obtained via the function get_zcta_crosswalk. There are 3 types of columns: ZCTA,
#' state and county. Where data in practice sometimes appears as both character and numeric, columns for both are 
#' provided. 
#'
#' @docType data
#' @name zcta_crosswalk
#' @usage data(zcta_crosswalk)
NULL

#' Metadata for Each "State" in zcta_crosswalk 
#'
#' The complete dataset in ?zcta_crosswalk contains information on 56 state and
#' state-equivalents. This dataframe contains the full name of each "state", plus
#' its USPS abbreviation and FIPS code.
#'
#' @docType data
#' @name state_names
#' @usage data(state_names)
NULL