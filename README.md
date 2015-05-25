# Cleveland Density and Commuting Charts

These charts were created for this <a href="http://beltmag.com/why-cant-cleveland-be-more-like-a-bicycle/" target="_blank">article</a> in Belt Magazine on urban density and commuting.

The <a href="https://github.com/etachov/cle-density-commuting/blob/master/density_commuting_clean.R" target="_blank">density_commuting_clean.R</a> script downloads and cleans the data for the charts from the U.S. Census and Wikipedia, using <a href="https://github.com/hadley/readxl" target="_blank">readxl</a> to deal with `.xlsx` files and <a href="https://github.com/hadley/rvest" target="_blank">rvest</a> to scrape tables. As always, <a href="http://blog.rstudio.org/2014/01/17/introducing-dplyr/" target="_blank">dplyr</a> holds the whole thing together. The resulting <a href="https://raw.githubusercontent.com/etachov/cle-density-commuting/master/cle_density_commuting.csv" target="_blank">clean data</a> is included in the respository.  

The <a href="https://github.com/etachov/cle-density-commuting/blob/master/density_commuting_charts.R" target="_blank">density_commuting_charts.R</a> script creates the final charts using <a href="http://ggplot2.org/" target="_blank">ggplot2</a>. The final charts are below:

![](https://github.com/etachov/cle-density-commuting/blob/master/Density Rank.png)

![](https://github.com/etachov/cle-density-commuting/blob/master/Biking v. Walking.png)