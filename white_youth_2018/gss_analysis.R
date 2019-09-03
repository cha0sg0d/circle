# Note GSS dataframe is loaded into the environment from R script.
library('dplyr')

young_GSS <- GSS %>%
  filter(AGE < 30)

mytable <- table(GSS$RACE, GSS$PARTYID) 
ftable(mytable)


# Load function
source("http://pcwww.liv.ac.uk/~william/R/crosstab.r")
# Frequency count
crosstab(GSS, row.vars = "RACE", col.vars = "PARTYID", type = "f")
