library(dplyr)
args <- commandArgs(trailingOnly = TRUE)

family_anno_table <- args[length(args)]
print(family_anno_table)
family_anno_table <- read.csv(file=family_anno_table, header=T)

files_length <- length(args)-1
files <- args[1:files_length]

print("FILES:")
print(files)
l <- list()
setwd(getwd())
for(i in seq_along(files)){
  f=read.table(files[i], header=T)
  colnames(f)[2]=unlist(strsplit(tail(unlist(strsplit(files[i], "/")),n=1),"-"))[1]
  l[[i]]=f
}
print("LIST:")
print(l)
print(length(l))
counts_merged <- Reduce(function (...) { merge(..., all = FALSE, by = "transcript") },   # Inner join
                        l)

family_anno_table <- family_anno_table[,c("ID", "Repbase")]
counts_merged=merge(counts_merged, family_anno_table, by.x = "transcript", by.y = "ID", all.x = TRUE)
print("COUNTS_MERGED:")
print(head(counts_merged))

print("DIMS counts_merged:")
print(dim(counts_merged))
write.csv(counts_merged, "telescope/counts.csv", row.names=FALSE)

for(i in seq_along(counts_merged$transcript)){
  if(is.na(counts_merged$Repbase[i])){
    counts_merged$Family[i]="__no_feature"
  }else{
    counts_merged$Family[i] <- paste(unlist(strsplit(counts_merged$Repbase[i], 
                                         "|", fixed=T))[-1], collapse="|")
    if(counts_merged$Family[i]==""){
      counts_merged$Family[i]=NA
    }
  }
}

counts_merged$Repbase <-NULL
counts_merged$transcript <-NULL
counts_summed_by_family <- counts_merged %>%
  group_by(Family) %>%
  summarise(across(everything(), sum))
counts_summed_by_family=as.data.frame(counts_summed_by_family)
write.csv(counts_summed_by_family,"telescope/counts_summed_by_family.csv", row.names=FALSE)

