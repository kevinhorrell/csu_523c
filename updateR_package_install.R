## Packages to Install on R Update##

install.packages('remotes')
library(remotes)

remotes::install_github("mikejohnson51/AOI")

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