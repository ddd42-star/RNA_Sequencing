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
annotable <- read.csv2("annotable.txt")
annotable
#checks the data and if there a column more, deleted
annotable <- annotable[1:length(annotable)-1]
annotable
#add col names transcription_id, gene_id, gene_names,gene_type,transcript_type,transcript_type
colnames(annotable) <- c("target_id","ens_gene","ext_gene","gene_biotype", "transcript_type")
annotable
#save condition
condition <- ~ metadata$condition
condition

# sleuth preparation object
sc2 <- sleuth_prep(metadata, condition, target_mapping = annotable, read_bootstrap_tpm = TRUE, extra_bootstrap_summary = TRUE, transform_fun_counts = function(x) log2(x + 0.5), num_cores = 8)
#sc2 <- sleuth_prep(metadata, condition, target_mapping = annotable)

# 1 fit model
# condition tested first alphabetically is the control
op <- sleuth_fit(sc2, condition,fit_name = "full")

#Checks model
models(op)

# new fit reduce
nop <- sleuth_fit(op,~ 1,"reduced")

# wade test
cc <- sleuth_wt(nop,"metadata$conditionreads","full")
# results shown
table <- sleuth_results(cc,"metadata$conditionreads","wt", show_all = TRUE,rename_cols = TRUE)
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

# filter for lncRNA,protein and NA
filter_table <- dplyr::filter(table, (gene_biotype == " protein_coding" | gene_biotype==" lncRNA" | gene_biotype == "NA"),  qval <= 0.05)
#filter protein_coding, NA, lncRNA
filter_table
first_twenty <- c(filter_table$ext_gene[1:20])
EnhancedVolcano(filter_table, lab = filter_table$ext_gene, x = "b", y = "qval", title = "lncRNA and protein differential expression paraclonal vs parental", legendPosition = "right", drawConnectors = TRUE)

# filter lncRNA
filter_lncrna <- dplyr::filter(table, gene_biotype==" lncRNA",  qval <= 0.05, transcript_type==" lncRNA")
filter_lncrna

# first 20 lncRNA
EnhancedVolcano(filter_lncrna, lab = filter_lncrna$ext_gene, x = "b", y = "qval", title = "lncRNA differential expression paraclonal vs parental", legendPosition = "right", drawConnectors = TRUE)


# filter protein coding
filter_protein <- dplyr::filter(table, gene_biotype==" protein_coding",  qval <= 0.05, transcript_type==" protein_coding")
filter_protein

# first 20 protein_coding
EnhancedVolcano(filter_protein, lab = filter_protein$ext_gene, x = "b", y = "qval", title = "protein differential expression paraclonal vs parental", legendPosition = "right", drawConnectors = TRUE)


# Heat map
#merge for each sample, R2-P3 tmp values for each genes with lncrna and protein