library(zctaCrosswalk)
library(tibble)
library(dplyr)
library(choroplethrMaps)

# choroplethrMaps package has a state.regions df that has most, but not all, of what we need
data(state.regions)
state.regions = as_tibble(state.regions)
nrow(state.regions) # 51
state.regions

# Generate extra rows we need
extra_states = rbind(
  data.frame(region = "puerto rico",              abb = "PR", fips.numeric = 72L, fips.character="72"),
  data.frame(region = "u.s. virigin islands",     abb = "VI", fips.numeric = 78L, fips.character="78"),
  data.frame(region = "american samoa",           abb = "AS", fips.numeric = 60L, fips.character="60"),
  data.frame(region = "guam",                     abb = "GU", fips.numeric = 66L, fips.character="66"),
  data.frame(region = "northern mariana islands", abb = "MP", fips.numeric = 69L, fips.character="69")
)

# Now merge and rename columns
state_names = rbind(state.regions, extra_states)
colnames(state_names) = c("full", "usps", "fips_numeric", "fips_character")

save(state_names, file="data/state_names.rda")
