# Tony's replication of Prabhat's code

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```


```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r}
library('knitr')

library('RODBC')

library("dplyr")

library("readxl")

library("readxl")

library("xlsx")
```

Beginning of actual code !

```{r}
# Read in sample file
GA_1 <- read.delim("/Users/anthonygoss/Downloads/IVR_2018_export_ev_CR-7883_2019-04-16.txt")
```

```{r}
#The following code can be used in order to de-duplicate the record based on required date or registration#
GA_1$ANIDsub <- paste(GA_1$ANID,GA_1$subgroup)

#no_blank_subgroups <- GA_1 %>%
#  filter(!(is.na(subgroup) | subgroup == ""))

# Use the responses in order to generate ifelse logic to create the syntax necessary

# You can concatenate ANID with subgroup just to keep unique individual within a subgroup. 

GA_1a <- GA_1[order(GA_1$ANIDsub,GA_1$requireddate, decreasing=TRUE),]

#Keep only the first row for the duplicate of UNIQUE_ID
GA_1b <- GA_1a[!duplicated(GA_1a$ANIDsub),]
mean(duplicated(GA_1b$ANIDsub))
```

```{r}
test_blocks <- GA_1b%>%
  filter(subgroup == "Blocks" | subgroup == "blocks")
```



