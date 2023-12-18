library("sleuth")

# set directory path
setwd("/home/dario/Documenti/RNA_seq/RNA_lncSeq/RNA_Sequencing")

# preliminary set-up data

# specify where kallisto results are stored
sample_id <- dir(file.path("DE"))
sample_id

# list of paths
kall_dir <- file.path("DE", sample_id)
kall_dir

# create condition vector
conditions <- sample_id
conditions[grepl("R", sample_id)] <- "reads"
conditions[grepl("P", sample_id)] <- "parental"
conditions

#create metadeta with reads and parents
metadata <- data.frame(sample_id, conditions) #stringsAsFactors = F
# replace header with "sample"
colnames(metadata) <- c("sample", "condition")
metadata

#add the path to the data.frame
metadata["path"] <- kall_dir
metadata

#load annotable table
annotable <- read.csv2("annotable.txt", sep = ";")
annotable
#checks the data and if there a column more, deleted
annotable <- annotable[1:length(annotable)-1]
annotable
#add col names transcription_id, gene_id, gene_names,gene_type,transcript_type,transcript_type
colnames(annotable) <- c("target_id","ens_gene","ext_gene","gene_biotype", "transcript_type")
annotable

#rename novel gene with biotype novel
annotable$gene_biotype[annotable$gene_biotype==""] <- "novel"
# rename novel transcript with biotype novel
annotable$transcript_type[annotable$transcript_type==""] <- "novel"
tail(annotable)

#save condition
condition <- ~ metadata$condition
condition

# sleuth preparation object
sc2 <- sleuth_prep(metadata, condition,target_mapping = annotable, read_bootstrap_tpm = TRUE, extra_bootstrap_summary = TRUE, transform_fun_counts = function(x) log2(x + 0.5))
#sc2 <- sleuth_prep(metadata, condition, target_mapping = annotable)

# 1 fit model, there is no difference between the two conditions
nop <- sleuth_fit(sc2,~ 1,"reduced")
# 2 fit full model that assumesa transcript is differential expressed between two conditions
# condition tested first alphabetically is the control
op <- sleuth_fit(nop, condition,fit_name = "full")

#Checks model
models(op)

# wade test
cc <- sleuth_wt(op,"metadata$conditionreads","full")

models(cc)
# results shown
table <- sleuth_results(cc,"metadata$conditionreads","wt", which_model = "full",show_all = TRUE)
table
sleuth_significant <- dplyr::filter(table, qval <= 0.05)

# likelihood model (other possible test)
#wt <- sleuth_lrt(nop,"reduced", "full")

#print first 20 values
head(sleuth_significant,40)

#plot_bootstrap(wt,"ENST00000335211.9",units = "est_counts", color_by = "condition")
#plot_pca(wt, color_by = "condition")

#plot_volcano(cc,"metadata$conditionreads","wt", which_model = "full", sig_level = 0.1, point_alpha = 0.05, sig_color = "red", highlight = annotable$target_id)
#plot_transcript_heatmap(cc,head(ll,n=20)$target_id,"est_counts")

library(EnhancedVolcano)
#plot with pCutoff <= 0.05
EnhancedVolcano(table, lab = table$ext_gene, x="b", y="qval", pCutoff = 0.05, xlim = c(-10,10), ylim = c(0,150),title = "Paraclonal vs Parental")

# filter for lncRNA,protein and novel
filter_table <- dplyr::filter(table, (gene_biotype == " protein_coding" | gene_biotype==" lncRNA" | gene_biotype == "novel"))
#filter protein_coding, NA, lncRNA
filter_table
first_twenty <- c(filter_table$ext_gene[1:20])
EnhancedVolcano(filter_table, lab = filter_table$ext_gene, x = "b", y = "qval", title = "lncRNA and protein differential expression paraclonal vs parental", legendPosition = "right", drawConnectors = TRUE)

# filter lncRNA with and without qval cutoff
filter_lncrna <- dplyr::filter(table, gene_biotype==" lncRNA",transcript_type==" lncRNA", qval <= 0.05)
#filter_lncrna <- dplyr::filter(table, gene_biotype==" lncRNA",transcript_type==" lncRNA")
filter_lncrna

# first 20 lncRNA
EnhancedVolcano(filter_lncrna, lab = filter_lncrna$ext_gene, x = "b", y = "qval", title = "lncRNA differential expression paraclonal vs parental", legendPosition = "right", drawConnectors = TRUE, pCutoff = 0.05)


# filter protein coding
#filter_protein <- dplyr::filter(table, gene_biotype==" protein_coding",  qval <= 0.05, transcript_type==" protein_coding")
filter_protein <- dplyr::filter(table, gene_biotype==" protein_coding",transcript_type==" protein_coding")
filter_protein

# first 20 protein_coding
EnhancedVolcano(filter_protein, lab = filter_protein$ext_gene, x = "b", y = "qval", title = "protein differential expression paraclonal vs parental", legendPosition = "right", drawConnectors = TRUE, pCutoff = 0.05)


# filter novel
filter_novel <- dplyr::filter(table,gene_biotype=="novel",  qval <= 0.05)
filter_novel

EnhancedVolcano(filter_novel, lab = filter_novel$ens_gene, x = "b", y = "qval", title = "novel gene differential expression paraclonal vs parental", legendPosition = "right", drawConnectors = TRUE)
# Heat map
#merge for each sample, R2-P3 tmp values for each genes with lncrna and protein
#norm_prep <-  sleuth_prep(metadata, condition, target_mapping = annotable, read_bootstrap_tpm = TRUE, extra_bootstrap_summary = TRUE, transform_fun_counts = function(x) log2(x + 0.5), num_cores = 8, normalize = TRUE)
#plot_transcript_heatmap(table,transcripts = sleuth_significant$target_id)

#matrix_data <- matrix(sc2$obs_norm, nrow = length(unique(sc2$obs_norm$target_id)), ncol = length(unique(sc2$obs_norm$sample)), byrow = TRUE)

#write table
write.table(table,"transcriptExpression.txt")

count_transcript <- sleuth_to_matrix(cc,"obs_norm", "est_counts")
count_transcript
write.table(count_transcript,"count_transcript.txt")
# count transcript

#data <- read.table("geneExpression.txt")
#data

# gene count

sc1 <- sleuth_prep(metadata, condition,target_mapping = annotable, aggregation_column = "ens_gene",gene_mode=TRUE,read_bootstrap_tpm = TRUE, extra_bootstrap_summary = TRUE, transform_fun_counts = function(x) log2(x + 0.5))

# first fit

no <- sleuth_fit(sc1, condition,fit_name = "full")

# second fit
nn <- sleuth_fit(no,~ 1,"reduced")
models(nn)

gwt <- sleuth_wt(nn,"metadata$conditionreads","full")
# wt test
genes_count <- sleuth_results(gwt,"metadata$conditionreads","wt",show_all = TRUE)
genes_count

sleuth_significant_gene <- dplyr::filter(genes_count, qval <= 0.05)
sleuth_significant_gene

#write table
write.table(genes_count,"geneExpression.txt")

# transcript counts
genes_counts <- sleuth_to_matrix(gwt,"obs_norm", "scaled_reads_per_base")
genes_counts
write.table(genes_counts,file = "counts_per_genes.txt")
