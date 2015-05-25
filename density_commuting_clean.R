library(dplyr) # data manipulation
library(readxl) # for reading in xlsx files
library(rvest) # scraping online data

# download bike data from census.gov and import with read_excel
download.file("http://www.census.gov/hhes/commuting/files/2014/Supplemental-Table3.xlsx", destfile = "bike.xlsx")

bike_raw <- read_excel("bike.xlsx", skip = 5)

# renaming columns 
colnames(bike_raw) <- c("city.state", "num.bike", "per.bike", "margin.bike")

# download waking data from census.gov and import with read_excel
download.file("http://www.census.gov/hhes/commuting/files/2014/Supplemental-Table6.xlsx", destfile = "walk.xlsx")

walk_raw <- read_excel("walk.xlsx", skip = 5)

colnames(walk_raw) <- c("city.state", "num.walk", "per.walk", "margin.walk")

# merge the biking and walking data 
comb_raw <- left_join(bike_raw, walk_raw)

# clean up the city.state text so we can merge with the population data
comb_clean <- comb_raw %>%
  filter(!is.na(per.walk)) %>%
  # don't need city label; using \\ to escape the special characters
  mutate(city.state = gsub(" city| municipality| \\(balance\\)", "", city.state), 
         # then fixing a very specific problem with TN
         city.state = gsub("-Davidson metropolitan government", ", Tennessee", city.state),
         per.bike.walk = per.bike + per.walk) 

# pull population data from wikipedia (this checks out with the census site and is already formatted in a nice table)
pop_raw <- html("https://en.wikipedia.org/wiki/List_of_United_States_cities_by_population") %>%
  html_node("table.wikitable") %>%
  html_table()

colnames(pop_raw) <- c("rank", "city", "state", "pop.2013", "pop.2010", "change", "area.sqm", "density", "location")

# clean up the random symbols and other anomalies
pop_clean <- pop_raw %>% 
  select(-location) %>%
  mutate(rank = as.numeric(gsub("-\\(T\\)", "", rank)),
         # regexp means (.) any character, (*) 0 or more times until the symbol (♠)
         change = as.numeric(gsub("−", "-", gsub(".*♠|%|+", "", change))), 
         pop.2013 = as.numeric(gsub(",", "", pop.2013)),
         pop.2010 = as.numeric(gsub(",", "", pop.2010)),
         # removing endnote
         city = gsub("\\d|\\[|\\]", "", city), 
         area.sqm = as.numeric(gsub(".*♠|sq.*$", "", area.sqm)),
         density = as.numeric(gsub(",|.*♠|per.*$", "", density)),    
         city.state = paste(city, state, sep = ", ")) %>%
  filter(rank < 51)

# merge population and commuting data
fin_clean <- left_join(pop_clean, comb_clean)

write.csv(fin_clean, "cle_density_commuting.csv", row.names = F)
