library(dplyr)
library(reshape)
library(ggplot2)
library(argparse)
parser <- ArgumentParser()

parser$add_argument("-tsvs", nargs='+', required=T,
    help="Vector of sampleName-TE_counts.tsv files")
parser$add_argument("-f", required=F, 
    help="Summary of family/subfamily/class by locus")
parser$add_argument("-dir", required=T, 
    help="Output directory")
args <- parser$parse_args()
files <- args$tsvs
family_anno_table <- args$f
out_dir <- args$dir
print("OUT_DIR:")
print(out_dir)
print("family_anno_table:")
print(family_anno_table)
if(!is.null(family_anno_table)){
  family_anno_table <- read.csv(file=family_anno_table, header=T)
}


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
print("List Length:")
print(length(l))
counts_merged <- Reduce(function (...) { merge(..., all = FALSE, by = "transcript") },   # Inner join
                        l)
if (is.null(family_anno_table)){
  write.csv(counts_merged, paste0(out_dir,"/counts.csv"), row.names=FALSE)
  } else {
    family_anno_table <- family_anno_table[,c("ID", "Repbase")]
    counts_merged=merge(counts_merged, family_anno_table, by.x = "transcript", by.y = "ID", all.x = TRUE)
    print("COUNTS_MERGED:")
    print(head(counts_merged))

    print("DIMS counts_merged:")
    print(dim(counts_merged))
    print(paste("this is class:", class(counts_merged$Repbase)))
    write.csv(counts_merged, paste0(out_dir,"/counts.csv"), row.names=FALSE)

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
    write.csv(counts_summed_by_subfamily, paste0(out_dir,"/counts_summed_by_subfamily.csv"), row.names=FALSE)

  }
