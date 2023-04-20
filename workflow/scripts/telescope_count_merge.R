library(dplyr)
library(reshape)
library(ggplot2)
args <- commandArgs(trailingOnly = TRUE)

family_anno_table <- args[length(args)]
print(family_anno_table)
family_anno_table <- read.csv(file=family_anno_table, header=T)

files_length <- length(args)-1
files <- args[1:files_length]

setwd(getwd())

print("FILES:")
print(files)
l <- list()

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
print(paste("this is class:", class(counts_merged$Repbase)))
write.csv(counts_merged, "telescope/counts.csv", row.names=FALSE)

# Counts Summing By Subfamily Per Sample
for(i in seq_along(counts_merged$transcript)){
  if(is.na(counts_merged$Repbase[i])){
    counts_merged$Subfamily[i]="__no_feature"
  }else if (counts_merged$Repbase[i]=="."){
    counts_merged$Subfamily[i] <- "." 
  }else{
    print(paste("this is Rebase:", i,counts_merged$Repbase[i]))
    separated_vector <- unlist(strsplit(unlist(strsplit(as.character(counts_merged$Repbase[i]), " ", fixed=T)), "|", fixed=T))
    counts_merged$Subfamily[i] <- paste(separated_vector[!grepl("/", separated_vector)], collapse="/")
  }
}

counts_merged$Repbase <-NULL
counts_merged$transcript <-NULL
counts_summed_by_subfamily <- counts_merged %>%
  group_by(Subfamily) %>%
  summarise(across(everything(), sum))
counts_summed_by_subfamily <- as.data.frame(counts_summed_by_subfamily)
counts_summed_by_subfamily <- counts_summed_by_subfamily[-which(counts_summed_by_subfamily$Subfamily=="."),]
write.csv(counts_summed_by_subfamily,"telescope/counts_summed_by_subfamily.csv", row.names=FALSE)

# Heatmap: Counts Summed By Subfamily Per Sample
counts_summed_by_subfamily$Subfamily[which(is.na(counts_summed_by_subfamily$Subfamily))] <- "Unknown"
transposed <- melt(counts_summed_by_subfamily)
ggplot(transposed, aes(x = variable, y = Subfamily, fill = value)) +
  geom_tile()+theme(axis.text.x = element_text(angle = 90,size=4,face="bold"),
                    axis.text.y = element_text(size=4,face="bold"),
                    plot.title = element_text())+
  xlab("Samples")+ylab("Subfamily")+ 
  ggtitle("Counts Summed By Subfamily Per Sample")
  
ggsave("telescope/counts_summed_by_subfamily_heatmap.jpeg",
       dpi=400, height=6, width=7, units="in")