% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zcta.R
\name{get_zctas_by_state}
\alias{get_zctas_by_state}
\title{Return the ZCTAs in a vector of states}
\usage{
get_zctas_by_state(states)
}
\arguments{
\item{states}{A vector of States. Can be FIPS Codes (either character or numeric), names or USPS abbreviations.}
}
\value{
A vector, where each element is a ZCTA in the requested state.
}
\description{
Given a vector of states, return the ZIP Code Tabulation Areas (ZCTAs)
in those states.
}
\examples{
# Not case sensitive when using state names
ca_zctas = get_zctas_by_state("CaLiFoRNia")
length(ca_zctas)
head(ca_zctas)

# "06" is the FIPS code for California
ca_zctas = get_zctas_by_state("06")
length(ca_zctas)
head(ca_zctas)

# 6 is OK too - sometimes people use numbers for FIPS codes
ca_zctas = get_zctas_by_state(6)
length(ca_zctas)
head(ca_zctas)

# USPS state abbreviations are also OK
ca_zctas = get_zctas_by_state("CA")
length(ca_zctas)
head(ca_zctas)

# Multiple states at the same time are also OK
ca_ny_zctas = get_zctas_by_state(c("CA", "NY"))
length(ca_ny_zctas)
head(ca_ny_zctas)

}
