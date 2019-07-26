# Tony's first attempt at replicating / improving SQL code

# Step 1: Read in the dataset, save a subset of it
```{r}
working_app <- read.delim("/Users/anthonygoss/Downloads/working_applications2016_0000.txt")
# curr <- mean(duplicated(working_app$anid) == TRUE) returns .15
```


```{r}
library(dplyr)
subset_working_app <- sample_n(working_app, 100000)
rm(working_app)

copy <- subset_working_app
```


```{r}
small_working_app <- sample_n(subset_working_app,100)
```

```{r}
empty_subgroup <- mean(subset_working_app$subgroup == "")
empty_subgroup_vpc <- mean(subset_working_app$subgroup == "" & subset_working_app$org == "vpc")
```

# Replace each instance where org = vpc and subgroup is empty with subgroup = vpc
```{r}
subset_working_app$subgroup[subset_working_app$subgroup==""] <- NA

subset_working_app$subgroup <- as.character(subset_working_app$subgroup)
subset_working_app$subgroup[is.na(subset_working_app$subgroup)] <- "vpc"
```

# We now have a manageable subgroup of data to work with.
# Let's download SQL for R and start analyzing the commented_query.sql file
```{r}
library('sqldf')
```
select cast('2016-12-25' as date) as christmas
becomes

select '2016-12-25'::date as christmas
```{r}
test <- sqldf("
    SELECT  anid 
    , case when person_rank=1 then race else null end as race
    , 1 unique_applicants
    , matched_app as matched_applicants
    , CASE WHEN successful_app = TRUE AND case when es_n2016g =1 then 1 else 0 end = 1 then 1 else null end general_election_voters_2016
    
    , CASE WHEN roll_changing_app = TRUE AND case when es_n2016g =1 then 1 else 0 end = 1 then 1 else null end general_election_roll_changing_voters_2016
    
    , CASE WHEN new_registrant = TRUE AND case when es_n2016g =1 then 1 else 0 end = 1 then 1 else null end general_election_new_voters_2016
    FROM subset_working_app
    ")
```