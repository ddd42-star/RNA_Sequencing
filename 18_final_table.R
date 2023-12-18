setwd("/home/dario/Documenti/RNA_seq/RNA_lncSeq/RNA_Sequencing")

# load transcript analysis
data <- read.table("transcriptExpression.txt", header = TRUE)
head(data, 50)

# load count transcript
transcript_count <- read.table("count_transcript.txt", header = TRUE)
transcript_count

# overlap 5 prime
overlap5 <- read.table("overlap5primeA.bed")
colnames(overlap5) <- c("chromosome", "start", "end", "transcript_id", "score", "strand")

# overlap 3 prime
overlap3 <- read.table("overlap3primeA.bed")
colnames(overlap3) <- c("chromosome", "start", "end", "transcript_id", "score", "strand")


# protein
protein <- read.csv("novelProtein", sep="\t", row.names = NULL)
protein

# change trasncript id
for (i in 1:length(protein$row.names)) {
  protein$row.names[i] <- strsplit(protein$row.names[i], "::")[[1]][1]
}

# new protein
new_protein <- data.frame(transcript_id=protein$row.names, Protein_coding=protein$coding_prob)

# load reference genome
genome <- read.table("transformedBed.bed")
colnames(genome) <- c("chromosome", "start", "end", "transcript_id", "score", "strand")


# load gene analysis
gene <- read.table("geneExpression.txt", header = TRUE)
gene

# load count gene
count_gene <- read.table("counts_per_genes.txt", header = TRUE)
count_gene

# load intergenic
novel_intergenic <- read.table("novelIntergenic.bed")
colnames(novel_intergenic) <- c("chromosome", "start", "end", "transcript_id", "score", "strand")

# Create new table with all the statistics
final_table <- data.frame(transcript_id=data$target_id, gene_id=data$ens_gene,log2FC=data$b, qval=data$qval)
final_table

# 5 prime & find unique overlap target id
new_overlap5 <- data.frame(transcript_id=unique(overlap5$transcript_id), Five_prime=rep("YES", length(unique(overlap5$transcript_id))))

# merge with final table
final_table <- merge(final_table, new_overlap5, by.x="transcript_id", by.y = "transcript_id", all.x = TRUE, all.y = TRUE)
final_table

# replace NA with NO
final_table$Five_prime[is.na(final_table$Five_prime)] <- "NO"
final_table

# 3 prime & find unique overlap target id
new_overlap3 <- data.frame(transcript_id=unique(overlap3$transcript_id), Three_prime=rep("YES", length(unique(overlap3$transcript_id))))

# merge with final table
final_table <- merge(final_table, new_overlap3, by.x="transcript_id", by.y = "transcript_id", all.x = TRUE, all.y = TRUE)
final_table

# replace NA with NO
final_table$Three_prime[is.na(final_table$Three_prime)] <- "NO"
final_table

# novel intergenic
new_intergenic <- data.frame(transcript_id=novel_intergenic$transcript_id, Intergenic=rep("YES", length(novel_intergenic$transcript_id)))

# merge with final table
final_table <- merge(final_table, new_intergenic, by.x="transcript_id", by.y = "transcript_id", all.x = TRUE, all.y = TRUE)
final_table

# replace NA with NO
final_table$Intergenic[is.na(final_table$Intergenic)] <- "NO"
final_table

# biotype
biotype_notation <- data.frame(transcript_id=data$target_id, Biotype=0)
biotype_notation
# note transcript that are old
biotype_notation$Biotype[grep("ENST", biotype_notation$transcript_id)] <- "annotated"
# note transcript thar are new
biotype_notation$Biotype[grep("MSTR", biotype_notation$transcript_id)] <- "novel"


# merge with final table
final_table <- merge(final_table, biotype_notation, by.x="transcript_id", by.y = "transcript_id", all.x = TRUE, all.y = TRUE)
final_table

# protein
final_table <- merge(final_table, new_protein, by.x="transcript_id", by.y = "transcript_id", all.x = TRUE, all.y = TRUE)
final_table

total_protein = length(protein$coding_prob)
novel_protein = dplyr::filter(protein, coding_prob>0.364)
novel_protein

novel_protein_len = length(grep("MSTR", novel_protein$row.names))

protein_cod = (novel_protein_len/total_protein)*100

# write final table
write.table(final_table, "Merge_table_step6.txt")

# sort final table

fin_table <- read.table("Merge_table_step6.txt")
fin_table

# sort according to the Biotype
sort1 <- fin_table[order(fin_table$Biotype, decreasing = TRUE),]
sort1

# sort according to 5'
sort2 <- sort1[order(sort1$Five_prime, decreasing = TRUE),]
sort2


# sort according to 3'
sort3 <- sort2[order(sort2$Three_prime, decreasing = TRUE),]
sort3

# sort accordint to intergenic
sort4 <- sort3[order(sort3$Intergenic, decreasing = TRUE),]
sort4

# sort according to
sorted_table <- fin_table[order(fin_table$Biotype,fin_table$Five_prime, fin_table$Three_prime, fin_table$Intergenic, fin_table$log2FC, decreasing = TRUE),]
sorted_table

write.table(sorted_table,"sorted_table_step6")







