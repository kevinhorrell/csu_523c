## Packages to Install on R Update##

install.packages('remotes')
library(remotes)

remotes::install_github("mikejohnson51/AOI")
remotes::install_github("ropensci/USAboundaries")
remotes::install_github("ropensci/USAboundariesData")

#data Retrieval from USGS
install.packages('dataRetrieval')
library(dataRetrieval)

#machine learning and data manipulation
library(tidymodels)

install.packages('powerjoin')
install.packages('glue')
install.packages('vip')
install.packages('baguette')


##Data Viz
install.packages('gghighlight')
library(gghighlight)
library(ggrepel)
install.packages('ggthemes')
library(ggthemes)

##Time Series
remotes::install_github("mikejohnson51/climateR")
#Modeltime Dependencies
install.packages("RcppParallel")
install.packages("reactR")
install.packages("bigD")
install.packages("bitops")
install.packages("juicyjuice")
install.packages("markdown")
install.packages("snakecase")
install.packages("dygraphs")
install.packages("extraDistr")

install.packages("StanHeaders")
install.packages("rstantools")
install.packages("rstan")

install.packages("reactable")
install.packages("gt")
install.packages("janitor")

# Then parallel computing packages
install.packages("doParallel")

# Finally the forecasting packages
install.packages("prophet")
install.packages("modeltime")
