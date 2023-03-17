args <- commandArgs(trailingOnly = TRUE)
files <- as.character(args[1])
print(files)
l <- list()
setwd(getwd())
for(i in seq_along(files)){
  f=read.table(files[1], header=T)
  l[[i]]=f
}
print(l)
counts_merged <- Reduce(function (...) { merge(..., all = FALSE, by = "transcript") },   # Inner join
          l)
write.csv(counts_merged, "telescope/counts_merged.csv")
