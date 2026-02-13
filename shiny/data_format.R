##data format to shiny

#package
library(dplyr)
library(data.table)
library(matrixStats)
#read data
total_data=data.frame(fread('/Users/liz36/Documents/CARD_challenge/Phosphoptoteomics/Longitudinal/total/092024/data_output.csv'))
phospho_data=data.frame(fread('/Users/liz36/Documents/CARD_challenge/Phosphoptoteomics/Longitudinal/phospho/092024/phospho_data.csv'))

setwd('/Users/liz36/Documents/CARD_challenge/Phosphoptoteomics/Longitudinal/shiny/')
##merge same gene(identify the one with the least missing values across all runs. In case there are multiple phospho-precursors with the same number of missing values, select the one with the top intensity based on the average across the runs.)
total_data <- total_data %>%
  # Calculate missing values 
  mutate(missing_value = rowSums(is.na(select(., -contains("Protein_Group|Genes|PTM|Precursor|Modified_Sequence")))))%>% 
  # Calculate median values
  mutate(median = rowMedians(as.matrix(select(., -contains("Protein_Group|Genes|PTM|Precursor|Modified_Sequence|missing_value")) %>% 
                                         select_if(is.numeric)), na.rm = TRUE)) %>%
  #Identify unique PTM with the least missing values and highest median intensity
  group_by(Genes) %>%
  filter(missing_value == min(missing_value)) %>%
  slice(which.max(median)) %>%
  ungroup() %>%
  select(-c(missing_value, median)) #missing value

#long format 
total_data_long=melt(total_data)
total_data_long$Sample=gsub('KOLF_','',total_data_long$variable)
total_data_long$Condition=gsub('_[0-9]','',total_data_long$Sample)

total_data_long$Time <- gsub('iN_D','',total_data_long$Condition)
total_data_long$Time <- gsub('iPSC',0,total_data_long$Time)
total_data_long$Time= as.numeric(total_data_long$Time)

total_data_long[is.na(total_data_long)]=1

#percentile_by_day
total_data_long <-total_data_long %>% 
  group_by(Sample) %>%
  mutate(percentile_by_day = ntile(value,100)) 
#normalized
total_data_long<- total_data_long %>% 
  group_by(Genes,Time) %>% 
  mutate(normalized = value/mean(value[Time==0]+1))

write.csv(total_data_long,"total_data_long.csv",row.names = F) 


#long format 
phospho_data_long=melt(phospho_data)
phospho_data_long$Sample=gsub('KOLF_|_PP','',phospho_data_long$variable)
phospho_data_long$Condition=gsub('_[0-9]','',phospho_data_long$Sample)

phospho_data_long$Time <- gsub('iN_D','',phospho_data_long$Condition)
phospho_data_long$Time <- gsub('iPSC',0,phospho_data_long$Time)
phospho_data_long$Time= as.numeric(phospho_data_long$Time)

phospho_data_long$PTM_Location= gsub('.*\\(|\\)', '',(phospho_data_long$PTM_Location))
phospho_data_long[is.na(phospho_data_long)]=0
write.csv(phospho_data_long,"phospho_data_long.csv",row.names = F) 

