# Input is file path.

# Path should lead to a folder of CSV

# Function will confirm that all the column names match
check_names <- function(path) {
  
  setwd(path)
  
  file_list <- list.files()
  
  counter <- 1
  
  for (file in file_list) {
    if (!exists("file_names")){
      file_names <- read.table(file = file, sep="\t", nrows=1)
    }
    
    # if the merged dataset does exist, append to it
    else if (exists("file_names")){
          temp_dataset <-read.table(file = file,sep="\t",nrows=1)
      out <- tryCatch(
        {
          merged_data<-rbind(file_names, temp_dataset)
          rm(temp_dataset)
        },
        error=function(cond) {
            message(paste("This file: "),file)
            message(paste("Doesn't match the other files: "),file_list[1:counter-1])
        return(-1)
        }
      )
    }
    
    counter <- counter + 1
  }
    return(1)
}





