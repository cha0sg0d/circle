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
install.packages('tibble')
library('tibble')
```

```{r}
small_working_app <- sample_n(subset_working_app,100)
```

```{r}
empty_subgroup <- mean(subset_working_app$subgroup == "")
empty_subgroup_vpc <- mean(subset_working_app$subgroup == "" & subset_working_app$org == "vpc")
```

# Step 2: For this dataset only, replace each instance subgroup is empty with subgroup = vpc
```{r}
subset_working_app$subgroup[subset_working_app$subgroup==""] <- NA

subset_working_app$subgroup <- as.character(subset_working_app$subgroup)
subset_working_app$subgroup[is.na(subset_working_app$subgroup)] <- "vpc"
```

# We now have a manageable subgroup of data to work with.
# Let's download SQL for R and start analyzing the commented_query.sql file

# Step 3: Convert this SQL chunk, which appears in every query, to R code 
```{r}
# We can select any subset we want using dplyr's select function.
#select(subset_working_app,)
library('tibble')
names <- colnames(subset_working_app)[42:45]

# Recode "t" / "f" as 1 and 0
subset_working_app_1 <- subset_working_app %>%
    mutate(matched_app = ifelse(matched_app == "t", 1, 0)) %>%
    mutate(successful_app = ifelse(successful_app == "t", 1, 0)) %>% 
    mutate(roll_changing_app = ifelse(roll_changing_app == "t", 1, 0)) %>%
    mutate(new_registrant = ifelse(new_registrant == "t", 1, 0)) %>%
    add_column(unique_applicants = 1)

# Create new variables for voting behavior 2016 general election:
# general election voters 2016 = voters who are "successful" and voted in 2016
# general election roll changing voters 2016 = voters who are "roll changing" and voted in 2016
# general election new voters 2016 = voters who are "new registrants" and voted in 2016

# NOTE: Update this to 2018 for 2018 report

subset_working_app_2 <- subset_working_app_1 %>%
    mutate(general_election_voters_2016 = ifelse((successful_app == 1 & es_n2016g == 1),1,0)) %>%
    mutate(general_election_roll_changing_voters_2016 = 
               ifelse((roll_changing_app == 1 & es_n2016g == 1),1,0)) %>% 
    mutate(general_election_new_voters_2016 = ifelse((new_registrant == 1 & es_n2016g == 1),1,0))
```

Step 4: Continue preprocessing: Recode race as each person's "best" race 
NEEDSWORK: This chink will change the existing race codes and replace it with a number
```{r}

#max(case when person_rank=1 then race else null end) as race # Pull the race from their "best" # record
subset_working_app_3 <- subset_working_app_2 %>%
    mutate(race = ifelse(person_rank == 1,race,"unknown"))
```

Step 5: Count the number of duplicates for each person
```{r}
duplicates <- count(subset_working_app_2,anid)

duplicates <- duplicates %>%
    arrange(desc(n))

num_dups <- table(duplicates$n)
```
Step 6: Does person rank match # of duplicates?
```{r}
ranks <- table(subset_working_app_2$person_rank)
```


```{r}
subset_working_app_2 %>%
    summarize(sum = sum(matched_app))


test <- subset_working_app_2[,names[1]]
```

Counts for orgs by subgroup
```{r}
counts <- subset_working_app_2 %>%
    group_by(subgroup) %>%
    summarize(matched_applicants = sum(matched_app), successful_applicants = sum(successful_app), roll_changing_applicants = sum(roll_changing_app), new_registrants = sum(new_registrant),roll_change_2016 = sum(general_election_roll_changing_voters_2016),new_voter_2016 = sum(general_election_new_voters_2016))
```
%'s for orgs by subgroup
```{r}
percentages <- subset_working_app_2 %>%
    group_by(subgroup) %>%
    summarize(matched_applicants = sum(matched_app)/sum(unique_applicants), successful_applicants = sum(successful_app)/sum(unique_applicants), roll_changing_applicants = sum(roll_changing_app)/sum(unique_applicants), new_registrants = sum(new_registrant)/sum(unique_applicants), pct_of_roll_change_2016 = sum(general_election_roll_changing_voters_2016)/sum(general_election_voters_2016), pct_of_new_2016 = sum(general_election_new_voters_2016)/sum(general_election_voters_2016))

```


sum(unique_applicants) as unique_applicants 
  , sum(records_submitted) as records_submitted
  , sum(matched_applicants) as matched_applicants
  , sum(successful_registrants) as successful_registrants
  , sum(roll_changing_registrants) as roll_changing_registrants
  , sum(new_registrants) as new_registrants
  #, sum(voted_all) as voted_all
  , sum(general_election_voters_2016) as general_election_voters_2016 #of those successful.
  , sum(general_election_roll_changing_voters_2016) as general_election_roll_changing_voters_2016 #of those roll changed.
  , sum(general_election_new_voters_2016) as general_election_new_voters_2016 #of those new.

  , sum(matched_applicants)/sum(unique_applicants)::float as match_pct  
  , sum(successful_registrants)/sum(unique_applicants)::float as successful_pct
  , sum(roll_changing_registrants)/sum(unique_applicants)::float as rollchange_pct  
  , sum(new_registrants)/sum(unique_applicants)::float as new_reg_pct #not inherently good or bad since some programs target movers etc

  , sum(general_election_voters_2016)/sum(successful_registrants)::float as vote_rate_sucessful #of those successful. makes sense because they definitely at least TRIED to register in 2016, even if their registration is actually from earlier year.
  #, sum(voted_all)/sum(unique_applicants)::float as vote_rate_all
  , sum(general_election_roll_changing_voters_2016)/sum(roll_changing_registrants)::float as vote_rate_rollchange
  , sum(general_election_new_voters_2016)/sum(new_registrants)::float as newreg_voterate

