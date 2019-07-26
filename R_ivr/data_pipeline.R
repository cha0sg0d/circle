# R script to open and combine many data files

# Note: Path variable should be updated to wherever the data is being stored.
# Data should be in TSV format

# THE COLUMNS MUST ALL HAVE THE SAME NAMES. 
# When using the function rbind, the two data frames must have the same variables
# but they do not have to be in the same order.

# Remove the dataframe from the environment to avoid duplicates.
if(exists("merged_data"))
  rm("merged_data")

path <- "/Users/anthonygoss/Projects/circle/R_ivr/data"

# Step 1. Quality check. Do the names of all files match?
source("/Users/anthonygoss/Projects/circle/R_ivr/check_names.R")

# NEEDSWORK
if(check_names(path) != 1)
  stop()
# Step 2. Get the files, merge the data

# Merging pipeline credit to Hayward Goodwin from blog post
# "Merge all files in a directory using R into a single dataframe"

# Retrive list of files in the directory
file_list <- list.files(path)

# Create union of one big file
for (file in file_list){
  
  # if the merged dataset doesn't exist, create it
  if (!exists("merged_data")){
    merged_data <- read.table(file, header=TRUE, sep="\t")
  }
  
  # if the merged dataset does exist, append to it
  else if (exists("merged_data")){
    temp_dataset <-read.table(file, header=TRUE, sep="\t")
    merged_data<-rbind(merged_data, temp_dataset)
    rm(temp_dataset)
  }
}

# We now have the dataframe "merged data"

# Step 3: Call a function to perform counts of the data

# Credit to Prabhat Gautam
source("/Users/anthonygoss/Projects/circle/R_ivr/count_data.R")

# output: An Excel Spreadsheet with the appropriate counts
count_dat(merged_data)





