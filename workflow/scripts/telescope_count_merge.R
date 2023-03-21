args <- commandArgs(trailingOnly = TRUE)
files <- args[1:length(args)]
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
print("COUNTS_MERGED:")
print(head(counts_merged))

print("DIMS counts_merged:")
print(dim(counts_merged))
write.csv(counts_merged, "telescope/counts_merged.csv")

