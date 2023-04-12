# Motivation

This package is designed to help answer common analytical questions that arise
when working with US ZIP Codes.

Note: the entity which maintains US ZIP Codes (the US Postal
Service) does not release a map or crosswalk of that dataset. As a result, most
analysts instead use [ZIP Code Tabulation Areas (ZCTAs)](https://www.census.gov/programs-surveys/geography/guidance/geo-areas/zctas.html) which
are maintained by the US Census Bureau. Census
also provides [Relationship Files](https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.2020.html#zcta) that maps ZCTAs to other geographies.

This package provides the "2020 ZCTA to County Relationship File" as a tibble, as well as convenience functions for working with it.

# Installation

`zctaCrosswalk` is not currently available on CRAN. You can install the latest
development version like this:

```
library(devtools)
install_github('https://github.com/MarketBridge/zctaCrosswalk/')
```

# Example Usage

The most useful functions in this package are:

 * `?get_zctas_by_county`
 * `?get_zctas_by_state`
 * `?get_zcta_metadata`

The Relationship File is stored as the tibble `zcta_crosswalk`. Note that the file has been processed to make it easier to work with. To see the processing,
view the contents of the function `?get_zcta_crosswalk` by typing
`get_zcta_crosswalk` (i.e., if you drop the parentheses, then R will show you the contents of the function).
