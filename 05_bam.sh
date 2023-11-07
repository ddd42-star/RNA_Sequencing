#!/usr/bin/env bash

#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/05_align_reads_%j.o
#SBATCH --partition=pall

READS=/data/users/dbassi/rnaseq_course/reads
GENOME=/data/users/dbassi/rnaseq_course/reference_genome
THREADS=$SLURM_CPUS_PER_TASK
INDEX=/data/users/dbassi/rnaseq_course/reference_genome
MAP=/data/users/dbassi/rnaseq_course/mapped_reads 

# load the module for transforming a sam file into a bam files
module add UHTS/Analysis/samtools/1.10;

# transform a sam file into a bam file
samtools view -b -@ $THREADS $MAP/P3_L3.sam > $MAP/P3_L3_unsorted.bam

# sort the bam file according to the position on the genome
samtools sort -@ $THREADS $MAP/P3_L3_unsorted.bam > $MAP/P3_L3.bam

# index the bam file
samtools index $MAP/P3_L3.bam

# remove temporary file
#rm $MAP/R_3_2_L3_unsorted.bam
#rm $MAP/R_3_2_L3.sam