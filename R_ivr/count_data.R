# Logic by Prabhat Gautam

# Last edit: 7/23/2019

# Input: Dataframe with the column names

# Note: Install these libraries if needed
library('knitr')
library('RODBC')
library("dplyr")
library("readxl")
library("readxl")
library("openxlsx")
library("purrr")

count_dat <- function(data) {

  #Use the responses in order to generate ifelse logic to create the syntax necessary
  # You can concatenate ANID with subgroup just to keep unique individual within a subgroup.
  data$ANIDsub <- paste(data$ANID,data$subgroup)
  
  # The following code can be used in order to de-duplicate the record based on 
  # required date or registration
  data_1a <- data[order(data$ANIDsub,data$requireddate,decreasing=TRUE),]
  
  #Keep only the first row for the duplicate of UNIQUE_ID
  data_1b <- data_1a[!duplicated(data_1a$ANIDsub),]

  #Coding chunk, which assigns indicator for all records#
  data_1b$id <- ifelse(data_1b$ANIDsub == ' ',0,1)

  #Matched to Current or Historic VF- based on typecode alone#
  data_1b$matched<-ifelse(data_1b$global_typecode == 'No match'| data_1b$global_typecode == ' ', 0, 1)

  #Successful Registrants- I noticed that everyone has required registration date in GA sample. I used voter status to code if someone is active or inactive as registered#
  data_1b$registered <- ifelse(data_1b$voterstatus == 'active' |
                          data_1b$voterstatus == 'inactive', 1, 0)

  #1. Based on the methodology document- successful registrant is referred to as information provided at the registration also matching contemporary voter file
  #2. are the input registration status passed through to the final file?
  #3. There is a table referred to in the syntax typecode_codes_detailed table-- how was this constructed

  #Successful Registrants based on global typecode#
  data_1b$success <- ifelse(data_1b$global_typecode == 'First time registrant' | data_1b$global_typecode == 'Cross-state move' | data_1b$global_typecode == 'In-state move in-county'| data_1b$global_typecode == 'In-state move cross-county'| data_1b$global_typecode == 'Status change' |data_1b$global_typecode == 'Date change'| data_1b$global_typecode == 'No change unregistered',1,0)

  #Roll Changing Registrants#
  data_1b$roll_ch <- ifelse(data_1b$global_typecode == 'First time registrant' | data_1b$global_typecode == 'Cross-state move' | data_1b$global_typecode == 'In-state move in-county'| data_1b$global_typecode == 'In-state move cross-county'| data_1b$global_typecode == 'Status change' |data_1b$global_typecode == 'Date change',1,0)

  #New Registrants#
  data_1b$new_reg <- ifelse(data_1b$global_typecode == 'First time registrant', 1,0)

  #Pending Registrants#
  data_1b$pending <- ifelse(data_1b$success == 0 | data_1b$roll_ch == 0,
                       1,0)

  #2018 Voters#
  data_1b$voted <- ifelse(data_1b$es_n2018g == 'N' |
                       data_1b$es_n2018g == 'Z'|
                       data_1b$es_n2018g == 'U', 0, 1)
  
  #Coding chunk which assigns the above categories to those who voted#

  #Voted and successful#
  data_1b$success_v <- ifelse(data_1b$success == 1 | data_1b$voted == 1, 1,0)
  
  #Voted and Roll Changed#
  data_1b$roll_v <- ifelse(data_1b$roll_ch == 1 | data_1b$voted == 1,1,0)
  
  #New Registrants and voted#
  data_1b$newreg_v <- ifelse(data_1b$new_reg == 1 | data_1b$voted == 1, 1,0)
  
  #Pending and voted#
  data_1b$pending_v <- ifelse(data_1b$pending == 1 | data_1b$voted
                           == 1,1,0)

  #Number of times a record has occured in the database and which is that record#
  n_occur <- data.frame(table(data$ANID))
  names(n_occur)[names(n_occur)=="Var1"] <- "ANID"
  
  n_occur_1 <- n_occur[n_occur$Freq == 1,]
  
  n_occur_2 <- n_occur[n_occur$Freq == 2,]
  
  n_occur_3 <- n_occur[n_occur$Freq == 3,]
  
  n_occur_4 <- n_occur[n_occur$Freq == 4,]
  
  n_occur_5 <- n_occur[n_occur$Freq == 5,]
  
  n_occur_6more <- n_occur[n_occur$Freq > 5,]
  
  #Merge the number of times UNIQUEID occurs with the original dataframe#
  data_1c <- Reduce(function(dtf1,dtf2)merge(dtf1,dtf2, by = "ANID", all.x=TRUE),
                        list(data_1b,n_occur))
  
  #Create indicator variables based on the above freq field#
  data_1c$`>1`<-ifelse(data_1c$Freq != 1, 1, 0)

  #Code below to group by sub-group type using dplyr#
  library("dplyr")
  subgroup <- data_1c %>% group_by(subgroup)
  
  #Summarize across the entire file#
  sub_group_output <- subgroup %>% summarise(
    unique = sum(id),
    `>1_r` = mean(`>1`),
    `>1` = sum(`>1`),
    success_r = mean(success),
    roll_ch_r = mean(roll_ch),
    new_reg_r = mean(new_reg),
    pend_r = mean(pending),
    vr =mean(voted),
    success = sum(success),
    roll_ch = sum(roll_ch),
    new_reg = sum(new_reg),
    pend = sum(pending),
    voted =sum(voted),
    success_v_r = mean(success_v),
    roll_ch_v_r = mean(roll_v),
    new_reg_v_r = mean(newreg_v),
    pend_v_r = mean(pending_v),
    success_v = sum(success_v),
    roll_ch_v = sum(roll_v),
    new_reg_v = sum(newreg_v),
    pend_v = sum(pending_v)
    )

  #Code below to group by sub-group and program_type type using dplyr#
  library("dplyr")
  subgroup2 <- data_1c %>% group_by(subgroup,program_type)
  
  #Summarize across the entire file#
  sub_group_prg_output <- subgroup2 %>% summarise(
    unique = sum(id),
    `>1_r` = mean(`>1`),
    `>1` = sum(`>1`),
    success_r = mean(success),
    roll_ch_r = mean(roll_ch),
    new_reg_r = mean(new_reg),
    pend_r = mean(pending),
    vr =mean(voted),
    success = sum(success),
    roll_ch = sum(roll_ch),
    new_reg = sum(new_reg),
    pend = sum(pending),
    voted =sum(voted),
    success_v_r = mean(success_v),
    roll_ch_v_r = mean(roll_v),
    new_reg_v_r = mean(newreg_v),
    pend_v_r = mean(pending_v),
    success_v = sum(success_v),
    roll_ch_v = sum(roll_v),
    new_reg_v = sum(newreg_v),
    pend_v = sum(pending_v)
    )
 
  #Code below to group by sub-group and program_type type using dplyr#
  library("dplyr")
  subgroup3 <- data_1c %>% group_by(org,program_type)
  
  #Summarize across the entire file#
  org_prgtype_output <- subgroup3 %>% summarise(
    unique = sum(id),
    `>1_r` = mean(`>1`),
    `>1` = sum(`>1`),
    success_r = mean(success),
    roll_ch_r = mean(roll_ch),
    new_reg_r = mean(new_reg),
    pend_r = mean(pending),
    vr =mean(voted),
    success = sum(success),
    roll_ch = sum(roll_ch),
    new_reg = sum(new_reg),
    pend = sum(pending),
    voted =sum(voted),
    success_v_r = mean(success_v),
    roll_ch_v_r = mean(roll_v),
    new_reg_v_r = mean(newreg_v),
    pend_v_r = mean(pending_v),
    success_v = sum(success_v),
    roll_ch_v = sum(roll_v),
    new_reg_v = sum(newreg_v),
    pend_v = sum(pending_v)
    )
  
  #Create workbook and sheets with names#
  GA_sample_QC <- createWorkbook()
  addWorksheet(GA_sample_QC, "sub_group_output")
  addWorksheet(GA_sample_QC, "sub_group_prg_output")
  addWorksheet(GA_sample_QC, "org_prgtype_output")
  
  #Write output tables into the sheets#
  writeDataTable(GA_sample_QC, "sub_group_output", x = sub_group_output)
  writeDataTable(GA_sample_QC, "sub_group_prg_output", x = sub_group_prg_output)
  writeDataTable(GA_sample_QC, "org_prgtype_output", x = org_prgtype_output)
  
  setwd("/Users/anthonygoss/Projects/circle/R_ivr")
  saveWorkbook(GA_sample_QC, "sample_output.xlsx",overwrite = TRUE)
  
  return("Process complete.")
}


    
    