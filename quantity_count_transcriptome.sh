#!/usr/bin/env bash

#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/Qualitycontrol_expression_%j.o

FILE=/data/users/dbassi/rnaseq_course/transcriptome_assembly


# total exons
awk '$3 == "exon" {print $3}'  $FILE/all_merge.gtf | wc -l


#total transcript
awk '$3 == "transcript" {print $3}'  $FILE/all_merge.gtf | wc -l

# total gene
awk '$3 == "transcript" {print $10}'  $FILE/all_merge.gtf | sort | uniq -c | wc -l

# Single Exon Transcripts
awk '$3 == "exon" {print $12}'  $FILE/all_merge.gtf | sort | uniq -c | awk '$1 == 1' | wc -l

#Single Exon Genes
awk '$3 == "transcript" {print $14}'  $FILE/all_merge.gtf | sort | uniq -c | awk '$1 == 1' | wc -l

#Novel transcript
awk '$3 == "transcript" {print}'  $FILE/all_merge.gtf | uniq | awk '$9=="gene_id" && $13!="gene_name" {print}' | wc -l

#Novel exon
awk '$3 == "exon" {print}'  $FILE/all_merge.gtf | awk '$9=="gene_id" && $15!="gene_name" {print}' | wc -l


