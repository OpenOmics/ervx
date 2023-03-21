args <- commandArgs(trailingOnly = TRUE)
files <- as.character(args[1])
print(files)
l <- list()
setwd(getwd())
for(i in seq_along(files)){
  f=read.table(files[i], header=T)
  colnames(f)[2]=unlist(strsplit(tail(unlist(strsplit(files[i], "/")),n=1),"-"))[1]
  l[[i]]=f
}
print(l)
counts_merged <- Reduce(function (...) { merge(..., all = FALSE, by = "transcript") },   # Inner join
          l)
print(counts_merged)
write.csv(counts_merged, "telescope/counts_merged.csv")

